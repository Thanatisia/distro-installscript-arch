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
- Installer
    1. via cloning (Whole)
        + This method will require you to download/clone the entire repository
        ```console
        git clone https://github.com/Thanatisia/distro-installscript-arch
        ```

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
        - Usage
            ```console
            curl -L -O https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/distinstall
            ```

- Makefile
    - (OPTIONAL) Obtaining Makefile
        + I designed this Makefile to automate and make running the installer easier
        ```console
        curl -L -O "https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/docs/configs/Makefile"
        ```

    - (OPTIONAL) Editing the Makefile
        + If you have obtained the Makefile and will be using this to install
        + Edit the Makefile and specify your device labels and information
            ```console
            $EDITOR Makefile
            ```

- All necessary files
    > Includes the above - Installer, config file and additional utilities
    - Download the latest release from 'https://github.com/Thanatisia/distro-installscript-arch/releases/latest'

- Download via the Makefile
    - Download Makefile
        ```console
        curl -L -O https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/Makefile
        ```
    - Execute the 'download' rule/target
        + You should get all the necessary files required (i.e. installer, generated configuration file)
        ```console
        make download
        ```

### Preparation/Setup

- Config File
    - Default config file
        + Default config file name : config.sh
        + WIP/TODO: check if a a config file exists (Default config file name is 'config.sh')
        ```console
        ./distinstall -g
        ```

    - Generate custom config file
        + WIP/TODO: check if a a config file exists (Default config file name is 'config.sh')
        ```console
        ./distinstall -c [new-config-file-name]
        ```

    - (OPTIONAL) Curling the example config.sh
        ```console
        curl -L -O "https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/docs/configs/config.sh"
        ```

    - Edit config file
        - NOTE: 
            + You can just edit those labelled with "# EDIT: MODIFY THIS" if you do not know where to start
            + Change the variables, you do not need to change the associative arrays but feel free to do so (only if you know what you are doing)
            + In the case whereby you would like to edit the Associative Array, this is found in setup() for modularity
        ```console
        $EDITOR [config file name]
        ```

- (OPTIONAL) Backup the config file for re-usage

+ Change Permission for use (Execute [+x])
	```console
	chmod +x distinstall
	```

### Installation/Compilation
> Currently installation is not required as it is using shellscript, however, there are plans on making a Rust-based/python installer for even easier configuration

## Documentations

### Synopsis/Syntax
```console
./distinstall {options} [positional] <arguments>
```

### Parameters
- Optional Parameters
    - With Arguments
        + -c [config-file-name] | --config      [config-file-name] : Set custom configuration file name
        + -d [target-disk-name] | --target-disk [target-disk-name] : Set target disk name
        + -e [default-editor]   | --editor      [default-editor]   : Set default text editor
        + -m [DEBUG|RELEASE]    | --mode        [DEBUG|RELEASE]    : Set mode (DEBUG|RELEASE)
    - Flags
        + -g | --generate-config    : Generate configuration file
        + -h | --help               : Display this help menu and all commands/command line arguments
        + --fdisk                   : Open up fdisk for manual partition configuration
        + --cfdisk                  : Open up cfdisk for manual partition configuration

- Positional Parameters
    + start : Start the installer

### Usage

1. Default (Test Install; Did not specify target disk name explicitly)
    ```console
    ./distinstall start
    ```

2. Test Install; with target disk name specified as flag
    ```console
    ./distinstall -d "/dev/sdX" start
    ```

3. Test Install; with target disk name specified with environment variable TARGET_DISK_NAME
    ```console
    TARGET_DISK_NAME="/dev/sdX" ./distinstall start
    ```

4. Test Install; with custom configuration file
    ```console
    ./distinstall -c "new config file" -d "/dev/sdX" start
    ```

5. Start installation (Did not specify target disk name explicitly)
    ```console
    sudo ./distinstall -m RELEASE start
    ```

6. Start installation (with target disk name specified as flag)
    ```console
    sudo ./distinstall -d "/dev/sdX" -m RELEASE start
    ```

7. Start installation (with target disk name specified with environment variable TARGET_DISK_NAME)
    ```console
    sudo TARGET_DISK_NAME="/dev/sdX" ./distinstall -m RELEASE start
    ```

8. Start installation (with custom configuration file)
    ```console
    sudo ./distinstall -c "new config file" -d "/dev/sdX" -m RELEASE start
    ```

9. Open up fdisk for Manual Partitioning
    ```console
    sudo ./distinstall --fdisk
    ```

10. Open up cfdisk for Manual Partitioning
    ```console
    sudo ./distinstall --cfdisk
    ```

11. Test Install; using Makefile
    ```console
    make testinstall
    ```

12. Start installation; using Makefile
    ```console
    sudo make install
    ```

13. Dis/Unmount using Makefile
    ```console
    sudo make clean
    ```

14. Generate configuration file using Makefile
    ```console
    make genscript
    ```

## Configuration and Customization

### Environment Variables
+ TARGET_DISK_NAME : This is used in the environment variable to specify the target disk you want to install with

### Modifiable Variables (in distinstall)
- cfg_name : the default configuration file name, change this variable before executing to use a specific config file *AND/OR* generate a default file in this custom filename
    + Default Value : config.sh

- Modes
    + DEBUG (Default) : Test install; Allows you to see all the commands that will be executed if you set the MODE to 'RELEASE'; set by default to prevent accidental reinstallation/overwriting
    + RELEASE : Performs the real RELEASE; must use with sudo

### Configuration guide
+ Please refer to the [configuration guide](docs/installer%20configuration.md) for full information with regards to editing the configuration file

### To Note


## Tips and Tricks
