# Docs - Base Installation : distinstall

Documentations for Base Installation script [distinstall]

## Table of Contents
- [Information](#information)
- [Setup](#setup)
- [Documentations](#documentations)
- [Tips and Tricks](#tips-and-tricks)

## Information

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
        - Development Branch : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/dev/src/distinstall
        - Stable : https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/distinstall

### Preparation/Setup

- Initial Visit (No Config File)
    - Download Default config file (config.sh)
        ```console
        curl -L -O "https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/docs/configs/config.sh"
        ```
    - Generate default config file
        + Just run the script
        + The config will be generated
      
- Edit the config file
    + Default Config File is config.sh
        ```console
        $EDITOR <your-config-file> 
        ```

- Modify file info according to your requirements
    ```
    NOTE: 
    - You can just edit those labelled with "# EDIT: MODIFY THIS" if you do not know where to start
    - Change the variables, you do not need to change the associative arrays but feel free to do so (only if you know what you are doing)
        - In the case whereby you would like to edit the Associative Array, this is found in setup() for modularity
    ```

- (OPTIONAL) Backup the config file for re-usage

### Installation/Compilation

## Documentations

### Synopsis/Syntax

+ TARGET_DISK_NAME='your-disk-label (/dev/sdX)' (./)distinstall {MODE}

### Parameters/Options/Flags

- MODE <options> : The mode to run the program
	+ Default: DEBUG
		
	- Options:
		+ DEBUG	: Use this to run the program and see the commands being used 				(DEFAULT)
		+ RELEASE : Use this to set the program to release and actually make changes to the system
	
### Usage

1. Change Permission for use (Execute [+x])
	```console
	chmod +x distinstall
	```

2. (OPTIONAL) If you want to test before official use (RECOMMENDED)
	```console
    TARGET_DISK_NAME='/dev/sdX' (./)distinstall           : Run in DEBUG mode	
	```	

3. Run Program
	```console
    TARGET_DISK_NAME='/dev/sdX' (./)distinstall RELEASE   : Run installation	
	```
    
4. Let Program run and just input your answers if there are any prompts

5. (OPTIONAL) using the provided Makefile
    - Download Makefile
        ```console
        curl -L -O https://raw.githubusercontent.com/Thanatisia/main/docs/configs/Makefile
        ```
        
    - Start test installation (outputs the steps and standard output)
        ```console
        make testinstall
        ```
        
    - Start full installation
        ```console
        sudo make install
        ```
        
    - Clean all temporary variables and unmount drives mounted
        ```console
        sudo make clean
        ```

## Configuration and Customization

#### Environment Variables
+ TARGET_DISK_NAME : To set the disk/device label you wish to use (/dev/sdX)

#### Modifiable Variables (in distinstall)
- cfg_name : the default configuration file name, change this variable before executing to use a specific config file *AND/OR* generate a default file in this custom filename
    + Default Value : config.sh

### To Note


## Tips and Tricks
