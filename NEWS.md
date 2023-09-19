# Updates and News

## Pins
- I am thinking of making a discord group for my set of Linux Installation Script plans, do message me in any of the following contacts if you are interested.
- Do message me with any comments or suggestions for improvements, all comments will be greatly appreciated!
- Please star/follow this repository if you think this is useful!

## News
### 2022-03-04 1349H
- The current status of the scripts is tested primarily for brand new installations
    + I am attempting to and in the midst of adding pre-existing installation features as well as testings surrounding pre-existing distributions
    + Thus, please do becareful when attempting to multiboot with this script

### 2022-03-05 1147H
- The script only has support for MBR (MSDOS/BIOS) Bootloader
    + Implementation of UEFI (EFI) support is currently in the plans

### 2022-06-20 1603H | 
- Script has 2 types
    + This is a brief summary of the differences between type-1 and type-2, for more info, please check out the [Base Installation README.md](src/base-installation/README.md)
    - As of installer.remake.sh v1.0.5 and v1.0.8, I have created 2 types, known as [type-1] and [type-2]
        + They are functionally the same, but the differences is in the configuration format
        + type-1 is operating in an all-in-one file environment that has the variables within the script
        + type-2 is operating as a source-config environment, theres a template config generated inside the script itself though, you can also just curl/download th template i have in my docs directory that I will push to githube
    + I am still considering which format is more configurable, once I have decided, I will rework the project filestructure and tidy up the repository.
    + I apologise for the messy structure at the moment.

### 2022-07-02 0019H
- Stable release v1.0.0
    + First of all, thank you to everyone whom have provided feedback as to which type you prefer.
    - After careful consideration and testing, the application will follow a "seperate config" structure on top of the initial portable design paradigm
        + With this change, essentially all updates and patches made will NOT affect your configurations unless the patch is a major patch that removes/deprecated variables.
        + Thus, this makes the program more portable, configurable and customizable.
    + This means that this is what I would consider the first stable release
    + Other changes can be found in [Changelog](CHANGELOG.md)

### 2023-01-25 1311H
- Implemented CLI Argument support and refactoring of documentations
    - New Features
        + Finally implemented CLI argument capabilities as well as writing it to be as easy to understand as possible, so as to make it customizable and modular
    - Modifications
        + Refactored installer to place initialized global variables into functions, allowing reusability, and readability as it is now cleaner
    + Tested multiple times, should be stable (please create issues if any are found, thank you!)
    + Please refer to the [CHANGELOGS](CHANGELOG.md) for all changes

### 2023-09-19 2016H
- It has been awhile since I last pushed anything, was busy with my school work the last few months
    + and I just completed my examinations and now have some time to spare
- Over the 9 months, I have had some new ideas on what could be done, as well as a generalized plan for this project that may be quite interesting
    + Plans are still in order though, so I'll need to loop at the pipeline as well as designs
+ If you have been using this project/application/repository, thank you


