#
# Profile Build Installer
# Author: Asura
# Created: 2021-06-15 0104H, Asura
# Modified: 
#	- 2021-06-15 0104H, Asura
#	- 2021-06-15 0154H, Asura
#	- 2021-06-15 1836H, Asura
#	- 2021-06-17 0123H, Asura
#	- 2021-06-17 0141H, Asura
#	- 2021-06-17 0232H, Asura
#	- 2021-06-18 1228H, Asura
#	- 2021-06-18 1739H, Asura
#	- 2021-06-18 2256H, Asura
#	- 2021-06-20 1136H, Asura
#	- 2021-06-23 1529H, Asura
#	- 2021-06-23 2103H, Asura
#	- 2021-06-23 2125H, Asura
#	- 2021-06-23 2233H, Asura
#	- 2021-07-12 0925H, Asura
#	- 2021-07-12 1223H, Asura
#	- 2021-07-26 1727H, Asura
# Features: 
#	- Full minimal user input install script
# Background Information: 
#	A full minimal user-input, modular install script that allows user to
#	change just afew variables and be able to effectively customize their system according to what they need
#	with just afew changes
# Changelog:
#	- 2021-06-15 0104H, Asura
#		- Created script file
#	- 2021-06-15 0154H, Asura
#		- Added other features
#	- 2021-06-15 1836H, Asura
#		- Completed main install structure
#		- Now focusing on postinstallation recommendations
#	- 2021-06-17 0123H, Asura
#		- Fixed some bugs: { mounting partitions boot, home and root didnt include the device name }
#	- 2021-06-17 0141H, Asura
#		- Added read -p if MODE == DEBUG
#	- 2021-06-17 0232H, Asura
#		- Added DEBUG features
#	- 2021-06-18 1228H, Asura
#		- Modified arch-chroot /mnt <commands> install scripts
#		- Added a [Reference] section for reference sites
#	- 2021-06-18 1739H, Asura
#		- Added 'check network'
#	- 2021-06-18 2256H, Asura
#		- Modified arch-chroot method to create a file inside root partition to execute for the time being
#	- 2021-06-20 1137H, Asura
#		- Added Comments
#	- 2021-06-23 1529H, Asura
#		- Added test use-case for auto-uncommenting /etc/locale.gen using sed
#	- 2021-06-23 2103H, Asura
#		- Added package 'base' into arraylist of packages to install
#	- 2021-06-23 2125H, Asura
#		- Moved local variable 'pkgs' from pacstrap_Install() -> Global Array variable 'pacstrap_Pkgs'
#		- Added syslinux bootloader install
#		- Created new associative array 'pkg' to store all packages
#		- Appended 'pacstrap_Pkgs' to 'pkg' associative array
#	- 2021-06-23 2233H, Asura
#		- Added syslinux install - To be tested
#	- 2021-07-12 0925H, Asura
#		- Added line to uncomment sudoers using sed in arch-chroot
#	- 2021-07-12 1223H, Asura
#		- Added simple postinstallation basic commands such as enabling sudo and user management
#		- no installation (to do in postinstallation setup script)
#	- 2021-07-26 1727H, Asura
#		- Transferred newest functions made in [installer-ux.min.sh]
#			- Should now be working
# TODO:
#		- Seperate and create script 'postinstallation-utilities.sh' for PostInstallation processes (non-installation focus)
#			such as 
#				'Repository' :
#					Enable multilib repository
#				'Sudo' :
#					Set sudo priviledges
#				'Administrative' : 
#					Create User Account
#				'System Maintenance' : 
#					Swap File
#		- Post installation: 
#			> Get user to create a user
# NOTES:
#	- Please modify all [EDIT: Modify this] and confirm before running this file
# References:
#	1. Multiline-scripting in Arch-chroot : https://www.reddit.com/r/archlinux/comments/bssbze/scripting_into_chroot/
#

# --- Variables

# [Program]
PROGRAM_SCRIPTNAME="installer"
PROGRAM_NAME="ArchLinux Profile Setup Installer"
PROGRAM_TYPE="Main"
MODE="${1:-DEBUG}" # { DEBUG | RELEASE }
DISTRO="ArchLinux"

