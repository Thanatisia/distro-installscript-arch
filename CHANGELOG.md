# Changelogs

## Version History
```
Version Naming Convension : major.minor.patches-status
```

### Notes and Updates

- 2022-04-23 1107H, Asura
	- Currently going through a overhaul to the README, will be adding the other versions below

### Modifications

```
release_date | version_number | release_author
```
+ 2021-06-15 0104H | v0.1.0 | Asura
+ 2021-10-15 1335H | v0.2.0 | Asura
+ 2022-03-04 1406H | v0.2.1 | Asura
+ 2022-04-23 1120H | v0.3.0 | Asura
+ 2022-04-23 1450H | v0.4.0-alpha | Asura
+ 2022-06-19 0133H | v0.5.0-alpha | Asura
+ 2022-06-20 1637H | v0.6.0-alpha | Asura
+ 2022-07-02 0025H | v1.0.0 | Asura 
+ 2022-07-15 1633H | v1.0.1 | Asura
+ 2022-08-27 1651H | v1.1.0 | Asura
+ 2023-01-19 1849H | v1.1.1 | Asura
+ 2023-01-20 1635H | v1.1.2 | Asura
+ 2023-02-06 1518H | v1.4.0 | Asura
+ 2023-02-08 1641H | v1.4.1 | Asura
+ 2023-09-19 2014H | v1.4.2 | Asura

### CHANGELOGS
```
release_date | version_number:
	- Changes Here
```
- 2021-06-15 0104H | v0.1.0
	- Created repository

