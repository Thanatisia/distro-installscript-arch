: "
Distro Install Script
Modular, Portable, Customizable and Configurable script that can be modified into other distro installers
=====================================
## Information
+ Author: Asura
- Features: 
    + Full minimal user input install script
- Dependencies
    + arch-install-scripts
    + build-devel
- Recommendation
    + Download the Makefile in the same directory as the script
### Background Information: 
+ A full minimal user-input, modular install script that allows user to
    change just afew variables and be able to effectively customize their system according to what they need
    with just afew changes
### Security Design
+ If user is empty : while true and get user to create until user is created
### NOTES
- Please modify all [EDIT: Modify this] and confirm before running this file
- As of 2022-06-16 2326H:
    - Support for installation from existing linux distro is still a WIP
        + Testing using ArchLinux (Base) completed, status  Success
   - Suggestions
        + Please try to install from the ArchLinux ISO
        - If you would like to try to install from an existing linux distro
            + Please install the package [arch-install-scripts]
- As of 2022-06-17 2356H:
    - Support for installation from existing linux distro success [ArchLinux].
        + Testing using ArchISO completed, status : Success
        + Testing using Existing Linux Distribution (Base Arch) completed, status: Success

## Documentation

### Synopsis/Syntax

+ TARGET_DISK_NAME='your-disk-label (/dev/sdX)' (./)installer.remake.sh {MODE}

### Parameters

- Positional Arguments
    1. MODE
        - Options
            + DEBUG     : Display only the commands
            + RELEASE   : Run the installation

### Usage

+ TARGET_DISK_NAME='/dev/sdX' (./)installer.remake.sh           : Run in DEBUG mode
+ TARGET_DISK_NAME='/dev/sdX' (./)installer.remake.sh RELEASE   : Run installation

## Configuration and Customization
    ## Environment Variables
    + TARGET_DISK_NAME : To set the disk/device label you wish to use (/dev/sdX)

References:
    1. Multiline-scripting in Arch-chroot : https://www.reddit.com/r/archlinux/comments/bssbze/scripting_into_chroot/
=====================================
"

# --- Variables

# [Program]
PROGRAM_SCRIPTNAME="installer"
PROGRAM_NAME="ArchLinux Profile Setup Installer"
PROGRAM_TYPE="Main"
MODE="${1:-DEBUG}" # { DEBUG | RELEASE }
DISTRO="ArchLinux"

