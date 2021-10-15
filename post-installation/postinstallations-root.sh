#
# Root - setup postinstallation
# Author: Asura
# Created by: 2021-05-30 1211H, Asura
# Modified by: 
#	2021-05-30 1211H, Asura
#	2021-06-05 2326H, Asura
#	2021-06-06 1230H, Asura
# Background Info:
#	/* Please run this first - must be ran on root level */
#	A simple post installation script that will run basic essential TODO stuff after a complete/minimal installation 
#	on a root level
#	- These are the "must do" after any basic/minimal installations to any distro, not just ArchLinux
#	- Similar to postinstallations.sh but must be ran on root level
#	- Use this alongside [setup.sh, postinstallations.sh, customs.sh] to install/create a complete fundamental Out-of-the-Box (OOTB) linux experience with the basic requirements such as
#		[postinstallations-root.sh]
#		1. Creating user etc.
#		[postinstallations.sh]
#		1. Window Managers/Desktop Environment
#		2. File Browser
#		3. Terminals
#		[setup.sh]
#		4. Proper home file directory structure (Home, Desktop, Documents, Media etc.)
#		5. A default OOTB universal preset that is easily understandable
#	- Use this alongside [customs.sh] to get dotfiles that will expand the linux OOTB experience and are considered essentials
#		1. Essential custom dotfiles, commands, files that can be adjusted to fit your needs
#			such as:
#				a bashrc-personal file in ~/.portable/dotfiles/BashRC/aliases folder (Path adjustable in customs.sh)
# Features:
#	- Fundamental root post-installation setups
#		- Create new user, groups etc.
#		- visudo (allow wheel to use sudo)
#

# --- Input
# Command Line Arguments
argv=("$1")
argc="${#argv[@]}"

# Local Variables

# Functions
user_Management()
{
	### 4. User account ###
	create_user_Confirmation=""
	custom_directory_Confirmation=""
	user_Name=""
	primary_Group=""
	secondary_Groups=""
	custom_Directory="" # For creating user in a custom directory; useradd -m -d $custom_Directory
	cmd_user_Create="useradd"
	read -p "Create user now? [Y|N]: " create_user_Confirmation
	if [[ "$create_user_Confirmation" == "Y" ]]; then
		# Create user
		read -p "User Name: " user_Name	
		read -p "Create in Custom Directory? [Y|N]: " custom_directory_Confirmation
		read -p "Primary Group (Seperate with ','): " primary_Group
		read -p "Secondary Groups (Seperate with ','): " secondary_Groups
		
		# Create custom directory & add user
		if [[ "$custom_directory_Confirmation" == "Y" ]]; then
			read -p "Custom Directory [Leave empty for no custom directory]: " custom_Directory
			if [[ ! "$custom_Directory" == "" ]]; then
				# Custom Directory
				custom_Directory="/home/profiles/$user_Name"
				sudo useradd -m -g $primary_Group -G $secondary_Groups -d $custom_Directory $user_Name
			fi
		else
			# No Custom Directory
			if [[ ! "$primary_Group" == "" ]]; then
				$cmd_user_Create+="-g $primary_Group"
			fi

			if [[ ! "$secondary_Groups" == "" ]]; then
				$cmd_user_Create+="-G $secondary_Groups"
			fi

			sudo $cmd_user_Create $user_Name 
		fi

		# Set user password
		sudo passwd $user_Name
	fi
}

network_Management()
{
	### 1. networking ###
	# Check if NetworkManager is installed
	network_pkg="networkmanager"
	pkg_check="$(pacman -Qq | grep $network_pkg)"
	if [[ "$pkg_check" == "" ]]; then
		# Does not exists
		sudo pacman -S $network_pkg
		
		# Verify installation
		pkg_check="$(pacman -Qq | grep $network_pkg)"
		if [[ ! "$pkg_check" == "" ]]; then
			install_Token="Success"
		else
			install_Token="Error"
		fi
		echo "Installed: [$network_pkg] : $install_Token"
	fi
	# Check if package is running
	networkmgr_status="$(systemctl status NetworkManager | grep running)"
	if [[ -z "$networkmgr_status" ]]; then
		# Empty; Not Activated
		echo "Network is not activated."
		echo "Activating network..."
		sudo systemctl start NetworkManager |& tee -a ~/.logs/svc-networkmgr.log &&
			echo "Network successfully activated." ||
			echo "Error activating network"
	fi
}

allow_sudo()
{
	visudo
}

# --- Processing

# 
# Setup
#

#
# Main
#
network_Management
user_Management

# --- Output


#================= Finishing Touches ================#


### Finish ###
complete_uInput=""
read -p "Setup is complete, please run setup.sh for a complete OOTB experience if you have time :)" complete_uInput

confirm_Delete=""
read -p "Would you like to delete this file?: " confirm_Delete
case "$confirm_Delete" in
	"Y" | "y" )
		# Delete itself
		sudo rm $0
		;;
	*)
		# Do nothing, just end
		;;
esac
