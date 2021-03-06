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

### CHANGELOGS
```
release_date | version_number:
	- Changes Here
```
2021-06-15 0104H | v0.1.0
	- Created repository

2021-10-15 1335H | v0.2.0
	- Migrated archlinux install scripts from repository [SharedSpace](https://github.com/Thanatisia/SharedSpace) to current repository
		- Folder "base-installation" and "post-installation" 
	- Folders Changed
		- base-installation
		- post-installation

2022-03-04 1406H | v0.2.1
	- Fixed loop bug in 'installer-manual.sh' from base-installation
	- Files Changed
		- base-installation/installer-manual.sh
			- Script should now be on par with [base-installation/installer-manual.min.sh]

2022-04-23 1120H | v0.3.0
	- Performing Refactoring of README.md and CHANGELOG.md
		- Moving CHANGELOGS from README to CHANGELOG.md (You probably are viewing this in the new CHANGELOG)
	- Files Changed
		- README.md

2022-04-23 1450H | v0.4.0-alpha
	- Moved the [base-installation] and [post-installation] folders into "src/" folder
	- Files Changed
		- base-installation/
		- post-installation/

2022-06-19 0133H | v0.5.0-alpha
    - Created folders
        - dev/ : For Development Builds (similar to Development Branch)
            + src/ : Source Files in the Development Folder
        - docs/configs/ : To contain all templates and config files
        - references/ : To store all references and resources 
            - deprecated/ : Temporary storage to store all deprecated files for deletion and/or archival
            - Samples/ : Contains all sample scripts with a pre-specified values that meets a specific criteria. Users can go into this directory, select a preset script and just download the file to install

2022-06-20 1637H | v0.6.0-alpha
    - Edited README to include latest specifications and Information
    - Updated CONTRIBUTING.md
    - Base Installer
        + installer-manual.sh (v0.4.0-alpha) has been Deprecated
        + installer-ux.min.sh (v0.4.0-alpha) updated
        + installer.remake.sh (v0.8.0-alpha) updated

2022-07-02 0025H | v1.0.0
    - Initial major stable release v1.0.0
    - Deprecated
        + installer-manual.sh line
        + installer-ux.min.sh line
    - Renamed 'installer.remake-{version}.sh' to distinstall

