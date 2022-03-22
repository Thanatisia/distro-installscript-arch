#======================================#
# Linux Distro Install Makefile Script #
#======================================#

#================================================================
# for ArchLinux Base & Post Installation + Setup Script
# Program Info:
# 	Author(s): 
#		1. Asura
#	Created: 2022-03-22 2258H, Asura
#	Modified:
#		[1] 2022-03-22 2258H, Asura
# Features:
#	- Easy Debug
#	- 1 Step installation
#	- Easy Seperation & Modification
#	- Similar to the Install Script
#		- You can use either according to your preferences
#	- Updates made to the bash install script will be made here too
# Remarks:
#	- 2022-03-22 : Created Script, still a WIP to translate from the Bash script
#================================================================

# Table of Contents
#	- Ingredients
#	- Recipes

#[Variables]

# Command Line Arguments
# Reference: https://stackoverflow.com/questions/2826029/passing-additional-variables-from-command-line-to-make
# Pass an argument: make <action> [arg-name]=[arg-value] 
# Get an argument: $(arg-name)
action=$@

# Global Variables
PKG_MGR=pacman
PKG_INSTALL=sudo $(PKG_MGR) -S
CC=cc

# File System Table (Fstab) Design
DISK_LABEL=msdos
DISK_NAME=/dev/sdX
DISK_SIZE=50.0GiB
declare -A PARTITION_SCHEME=(
	#======================================EDIT THIS==========================================================================#
	# ROW_ID, partition_name, mount_directory, partition_type, partition_filesystem_type, start_size, end_size, other_options #
	#=========================================================================================================================#
	[1]="Boot, /mnt/boot, primary, ext4, 0%,       1024MiB, Bootable"
	[2]="Root, /,         primary, ext4, 1024MiB,  32768MiB"
	[3]="Home, /home,     primary, ext4, 32768MiB, 100%"
)


# [Ingredients]

base-pkgs: ## Essential Base-Installation Packages
	## Can be modified
	linux linux-lts linux-firmware linux-lts-headers vim base-devel 


postinstall-pkgs: ## All other Packages to install
	xorg xorg-xinit git 

# [Recipes]

#========#
# Helper #
#========#

Changelogs: ## Print Changelogs
    echo "[1] 2022-03-02 1630H : Asura"
    echo "	- Created Script File"

targets: ## List all targets
    @grep '^[^#[:space:]].*:' Makefile

verify-network: ## Check if Host network is available

setup-disk: ## Setup Disk for use
	# Format Disk (Setup Disk Label)
	parted $(DISK_NAME) mklabel $(DISK_LABEL)

	# Create Partitions
	for partition_id in ${!PARTITION_SCHEME[@]}; do
		part_id=$partition_id
		part_scheme=(`echo ${PARTITION_SCHEME[$part_id]} | tr "," "\n"`)	# Split Partition Scheme string into array
		number_of_col=${#part_scheme[@]}
		part_name=${part_scheme[0]}
		part_mnt_dir=${part_scheme[1]}
		part_type=${part_scheme[2]}
		part_filesystem_type=${part_scheme[3]}
		part_start_size=${part_scheme[4]}
		part_end_size=${part_scheme[5]}
		part_label="$(DISK_NAME)$(part_id)"

		# Get Bootable
		if [[ $number_of_col -gt 6 ]]; then
			# Additional Options
			part_others=${part_scheme[@:6]}
		fi
		
		# Make Partition
		parted $(DISK_NAME) mkpart $(part_type) $(part_filesystem_type) $(part_start_size) $(part_end_size)

		# Format Partition
		case "$(part_filesystem_type)" in
			"fat16")
				mkfs.fat -F16 $(part_label)
				;;
			"fat32")
				mkfs.fat -f32 $(part_label)
				;;
			"ext3")
				mkfs.ext4 $(part_label)
				;;
			"ext4")
				mkfs.ext4 $(part_label)
				;;
			"linux-swap")
				# Swap Partition
				mkswap $(part_label)
				;;
			*)
				# Default
				;;
		esac

		# - Check if string contains substring
		if [[ "$part_others" == *"Bootable"* ]]; then
			# Make Bootable			
			parted $(DISK_NAME) set $(part_id) boot on
		fi
	done

enable-sudo: ## Enable sudo permission in /etc/sudoers
	sudo sed -i '' /etc/sudoers

#======#
# Main #
#======#
default: ## Set Default Recipe 
	## What to do if no instructions
	make -c help

help: ## List all options
	install : install packages
	start : Start Base Installation
	setup : 
	clean : 
	help : 
	default : 

start: ## Start Linux Distro Installation
	baseinstall
	setup
	postinstall
	clean

baseinstall: ## Base-Installation Proccess
	# 1. Check Network
	verify-network
	# 2. Setup Disk
	setup-disk

setup: ## Generate and Setup Configs of programs


postinstall: ## Post-Installation Setup 'Must Dos'
	enable-sudo


clean: ## Clean-up and remove all unnecessary files
	rm -f *.o