"""
Setup Function
"""
## Built-in
import os
import sys

## External Libraries
from lib.cli import CLIParser
from lib.format import Text
from lib.env import Environment
import app.distributions as dist

class Setup():
    """
    Initialization and setup
    """
    def __init__(self):
        """
        Constructor
        """
        # Initialize Class
        self.cliparser = CLIParser()
        self.fmt_Text = Text()

    def init_prog_Info(self, program_scriptname, program_appName, program_Type, program_Version, program_Mode, distribution, config_Name="config.yaml"):
        # Initialize Variables
        self.PROGRAM_SCRIPTNAME = program_scriptname
        self.PROGRAM_NAME = program_appName
        self.PROGRAM_TYPE = program_Type
        self.PROGRAM_VERSION = program_Version
        self.MODE = program_Mode # { DEBUG | RELEASE }
        self.DISTRO = distribution
        self.cfg_name = config_Name

    def init_Variables(self):
        """
        Initialize Variables
        """
        # Initialize system variables
        self.default_Var = {
            ## Lists
            ### Stores all external scripts created
            "external_scripts" : [],
            ## Associative Array/Dictionaries
            ### Device and Partitions
            "device_Parameters" : {},
            "partition_Configuration" : {},
            "partition_Parameters" : {},
            "partition_Layout" : {},
            ### Mounts
            "mount_Group" : {},
            ### Region & Location
            "location" : {},
            ### Packages
            "pkgs" : {},
            ### User Control
            "user_Info" : {},
            ### Network Configurations
            "network_config" : {},
            ### Operating System Definitions
            "osdef" : {},
            ### Linux Definitions
            "linux" : {},
        }

    def system_Configs(self):
        """
        Setup all default associative arrays and variables that are not expected to be touched
        and to be reinitialized if changes are made on a system level
        """
        # [Associative Array]

        ### Device and Partitions
        self.device_Parameters=(
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
            # [1]="${boot_Partition[0]}"
            # [2]="${boot_Partition[1]}"
            # [3]="${boot_Partition[2]}"
        )
        for curr_partition_row in "${!boot_Partition[@]}"; do
            curr_partition="${boot_Partition[$curr_partition_row]}"
            count=$((curr_partition_row+1))
            partition_Configuration[$count]=$curr_partition
        done

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
            # This corresponds to the configuration variable 'mount_Paths'
            #
            # EDIT: Modify this
            # Place all your partition path 
            #	corresponding to the partition name
            #
            # [Syntax]
            #   [partition-name]="/partition/mount/path"
            #
            # [Example]
            #     [Boot]="${mount_Paths[0]}"	# Boot
            #     [Root]="${mount_Paths[1]}"	# Root
            #     [Home]="${mount_Paths[2]}"	# Home
        )
        for i in ${!mount_Paths[@]}; do
            # Get current mount row
            curr_mount_row=${mount_Paths[$i]}

            # Get mount directory and partition name from path definition
            part_Name="$(echo $curr_mount_row | cut -d ',' -f1)"
            mount_dir="$(echo $curr_mount_row | cut -d ',' -f2)"

            # Set Key-Value
            mount_Group[$part_Name]=$mount_dir
        done

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
            # [1]="${user_ProfileInfo[0]}"
        )
        for curr_profile_row in "${!user_ProfileInfo[@]}"; do
            curr_profile="${user_ProfileInfo[$curr_profile_row]}"
            user_Info[$curr_profile_row]=$curr_profile
        done

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
            [bootloader]="$bootloader"					# Your Bootloader as defined in the configuration file
            [bootloader-directory]="$bootloader_directory" # The Bootloader directory as defined in the configuration file; Default: /boot/grub
            [optional-parameters]="$bootloader_Params"	# Your Bootloader's additional parameters outside of the main important ones as defined in the configuration file
            [target_device_Type]="$platform_Arch"		# Your Target Device Architecture/Type as defined in the configuration file
        )

        ### Linux Definitions
        linux=(
            ["kernel"]="$default_kernel" # Default Kernel
        )

    def start(self):
        """
        Start setup
        """




