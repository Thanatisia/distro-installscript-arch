# distro-installscript-arch

Linux Distribution Portable, Modular Command Line/Terminal Installation Script - ArchLinux

## Table of Contents

1. Background
2. Remarks
3. Files
4. Contacts
5. FAQs

## Background

Welcome to my **ArchLinux distro install script**!

Designed to be

  1. Modular
  2. Portable,

you just need to open up the script, edit it with your basic information such as packages; distro user profile information (that you want to create) etc. and you can backup the file!

Afterwhich, when you want to install the build, you just need to open it, edit the disk name (i.e. /dev/sd{a|b|c...} and run it.

On run, just several presses to confirm the details and it's done!

## Remarks

- Please do contact me in any of the platforms below if you have any ideas | bugs | comments | suggestions or if you just wanna talk!
I am open for suggestions as well as talking to everyone

- As of 2022-03-04 1349H : The current status of the scripts is primarily for brand new installations
	> I am attempting to and in the midst of adding pre-existing installation features as well as testings surrounding pre-existing distributions
	> Thus, please do update

- I am thinking of making a discord group for my set of Linux Installation Script plans, do message me in any of the following contacts if you are interested.

- Do message me with any comments or suggestions for improvements, all comments will be greatly appreciated!

- Please star/follow this repository if you think this is useful!

thank you again for using!

## Files

[base-installation](base-installation)

* [Manual](base-installation/installer-manual.sh)
* [Simple](base-installation/installer-ux.min.sh)

	> Differences:

		- Manual : Variables are defined in arrays & associative arrays directly labelled with 'EDIT THIS'

		- Simple : Arrays & Associative Arrays have all been predefined and "Symlinked" with variable containers at the top
			- You (the user) just need to modify the variables labelled under 'EDIT THIS' at the top

	> Notes:

		- The script is designed for portability and modularity in mind, thus:
			> You do not need to change or modify any of the functions unless 
				a. you know what you're adding or
				b. you're contributing to the project
			> Just need to edit the variables labelled with 'EDIT THIS'

[post-installation](post-installation)

* [Install Core & Essential Packages](postinstallation-core-packages.sh)
* [Setup Root Settings](postinstallations-root.sh)
* [General PostInstallation Setup](postinstallations.sh)

[references](references)

* [vbox-usboot-1](references/vbox-usboot-1)

	- Reference example profile 

	- used to install in a USB MicroSD Card booted in a VirtualBox ArchLinux Instance


## Contacts

* Twitter: [@phantasu](https://twitter.com/phantasu)

* [My Portfolio Website](https://thanatisia.github.io/my-portfolio-website)

* Fiverr: @fortissimasura

## FAQs