# [Array]

### Pacstrap
pacstrap_Pkgs=(
	# EDIT: MODIFY THIS
	# Place your pacstrap packages here
	# - Ensure 'base' is inside
	# - Otherwise, there will be issues loading after installation
	# - Error examples:
	#	1. 'root mounted, but /sbin/init not found, have fun'
	# Add the packages you want to strap in here
	"base"
	"linux"
	"linux-firmware"
	"linux-lts"
	"linux-lts-headers"
	"base-devel"
	"nano"
	"vim"
	"networkmanager"
	"os-prober"
)

# [Associative Array]

### Device and Partitions
declare -A device_Parameters=(
	# EDIT: Modify this
	[device_Type]="<hdd|ssd|flashdrive|microSD>"
	[device_Name]="</dev/sdX>"
	[device_Size]="<x {GB | GiB | MB | MiB}>"
	[device_Boot]="<mbr|uefi>"
	[device_Label]="<msdos|gpt>"
)

declare -A partition_Configuration=(
	# EDIT: Modify this
	# [Background Information]
	# Compilation of all partitions
	# Please append according to your needs
	# [Syntax]
	# ROW_ID="<partition_ID>;<partition_Name>;<partition_file_Type>;<partition_start_Size>;<partition_end_Size>;<partition_Bootable>;<partition_Others>
	[1]="1;Boot;primary;ext4;0%;1024MiB;True;NIL"
	[2]="2;Root;primary;ext4;1024MiB;<x1MiB>;False;NIL"
	[3]="3;Home;primary;ext4;<x1MiB>;100%;False;NIL"
)

declare -A partition_Parameters=(
	[part_ID]=1
	[part_Name]="Boot"
	[part_Type]="primary"
	[part_file_Type]="ext4"
	[part_start_Size]="1MiB"
	[part_end_Size]="1024MiB"
	[part_Bootable]=True
	[part_Others]=""
)

### Mounts
declare -A mount_Group=(
	# Place all your partition path
	#	corresponding to the partition number
	# [Syntax]
	# [partition-n]="/partition/mount/path"
	[1]="/mnt/boot"	# Boot
	[2]="/mnt"		# Root
	[3]="/mnt/home"	# Home
)

### Packages
declare -A pkgs=(
	# EDIT: Modify this 
	# All Packages
	#	- pacstrap packages etc.
	# Please append all new categories below in the key while
	#	the array for the category in the values
	[pacstrap]="${pacstrap_Pkgs[@]}"
)

### Region & Location
declare -A location=(
	# Regional & Location
	# Your Region, Your City etc.
	# EDIT: Modify this
	[region]="<Your Region>"
	[city]="<Your City>"
	[language]="en_SG.UTF-8"
	[keymap]="en_UTF-8"
)

### User Control
declare -A user_Info=(
	# EDIT: Modify this
	# User Profile Information
	# [Delimiters]
	# , : For Parameter seperation
	# ; : For Subparameter seperation (seperation within a parameter itself)
	# [Syntax]
	# ROW_ID="
	#	<username>,
	#	<primary_group>,
	#	<secondary_group (put NIL if none),
	#	<custom_directory_path (if custom_directory is True)>
	#	<any other parameters>
	# "
	# [Examples]
	# [1]="username,wheel,NIL,True,/home/profiles/username"
	[1]="asura,wheel,NIL,/home/profiles/asura,NIL"
)

### Network Configurations
declare -A network_config=(
	# EDIT: Modify this
	# Network Configuration info
	[hostname]="ArchLinux"
)

### Operating System Definitions
declare -A osdef=(
	# EDIT: Modify this
	# Operating System Definitions
	# - Bootloader, Kernels (to be added) etc.
	[bootloader]="grub"				# Your Bootloader
	[optional-parameters]=""		# Your Bootloader's additional parameters outside of the main important ones
	[target_device_Type]="i386-pc"	# Your Target Device Type
)

# --- Functions

