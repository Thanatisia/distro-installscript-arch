# ArchLinux Install Script Makefile
# 
# A all-in-one setup wrapper script initially created for my (Arch)Linux install scripts 
# that streamlines the download, configuration and customization and installation process without requiring you to
# manually download the scripts.
#
# Now it is designed to be modular, portable and customizable Out-of-the-Box (OOTB).
# You can reuse this as a template for other makefile usage
#
# -- DISCLAIMER : This is still a design and a W.I.P, please do a testrun in a virtual machine before running in your production
#  At the moment, the makefile is optimized only to be used by an ArchLinux system due to the package manager.
#  Cross-Package manager support is in the works.
#
# :: TODO
# 	- Add/Test support for apt and emerge into the switch case 
#
# :: Usage
#	make about 				: Displays the project information
#	make backup				: Backup target system
# 	make build 				: To download all files and run the full customization and configuration process
#	make checkdependencies 	: Check if dependencies are installed
#	make clean	 			: Clean and removes all temporary files
# 	make configure 			: To configure your currently found files
# 	make download 			: To download the files only
#	make help 				: Prints this help menu
# 	make install			: Runs the script in the correct order and install the program; Please run this in sudo
#	make prepare_all		: Does an automated downloaded and setting up of all files required (excluding backup) for use.
#	make setup				: Prepare system for script use

#============
# Variables
#============
PROJ_NAME = distro-installscript-arch 	# Project Name
PROJ_FLDR = $(PWD)/$(PROJ_NAME) 		# Project Folder
BASE  = $(PROJ_FLDR)
PROJ_SCRIPTS = $(BASE)/scripts
PROJ_TMP = $(BASE)/tmp
OS_VERS := $(shell lsb_release -a 2>/dev/null | grep Description | awk '{ print $$2 "-" $$3 }')
BASE_DISTRO_INSTALL_SCRIPT_PATH = https://raw.githubusercontent.com/Thanatisia/distro-installscript-arch/main/src/base-installation

# Get Base Distro File
@read -p "Select Script {(a) : installer-ux.min.sh | (b) : installer-manual.sh}: " BASE_DISTRO_INSTALL_SCRIPT_FILE 
@case "$(BASE_DISTRO_INSTALL_SCRIPT_FILE)" in
	"a")
		BASE_DISTRO_INSTALL_SCRIPT_FILE = "installer-ux.min.sh"
		;;
	"b")
		BASE_DISTRO_INSTALL_SCRIPT_FILE = "installer-manual.sh"
		;;
	*)
		BASE_DISTRO_INSTALL_SCRIPT_FILE = "installer-ux.min.sh"
		;;
esac

#==========
# Commands
#==========
MKDIR = mkdir -p
LN = ln -vsf 	# Symbolic Link Files
LNDIR = ln -vs 	# Symbolic Link Directory
case "$(OS_VERS)" in
	"Arch")
		PKGMGR = sudo pacman
		PKGINSTALL = $(PKGRMGR) --needed -S
		PKGUPDATE = $(PKGMGR) -Syu
		PKGBACKUP = $(PKGMGR) -Qnq
		PKGLIST = $(PKGMGR) -Qi
		;;
	"Debian")
		PKGMGR = sudo apt
		PKGINSTALL = $(PKGRMGR) install
		PKGUPDATE = $(PKGMGR) update && $(PKGMGR) upgrade
		# TBC
		PKGBACKUP = $(PKGMGR) list
		PKGLIST = $(PKGMGR) list
	*)
		;;
esac
TAR_COMPRESS = sudo tar -cvzf
TAR_EXTRACT = sudo tar -xvzf

#=============
# Ingredients
#=============
dependencies = build-devel make git curl arch-install-scripts
		
#=========
# Recipes
#=========
.PHONY: about backup checkdependencies setup configure download build testinstall install clean help

.DEFAULT_GOAL := help	# Run ':help' if no target/action is provided

about:
	## Displays the project information
	echo -e "Program Name : arch-install-scripts \n"
		\ "Author : Thanatisia \n"
		\ "Repository URL : https://github.com/Thanatisia/arch-install-scripts \n"

