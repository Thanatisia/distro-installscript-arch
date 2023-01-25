# Changelogs

## Version History
```
Version Naming Convension : major.minor.patches-status
```

### Notes and Updates

- 2022-04-23 1107H, Asura
	- Currently going through a overhaul to the README, will be adding the other versions below

### Modifications

```
release_date | version_number | release_author
```
+ 2021-06-15 0104H | v0.1.0 | Asura
+ 2021-10-15 1335H | v0.2.0 | Asura
+ 2022-03-04 1406H | v0.2.1 | Asura
+ 2022-04-23 1120H | v0.3.0 | Asura
+ 2022-04-23 1450H | v0.4.0-alpha | Asura
+ 2022-06-19 0133H | v0.5.0-alpha | Asura
+ 2022-06-20 1637H | v0.6.0-alpha | Asura
+ 2022-07-02 0025H | v1.0.0 | Asura 
+ 2022-07-15 1633H | v1.0.1 | Asura
+ 2022-08-27 1651H | v1.1.0 | Asura
+ 2023-01-19 1849H | v1.1.1 | Asura
+ 2023-01-20 1635H | v1.1.2 | Asura

### CHANGELOGS
```
release_date | version_number:
	- Changes Here
```
- 2021-06-15 0104H | v0.1.0
	- Created repository

- 2021-10-15 1335H | v0.2.0
	- Migrated archlinux install scripts from repository [SharedSpace](https://github.com/Thanatisia/SharedSpace) to current repository
		+ Folder "base-installation" and "post-installation" 
	- Folders Changed
		+ base-installation
		+ post-installation

- 2022-03-04 1406H | v0.2.1
	+ Fixed loop bug in 'installer-manual.sh' from base-installation
	- Files Changed
		- base-installation/installer-manual.sh
			+ Script should now be on par with [base-installation/installer-manual.min.sh]

- 2022-04-23 1120H | v0.3.0
	- Performing Refactoring of README.md and CHANGELOG.md
		+ Moving CHANGELOGS from README to CHANGELOG.md (You probably are viewing this in the new CHANGELOG)
	- Files Changed
		+ README.md

- 2022-04-23 1450H | v0.4.0-alpha
	+ Moved the [base-installation] and [post-installation] folders into "src/" folder
	- Files Changed
		+ base-installation/
		+ post-installation/

- 2022-06-19 0133H | v0.5.0-alpha
    - Created folders
        - dev/ : For Development Builds (similar to Development Branch)
            + src/ : Source Files in the Development Folder
        + docs/configs/ : To contain all templates and config files
        - references/ : To store all references and resources 
            + deprecated/ : Temporary storage to store all deprecated files for deletion and/or archival
            + Samples/ : Contains all sample scripts with a pre-specified values that meets a specific criteria. Users can go into this directory, select a preset script and just download the file to install

- 2022-06-20 1637H | v0.6.0-alpha
    + Edited README to include latest specifications and Information
    + Updated CONTRIBUTING.md
    - Base Installer
        + installer-manual.sh (v0.4.0-alpha) has been Deprecated
        + installer-ux.min.sh (v0.4.0-alpha) updated
        + installer.remake.sh (v0.8.0-alpha) updated

- 2022-07-02 0025H | v1.0.0
    - Initial major stable release v1.0.0
    - Deprecated
        + installer-manual.sh line
        + installer-ux.min.sh line
    + Renamed 'installer.remake-{version}.sh' to distinstall
    
- 2022-07-15 | v1.0.1
    - Updated dependencies
        + Added "parted"
    
- 2022-08-27 1651H | v1.1.0 
    - Updated README with a basic usage and documentation (Please refer to the manual for more detailed information
    - Updated distinstall application manual with additional variables
    - Updated Makefile : Replaced 'installer.remake.sh' with 'distinstall'
    - Updated [TODO](TODO.md) with new TODO in the pipeline

- 2023-01-19 1849H | v1.1.1
    - Packaged release v1.1.0 and created first GitHub releases
        + Will create more releases for any changes regarding the main scripts
    + Updated README with command to download the latest packaged release instead of just cloning
    + Updated TODO list pipeline

- 2023-01-20 1636H | v1.1.2
    - Created documentation guide for the installer configuration file in [Docs - installer configuration.md]('docs/installer configuration.md')
    - Created features write-up
    - Updated TODO pipeline list
    - Relocated manuals and implementation ideas

- 2023-01-21 0007H | v1.2.0
    - [New Features]
        - Command Line Arguments (CLI) support in install script
            + -c | --config : For setting custom configuration file
            + -d | --target-disk : For setting target disk name via CLI argument
            + -g | --generate-config : For generating a new config file template right from the get-go
            + -h | --help : Display help message
            + -m | --mode : Set startup mode; DEBUG or RELEASE
    - [Refactor/Modification]
        - Changed 'MODE' variable from  to a static DEBUG as the command line argument is now dynamic
        - Refactored global variables into individual functions for reusability (i.e. generating or resetting)
            + Script should be cleaner

- 2023-01-25 1435H | v1.3.0-rc1
    - Compilation of all changes and releases
    ```
    [New Features]
    - Command Line Arguments (CLI) support in install script
        + -c | --config : For setting custom configuration file
        + -d | --target-disk : For setting target disk name via CLI argument
        + -g | --generate-config : For generating a new config file template right from the get-go
        + -h | --help : Display help message
        + -m | --mode : Set startup mode; DEBUG or RELEASE
    - display_help() function to display a help menu

    [Refactor/Modification]
    - Changed 'MODE' variable from  to a static DEBUG as the command line argument is now dynamic
    - Refactored global variables into individual functions for reusability (i.e. generating or resetting)
        + Script should also be cleaner, improving readability 
    - Changed documentation for 'distinstall' and README to reflect the latest usage
    - Removed documentation from distinstall script as the help function explains it

    [Errors/Bug Fixes]
    - Error validation and checking, implementing exit if error was detected
    ```