# General Functions
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
	comms=(
		# Sync NTP
		"timedatectl set-ntp true"
		# To check system clock
		"timedatectl status"
	)

	for c in "${comms[@]}"; do
		case "$MODE" in
			"DEBUG")
				echo $c
				;;
			*)
				# Default: RELEASE
				$c
				;;
		esac
	done

	# Sync NTP
	#echo timedatectl set-ntp true

	# To check system clock
	#echo timedatectl status
}

device_partition_Manager()
{
	#
	# Device & Partition Manager
	#

	echo "Get User Input - Device Information"
	device_Name="${device_Parameters["device_Name"]}"
	device_Label="${device_Parameters["device_Label"]}"

	echo "Device Name : $device_Name"
	echo "Device Label: $device_Label"

	echo ""

	echo "Get User Input - Partition Information"

	# Format & Create Label
	read -p "Would you like to format? [Y|N]: " format_conf
	if [[ "$format_conf" == "Y" ]] || [[ "$format_conf" == "" ]]; then
		echo "=============================================="
		echo " Formatting [$device_Name] to [$device_Label] "
		echo "=============================================="
		
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

			echo "==============================="
			echo "Creating Partition [ $part_ID ]"
			echo "==============================="

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
					echo "Unknown File System: [$part_file_Type]"
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

	echo "======================"
	echo " Partition Completed. "
	echo "======================"
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
	else
		mount "$device_Name"3 $dir_Home
	fi

	if [[ "$MODE" == "DEBUG" ]]; then
		echo mount "$device_Name"1 $dir_Boot
	else
		mount "$device_Name"1 $dir_Boot
	fi

	# --- Output
	echo "==============="
	echo " Disks Mounted "
	echo "==============="
}