: "
### EDIT THIS ###
[Must change edits]
- Please edit all parameters labelled with 'EDIT: Modify this'
"
deviceParams_devType="<hdd|ssd|flashdrive|microSD>"
deviceParams_Name="$TARGET_DISK_NAME"
deviceParams_Size="<x {GB | GiB | MB | MiB}"
deviceParams_Boot="<mbr|uefi>"
deviceParams_Label="<msdos|gpt>"
boot_Partition=(
	# Append this and append a [n]="${boot_Partition[<n-1>]}" in
	#	partition_Configuration
    # <partition_Number>;<partition_Name>;<partition_Type>;<partition_file_Type><partition_start_Size>;<partition_end_Size>;<partition_Bootable>;<partition_Others>
	"1;Boot;primary;ext4;0%;1024MiB;True;NIL"
	"2;Root;primary;ext4;1024MiB;<x1MiB>;False;NIL"
	"3;Home;primary;ext4;<x1MiB>;100%;False;NIL"
)
mount_Paths=(
	# Append this and append a [n]="${mount_Paths[<n-1>]}" in
	"/mnt/boot"	# Boot
	"/mnt"		# Root
	"/mnt/home"	# Home
)
pacstrap_pkgs=(
		# EDIT: MODIFY THIS
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
location_Region="<your-region (Asia|US etc)>" # Refer to /usr/share/zoneinfo for your region
location_City="<your-city (Singapore etc)>" # Refer to /usr/share/zoneinfo/<your-region> for your City
location_Language="<language-code (en_US.UTF-8|en_SG.TF-8 etc)>" # Your Language code - refer to /etc/locale.gen for a list of all language codes
location_KeyboardMapping="en_UTF-8" # Your Keyboard Mapping - change this if you use this (TODO: 2022-06-17 2314H : At the moment this is not used)
user_ProfileInfo=(
	# Append this and append a [n]="${user_ProfileInfo[<n-1>]}" in
	# 	user_Info
	# Note:
	#	- Please seperate all parameters with delimiter ','
	#	- Please seperate all subvalues with delimiter ';'
	# Syntax:
	# "
	#	<username>,
	#	<primary_group>,
	#	<secondary_group (put NIL if none),
	#	<custom_directory_path (put NIL if none)>,
	#	<any_other_Parameters>
	# "
	"username,wheel,NIL,/home/profiles/username,NIL"	
)
networkConfig_hostname="<your-network-hostname>" # Similar to workspace group name, used in /etc/hostname
bootloader="<your-bootloader>" # Your bootloader, at the moment - supported bootloaders are [grub, syslinux], tested: [grub] (TODO: 2022-06-17 317H : Add more bootloaders (if available))
bootloader_Params="" # Your Bootloader Parameters - fill this if you have any, leave empty if NIL
default_kernel="<linux-kernel>" # Your Default Linux Kernel
platform_Arch="<platform-architecture>" # Your Platform Architecture i.e. [ i386-pc | x86_64 ]2

: "Empty Data Storage
- Please do not edit these
- (If Required) Edit the associative array values specified in [setup()]
"
## Lists

### Stores all external scripts created
external_scripts=()

## Associative Array

### Device and Partitions
declare -A device_Parameters=()
declare -A partition_Configuration=()
declare -A partition_Parameters=()
### Mounts
declare -A mount_Group=()
### Region & Location
declare -A location=()
### Packages
declare -A pkgs=()
### User Control
declare -A user_Info=()
### Network Configurations
declare -A network_config=()
### Operating System Definitions
declare -A osdef=()
### Linux Definitions
declare -A linux=()

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
	pacstrap_Pkgs=${pkgs["pacstrap"]}

	# Local Variables
	mount_Point=${mount_Group["2"]}


	# --- Processing
	if [[ "$MODE" == "DEBUG" ]]; then
		# echo pacstrap ${mount_Group["2"]} "${pkgs[@]}"
		echo pacstrap $mount_Point ${pacstrap_Pkgs[@]}
	else
		# pacstrap ${mount_Group["2"]} "${pkgs[@]}"
		pacstrap $mount_Point ${pacstrap_Pkgs[@]}
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
    default_Kernel="${linux["kernel"]}"
	bootloader="${osdef["bootloader"]}"
	bootloader_optional_Params="${osdef["optional-parameters"]}"
	bootloader_target_device_Type="${osdef["target_device_Type"]}"

	# Array

	# Associative Array
	chroot_commands=(
		# "echo ======= Time Zones ======"												# Step 10: Time Zones
        "echo \(+\) Time Zones"
        "ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime"						# Step 10: Time Zones; Set time zone
		"hwclock --systohc"																# Step 10: Time Zones; Generate /etc/adjtime via hwclock
		# "echo ======= Location ======"													# Step 11: Localization;
        "echo \(+\) Location"
        "sed -i '/$language/s/^#//g' /etc/locale.gen" 									# Step 11: Localization; Uncomment locale using sed
		"locale-gen"																	# Step 11: Localization; Generate the locales by running
		"echo \"LANG=$language\" | tee -a /etc/locale.conf"								# Step 11: Localization; Set LANG variable according to your locale
		# "echo ======= Network Configuration ======"										# step 12: Network Configuration;
        "echo \(+\) Network Configuration"
        "echo \"$hostname\" | tee -a /etc/hostname"										# Step 12: Network Configuration; Set Network Hostname Configuration; Create hostname file
		"echo \"127.0.0.1   localhost\" | tee -a /etc/hosts"							# Step 12: Network Configuration; Add matching entries to hosts file
		"echo \"::1         localhost\" | tee -a /etc/hosts"							# Step 12: Network Configuration; Add matching entries to hosts file
		"echo \"127.0.1.1   $hostname.localdomain	$hostname\" | tee -a /etc/hosts"	# Step 12: Network Configuration; Add matching entries to hosts file
		# "echo ======= Make Initial Ramdisk ======="										# Step 13: Initialize RAM file system;
        "echo \(+\) Making Initial Ramdisk"
        "mkinitcpio -P $default_Kernel"													# Step 13: Initialize RAM file system; Create initramfs image (linux-lts kernel)
		# "echo ======= Change Root Password ======="										# Step 14: User Information; Set Root Password
        "echo \(+\) Change Root Password"
        "passwd || passwd"																		# Step 14: User Information; Set Root Password
	)

	# --- Extra Information

	#### Step 15: Install Bootloader
	### NOTE:
	### 1. Please Edit [osdef] on top with the bootloader information before proceeding
	####
	# Default Bootloader
	if [[ "$bootloader" == "" ]]; then
		# Empty : Reset to 'Grub'
        echo "(-) Sorry, $bootloader is not supported at the moment, we will default to Grub(2.0)"
		bootloader="grub"
	fi

	# Switch Case bootloader between grub and syslinux
	case "$bootloader" in
		# Step 15: Bootloader
		"grub")
			chroot_commands+=(
                "echo \(+\) Installing Bootloader : Grub"
                "sudo pacman -S grub"																# Install Grub Package
				"grub-install --target=$bootloader_target_device_Type --debug $bootloader_optional_Params $device_Name"	# Install Grub Bootloader
				"mkdir -p /boot/grub"																# Create grub folder
				"grub-mkconfig -o /boot/grub/grub.cfg"												# Create grub config
			)
			;;
		"syslinux")
			chroot_commands+=(
                "echo \(+\) Installing Bootloader : Syslinux"
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
		echo -e "$cmd_str"
	else
		echo -e "$cmd_str" > $mount_Root/$script_to_exe
	fi

	# Execute in arch-chroot
    # Future Codes deemed stable *enough*, thanks Past self for retaining legacy codes
    # for debugging
	external_scripts+=(
		### Append all external scripts used ###
		$mount_Root/$script_to_exe
	)

	if [[ "$MODE" == "DEBUG" ]]; then
		echo "chmod +x $mount_Root/$script_to_exe"
		echo "arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe""
	else
		chmod +x $mount_Root/$script_to_exe
		arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe"
	fi
	# --- Output
}


