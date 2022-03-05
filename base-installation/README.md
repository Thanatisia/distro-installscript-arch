# distro-installscript-arch

This page contains the Base Installation Scripts

## Table of Contents:
- Notes
- Obtaining
- Syntax
- Parameters/Options/Flags
- Pre-Requisites
- Usage
- FAQs

## Notes
	1. Please note that as of 2022-03-05 1147H : The script only has support for MBR (MSDOS/BIOS) Bootloader style
		- Implementation of UEFI (EFI) support is currently in the plans

## Obtaining
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

		Syntax: curl -L -O https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/base-installation/script_name.sh
		Examples:
			installer-ux.min.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/base-installation/installer-ux.min.sh

## Syntax

	./installer-ux.min.sh {MODE}


## Parameters/Options/Flags

	MODE : The mode to run the program
		Default: DEBUG
		
		Options:
			DEBUG	: Use this to run the program and see the commands being used 				(DEFAULT)
			RELEASE : Use this to set the program to release and actually make changes to the system

## Pre-Requisites

	1. Edit Variables in script before use
		$EDITOR installer-ux.min.sh
	
## Usage

	1. Change Permission for use (Execute [+x])
		chmod +x installer-ux.min.sh

	2. (OPTIONAL) If you want to test before official use (RECOMMENDED)
		./installer-ux.min.sh

	3. Run Program
		./installer-ux.min.sh RELEASE

	4. Let Program run and just input your answers if there are any prompts

## FAQs

