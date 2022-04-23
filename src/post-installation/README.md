# distro-installscript-arch

This page contains the Post Installation Scripts

## Table of Contents:
- [Information](#information)
- [Setup](#setup)
- [Documentation](#documentation)
- [References](#references)
- [FAQs](#faqs)

## Information

### Background Information

This is my set of post-installation scripts designed to go alongside the base-installation script.

- postinstallation-core-packages : contains functions to install and setup essential/core packages in 1 script.
	- You can edit the packages you would like to use inside the script
	- backup the modified script for portable/reusability

- postinstallations-root : Contains functions for root setup (requires sudo). Currently Docs are being written, may be changed according to status of the base installation script

- postinstallations : A general setup process which includes installing of packages that the user/I recommend or use. Automatically setting up of Graphical Environment (Desktop Environment/Window Managers) and the likes.


### Files

- For Essential & Core Package (Installation + Setup) : postinstallation-core-packages.sh
- For Root Setup : postinstallations-root.sh
- For General Install + Setup : postinstallations.sh

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
			git sparse-checkout set "https://github.com/Thanatisia/distro-installscript-arch/tree/main/src/post-installation"

		6. Verify sparse-checkout
			git sparse-checkout list

		7. Update new repository from sparse-checkout remote repository url
			git pull origin {branch}

3. via curl

	- This method allows you to download specifically the script to use

	- Syntax: 
		```shellscript
		curl -L -O https://raw.githubusercontent.com/<author>/<repository_name>/<branch>/[folder/to/script_name.sh]
		```

	- Examples:
		- postinstallations.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/post-installation/postinstallations.sh
		- postinstallation-core-packages.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/post-installation/postinstallation-core-packages.sh
		- postinstallations-root.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/post-installation/postinstallations-root.sh

### Preparation/Setup

- Edit the script
	```console
	$EDITOR {script_name}
	```

- Modify file info according to your requirements
	```
	NOTE: 
		At the moment, there are generally no sections in the post-installation scripts that requires editing for the most part.
		However, please feel free to edit the variables if you deem it necessary.

		Generally the post-installation scripts are to be ran without modifications required, however - this is still a WIP
	```

- (OPTIONAL) Backup the file for re-usage

### Installation/Compilation

## Documentation

postinstallation-core-packages.sh : 

	### Syntax
	./postinstallation-core-packages.sh {MODE}

	### Parameters/Options/Flags
	MODE : The mode to run the program
		Default: DEBUG
		
		Options:
			DEBUG	: Use this to run the program and see the commands being used 				(DEFAULT)
			RELEASE : Use this to set the program to release and actually make changes to the system

	### Usage
		1. Change Permission for use (Execute [+x])
			```console
			chmod +x script.sh
			```

		2. Run Program
			```console
			./script.sh {arguments}
			```

		3. Let Program run and just input your answers if there are any prompts

postinstallations-root.sh :

	### Syntax
	./postinstallations-root.sh

	### Usage
	1. Change Permission for use (Execute [+x])
		```console
		chmod +x script.sh
		```

	2. Run Program
		```console
		./script.sh {arguments}
		```

	3. Let Program run and just input your answers if there are any prompts

postinstallations.sh : 

	### Syntax
	./postinstallations.sh {base_Distro} {package_manager}

	### Parameters/Options/Flags
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

	### Usage
		1. Change Permission for use (Execute [+x])
			```console
			chmod +x script.sh
			```

		2. Run Program
			```console
			./script.sh {arguments}
			```

		3. Let Program run and just input your answers if there are any prompts

## References

### Notes

## FAQs