pacstrap_Install()
{
	#
	# Pacstrap essential and must have packaes to mount (/mnt) before arch-chroot
	#
	# [Essential Package Categories]
	#	Text Editor
	#	Development
	#	networkmanager
	#	Kernels
	#

	# --- Input

	# Arrays
	# pkgs=()
	pkg=${pkgs["pacstrap"]}

	# Local Variables
	mount_Point="${mount_Group["2"]}"

	# --- Processing
	if [[ "$MODE" == "DEBUG" ]]; then
		echo pacstrap $mount_Point ${pkg[@]}
	else
		pacstrap $mount_Point ${pkg[@]}
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

arch_chroot_Exec()
{
	#
	# Execute commands using arch-chroot due to limitations with shellscripting
	#

	# --- Input
	# Local Variables
	device_Name="${device_Parameters["device_Name"]}"
	device_Label="${device_Parameters["device_Label"]}"
	dir_Mount="${mount_Group["2"]}"
	region="${location["region"]}"
	city="${location["city"]}"
	language="${location["language"]}"
	hostname="${network_config["hostname"]}"
	bootloader="${osdef["bootloader"]}"
	bootloader_optional_Params="${osdef["optional-parameters"]}"
	bootloader_target_device_Type="${osdef["target_device_Type"]}"

	# Array

	# Associative Array
	chroot_commands=(
		"echo ======= Time Zones ======"												# Step 10: Time Zones
		"ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime"						# Step 10: Time Zones; Set time zone
		"hwclock --systohc"																# Step 10: Time Zones; Generate /etc/adjtime via hwclock
		"echo ======= Location ======"													# Step 11: Localization;
		# "vim /etc/locale.gen"															# Step 11: Localization; Edit /etc/locale.gen and uncomment language (ie. en_US.UTF-8 UTF-8; en_SG.UTF-8 UTF-8;)
		"sed -i '/$location/s/^#//g' /etc/locale.gen"									# Step 11: Localization; Uncomment the locale region language
		"locale-gen"																	# Step 11: Localization; Generate the locales by running
		"echo \"LANG=$language\" | tee -a /etc/locale.conf"								# Step 11: Localization; Set LANG variable according to your locale
		"echo ======= Network Configuration ======"										# step 12: Network Configuration;
		"echo \"$hostname\" | tee -a /etc/hostname"										# Step 12: Network Configuration; Set Network Hostname Configuration; Create hostname file
		"echo \"127.0.0.1   localhost\" | tee -a /etc/hosts"							# Step 12: Network Configuration; Add matching entries to hosts file
		"echo \"::1         localhost\" | tee -a /etc/hosts"							# Step 12: Network Configuration; Add matching entries to hosts file
		"echo \"127.0.1.1   $hostname.localdomain   $hostname\" | tee -a /etc/hosts"	# Step 12: Network Configuration; Add matching entries to hosts file
		"echo ======= Make Initial Ramdisk ======="										# Step 13: Initialize RAM file system;
		"mkinitcpio -P linux"															# Step 13: Initialize RAM file system; Create initramfs image (linux kernel)
		"mkinitcpio -P linux-lts"														# Step 13: Initialize RAM file system; Create initramfs image (linux-lts kernel)
		"echo ======= Change Root Password ======="										# Step 14: User Information; Set Root Password
		"passwd"																		# Step 14: User Information; Set Root Password
	)

	# --- Extra Information

	#### Step 15: Install Bootloader
	### NOTE:
	### 1. Please Edit [osdef] on top with the bootloader information before proceeding
	####
	# Default Bootloader
	if [[ "$bootloader" == "" ]]; then
		# Empty : Reset to 'Grub'
		echo "Sorry, $bootloader is not supported at the moment, we will default to Grub(2.0)"
		bootloader="grub"
	fi

	# Switch Case bootloader between grub and syslinux
	case "$bootloader" in
		"grub")
			chroot_commands+=(
				"echo ======= Bootloader : Grub ======"											# Step 15: Bootloader
				"sudo pacman -S grub"																# Install Grub Package
				"grub-install --target=$bootloader_target_device_Type --debug $bootloader_optional_Params $device_Name"	# Install Grub Bootloader
				"mkdir -p /boot/grub"																# Create grub folder
				"grub-mkconfig -o /boot/grub/grub.cfg"												# Create grub config
			)
			;;
		"syslinux")
			chroot_commands+=(
				"echo ======= Bootloader : Syslinux ======"											# Step 15: Bootloader
				"sudo pacman -S syslinux"
				"mkdir -p /boot/syslinux"
				"cp -r /usr/lib/syslinux/bios/*.c32 /boot/syslinux"
				"extlinux --install /boot/syslinux"
			)
			case "$device_Label" in
				"mbr")
					chroot_commands+=(
						"dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/bios/mbr.bin of=$device_Name"
					)
					;;
				"gpt")
					chroot_commands+=(
						"sgdisk $device_Name --attributes=1:set:2"
						"dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=$device_Name"
					)
					;;
				*)
					# Default to MBR
					;;
			esac
			;;
		*)
			# Default to grub
			;;
	esac

	# --- Processing

	# Combine into a string
	cmd_str=""
	for c in "${chroot_commands[@]}"; do
		cmd_str+="\n$c;"
	done
	
	# Cat commands into script file in mount root
	mount_Root=$dir_Mount/root
	script_to_exe=chroot-comms.sh
	if [[ "$MODE" == "DEBUG" ]]; then
		# echo "echo -e "$cmd_str" > $mount_Root/$script_to_exe"
		echo -e "$cmd_str"
	else
		echo -e "$cmd_str" > $mount_Root/$script_to_exe
	fi

	# Execute in arch-chroot
	if [[ "$MODE" == "DEBUG" ]]; then
		echo "chmod +x $mount_Root/$script_to_exe"
		echo "arch-chroot $dir_Mount /bin/bash -c \"$PWD/$script_to_exe\""
	else
		chmod +x $mount_Root/$script_to_exe
		arch-chroot $dir_Mount /bin/bash -c "$PWD/$script_to_exe"
	fi
	# --- Output
}

