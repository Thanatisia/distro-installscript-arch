#!/bin/env bash
<<EOF
Setup class library module
- To initialize specifications such as 
	+ dependencies
	+ files required
EOF

DEPENDENCIES=()

setup()
{
    : "
    Setup all associative arrays and variables that are not expected to be touched
    and to be reinitialized if changes are made on a settings level
    "
    # [Associative Array]

    ### Device and Partitions
    declare -gA device_Parameters=(
        # EDIT: Modify this
        [device_Type]="$deviceParams_devType"
        [device_Name]="$deviceParams_Name"
        [device_Size]="$deviceParams_Size"
        [device_Boot]="$deviceParams_Boot"
        [device_Label]="$deviceParams_Label"
    )

    declare -gA partition_Configuration=(
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

    declare -gA partition_Parameters=(
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
    declare -gA mount_Group=(
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
    declare -gA location=(
        # Regional & Location
        # Your Region, Your City etc.
        # EDIT: Modify this
        [region]="$location_Region"
        [city]="$location_City"
        [language]="$location_Language"
        [keymap]="$location_KeyboardMapping"
    )

    ### Packages
    declare -gA pkgs=(
        # All Packages
        #	- pacstrap packages etc.
        # Please append all new categories below in the key while
        #	the array for the category in the values
        [pacstrap]="${pacstrap_pkgs[@]}"
    )

    ### User Control
    declare -gA user_Info=(
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
    declare -gA network_config=(
        # EDIT: Modify this
        # Network Configuration info
        [hostname]="$networkConfig_hostname"
    )

    ### Operating System Definitions
    declare -gA osdef=(
        # EDIT: Modify this
        # Operating System Definitions 
        # - Bootloader, Kernels (to be added) etc.
        [bootloader]="$bootloader"					# Your Bootloader
        [optional-parameters]="$bootloader_Params"	# Your Bootloader's additional parameters outside of the main important ones
        [target_device_Type]="$platform_Arch"		# Your Target Device Type
    )

    ### Linux Definitions
    declare -gA linux=(
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

import()
{
	# import external library scripts
	declare -gA ext_libs=(
		[baselib.sh]="libs/base-installation"
		[postlib.sh]="libs/post-installation"
	)

	# import distro-specific library scripts
	case "$DISTRO" in
		"ArchLinux")
			ext_libs["arch.sh"]="libs/base-installation"
			;;
		"Debian")
			ext_libs["debian.sh"]="libs/base-installation"
			;;
		"Gentoo")
			ext_libs["gentoo.sh"]="libs/base-installation"
			;;
	esac

	# Start sourcing
	for ext_filename in "${ext_libs[@]}"; do
		ext_filepath="${ext_libs[$ext_filename]}"
		ext_file="$ext_filepath/$ext_filename"
		if [[ -f $ext_file ]]; then
			source $ext_file
		fi
	done
}


