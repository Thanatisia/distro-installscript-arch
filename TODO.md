# TODO List Pipeline

## Table of Contents
- [List](#list)

## List
+ [] UEFI Motherboard firmware Support
+ [X] GPT Partition Table and filesystem label support
- Other Bootloader Support
    + [] syslinux
- [] Add support for filesystems : 'btrfs'
- [X] Add support for Swap partitions
- [] Add support for raw disk image file system installation into mounted loopback interface
+ [] Replace 'dev' folder with an official development branch
- [] Complete creation of the additional installer GUI/CLI helper utility
- [O] Perform application overhaul
    + [O] Restructure project repository to become more coherent
- [] Rename application from distinstall to something better
- [O] Add command line (CLI) argument (parameters/flag) support
    + [O] To fit the mission
- [X] Refactor and rename variable 'devicePrams_Boot' in the configuration template structure as well as the installer
- [] Reorganize CLI argument to be placeable in any position unless is behind an option/positional with additional arguments
- [O] Development of the port/re-implementation of the distribution installer in Python
    - Goals to be achieved
        + [ ] fix most of the technical terminological errors made (I know of afew) as well as
        + [ ] Improve the configuration file handling by changing the configuration file from a linux shellscript parser to a proper Serializable data structure/object (i.e. YAML, TOML, JSON) where configuration files can be easier to edit, modify and/or use in general.
        + [ ] Improve the customizable, modifiable and portability of the project instead of using linux shellscripting (Bash) which, granted, is quite limiting
        + [ ] Improve the readability