postinstallation()
{
	#
	# Post-Installation Recommendations and TODOs 
	# - To be seperated into its own individual scripts for running
	# 
	postinstall_commands=(
		"echo ======= Enable sudo ======="												# PostInstall Must Do | Step 1: Enable sudo for group 'wheel'
		"sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers"				# PostInstall Must Do | Step 1: Enable sudo for group 'wheel'		
	)

	
	# Combine into a string
	cmd_str=""
	for c in "${postinstall_commands[@]}"; do
		cmd_str+="\n$c;"
	done
	
	# Cat commands into script file in mount root
	mount_Root=$dir_Mount/root
	script_to_exe=postinstall-comms.sh
	if [[ "$MODE" == "DEBUG" ]]; then
		# echo "echo -e "$cmd_str" > $mount_Root/$script_to_exe"
		echo -e "$cmd_str"
	else
		echo -e "$cmd_str" > $mount_Root/$script_to_exe
	fi

	# Change Permission and Execute command
	if [[ "$MODE" == "DEBUG" ]]; then
		echo "chmod +x $mount_Root/$script_to_exe"
		echo "arch-chroot $dir_Mount /bin/bash -c \"$PWD/$script_to_exe\""
	else
		chmod +x $mount_Root/$script_to_exe
		arch-chroot $dir_Mount /bin/bash -c "$PWD/$script_to_exe"
	fi
	
	echo "- Please proceed to follow the 'Post-Installation' series of guides"
	echo "and/or"
	echo "- Follow this list of recommendations:"
	echo "	[Post-Installation TODO]"
	echo "	1. Enable multilib repository : "
	echo "		Summary:"
	echo "			If you want to run 32-bit applications on your 64-bit systems"
	echo "			Uncomment/enable the multilib repository"
	echo "		i. Edit '/etc/pacman.conf'"
	echo "		ii. Uncomment [multilib]"
	echo "		iii. Uncomment 'include = /etc/pacman.d/mirrorlist' below [multilib]"
	echo "		WIP:"
	echo "			- Automatic removal of comments in a file"
	echo ""
	# Command and Control
	echo " 2. [To validate if is done] Set sudo priviledges"
	echo "		Summary:"
	echo "			Ability to use 'sudo'"
	echo "		i. Use 'visudo' to enter the sudo file safely"
	echo "			i.e."
	echo "				$EDITOR=vim sudo visudo"
	echo "		ii. Uncomment '%wheel ALL=(ALL) ALL' to allow all users under the group 'wheel' to access sudo (with password)"
	echo ""
	# Administrative
	echo " 3. Create user account"
	echo "		Summary:"
	echo "			Create user account"
	echo "		i. Add user using the 'useradd' command"
	echo "			useradd -m -g <primary group (default: <username>) -G <secondary/supplementary groups (default: wheel)> -d <custom-profile-directory-path> <username>"
	echo "			i.e."
	echo "				useradd -m -g wheel -d /home/profiles/admin admin"
	echo "				useradd -m -g users -G wheel -d /home/profiles/admin admin"
	echo "		ii. Set password to username"
	echo "			passwd <username>"
	echo "			i.e."
	echo "				let <username> be 'admin':"
	echo "					passswd admin"
	echo "		iii. Test user"
	echo "			su - <username>"
	echo "			sudo whoami"
	echo "		iv. If part iii works : User has been created."
	# System Maintenance
	echo " 4. Swap File"
	echo "		Summary:"
	echo "			Instead of using swap partitions which are hard to change size, consider using swap files instead"
	echo "			- Easy to resize"
	echo "			- Easy to remove"
	echo "			- Easy to add/allocate"
	echo "		i. Allocate/Create swap file"
	echo "			fallocate -l <size> /swapfile # <size> : in formats { MB | MiB | GB | GiB }"
	echo "			i.e."
	echo "				fallocate -l 8.0GB /swapfile"
	echo "		ii. Change permission of swapfile to read + write"
	echo "			chmod 600 /swapfile"
	echo "		iii. Make swapfile"
	echo "			mkswap /swapfile"
	echo "		iv. Enable the swap file to begin using it"
	echo "			swapon /swapfile"
	echo "		v. The operating system needs to know that it is safe to use this file everytime it boots up"
	echo "			echo \"# /swapfile\" | tee -a /etc/fstab"
	echo "			echo \"/swapfile none swap defaults 0 0\" | tee -a /etc/fstab"
	echo "			i.e."
	echo "				swapfile size = 4GB"
	echo "				fallocate -l 4G /swapfile"
	echo "				chmod 600 /swapfile"
	echo "				mkswap /swapfile"
	echo "				swapon /swapfile"
	echo "				echo \"# /swapfile\" | tee -a /etc/fstab"
	echo "				echo \"/swapfile none swap defaults 0 0\" | tee -a /etc/fstab"
	echo "		vi. Verify swap file"
	echo "			ls -lh /swapfile"
	echo "		vii. Verify swap file allocation"
	echo "			free -h"
	echo "		viii. If part vii works : Swap file has been created."
}

