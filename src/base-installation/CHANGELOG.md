# CHANGELOGS

## Table of Contents
- [Information](#information)
    + [Files](#files)
- [Changelog](#changelog)
    - [installer.remake.sh](#i-1-installer-remake-sh)
        + [Information](#i-1-information)
        + [Changelog](#i-1-changelog)

## Information

### Files 
+ I.1. installer.remake.sh
+ I.2. installer-manual.sh
+ I.3. installer-ux.min.sh
 
## Changelog

### I.1. installer.remake.sh

#### I.1. Information 
+ Created: 2022-06-16 2321H, Asura
- Modified: 
    - 2022-06-16 2321H, v0.4.0, Asura
    - 2022-06-17 1121H, v0.5.0, Asura
    - 2022-06-18 2323H, v0.6.0, Asura
    - 2022-06-19 0113H, v0.7.0, Asura
    - 2022-06-19 2351H, v0.8.0, Asura
    
#### I.1. Changelog
- v0.4.0
	- Copied using 'installer-ux.min.sh' as base
- v0.5.0
    - Mass Update and Testing
    - Performed overhaul on UI/UX (more work to be done) to make the standard output more meaningful
    - Tested install script on an existing Linux Distribution
        - Using:
            + Distribution: Base Arch
            - Dependencies: 
                + arch-install-scripts : The tools and utilities used in ArchISO and required are found in arch-install-scripts
        - Result:
            + Installing via ArchISO : Success
            + Installing via Existing Linux Install : Success
        - Notes
            + Expected to work with other base distros as well as long as 'arch-install-scripts' exists in their package managers
    - Application has only been officially tested to work with MBR/MSDOS support, although I remember using UEFI one time and it worked
        + Please becareful and test it in a Virtual Environment before deploying to producton/live environmention
- v0.6.0
    - Mass overhaul on structure
        - Re-factored and overhauled to make codes more modular and readable
        - Created empty containers in place of global variables during initialization
        - Created a function setup() to initialize all associative arrays and any other variables required
            - User can just run setup() to get the latest values at that point in the code too
    - Functionally similar to v0.5.0
        - Currently a test design undergoing testing for how usable and understandable this design change is
- v0.7.0
    - Converted variables into a config template from within the script and 
        - Check if config exists
        - If config exists: Source the configs containing the required variables
        - If config does not exists : 
            - Generate a config using the in-line template OR
            - Download from the github repo
                ```console
                curl -L -O https://raw.githubusercontent.com/Thanatisia/main/docs/configs/config.sh
                ```
        - Users will be working entirely with the config file and not the script (unless they want to)
    - Type 2 design is a W.I.P
    - Functionally similar to v0.5.0 and v0.6.0
        - v0.6.0 is known as 'type-1' in dev
            ```
            Is an all-in-one script that has everything within a single script including the variables, 
            Pros:
                - just need to change the script contents itself and you can backup just that 1 file. 
            
            Cons: variables need to be manually transferred if updates are made, making it tedious to update
            ```
        - v0.7.0 is known as 'type-2' in dev
            ```
            script is seperated from the configs where configs contains the variables used in the program.
            - For Developers:
                - If you wish to make a custom install script or fork this project
                    - You can do the following (for starters) to make changes
                        - Add a new variable into config.sh
                        - Add that new variable into the program for use however you like because it has been imported into the script
                - Makes patching an easier time
            
            Pros:
                - Development, forking and customization and configuration is easier
                - Portable
                - Modular
                - Just need to backup the configs file and change to the next version
                    - Unless variables are removed or import compatibility is removed
                      
            Cons:
                - You need to hold multiple files to bring around, which admittedly is different from my initial design specifications which is closer to v0.6.0 (type-1)
                    - However, it feels like type-2 is closer to being actually portable, customizable, configurable, modular and upgradeable.
            ```
    - The types will be merged once decided on a software design 
- v0.8.0
    - Applied Heredoc for the template config file multiline strings to 'type-2'
    
### I.2. installer-manual.sh

#### I.2. Information

#### I.2. Changelog
