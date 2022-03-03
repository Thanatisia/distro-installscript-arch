# Makefile 
#================================================================
# for ArchLinux Base & Post Installation + Setup Script
# Program Info:
# 	Author(s): 
#		1. Asura
#	Created: 2022-03-02 1630H, Asura
#	Modified:
#		[1] 2022-03-02 1630H, Asura
# Features:
#	- Easy Debug
#	- 1 Step installation
#	- Easy Seperation & Modification
#	- Similar to the Install Script
#		- You can use either according to your preferences
#	- Updates made to the bash install script will be made here too
# Remarks:
#	- 2022-03-02 : Created Script, still a WIP to translate from the Bash script
#================================================================
  
#===========
# Variables
#===========
BASE_PKGS=base base-utils
POST_PKGS=xorg
PKGINSTALL=sudo pacman -S

#==========
# Recipes
#==========

pkgs-base: ## List all Base Packages to install
	$(BASE_PKGS)

targets: ## List all targets
    @grep '^[^#[:space:]].*:' Makefile

#==============
# Instructions
#==============

#========
# Others
#========
Changelogs: ## Print Changelogs
    echo "[1] 2022-03-02 1630H : Asura"
    echo "	- Created Script File"

clean: ## Clean Up Files after done