- 2021-10-15 1335H | v0.2.0
	- Migrated archlinux install scripts from repository [SharedSpace](https://github.com/Thanatisia/SharedSpace) to current repository
		+ Folder "base-installation" and "post-installation" 
	- Folders Changed
		+ base-installation
		+ post-installation

- 2022-03-04 1406H | v0.2.1
	+ Fixed loop bug in 'installer-manual.sh' from base-installation
	- Files Changed
		- base-installation/installer-manual.sh
			+ Script should now be on par with [base-installation/installer-manual.min.sh]

- 2022-04-23 1120H | v0.3.0
	- Performing Refactoring of README.md and CHANGELOG.md
		+ Moving CHANGELOGS from README to CHANGELOG.md (You probably are viewing this in the new CHANGELOG)
	- Files Changed
		+ README.md

- 2022-04-23 1450H | v0.4.0-alpha
	+ Moved the [base-installation] and [post-installation] folders into "src/" folder
	- Files Changed
		+ base-installation/
		+ post-installation/

- 2022-06-19 0133H | v0.5.0-alpha
    - Created folders
        - dev/ : For Development Builds (similar to Development Branch)
            + src/ : Source Files in the Development Folder
        + docs/configs/ : To contain all templates and config files
        - references/ : To store all references and resources 
            + deprecated/ : Temporary storage to store all deprecated files for deletion and/or archival
            + Samples/ : Contains all sample scripts with a pre-specified values that meets a specific criteria. Users can go into this directory, select a preset script and just download the file to install

- 2022-06-20 1637H | v0.6.0-alpha
    + Edited README to include latest specifications and Information
    + Updated CONTRIBUTING.md
    - Base Installer
        + installer-manual.sh (v0.4.0-alpha) has been Deprecated
        + installer-ux.min.sh (v0.4.0-alpha) updated
        + installer.remake.sh (v0.8.0-alpha) updated

- 2022-07-02 0025H | v1.0.0
    - Initial major stable release v1.0.0
    - Deprecated
        + installer-manual.sh line
        + installer-ux.min.sh line
    + Renamed 'installer.remake-{version}.sh' to distinstall
    
- 2022-07-15 | v1.0.1
    - Updated dependencies
        + Added "parted"
    
- 2022-08-27 1651H | v1.1.0 
    - Updated README with a basic usage and documentation (Please refer to the manual for more detailed information
    - Updated distinstall application manual with additional variables
    - Updated Makefile : Replaced 'installer.remake.sh' with 'distinstall'
    - Updated [TODO](TODO.md) with new TODO in the pipeline

- 2023-01-19 1849H | v1.1.1
    - Packaged release v1.1.0 and created first GitHub releases
        + Will create more releases for any changes regarding the main scripts
    + Updated README with command to download the latest packaged release instead of just cloning
    + Updated TODO list pipeline

- 2023-01-20 1636H | v1.1.2
    - Created documentation guide for the installer configuration file in [Docs - installer configuration.md]('docs/installer configuration.md')
    - Created features write-up
    - Updated TODO pipeline list
    - Relocated manuals and implementation ideas

- 2023-01-21 0007H | v1.2.0
    - [New Features]
        - Command Line Arguments (CLI) support in install script
            + -c | --config : For setting custom configuration file
            + -d | --target-disk : For setting target disk name via CLI argument
            + -g | --generate-config : For generating a new config file template right from the get-go
            + -h | --help : Display help message
            + -m | --mode : Set startup mode; DEBUG or RELEASE
    - [Refactor/Modification]
        - Changed 'MODE' variable from  to a static DEBUG as the command line argument is now dynamic
        - Refactored global variables into individual functions for reusability (i.e. generating or resetting)
            + Script should be cleaner

- 2023-01-25 1435H | v1.3.0-rc1
    - Compilation of all changes and releases
    ```
    [New Features]
    - Command Line Arguments (CLI) support in install script
        + -c | --config : For setting custom configuration file
        + -d | --target-disk : For setting target disk name via CLI argument
        + -g | --generate-config : For generating a new config file template right from the get-go
        + -h | --help : Display help message
        + -m | --mode : Set startup mode; DEBUG or RELEASE
    - display_help() function to display a help menu

    [Refactor/Modification]
    - Changed 'MODE' variable from  to a static DEBUG as the command line argument is now dynamic
    - Refactored global variables into individual functions for reusability (i.e. generating or resetting)
        + Script should also be cleaner, improving readability 
    - Changed documentation for 'distinstall' and README to reflect the latest usage
    - Removed documentation from distinstall script as the help function explains it

    [Errors/Bug Fixes]
    - Error validation and checking, implementing exit if error was detected
    ```

- 2023-02-01 2206H | v1.3.6
    ```
    [New Features]
    - Installer
        - For Developers:
            - 'partition_Configuration', 'mount_Group', 'user_Info' variables in installer now do not need to be statically modified, they will now dynamically read from the config file
                + The syntax is provided in the comments, thus if you wish to statically define, you may do so
            - Partition mounting are no longer statically defined and is now dynamic
                + This means that you can define the mount path in the config file mapped to the Partition Name
                - Note that there's a couple of requirements:
                    - There are special partitions that has a special naming convention
                        + Root partition : For root partitions, you need to name it 'Root' as the mount_Disk function will mount the root partition first before mounting the others
            + New function 'unset_arr_value': To remove an element from an array via the 'unset' function

    [Bug Fixes]
    - Fixed bug where copying of files in postinstall_sanitize() wasnt detecting the user properly, and thus, wasnt copying to the accounts properly
    - Fixed issue where user_ProfileInfo and user_Info variables needed to be manually modified by user (Inefficient)
        + because of that, 'user_Info' was only reading 1 item from the 'user_ProfileInfo' array from the config file
    - Fixed issue where mounting of disk partition wasnt mounting the 'Root' partition first, thus all the mounting were out of position
        - I.E
           + Partition 'Boot' was mounted before Root => Mounting Root overwrote the boot partition => only Root and Home partitions were mounted
           + Partition 'Home' was mounted before Root => Mounting Root overwrote the home partition => Only Root and Boot partitions were mounted, and the Home directory was created inside the mount partition and mounted as the 'Home partition'

    [Changes]
    - configuration file
        - Modified variable 'mount_Paths'
            - Prepended a new column in each row for Partition Name, this is for identification purposes
            - Seperated by ',' delimiter
            - Thus, the current structure for the 'mount_Paths' array is 'Paritition Name,Mount Path'
            - Reason: 
                - This change was made to solve bug/issue no.1 whereby the mount paths are being mounted at inconsistent orders, which means mount directories will be overwritten.
                - This issue can be seen more clearly if you unmount and remount, the home partition will be overwritten - which suggests that the home mount directory was not mounted in the home partition

    - distinstall
        - Modified global variable 'mount_Group'
            - Changes
                - Changed 'curr_mount_row' to 'curr_mount_name'
        - Created function 'unset_arr_value' to remove an element from an array via the 'unset' function using the target value's index
        - Modified function 'mount_Disks' to fix bug/issue no.1
            - Temporary Solution:
                - Root must be mounted before the Boot partition, thus the decision to add a Paritition name at the back of the mount path
                - Notes
                    - There are some mandatory partition names to use
                        - Boot Partition : 'Boot'
                        - Root Partition : 'Root'
        - Fixed static user_Profile definition issue

    - TODO
        - Added more tasks and ideas to the pipeline

    [Created]
    - Created file 'ISSUES.md' to store all issues
    ```

- 2023-02-06 1521H | v1.4.0
    ```
    [New Features]
    - new rule 'download' to download all necessary files in a single target into Makefile
        - Files
            - Download installer from the repository
            - Generate config file using the installer script
        - Purpose:
            + This allows the user to easily obtain the required files just by downloading the Makefile
    - GPT partition table support on UEFI systems into installer
    - GRUB installation with GPT (UEFI)
        - Notes for users
            + Please remember to add '--efi-directory=/boot' to the 'bootloader_Params' variable in the configuration file if you are installing using GPT (UEFI)
    - Swap Partition support
    - New CLI Argument flags
    - New Configuration variables

    [Changes]
    - Makefile
        - Added new rule 'download' to download all necessary files in a single target
            - Download installer
            - Generate config file

    - distinstall
        - Added '-e' | '--editor' flags into CLI Argument to set your default editor
        - Added '--fdisk' and '--cfdisk' flags into CLI Argument for Manual Partition Configuration support
        - Added Swap partition type formatting
        - Added Swap partition enabling (swapon)
        - Removed '--debug' flag from grub-install command by default, please append the '--debug' flag in the 'bootloader_Params' variable in the configuration file
        - Added variable 'bootloader_directory' that corresponds to the configuration variable 'bootloader_directory' that will contain the bootloader's directory in the boot partition
        - Refactored Grub installation structure to use the bootloader_directory variable instead of '/boot/grub' directly for dynamic user control
        - Added Associative Array 'partition_Layout' to map the partition name with the partition configuration for reusability
        - Added GPT partition table support on UEFI systems
        - Added GRUB GPT installation support

    - Configuration file
        - Added new variable 'bootloader-directory' for your bootloader's directory in the boot partition; Certain bootloaders have different boot directories based on the partition table (i.e. MBR/GPT)
            + Default Value: /boot/[your-bootloader]
            - GRUB
                + Recommended: /boot/grub
                + GPT (UEFI): /efi/grub

    - Files Changed
        - Root
            + CHANGELOG
            + TODO

        - docs
            + features.md
            + installer configuration guide

            - Configuration templates
                + Makefile
                + config.sh

            - Manuals
                + distinstall.md

        - Source Files
            + Makefile
            + distinstall (Installer)
    ```

- 2023-09-19 2015H | v1.4.2
    - Performed some simple cleaning up and restructuring to make it easier to navigate the repository, as well as cleaner
    - Added tasks to TODO list that may have become relevant in the time I was busy from school work

