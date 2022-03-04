# distro-installscript-arch

This page contains the Post Installation Scripts

## Table of Contents:
- Files
- Obtaining
- Syntax
- Parameters/Options/Flags
- Pre-Requisites
- Usage
- FAQs

## Files

- For Essential & Core Package (Installation + Setup) : postinstallation-core-packages.sh
- For Root Setup : postinstallations-root.sh
- For General Install + Setup : postinstallations.sh

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
				git sparse-checkout set "https://github.com/Thanatisia/distro-installscript-arch/tree/main/post-installation"

			6. Verify sparse-checkout
				git sparse-checkout list

			7. Update new repository from sparse-checkout remote repository url
				git pull origin {branch}

	3. via curl

		- This method allows you to download specifically the script to use

		Syntax: curl -L -O https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/post-installation/script_name.sh
		Examples:
			installer-ux.min.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/post-installation/postinstallations.sh

## Syntax

	postinstallation-core-packages.sh : 
		./postinstallation-core-packages.sh {MODE}

	postinstallations-root.sh :
		./postinstallations-root.sh

	postinstallations.sh : 
		./postinstallations.sh {base_Distro} {package_manager}


## Parameters/Options/Flags

	postinstallation-core-packages.sh
		MODE : The mode to run the program
			Default: DEBUG
		
			Options:
				DEBUG	: Use this to run the program and see the commands being used 				(DEFAULT)
				RELEASE : Use this to set the program to release and actually make changes to the system

	postinstallations.sh
		base_Distro : Your Base Distribution of Installation
			Default: ArchLinux

			Options:
				ArchLinux (DEFAULT)
				Debian
		package_manager : Your Package Manager of the Base Distribution
			Default: pacman

			Options:
				ArchLinux : pacman (DEFAULT)
				Debian : aptitude (apt)
	

## Pre-Requisites

	1. (OPTIONAL) Edit Variables in script before use 
		- if you have any changes
		$EDITOR script.sh
	
## Usage

	1. Change Permission for use (Execute [+x])
		chmod +x script.sh

	2. Run Program
		./script.sh {arguments}

	3. Let Program run and just input your answers if there are any prompts

## FAQs