# =========================== #
# Post-Installation Functions #
# =========================== #
# User Management
get_users_Home()
{
	#
	# Get the home directory of a user
	#
	USER_NAME=$1
	HOME_DIR=""
	if [[ ! "$USER_NAME"  == "" ]]; then
		# Not Empty
		HOME_DIR=$(su - $USER_NAME -c "echo \$HOME")
	fi
	echo "$HOME_DIR"
}
check_user_Exists()
{
	#
	# Check if user exists
	#
	user_name="$1"
	exist_Token="0"
	delimiter=":"
	res_Existence="$(getent passwd $user_name)"

	if [[ ! "$res_Existence" == "" ]]; then
		# Something is found
		# Check if is the user
		res_is_User=$(echo "$res_Existence" | grep "^$user_name:" | cut -d ':' -f1)

		if [[ "$res_is_User" == "$user_name" ]]; then
			exist_Token="1"
		fi
	fi

	echo "$exist_Token"
}
useradd_get_default_Params()
{
    #
    # Useradd
    #   - Get Default Parameters
    #
    declare -A params=(
        [group]="$(useradd -D | grep GROUP | cut -d '=' -f2)"
        [home]="$(useradd -D | grep HOME | cut -d '=' -f2)"
        [inactive]="$(useradd -D | grep INACTIVE | cut -d '=' -f2)"
        [expire]="$(useradd -D | grep EXPIRE | cut -d '=' -f2)"
        [shell]="$(useradd -D | grep SHELL | cut -d '=' -f2)"
        [skeleton-path]="$(useradd -D | grep SKEL | cut -d '=' -f2)"
        [create-mail-spool]="$(useradd -D | grep CREATE_MAIL_SPOOL | cut -d '=' -f2)"
    )
    default_Params=()

    keywords=(
        "GROUP"
        "HOME"
        "INACTIVE"
        "EXPIRE"
        "SHELL"
        "SKEL"
        "CREATE_MAIL_SPOOL"
    )
    for k in "${keywords[@]}"; do
        # Put all keywords with the default values
        # default_Params[$k]="$(useradd -D | grep $k | cut -d '=' -f2)"
        default_Params+=("$(useradd -D | grep $k | cut -d '=' -f2)")
    done

    echo "${default_Params[@]}"
}
get_all_users()
{
	#
	# Check if user exists
	#
	exist_Token="0"
	delimiter=":"
	res_Existence="$(getent passwd)"
    all_users=($(cut -d ':' -f1 /etc/group | tr '\n' ' '))

	echo "${all_users[@]}"
}
get_user_primary_group()
{
    #
    # Just retrieves the user's primary group (-g)
    #
    user_name="$1"
    primary_group="$(id -gn $user_name)"
    echo "$primary_group"
}
create_user()
{
    # =========================================
    # :: Function to create user lol
    #   1. Append all arguments into the command
    #   2. Execute command and create
    # =========================================

    # --- Head
    ### Parameters ###
    u_name="$1"                 # User Name
    # Get individual parameters
    u_primary_Group="$2"        # Primary Group
    u_secondary_Groups="$3"     # Secondary Groups
    u_home_Dir="$4"             # Home Directory
    u_other_Params="$5"         # Any other parameters after the first 3

    # Local variables
    u_create_Command="useradd"
    create_Token="0"            # 0 : not Created; 1 : Created

    # --- Processing
    # Get Parameters
    if [[ ! "$u_home_Dir" == "NIL" ]]; then
        # If Home Directory is not Empty
        u_create_Command+=" -m "
        u_create_Command+=" -d $u_home_Dir "
    fi

    if [[ ! "$u_primary_Group" == "NIL" ]]; then
        # If Primary Group is Not Empty
        u_create_Command+=" -g $u_primary_Group "
    fi

    if [[ ! "$u_secondary_Groups" == "NIL" ]]; then
        # If Primary Group is Not Empty
        u_create_Command+=" -G $u_secondary_Groups "
    fi

    if [[ ! "$u_other_Params" == "NIL" ]]; then
        # If there are any miscellenous parameters
        u_create_Command+=" $u_other_Params "
    fi

    u_create_Command+="$u_name"

    # --- Output
    # Return Create Command
	echo "$u_create_Command"
}

