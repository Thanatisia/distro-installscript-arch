# Base Installation Script (ArchLinux Edition)

This page contains the Base Installation Scripts

## Table of Contents:
- [Information](#information)
- [Setup](#setup)
- [Documentation](#documentation)
- [References](#references)
- [FAQs](#faqs)

## Information

### Program Information

+ Program Name: Base Install Script (ArchLinux Edition)
+ Program Version: v1.0.0

### Background Information

+ Initially started in 2 forms, 'installer-manual.sh' and 'installer-ux.min.sh' that basically has 2 styles of configs but they do the same function - to perform a linux distro's base installation
+ Thus, I combined them to make installer.remake.sh where it too had 2 forms.
+ Eventually narrowed down and got a external-config sourcing style configuration script and renamed to 'distinstall' (for now)

## Files

+ README.md     : README for the Base Installation-related scripts
+ CHANGELOG.md  : The Changelogs
+ Makefile      : A makefile for automate compilation/installation using the installer
+ distinstall   : The Distribution install script

## Setup

### Pre-Requisites

- git
- curl

### Dependencies

+ arch-install-scripts

### Obtaining

1. via cloning (Whole)
	- This method will require you to download/clone the entire repository

	+ Syntax: git clone https://github.com/Thanatisia/distro-installscript-arch

2. via cloning (Folder)
	- This method will use the git 'sparse-checkout' to download a specific folder in the repository
	- in this case : base-installation

	- Syntax: 
		1. Initialize Local Git
			```console
            git init
            ```

		2. Add path of remote repository
			```console
            git remote add -f origin https://github.com/Thanatisia/distro-installscript-arch
            ```
            
		3. (OPTIONAL) Add config
			```console
            git config user.name {username}

			git config user.email {email}
            ```
            
		4. Initialize sparse-checkout git local repository folder
			```console
            git sparse-checkout init
            ```
            
		5. Set path to tree
            ```console
			git sparse-checkout set "https://github.com/Thanatisia/distro-installscript-arch/tree/main/base-installation"
            ```
            
		6. Verify sparse-checkout
			```console
            git sparse-checkout list
            ```
            
		7. Update new repository from sparse-checkout remote repository url
			```console
            git pull origin {branch}
            ```
            
3. via curl

	- This method allows you to download specifically the script to use

	- Syntax: 
		```console
		curl -L -O https://raw.githubusercontent.com/<author>/<repository_name>/<branch>/[folder/to/script_name.sh]
		```

	- Examples:
		- distinstall : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/distinstall
        
### Preparation/Setup

- Change permission to enable running
    ```sh
    chmod u+x distinstall
    ```

- Configuration File 
    + Download the sample configuration file 
        ```sh
        curl -L -O https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/docs/configs/config.sh
        ```
    + Generate the template configuration file in initial run
        ```sh
        ./distinstall
        ```
        
- Edit the configuration file and set variables according to requirements
	```console
    $EDITOR distinstall
	```

- (OPTIONAL) Backup the file for re-usage
	

### Installation/Compilation

## Documentation

### Synopsis/Syntax

+ TARGET_DISK_NAME='your-disk-label (/dev/sdX)' (./)installer.remake.sh {MODE}

### Parameters/Options/Flags

- Positional Arguments
    1. MODE <options> : The mode to run the program
        + Default: DEBUG
        - Options
            + DEBUG     : Use this to run the program and see the commands being used 				(DEFAULT) 
            + RELEASE   : Use this to set the program to release and actually make changes to the system 

### Usage

1. Change Permission for use (Execute [+x])
    ```console
    chmod +x installer.remake.sh
    ```

2. (OPTIONAL) If you want to test before official use (RECOMMENDED)
    ```console
    TARGET_DISK_NAME="/dev/sdX" (./)installer.remake.sh
    ```	

3. Run Program
    ```console
    TARGET_DISK_NAME="/dev/sdX" (./)installer.remake.sh RELEASE
    ```

4. Let Program run and just input your answers if there are any prompts

### Configuration and Customization

- Environment Variables
    + TARGET_DISK_NAME : To set the disk/device label you wish to use (/dev/sdX)

## References

### Notes

- 2022-03-05 1147H : Asura
	- The script only has support for MBR (MSDOS/BIOS) Bootloader style
	    + Implementation of UEFI (EFI) support is currently in the plans
	- Scripts only support installation from the ArchLinux Installer
		+ Installation from an existing distro is currently in the works

- 2022-04-23 1617H : Asura
	- $mount_Paths
		+ Please note that if you edit this variable, please append to mount_Group
			```console
			[mount_Paths_pos_index+1]="${mount_Paths[index]}"
			```
	- $mount_Group
		+ As of v0.4.0-alpha : The root directory (/mnt) will always be placed in index [2] of $mount_Group variable

- 2022-06-17 2333H : Asura
    - Features
        - installer has been tested with both ArchISO and an existing linux distribution - using a base arch install with dependency [arch-install-scripts]
            + please refer to [CHANGELOGS](CHANGELOG.md) for more info
    - Deprecation and Archiving
        - installer-manual.sh will be deprecated and archived by the end of this week (2022-06-19 Sunday) in consideration that
            + I figured that having 2 scripts for base installation - although they are designed with different styles in mind and that I thought it would be useful for different people - was kinda redundant
            + since it was basically the same script where one was designed to operate on top of variables linked with the associative arrays
        - installer-ux.min.sh will be considered and might be deprecated after installer.remake.sh is tested and there are no added benefits for installer-ux.min.sh to remain.
        - installer.remake.sh will potentially be renamed to something better, name is currently a WIP
    - Application has only been officially tested to work with MBR/MSDOS support
        + UEFI support to be implemented (in TODO)
    - Please becareful and test it in a Virtual Environment before deploying to production/live environment
    
- 2022-07-02 0030H : Asura
    - Initial Stable Release v1.0.0 (Finally)
        + Please refer to [CHANGELOGS](CHANGELOG.md) for more info on changes
    - installer-ux.min.sh has been officially deprecated
    - installer.remake.sh is renamed to 'distinstall' for the time being
    - Documentations have been modified and deleted accordingly
    - Old files can currently (as of release) be found in the Archives references folder for a short period of time
    
## FAQs

## TODO
+ [] Seperate and create script 'postinstallation-utilities.sh' for PostInstallation processes (non-installation focus)
    - [] 'Repository' :
        + [] Enable multilib repository
    - [] 'Sudo' :
        + [] Set sudo priviledges
    - [] 'Administative' : 
        + [] Create User Account
    - [] 'System Maintenance' : 
        + [] Swap Filer
+ [] Think of a name for the base installation script
+ [] Add installation support for UEFI with Grub
 
