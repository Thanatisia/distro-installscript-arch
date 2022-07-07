# Makefile for Linux Distro Install Script Execution

# [Variables]

# Settings and Configurations
TARGET_DISK = /dev/sdd
MOUNT_ROOT = "/mnt"
MOUNT_PATHS = "/mnt/boot" "/mnt" "/mnt/home"

# Program Variables
ENV = TARGET_DISK_NAME="$(TARGET_DISK)"	# Environment Variables
SCRIPT = ./src/installer.remake.sh			# Script Filename
CFLAGS = "RELEASE"						# Compilation Flags

# [Commands]
CMD = $(ENV) $(SCRIPT)

# [Recipe]
.DEFAULT_GOAL := help
.PHONY: help init testinstall install clean

### Program Recipes ###

help: 
	## Displays this help menu
	@declare -A opts=( \
		[help]="Displays this help menu" \
		[init]="Initialize Environment Variables and System/Program Information" \
        [testinstall]="Run the install script's test suite and see the commands it will run before committing" \
        [install]="Run the install script. WARNING: This will overwrite the target disk/filesystem, please becareful. You will need to run 'sudo make install' to execute this" \
		[genscript]="Run install-gen and generate the commands to output as a script" \
		[clean]="Clean all temporary files and unmount drives" \
    ); \
    for opt in "$${!opts[@]}"; do \
		echo -e "$${opt} : $${opts[$${opt}]}"; \
	done

init:
	## Initialize Environment Variables and System/Program Information

testinstall: init
	## Run the install script testsuite
	# - Run this with sudo for username verification
	$(CMD)

install: clean
	## Run the install script and install
	# WARNING: This will overwrite the target disk/filesystem, please be careful
	# - Run this with sudo
	$(CMD) $(CFLAGS)

genscript:
	## Run install-gen and generate the commands to install and
	# Output as a script file for backup
	./install-gen

clean: 
	## Clean all temporary files and unmount drives 
	# Check if directory is a mount point
	! mountpoint -q "$(MOUNT_ROOT)" || sudo umount -l $(MOUNT_ROOT) # If error, assume no errors

### Test Suites / Unit Tests