backup:
	## Backup target system before install (OPTIONAL)
	echo -e "(S) Backup Start"

	# Test if directory exists
	# else - create
	@test -d $(BASE)/backup || \ 
		echo -e "(+) Backup Directory doesnt exist, making Backup Directory..." && \ 
			$(MKDIR) $(BASE)/backup

	# Backup Packages in package manager
	echo -e "(+) Backup Packages in Package Manager"
	$(PKGBACKUP) > $(BASE)/backup/pkglist

	# Backup Root excluding home folder to store into home folder
	echo -e "(+) Backup Root directory excluding home folder"
	$(TAR_COMPRESS) $(BASE)/backup/files/system-backup.tar.gz
		\ / --exclude /home  

	# Backup Home directory into general /home
	# and move into backup directory after creation
	echo -e "(+) Backup Home directory to /home for temporary storage"
	$(TAR_COMPRESS) /home/home-backup.tar.gz 
		\ $(HOME)

	echo -e "(+) Moving Home backup to Backup directory"
	echo -e "(1) Moving"
	mv /home/home-backup.tar.gz $(BASE)/backup/files/system-backup.tar.gz	

	# Done
	echo -e "(D) Backup complete."

checksysinfo:
	## Check System Information
	echo -e "Distribution : $(OS_VERS)"

checkdependencies:
	## Check if dependencies are installed
	for pkg in $(dependencies); do
		if [[ $(PKGLIST) $$pkg > /dev/null ]]; then
			echo -e "$$pkg is installed"
		else
			echo -e "$$pkg is not installed."
		fi
	done

setup:
	## Prepare System for script use
	
	# - Install Dependencies
	for pkg in $(dependencies); do
		if [[ ! $(PKGLIST) $$pkg > /dev/null ]]; then
			echo -e "$$pkg is not installed."
			$(PKGINSTALL) $$pkg && 
				\ echo -e "Package has been installed." || 
				\ echo -e "Error installing package."
		fi
	done

	# - Create Temporary folders
	fldrs = $(PROJ_SCRIPTS) $(PROJ_TMP)
	for fldr in $(fldrs); do
		@test -d $$fldr || \
			# Directory Not Found
			$(MKDIR) $$fldr
	done

configure:
	## Configures all configurable and customizable files
	$(EDITOR) $(BASE_DISTRO_INSTALL_SCRIPT_PATH)/$(BASE_DISTRO_INSTALL_SCRIPT_FILE)

download:
	## Download the script/files
	echo -e "(S) Downloading scripts/files"

	echo -e "(+) Downloading Base Install Script : $(BASE_DISTRO_INSTALL_SCRIPT)"
	curl -L $(BASE_DISTRO_INSTALL_SCRIPT_PATH)/$(BASE_DISTRO_INSTALL_SCRIPT_FILE) -o $(PROJ_SCRIPTS)/$(BASE_DISTRO_INSTALL_SCRIPT_FILE)
	
	echo -e "(D) Download complete."

prepare_all: checksysinfo checkdependencies setup download configure ## Automate preparation and setup of all files required

testinstall:
	## Run the installation test process for the scripts (This will not run the commands, just to debug and view)
	echo -e "(S) Starting test install..."
	./$(PROJ_SCRIPTS)/$(BASE_DISTRO_INSTALL_SCRIPT)
	echo -e "(D) Test install end."

install:
	## Start the installation process for the scripts
	echo -e "(S) Starting installation script..."
	./$(PROJ_SCRIPTS)/$(BASE_DISTRO_INSTALL_SCRIPT) RELEASE
	echo -e "(D) Installation script end."

clean:
	## Removes all temporary files
	echo -e "(S) Starting cleaning"

	echo -e "(-) Deleting $(PROJ_FLDR)"
	rm -r $(PROJ_FLDR) && \
		echo -e "(+) $(PROJ_FLDR) deleted." || \
		echo -e "(+) Error deleting $(PROJ_FLDR)"
	echo -e "(D) Delete end."

help:
	## Prints this help menu
	# Will search for all '##' in each recipe and
	# Write that out in the help menu
	# Reference: Gavin Freeborn | How to manage your dotfiles with make | https://www.youtube.com/watch?v=aP8eggU2CaU
	@grep -E '^[a-ZA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