postinstall_user_create()
{
	#
	# PostInstallation Function: Create user account
	# TODO:
	#	- To be made into a proper function (useradd)
	#	- Place inside another script (postinstallation-utilities.sh)
	#
	echo " 3. Create user account"
	echo "		Summary:"
	echo "			Create user account"
	echo "		i. Add user using the 'useradd' command"
	echo "			useradd -m -g <primary group (default: <username>) -G <secondary/supplementary groups (default: wheel)> -d <custom-profile-directory-path> <username>"
	echo "			i.e."
	echo "				useradd -m -g wheel -d /home/profiles/admin admin"
	echo "				useradd -m -g users -G wheel -d /home/profiles/admin admin"
	echo "		ii. Set password to username"
	echo "			passwd <username>"
	echo "			i.e."
	echo "				let <username> be 'admin':"
	echo "					passswd admin"
	echo "		iii. Test user"
	echo "			su - <username>"
	echo "			sudo whoami"
	echo "		iv. If part iii works : User has been created."
}

installer()
{
	#
	# Main setup installer
	#

	echo "========================"
	echo "Stage 1: Prepare Network"
	echo "========================"
	echo "Testing Network..."
	network_Enabled="$(verify_network)"
	if [[ "$network_Enabled" == "False" ]]; then
		sudo dhcpcd
	fi

	echo ""

	echo "=========================================="
	echo "Stage 2: Verify Boot Mode (i.e. UEFI/BIOS)"
	echo "=========================================="
	boot_Mode="$(verify_boot_Mode)"
	echo "Boot Mode: $boot_Mode"

	echo ""

	echo "============================"
	echo "Stage 3: Update System Clock"
	echo "============================"
	update_system_Clock

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "============================"
	echo "Stage 4: Partition the Disks"
	echo "============================"
	device_partition_Manager

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "===================="
	echo "Stage 5: Mount Disks"
	echo "===================="
	mount_Disks

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "======================="
	echo "Stage 6: Select Mirrors"
	echo "======================="
	echo $EDITOR /etc/pacman.d/mirrorlist

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==================================="
	echo "Stage 7: Install essential packages"
	echo "==================================="
	pacstrap_Install

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==========================================="
	echo "Stage 8: Generate fstab (File System Table)"
	echo "==========================================="
	fstab_Generate

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==========================="
	echo "Stage 9: Chroot and execute"
	echo "==========================="
	arch_chroot_Exec # Execute commands in arch-chroot

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "======================="
	echo "Installation Completed."
	echo "======================="
	echo "Base ArchLinux installation completed."

	echo ""

	echo "================="
	echo "Post-Installation"
	echo "================="
	postinstallation

	echo ""
}

init()
{
	#
	# Initialization
	#
	echo "PROGRAM NAME: $PROGRAM_NAME"
	echo "DISTRO      : $DISTRO"
}


body()
{
	#
	# Main function to run
	#
	argv=("$@")
	argc="${#argv[@]}"

	installer
}

function END()
{
    line=""
    read -p "Pause" line
}

function main()
{
	#
	# Main Function 
	#  - You may not edit this if you want to leave it as default
	#
	
	body "$@"
	res="$?"
	echo "$res"
}

if [[ "${BASH_SOURCE[@]}" == "${0}" ]]; then
    # START
    init
	main "$@"
    END
fi

