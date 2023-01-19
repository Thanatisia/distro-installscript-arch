# Base Installation Script (ArchLinux Edition)

Linux Distribution Portable, Modular CLI/Terminal Base-Installation + Essential Scripts for ArchLinux

## Table of Contents

- [Information](#information)
- [FAQs](#faqs)
- [Remarks](#remarks)
- [Contacts](#contacts)
- [Updates](CHANGELOG.md)

## Information

### Background

Welcome to my (semi)automatic Linux distribution (trying-to-be-generic) installation script!

This project revolves primarily around the base installation area, but this project will also contain various scripts for Post-Installation support as well!

- The Project was first planned as I had to reinstall my ArchLinux (as do many Arch users) but had to do it manually. Thus, the concept bloomed when I considered 
how to automatically install a consistent ArchLinux build with similar if not the same packages and users etc without having to re-type them.

- The project (specifically the Base Installation Linux Install script ) is designed to be
  1. Modular
  2. Portable,
  3. Customizable
  4. Configurable

- As you will see in [Usage](#usage), the end result will be that you *should* get the same build everytime consistently. The only time it might not may be if the installation process itself completely change 
and/or the tools required by the target distribution changed, thus, leading to the next point

- The script has been formatted and structured in a way that if you want to create a Linux install script for another distro, you just need to 
    + enter the functions that is specifically for that distro (according to the steps for installation)
    + change that line of code and that should do it, as some of the general steps are universal across the distro CLI-based installation steps
    + Thus, with the modular, containerized method, the modification of codes will be easier and customizable

 ### Files and Folders
- [base-installation/](src/base-installation) : This is the Base Installation script. All files placed here have been tested from those found in dev (Development Folder). This is probably where you want to go first.
- [post-installation/](src/post-installation) : This is the Post-Installation related scripts. All files placed here have been tested from those found in dev
- [references/](references) : This references directory contains various useful files such as Sample configurations, Sample templates and Sample usage scripts.
- [development](dev) : This is the development directory. This directory is essentially the Nightly Build branch and to be considered as Testing or unsafe, just to be safe, please test the files found here in a Virtual Machine.
- [documentations](docs) : This contains all documentations and guides for references
    + including detailed setup; usage
    
## Setup
> This is a basic rundown of how to use the program, please refer to [Base Installation Manual](docs/base-installation/manuals/distinstall/manual.md) for a more detailed rundown
### Pre-Requisites
+ (Optional) Internet Connection
    ```
    Required for curl and wget
    ```

### Dependencies (General)

+ curl
+ base-devel
+ arch-install-scripts
+ make
+ git
+ parted

### Obtaining Installer
- via Curl (Recommended)
    ```console
    curl -L -O "https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation/distinstall"
    ```

- Downloading the latest release
    ```console
    wget "https://github.com/Thanatisia/distro-installscript-arch/releases/latest/distinstall-*.zip"
    ```
    
### Obtaining Config File
- via Autogeneration (Default)
    - The application will check if a a config file exists (Default config file name is 'config.sh')
        - If config file doesnt exist
            + Application will automatically generate a 'config.sh' file on startup
      
- (OPTIONAL) Specifying a specific config file
    - If you have a config file of a specific name
        + Edit the variable "cfg_name" in *distinstall* with your custom config file name (TODO: Flag to specify custom config file)
   
- (OPTIONAL) Curling the example config.sh
    ```console
    curl -L -O "https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/docs/configs/config.sh"
    ```
   
### Obtaining additional helper utilities/files
- (OPTIONAL) Obtaining Makefile
    + I designed this Makefile to automate and make running the installer easier
    ```console
    curl -L -O "https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/docs/configs/Makefile"
    ```

   
## Documentation
### Usage
- Modify configuration file variables
    + Default configuration file name: 'config.sh'
        ```console
        $EDITOR config.sh
        ```

- (OPTIONAL) Editing the Makefile
    + If you have obtained the Makefile and will be using this to install
    + Edit the Makefile and specify your device labels and information
        ```console
        $EDITOR Makefile
        ```
        
- Execute installer (Default)
    + At the moment, the script is called 'distinstall'
    + By default: the script will execute in DEBUG mode whereby it shows you all the commands but it wont execute the formatting (security purposes)
    ```console
    TARGET_DISK_NAME='/dev/sdX' (./)distinstall {RERLEASE}
    ```

## FAQs

## Remarks
```
- Please do contact me in any of the platforms below if you have any ideas | bugs | comments | suggestions or if you just wanna talk!
I am open for suggestions as well as talking to everyone

- Immediate Newsletter
	- 2022-03-04 1349H | The current status of the scripts is tested primarily for brand new installations
		+ I am attempting to and in the midst of adding pre-existing installation features as well as testings surrounding pre-existing distributions
		+ Thus, please do becareful when attempting to multiboot with this script

	- 2022-03-05 1147H | The script only has support for MBR (MSDOS/BIOS) Bootloader
		+ Implementation of UEFI (EFI) support is currently in the plans
        
    - 2022-06-20 1603H | Script has 2 types
        + This is a brief summary of the differences between type-1 and type-2, for more info, please check out the [Base Installation README.md](src/base-installation/README.md)
        - As of installer.remake.sh v1.0.5 and v1.0.8, I have created 2 types, known as [type-1] and [type-2]
            + They are functionally the same, but the differences is in the configuration format
            + type-1 is operating in an all-in-one file environment that has the variables within the script
            + type-2 is operating as a source-config environment, theres a template config generated inside the script itself though, you can also just curl/download th template i have in my docs directory that I will push to githube
        + I am still considering which format is more configurable, once I have decided, I will rework the project filestructure and tidy up the repository.
        + I apologise for the messy structure at the moment.

    - 2022-07-02 0019H | Stable release v1.0.0
        + First of all, thank you to everyone whom have provided feedback as to which type you prefer.
        - After careful consideration and testing, the application will follow a "seperate config" structure on top of the initial portable design paradigm
            + With this change, essentially all updates and patches made will NOT affect your configurations unless the patch is a major patch that removes/deprecated variables.
            + Thus, this makes the program more portable, configurable and customizable.
        + This means that this is what I would consider the first stable release
        + Other changes can be found in [Changelog](CHANGELOG.md)

- I am thinking of making a discord group for my set of Linux Installation Script plans, do message me in any of the following contacts if you are interested.

- Do message me with any comments or suggestions for improvements, all comments will be greatly appreciated!

- Please star/follow this repository if you think this is useful!

thank you again for using!
```

## Contacts
+ [Twitter: @phantasu](https://twitter.com/phantasu)
+ [GitHub: @thanatisia](https://github.com/Thanatisia)
+ [My Portfolio Website](https://thanatisia.github.io/my-portfolio-website)
+ [Fiverr: @fortissimasura](https://fiverr.com/fortissimasura)
+ [Email: AsuraTechna@gmail.com](mailto:AsuraTechna@gmail.com)


