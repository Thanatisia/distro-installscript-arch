#!/bin/env bash
<<EOF
Distribution CLI Base Installation General Helper Functions
EOF

debug_printAll()
{
	#
	# Debugger : Print all
	#
	cat="$1"

	case "$cat" in
		"device_Parameters")
			for k in "${!device_Parameters[@]}"; do
				echo "[$k] : ${device_Parameters[$k]}"
			done
			;;
		"partition_Parameters")
			for k in "${!partition_Parameters[@]}"; do
				echo "[$k] : ${partition_Parameters[$k]}"
			done
			;;
		"partition_Configuration")
			for k in "${!partition_Configuration[@]}"; do
				echo "[$k] : ${partition_Configuration[$k]}"
			done
			;;
		*)
			;;
	esac
}
seperate_by_Delim()
{
	#
	# Seperate a string into an array by the delimiter
	#

	# --- Input
	
	# Command Line Argument
	str="$1"			# String to be seperated
	delim="${2:-';'}"	# Delimiter to split

	# Local Variables

	# Array
	content=()			# Array container to store results
	char=''				# Single character for splitting element of a string

	# Associative Array

	# --- Processing
	# Split string into individual characters
	IFS=$delim read -r -a content <<< "$str"
	
	# --- Output
	echo "${content[@]}"
}

# Installation stages
verify_network()
{
	ping -c 5 8.8.8.8
	ret_code="$?"
	res=False
	if [[ "$res" == "0" ]]; then
		# Success
		res=True
	fi
	echo "$res"
}

verify_boot_Mode()
{
	boot_Mode="bios"
	
	ls /sys/firmware/efi/efivars
	ret_code="$?"
	if [[ "$ret_code" == "0" ]]; then
		# UEFI
		boot_Mode="uefi"
	fi
	echo "$boot_Mode"
}

update_system_Clock()
{
	# Sync NTP
	if [[ "$MODE" == "DEBUG" ]]; then
		echo timedatectl set-ntp true
	else
		timedatectl set-ntp true
	fi

	# To check system clock
	if [[ "$MODE" == "DEBUG" ]]; then
		echo timedatectl status
	else
		timedatectl status
	fi
}

device_partition_Manager()
{
	#
	# Device & Partition Manager
	#

    echo "(+) Get User Input - Device Information"
	device_Name="${device_Parameters["device_Name"]}"
	device_Label="${device_Parameters["device_Label"]}"

	echo ""

    echo "(+) Get User Input - Partition Information"

	# Format & Create Label
	read -p "Would you like to format? [Y|N]: " format_conf
	if [[ "$format_conf" == "Y" ]] || [[ "$format_conf" == "" ]]; then
        echo "(+) Formatting [$device_Name] to [$device_Label]..."
		
		if [[ "$MODE" == "DEBUG" ]]; then
			echo parted $device_Name mklabel $device_Label
		else
			parted $device_Name mklabel $device_Label
		fi
	fi

	for(( i=0; i <= "${#partition_Configuration[@]}"; i++)); do
		v="${partition_Configuration[$i]}"

		if [[ ! "$v" == "" ]]; then
			# echo "Value: $v"
		
			# Split v by ';' delimiter
			part_ID="$(echo $v | cut -d ';' -f1)"
			part_Name="$(echo $v | cut -d ';' -f2)"
			part_Type="$(echo $v | cut -d ';' -f3)"
			part_file_Type="$(echo $v | cut -d ';' -f4)"
			part_start_Size="$(echo $v | cut -d ';' -f5)"
			part_end_Size="$(echo $v | cut -d ';' -f6)"
			part_Bootable="$(echo $v | cut -d ';' -f7)"
			part_Others="$(echo $v | cut -d ';' -f8)"

			# Populate
			partition_Parameters["part_ID"]="$part_ID"
			partition_Parameters["part_Name"]="$part_Name"
			partition_Parameters["part_Type"]="$part_Type"
			partition_Parameters["part_file_Type"]="$part_file_Type"
			partition_Parameters["part_start_Size"]="$part_start_Size"
			partition_Parameters["part_end_Size"]="$part_end_Size"
			partition_Parameters["part_Bootable"]="$part_Bootable"
			partition_Parameters["part_Others"]="$part_Others"

			echo ""

            echo "(+) Creating Partition [ $part_ID ]"

			# Create Partition
			if [[ "$MODE" == "DEBUG" ]]; then
				echo parted $device_Name mkpart $part_Type $part_file_Type $part_start_Size $part_end_Size
			else
				parted $device_Name mkpart $part_Type $part_file_Type $part_start_Size $part_end_Size
			fi

			## Format file system
			case "$part_file_Type" in 
				"fat32")
					if [[ "$MODE" == "DEBUG" ]]; then
						echo mkfs.fat -F32 $device_Name$part_ID
					else
						mkfs.fat -F32 $device_Name$part_ID
					fi
					;;
				"ext4")
					if [[ "$MODE" == "DEBUG" ]]; then
						echo mkfs.ext4 $device_Name$part_ID
					else
						mkfs.ext4 $device_Name$part_ID
					fi
					;;
				*)
                    echo "(-) Unknown File System: [$part_file_Type]"
					;;
			esac
			## Check bootable
			if [[ "$part_Bootable" == "True" ]]; then
				if [[ "$MODE" == "DEBUG" ]]; then
					echo parted $device_Name set $part_ID boot on
				else
					parted $device_Name set $part_ID boot on
				fi
			fi
		fi
	done

	echo ""

    echo "(D) Partition Completed. "
}

mount_Disks()
{
	#
	# Mount Disks and Partitions
	#
	
	# --- Input
	# Local Vairiables
	device_Name="${device_Parameters["device_Name"]}"
	device_Label="${device_Parameters["device_Label"]}"
	
	# Directories
	dir_Boot="${mount_Group["1"]}"
	dir_Mount="${mount_Group["2"]}"
	dir_Home="${mount_Group["3"]}"

	# --- Processing
	# Mount the root volume to /mnt
	if [[ "$MODE" == "DEBUG" ]]; then
		echo mount "$device_Name"2 $dir_Mount
	else
		mount "$device_Name"2 $dir_Mount
	fi

	# Make other directories (i.e. home)
	# Home Directory
	if [[ "$MODE" == "DEBUG" ]]; then
		echo mkdir -p $dir_Home
	else
		mkdir -p $dir_Home
	fi
	# Boot Directory
	if [[ "$MODE" == "DEBUG" ]]; then
		echo mkdir -p $dir_Boot
	else
		mkdir -p $dir_Boot
	fi

	# Mount remaining directories
	if [[ "$MODE" == "DEBUG" ]]; then
		echo mount "$device_Name"3 $dir_Home
		echo mount "$device_Name"1 $dir_Boot
	else
		mount "$device_Name"3 $dir_Home
		mount "$device_Name"1 $dir_Boot
	fi

	# --- Output
}

fstab_Generate()
{
	#
	# Generate File System Table (fstab)
	#

	# --- Input
	# Local Variables
	dir_Mount="${mount_Group["2"]}"

	# Generate an fstab file (use -U or -L to define by UUID or labels, respectively):
	if [[ "$MODE" == "DEBUG" ]]; then
		echo "genfstab -U $dir_Mount >> $dir_Mount/etc/fstab"
	else
		genfstab -U $dir_Mount >> $dir_Mount/etc/fstab
	fi
}