# Post-Installation Stages
postinstallation()
{
	#
	# Post-Installation Recommendations and TODOs 
	# - To be seperated into its own individual scripts for running
	# 

	### Header ###

	# Local Variable
	postinstall_commands=()

	### Body ###
	# =========== #
	# Enable Sudo #
	# =========== #
	postinstall_commands+=(
        "echo \(+\) Enable sudo"
        "sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers"				# PostInstall Must Do | Step 1: Enable sudo for group 'wheel'
	)

	# =============== #
	# User Management #
	# =============== #
	postinstall_commands+=(
	    "echo \(+\) User Management"
    )
    # Loop through all users in user_profiles and
    # See if it exists, follow above documentation
    for u_ID in "${!user_Info[@]}"; do
		curr_user="${user_Info[$u_ID]}"
		curr_user_Params=($(seperate_by_Delim $curr_user ','))
    
        # Get individual parameters
		u_name="${curr_user_Params[0]}"					# User Name
        u_primary_Group="${curr_user_Params[1]}"        # Primary Group
        u_secondary_Groups="${curr_user_Params[2]}"     # Secondary Groups
        u_home_Dir="${curr_user_Params[3]}"             # Home Directory
        u_other_Params="${curr_user_Params[@]:4}"       # Any other parameters after the first 3

		# Check if user exists
        echo -e "(+) Checking for user $u_name..."
        u_Exists=`arch-chroot $dir_Mount /bin/bash -c "getent passwd $u_name"` #  Check if user exists | Empty if Not Found

        if [[ "$u_Exists" == "" ]]; then
            # 0 : Does not exist
            echo "(-) User [$u_name] does not exist"

            u_create_Command="useradd"
            # Get Parameters
            if [[ ! "$u_home_Dir" == "NIL" ]]; then
                # If Home Directory is not Empty
                u_create_Command+=" -m "
                u_create_Command+=" -d $u_home_Dir "
            fi

            if [[ ! "$u_primary_Group" == "NIL" ]]; then
                # If Primary Group is Not Empty
                u_create_Command+=" -g $u_primary_Group "
            fi

            if [[ ! "$u_secondary_Groups" == "NIL" ]]; then
                # If Primary Group is Not Empty
                u_create_Command+=" -G $u_secondary_Groups "
            fi

            if [[ ! "$u_other_Params" == "NIL" ]]; then
                # If there are any miscellenous parameters
                u_create_Command+=" $u_other_Params "
            fi

            u_create_Command+="$u_name"

			postinstall_commands+=(
				"$u_create_Command"
                "echo \"\t(+) Password change for $u_name\""
				"if [[ \"\$?\" == \"0\" ]]; then"
                "	passwd $u_name"
				"fi"
			)
        fi
    done
	
	
	### Footer ###

	# =============== #
	# Execute Command #
	# =============== #

	# Combine into a string
	cmd_str=""
	for c in "${postinstall_commands[@]}"; do
		cmd_str+="\n$c"
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
		echo "arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe""
	else
		chmod +x $mount_Root/$script_to_exe
		arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe"
	fi
	
	external_scripts+=(
		### Append all external scripts used ###
		$mount_Root/$script_to_exe
	)
}

