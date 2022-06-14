# Docs - Base Installation : installer-ux.min.sh

Documentations for Base Installation script [installer-ux.min.sh]

## Table of Contents
- [Setup](#setup)
- [Documentations](#documentations)
- [Tips and Tricks](#tips-and-tricks)

## Setup

### Pre-Requisites

- git
- wget/curl
- If you are using an existing linux distro
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
		- installer-manual.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/installer-manual.sh
		- installer-ux.min.sh : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/installer-ux.min.sh

### Preparation/Setup

- Edit the script
	```console
	$EDITOR installer-manual.sh
	$EDITOR installer-ux.min.sh
	```

- Modify file info according to your requirements
	```
	NOTE: You can just edit those labelled with "# EDIT: MODIFY THIS" if you do not know where to start
	```

- (OPTIONAL) Backup the file for re-usage
	

### Installation/Compilation

## Documentations

### Synopsis/Syntax

./installer-ux.min.sh {MODE}

### Parameters/Options/Flags

- MODE <options> : The mode to run the program
	+ Default: DEBUG
		
	- Options:
		+ DEBUG	: Use this to run the program and see the commands being used 				(DEFAULT)
		+ RELEASE : Use this to set the program to release and actually make changes to the system
	
### Usage

1. Change Permission for use (Execute [+x])
	```console
	chmod +x installer-ux.min.sh
	```

2. (OPTIONAL) If you want to test before official use (RECOMMENDED)
	```console
	./installer-ux.min.sh
	```	

3. Run Program
	```console
	./installer-ux.min.sh RELEASE
	```

4. Let Program run and just input your answers if there are any prompts

### Configuration & Customization

#### Variables

$


### To Note


## Tips and Tricks
