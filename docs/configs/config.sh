#==============================#
# Distro Installer Config File #
#==============================#
: "
Variables to be imported into the installer file

:: Usage
    # Enable executable
    chmod +x config.sh

    cfg_name='config.sh'
    # Import Library
    if [[ -f 'config.sh']]; then
        # Found 
        . config.sh
    else
        # Not Found
        # statements...
        exit 1
    fi
"

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
	# This contains the mount paths mapped to the partition name
	# Note:
	#   - Please seperate all parameters with delimiter ','
	#   - Please seperate all subvalues with delimiter ';'
	#
	# Syntax:
	# [Partition Name],[mount path]
	#
	# Some Manadatory partition names:
	#   - For Boot Partition : 'Boot'
	#   - For Root Partition : 'Root'
	"Boot,/mnt/boot"	# Boot
	"Root,/mnt"			# Root
	"Home,/mnt/home"	# Home
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
platform_Arch="<platform-architecture>" # Your Platform Architecture i.e. [ i386-pc | x86_64 ]