postinstall_todo()
{
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

postinstall_sanitize()
{
	# ========================== #
	#        Sanitize user       #
	#   To sanitize the account  #
	# from any unnecessary files #
	# ========================== #
	# Local Variables
	dir_Mount="${mount_Group["2"]}"

	number_of_external_scripts="${#external_scripts[@]}"
	echo -e "External Scripts created:"
	for ((i=0; i < $number_of_external_scripts; i++)); do
		echo "[$i] : [${external_scripts[$i]}]"
	done
	read -p "What would you like to do to the root scripts? [(C)opy to user|(D)elete|<Leave empty to do nothing>]: " action
	case "$action" in
		"C" | "Copy")
			read -p "Copy to which user? [(A)ll created users|(S)elect]: " users

			# Copy to stated users
			case "$users" in
				"A" | "All")
					# Loop through all users in user_profiles and
					# See if it exists, follow above documentation
					for u_ID in "${!user_Info[@]}"; do
						curr_user="${user_Info[$u_ID]}"
						curr_user_Params=($(seperate_by_Delim $curr_user ','))
					
						# Get individual parameters
						u_name="${curr_user_Params[0]}"					# User Name
						u_primary_Group="${curr_user_Params[1]}"        # Primary Group
						u_secondary_Groups="${curr_user_Params[2]}"     # Secondary Groups
						u_home_Dir="${curr_user_Params[3]}"             # Home Directory
						u_other_Params="${curr_user_Params[@]:4}"       # Any other parameters after the first 3

						echo "Copying from [$PWD] : curl_repositories.sh => /mnt/$u_home_Dir"
						cp curl_repositories.sh /mnt/$u_home_Dir/curl_repositories.sh														# Copy script from root to user
						arch-chroot $dir_Mount /bin/bash -c "chown -R $u_name:$u_primary_Group $u_home_Dir/curl_repositories.sh"		# Change ownership of file to user
					done
					;;
				"S" | "Select")
					# User Input
					read -p "User name: " sel_uhome
					sel_primary_group=$(arch-chroot $dir_Mount /bin/bash -c "su - $sel_uhome -c 'echo \$(id -gn $sel_uhome)'")
					sel_uhome_dir=$(arch-chroot $dir_Mount /bin/bash -c "su - $sel_uhome -c 'echo \$HOME'")
					echo "Copying from [$PWD] : curl_repositories.sh => /mnt/$sel_uhome_dir/curl_repositories.sh"
					cp curl_repositories.sh /mnt/$sel_uhome_dir/curl_repositories.sh
					arch-chroot $dir_Mount /bin/bash -c "chown -R $sel_uhome:$sel_primary_group $sel_uhome_dir/curl_repositories.sh"		# Change ownership of file to user
					;;
				*)
					;;
			esac

			# Reset script to let user delete if they want to
			postinstall_sanitize
			;;
		"D" | "Delete")
			read -p "Delete the scripts? [(Y)es|(N)o|(S)elect]: " del_conf
			# Yes - Delete
			# No - Nothing
			# Select - Allow user to choose
			case "$del_conf" in
				"Y" | "Yes") 
					# Delete all
					for ((i=0; i < $number_of_external_scripts; i++)); do
						if [[ "$MODE" == "DEBUG" ]]; then
							echo "rm -r ${external_scripts[$i]}"
						else
							rm -r ${external_scripts[$i]}
						fi
					done
					;;
				"S" | "Select")
					# Let user choose
					# Seperate all options with delimiter ','
					echo -e "Please enter all files you wish to delete\n	(Seperate all options with delimiter ',')"
					read -p "> : " del_selections
					# Seperate selected options with ',' delimited
					arr_Selected=($(seperate_by_Delim "$del_selections" ','))
					# Delete selected files if not empty
					if [[ ! "$del_selections" == "" ]]; then
						for sel in "${arr_Selected[@]}"; do
							# Delete selected files
							if [[ "$MODE" == "DEBUG" ]]; then
								echo "rm -r ${external_scripts[$sel]}"
							else
								rm -r ${external_scripts[$sel]}
							fi
						done
					fi
					;;
				*)
					;;
			esac
			;;
		*)
			echo "No action."
			;;
	esac
	echo "Sanitization Completed."
}

