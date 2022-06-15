[#](#) Base Installation Script (ArchLinux Edition)

Linux Distribution Portable, Modular CLI/Terminal Base-Installation + Essential Scripts for ArchLinux

## Table of Contents

- [Information](#information)
- [FAQs](#faqs)
- [Remarks](#remarks)
- [Contacts](#contacts)
- [Updates](CHANGELOG.md)

## Information

### Background

Welcome to my **ArchLinux distro install script**!

Designed to be

  1. Modular
  2. Portable,

you just need to open up the script, edit it with your basic information such as packages; distro user profile information (that you want to create) etc. and you can backup the file!

Afterwhich, when you want to install the build, you just need to open it, edit the disk name (i.e. /dev/sd{a|b|c...} and run it. (Plans to add Disk Name input via CLI is a WIP)

On run, just several presses to confirm the details and it's done!

For further usage information, please refer to the Usage section in the relevant files found in [here](#files)

### Files
+ [Makefile](Makefile)
    - Dependencies
        + curl
        + base-devel
        + arch-install-scripts
        + make
        + git

    - Usage
        - Download Makefile
            ```console
            curl -L -O https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/Makefile
            ```
           
        - Step-by-Step
            - Check system information
                ```console
                make checksysinfo
                ```
                
            - Check your dependencies
                ```console
                make checkdependencies
                ```
                
            - Run setup
                ```console
                make setup
                ```
                
            - (OPTIONAL) Backup your system
                ```console
                # Ensure you have space in your home directory
                make backup
                ```
                
            - Download file
                ```console
                make download
                ```
        - Automated 
            - Use prepare_all
                ```console
                make prepare_all
                ```
                
        - Configure your install
            ```console
            make configure
            ```
            
        - Test the install
            ```console 
            # Repeat this until you are satisfied with what you see before proceeding to the final step of the base install
            make testinstall
            ```
            
        - Perform the installation
            ```console
            # NOTE: Only do this if you are super sure you are willing to do this
            #   - run this with sudo
            sudo make install
            ```

- [base-installation/](src/base-installation)
	+ [Manual](src/base-installation/installer-manual.sh)
	+ [User Experience](src/base-installation/installer-ux.min.sh)
	
	- Differences:
		- Manual : Variables are defined in arrays & associative arrays directly labelled with 'EDIT THIS'

		- Simple : Arrays & Associative Arrays have all been predefined and "Symlinked" with variable containers at the top
			+ You (the user) just need to modify the variables labelled under 'EDIT THIS' at the top

	- Notes:
		- The script is designed for portability and modularity in mind, thus:
			- You do not need to change or modify any of the functions unless 
				a. you know what you're adding or
				b. you're contributing to the project
			+ Just need to edit the variables labelled with 'EDIT THIS'

- [post-installation/](src/post-installation)
	- [Install Core & Essential Packages](src/post-installation/postinstallation-core-packages.sh)
	- [Setup Root Settings](src/post-installation/postinstallations-root.sh)
	- [General PostInstallation Setup](src/post-installation/postinstallations.sh)

- [references/](references)
	- [vbox-usboot-1/](references/vbox-usboot-1)
		- Reference example profile 
		- used to install in a USB MicroSD Card booted in a VirtualBox ArchLinux Instance

## FAQs

## Remarks

- Please do contact me in any of the platforms below if you have any ideas | bugs | comments | suggestions or if you just wanna talk!
I am open for suggestions as well as talking to everyone

- Please note that 
	- as of 2022-03-04 1349H : The current status of the scripts is tested primarily for brand new installations
		> I am attempting to and in the midst of adding pre-existing installation features as well as testings surrounding pre-existing distributions

		> Thus, please do becareful when attempting to multiboot with this script

	- as of 2022-03-05 1147H : The script only has support for MBR (MSDOS/BIOS) Bootloader style
		> Implementation of UEFI (EFI) support is currently in the plans

- I am thinking of making a discord group for my set of Linux Installation Script plans, do message me in any of the following contacts if you are interested.

- Do message me with any comments or suggestions for improvements, all comments will be greatly appreciated!

- Please star/follow this repository if you think this is useful!

thank you again for using!


## Contacts
- [Twitter @phantasu](https://twitter.com/phantasu)
- [GitHub @thanatisia](https://github.com/Thanatisia)
- [My Portfolio Website](https://thanatisia.github.io/my-portfolio-website)
- [Fiverr @fortissimasura](https://fiverr.com/fortissimasura)



