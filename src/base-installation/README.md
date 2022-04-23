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

Program Name: Base Install Script (ArchLinux Edition)
Program Version: v0.4.0-alpha

### Background Information

The general differences between the 2 files are as follows

- Manual : Variables are defined in arrays & associative arrays directly labelled with 'EDIT THIS'

- Simple : Arrays & Associative Arrays have all been predefined and "Symlinked" with variable containers at the top
	- You (the user) just need to modify the variables labelled under 'EDIT THIS' at the top

Generally they are the same function wise, however - the variable setup and arrangement is different to fit your preference. Thus, they are considered the same version history

## Setup

### Pre-Requisites

- git
- wget/curl

### Obtaining

1. via cloning (Whole)
	- This method will require you to download/clone the entire repository

	Syntax: git clone https://github.com/Thanatisia/distro-installscript-arch

2. via cloning (Folder)
	- This method will use the git 'sparse-checkout' to download a specific folder in the repository
	- in this case : base-installation

	Syntax: 
		1. Initialize Local Git
			git init

		2. Add path of remote repository
			git remote add -f origin https://github.com/Thanatisia/distro-installscript-arch

		3. (OPTIONAL) Add config
			git config user.name {username}

			git config user.email {email}

		4. Initialize sparse-checkout git local repository folder
			git sparse-checkout init

		5. Set path to tree
			git sparse-checkout set "https://github.com/Thanatisia/distro-installscript-arch/tree/main/base-installation"

		6. Verify sparse-checkout
			git sparse-checkout list

		7. Update new repository from sparse-checkout remote repository url
			git pull origin {branch}

3. via curl

	- This method allows you to download specifically the script to use

	Syntax: 
		```shellscript
		curl -L -O https://raw.githubusercontent.com/<author>/<repository_name>/<branch>/[folder/to/script_name.sh]
		```

	Examples:
		installer-manual.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/installer-manual.sh
		installer-ux.min.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/installer-ux.min.sh

### Preparation/Setup

- Edit the script
	```bash
	$EDITOR installer-ux.min.sh
	```

- Modify file info according to your requirements
	```
	NOTE: You can just edit those labelled with "# EDIT: MODIFY THIS" if you do not know where to start
	```

- (OPTIONAL) Backup the file for re-usage
	

### Installation/Compilation

## Documentation

- installer-ux.min.sh
	### Synopsis/Syntax

	./installer-ux.min.sh {MODE}

	### Parameters/Options/Flags

	MODE : The mode to run the program
		Default: DEBUG
		
	Options:
		DEBUG	: Use this to run the program and see the commands being used 				(DEFAULT)
		RELEASE : Use this to set the program to release and actually make changes to the system
	
	### Usage

	1. Change Permission for use (Execute [+x])
		chmod +x installer-ux.min.sh

	2. (OPTIONAL) If you want to test before official use (RECOMMENDED)
		./installer-ux.min.sh
	
	3. Run Program
		./installer-ux.min.sh RELEASE

	4. Let Program run and just input your answers if there are any prompts

- installer-ux.min.sh
	### Synopsis/Syntax

	./installer-manual.sh {MODE}

	### Parameters/Options/Flags

	MODE : The mode to run the program
		Default: DEBUG
		
	Options:
		DEBUG	: Use this to run the program and see the commands being used 				(DEFAULT)
		RELEASE : Use this to set the program to release and actually make changes to the system
	
	### Usage

	1. Change Permission for use (Execute [+x])
		chmod +x installer-manual.sh

	2. (OPTIONAL) If you want to test before official use (RECOMMENDED)
		./installer-manual.sh
	
	3. Run Program
		./installer-manual.sh RELEASE

	4. Let Program run and just input your answers if there are any prompts

## References

### Notes

- 2022-03-05 1147H : Asura

	- The script only has support for MBR (MSDOS/BIOS) Bootloader style
		- Implementation of UEFI (EFI) support is currently in the plans

	- Scripts only support installation from the ArchLinux Installer
		- Installation from an existing distro is currently in the works

## FAQs