installer()
{
	#
	# Main setup installer
	#
    echo -e "(S) Starting Base Installation..."

	echo "========================"
	echo "Stage 1: Prepare Network"
	echo "========================"
    echo "(S) 1. Testing Network..."
	network_Enabled="$(verify_network)"
	if [[ "$network_Enabled" == "False" ]]; then
		sudo dhcpcd && \
            echo -e "(+) Network is activated" || \
            echo -e "(+) Error starting Network"
    else
        echo -e "(+) Network is active"
	fi
    echo "(D) Network testing completed."

    if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "=========================================="
	echo "Stage 2: Verify Boot Mode (i.e. UEFI/BIOS)"
	echo "=========================================="
    echo -e "(S) Verifying Boot Mode..."
	boot_Mode="$(verify_boot_Mode)"
    echo -e "(+) Boot Mode: $boot_Mode"
    echo -e "(D) Boot Mode verification completed."

    if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "============================"
	echo "Stage 3: Update System Clock"
	echo "============================"
    echo -e "(S) Updating System Clock..."
    update_system_Clock
    echo -e "(D) System clock updated."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "============================"
	echo "Stage 4: Partition the Disks"
	echo "============================"
    echo -e "(S) Starting Disk Management..."
    device_partition_Manager
    echo -e "(D) Disk Management completed."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "===================="
	echo "Stage 5: Mount Disks"
	echo "===================="
    echo -e "(S) Mounting disks..."
	mount_Disks
    echo -e "(D) Disks mounted."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "======================="
	echo "Stage 6: Select Mirrors"
	echo "======================="
    echo -e "(S) Selecting mirrors..."
	echo $EDITOR /etc/pacman.d/mirrorlist
    echo -e "(D) Mirror selected."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==================================="
	echo "Stage 7: Install essential packages"
	echo "==================================="
    echo -e "(S) Strapping packages to mount point..."
	pacstrap_Install
    echo -e "(D) Packages strapped."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==========================================="
	echo "Stage 8: Generate fstab (File System Table)"
	echo "==========================================="
    echo -e "(S) Generating Filesystems Table in /etc/fstab"
	fstab_Generate
    echo -e "(D) Filesystems Table generated."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==========================="
	echo "Stage 9: Chroot and execute"
	echo "==========================="
    echo -e "(S) Executing chroot commands"
	arch_chroot_Exec # Execute commands in arch-chroot
    echo -e "(D) Commands executed"

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "======================="
	echo "Installation Completed."
	echo "======================="

	echo ""

	echo "================="
	echo "Post-Installation"
	echo "================="
    echo -e "(S) Starting Basic Post-Installation"

    echo -e "(+) Running post-installation..."
	postinstallation
    echo -e "(+) Post-Installation execution completed"

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "========================"
	echo "Sanitization and Cleanup"
	echo "========================"
    echo -e "(+) Running finalization and sanitization..."
	postinstall_sanitize
    echo -e "(+) Sanitization completed"

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

    echo -e "(D) Basic Post-Installation processes completed."


    read -p "(D) Finished, press anything to quit." finish	
}

