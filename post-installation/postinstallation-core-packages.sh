#
# Distro Post-Installation Core Package Installation Setup Script
# Author: Asura
# Created: 2021-06-15 0113H, Asura
# Modified: 
#	- 2021-06-15 0113H, Asura
#	- 2021-06-15 0154H, Asura
# Features: 
# Background Information: 
#	An all-in-one module core package install script
# Changelog:
#	- 2021-06-15 0113H, Asura:
#		- Created script file
#	- 2021-06-15 0154H, Asura:
#		- Fixed installation
#

# --- Variables

# [Program]
PROGRAM_SCRIPTNAME="installation-core-packages"
PROGRAM_NAME="Postinstallation: Core Packages Installation"
PROGRAM_TYPE="Main"
MODE="${1:-DEBUG}" # { DEBUG | RELEASE }
DISTRO="ArchLinux"

# [Folders]
logging_filepath=~/.logs

# [Arrays]
folders_to_create=(
	$logging_filepath
)

pkgs=(
	# EDIT: Place your packages to install here
	"qtile"				# Window Manager
	"alacritty"			# Terminal Emulator
	"pcmanfm"			# File Browser
	"brave"				# Web Browser
	"sublime-text-dev"	# Graphial Text/Code Editor
	"nitrogen"			# Image Setter
	"picom"				# Compositor
	"conky"				# System Monitor
	"bluez"				# Bluetooth Manager
	"lxappearance-gtk3"	# Others : Ricing Utility (GTK-3.0)
	"neofetch"			# Others : Fetch Utility
)

base_distros=(
	"ArchLinux"
	"Debian"
	"Gentoo"
	"Void Linux"
)

# [Associative Array]
declare -A reference_Distros=(
	[ArchLinux]="ArtixLinux;"
	[Debian]="Ubuntu"
)
declare -A install_commands=(
	[ArchLinux]="sudo pacman -S --noconfirm --needed"
	[Debian]="sudo apt-get install"
)

# [Derivatives]
number_of_Packages="${#pkgs[@]}"

# [Essentials]
install_Command="${install_commands["$DISTRO"]}"

# --- Functions

# General Functions

# Main functions
init()
{
	#
	# On Runtime initialization
	#	- When program initialized
	#
	echo "Program Name: $PROGRAM_NAME"
	echo "Running on  : $DISTRO"

	# Create folders if doesnt exist
	for d in "${folders_to_create[@]}"; do
		if [[ ! -d $d ]]; then
			mkdir -p $d
		fi
	done
}

body()
{
	#
	# Main function to run
	#
	argv=("$@")
	argc="${#argv[@]}"


	echo "====================================================================="
	echo " Post-Installation: Core Packages and Essential 'Must have' Packages "
	echo "====================================================================="

	# Confirm installation
	for p in "${!pkgs[@]}"; do
		echo "[$p] : [${pkgs[$p]}]"
	done

	read -p "Confirm installation of the above following packages? [Y|N]: " conf
	if [[ "$conf" == "Y" ]]; then
		for p in "${pkgs[@]}"; do
			if [[ "$MODE" == "DEBUG" ]]; then
				echo $install_Command $p | tee -a $logging_filepath/installed-packages.log 
			else
				$install_Command $p | tee -a $logging_filepath/installed-packages.log
			fi
		done
	fi

	echo "======"
	echo " End  "
	echo "======"
}

function END()
{
    line=""
    read -p "Pause" line
}

function main()
{
	#
	# Main Function 
	#  - You may not edit this if you want to leave it as default
	#

	body "$@"
	res="$?"
	echo "$res"
}

if [[ "${BASH_SOURCE[@]}" == "${0}" ]]; then
    # START
    init
	main "$@"
    END
fi