setup()
{
    : "
    Setup all associative arrays and variables that are not expected to be touched
    and to be reinitialized if changes are made on a settings level
    "
    # [Associative Array]

    ### Device and Partitions
    device_Parameters=(
        # EDIT: Modify this
        [device_Type]="$deviceParams_devType"
        [device_Name]="$deviceParams_Name"
        [device_Size]="$deviceParams_Size"
        [device_Boot]="$deviceParams_Boot"
        [device_Label]="$deviceParams_Label"
    )

    partition_Configuration=(
        # EDIT: Modify this
        # [Background Information]
        # Compilation of all partitions
        # Please append according to your needs
        # [Syntax]
        # ROW_ID="<partition_ID>;<partition_Name>;<partition_file_Type>;<partition_start_Size>;<partition_end_Size>;<partition_Bootable>;<partition_Others>
        [1]="${boot_Partition[0]}"
        [2]="${boot_Partition[1]}"
        [3]="${boot_Partition[2]}"
    )

    partition_Parameters=(
        # This is the default container for partition parameters
        # - created to store partition parameter as global variable
        # This will be used to dynamically store data
        # You do not need to edit this
        [part_ID]=1
        [part_Name]="Boot"
        [part_Type]="primary"
        [part_file_Type]="ext4"
        [part_start_Size]="0%"
        [part_end_Size]="1024MiB"
        [part_Bootable]=True
        [part_Others]=""
    )

    ### Mounts
    mount_Group=(
        # EDIT: Modify this
        # Place all your partition path 
        #	corresponding to the partition number
        # [Syntax]
        #   [partition-n]="/partition/mount/path"
        [1]="${mount_Paths[0]}"	# Boot
        [2]="${mount_Paths[1]}"	# Root
        [3]="${mount_Paths[2]}"	# Home
    )

    ### Region & Location
    location=(
        # Regional & Location
        # Your Region, Your City etc.
        # EDIT: Modify this
        [region]="$location_Region"
        [city]="$location_City"
        [language]="$location_Language"
        [keymap]="$location_KeyboardMapping"
    )

    ### Packages
    pkgs=(
        # All Packages
        #	- pacstrap packages etc.
        # Please append all new categories below in the key while
        #	the array for the category in the values
        [pacstrap]="${pacstrap_pkgs[@]}"
    )

    ### User Control
    user_Info=(
        # EDIT: Modify this
        # User Profile Information
        # [Delimiters]
        # , : For Parameter seperation
        # ; : For Subparameter seperation (seperation within a parameter itself)
        # [Notes]
        # Please put 'NIL' for empty space
        # [Syntax]
        # ROW_ID="
        #	<username>,
        #	<primary_group>,
        #	<secondary_group (put NIL if none),
        #	<custom_directory_path (if custom_directory is True)>
        #	<any other parameters>
        # "
        # [Examples]
        # [1]="username,wheel,NIL,/home/profiles/username"
        [1]="${user_ProfileInfo[0]}"
    )

    ### Network Configurations
    network_config=(
        # EDIT: Modify this
        # Network Configuration info
        [hostname]="$networkConfig_hostname"
    )

    ### Operating System Definitions
    osdef=(
        # EDIT: Modify this
        # Operating System Definitions 
        # - Bootloader, Kernels (to be added) etc.
        [bootloader]="$bootloader"					# Your Bootloader
        [optional-parameters]="$bootloader_Params"	# Your Bootloader's additional parameters outside of the main important ones
        [target_device_Type]="$platform_Arch"		# Your Target Device Type
    )

    ### Linux Definitions
    linux=(
        ["kernel"]="$default_kernel" # Default Kernel
    )
}

init()
{
	#
	# Initialization
	# 
    echo -e "(S) Starting Initialization..."
	echo "Program Name: $PROGRAM_NAME"
	echo "Program Type: $PROGRAM_TYPE"
	echo "Distro: $DISTRO"
    echo -e "(+) Verifying Environment Variables..."
    setup
    if [[ "$TARGET_DISK_NAME" == "" ]]; then
        while [[ "$deviceParams_Name" == "" ]]; do
            echo -e "(-) TARGET_DISK_NAME not set"
            read -p "Please indicate target disk (i.e. /dev/sdX): " deviceParams_Name
        done
        echo -e "(+) Target disk set to $deviceParams_Name"

        device_Parameters["device_Name"]=$deviceParams_Name
    fi
    echo -e "(D) Initialization completed"
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

