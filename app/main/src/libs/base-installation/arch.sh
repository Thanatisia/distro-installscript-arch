#!/bin/env bash
<<EOF
Arch-related helper functions
EOF

base_system_Install()
{
	#
	# Pacstrap/Install base system and essential and must have packaes to mount (/mnt) before arch-chroot
	#
	# [Essential Package Categories]
	#	Text Editor
	#	Development
	#	networkmanager
	#	Kernels
	#

	# --- Input

	# Arrays
	pacstrap_Pkgs=${pkgs["pacstrap"]}

	# Local Variables
	mount_Point=${mount_Group["2"]}


	# --- Processing
	if [[ "$MODE" == "DEBUG" ]]; then
		# echo pacstrap ${mount_Group["2"]} "${pkgs[@]}"
		echo pacstrap $mount_Point ${pacstrap_Pkgs[@]}
	else
		# pacstrap ${mount_Group["2"]} "${pkgs[@]}"
		pacstrap $mount_Point ${pacstrap_Pkgs[@]}
	fi

	# --- Output
}

chroot_Exec()
{
	#
	# Execute commands using arch-chroot due to limitations with shellscripting
	#

	# --- Input
	# Local Variables
	device_Name="${device_Parameters["device_Name"]}"
	device_Label="${device_Parameters["device_Label"]}"
	dir_Mount="${mount_Group["2"]}"
	region="${location["region"]}"
	city="${location["city"]}"
	language="${location["language"]}"
	hostname="${network_config["hostname"]}"
    default_Kernel="${linux["kernel"]}"
	bootloader="${osdef["bootloader"]}"
	bootloader_optional_Params="${osdef["optional-parameters"]}"
	bootloader_target_device_Type="${osdef["target_device_Type"]}"

	# Array

	# Associative Array
	chroot_commands=(
		# "echo ======= Time Zones ======"												# Step 10: Time Zones
        "echo \(+\) Time Zones"
        "ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime"						# Step 10: Time Zones; Set time zone
		"hwclock --systohc"																# Step 10: Time Zones; Generate /etc/adjtime via hwclock
		# "echo ======= Location ======"													# Step 11: Localization;
        "echo \(+\) Location"
        "sed -i '/$language/s/^#//g' /etc/locale.gen" 									# Step 11: Localization; Uncomment locale using sed
		"locale-gen"																	# Step 11: Localization; Generate the locales by running
		"echo \"LANG=$language\" | tee -a /etc/locale.conf"								# Step 11: Localization; Set LANG variable according to your locale
		# "echo ======= Network Configuration ======"										# step 12: Network Configuration;
        "echo \(+\) Network Configuration"
        "echo \"$hostname\" | tee -a /etc/hostname"										# Step 12: Network Configuration; Set Network Hostname Configuration; Create hostname file
		"echo \"127.0.0.1   localhost\" | tee -a /etc/hosts"							# Step 12: Network Configuration; Add matching entries to hosts file
		"echo \"::1         localhost\" | tee -a /etc/hosts"							# Step 12: Network Configuration; Add matching entries to hosts file
		"echo \"127.0.1.1   $hostname.localdomain	$hostname\" | tee -a /etc/hosts"	# Step 12: Network Configuration; Add matching entries to hosts file
		# "echo ======= Make Initial Ramdisk ======="										# Step 13: Initialize RAM file system;
        "echo \(+\) Making Initial Ramdisk"
        "mkinitcpio -P $default_Kernel"													# Step 13: Initialize RAM file system; Create initramfs image (linux-lts kernel)
		# "echo ======= Change Root Password ======="										# Step 14: User Information; Set Root Password
        "echo \(+\) Change Root Password"
        "passwd || passwd"																		# Step 14: User Information; Set Root Password
	)

	# --- Extra Information

	#### Step 15: Install Bootloader
	### NOTE:
	### 1. Please Edit [osdef] on top with the bootloader information before proceeding
	####
	# Default Bootloader
	if [[ "$bootloader" == "" ]]; then
		# Empty : Reset to 'Grub'
        echo "(-) Sorry, $bootloader is not supported at the moment, we will default to Grub(2.0)"
		bootloader="grub"
	fi

	# Switch Case bootloader between grub and syslinux
	case "$bootloader" in
		# Step 15: Bootloader
		"grub")
			chroot_commands+=(
                "echo \(+\) Installing Bootloader : Grub"
                "sudo pacman -S grub"																# Install Grub Package
				"grub-install --target=$bootloader_target_device_Type --debug $bootloader_optional_Params $device_Name"	# Install Grub Bootloader
				"mkdir -p /boot/grub"																# Create grub folder
				"grub-mkconfig -o /boot/grub/grub.cfg"												# Create grub config
			)
			;;
		"syslinux")
			chroot_commands+=(
                "echo \(+\) Installing Bootloader : Syslinux"
				"sudo pacman -S syslinux"
				"mkdir -p /boot/syslinux"
				"cp -r /usr/lib/syslinux/bios/*.c32 /boot/syslinux"
				"extlinux --install /boot/syslinux"
			)
			case "$device_Label" in
				"mbr")
					chroot_commands+=(
						"dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/bios/mbr.bin of=$device_Name"
					)
					;;
				"gpt")
					chroot_commands+=(
						"sgdisk $device_Name --attributes=1:set:2"
						"dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=$device_Name"
					)
					;;
				*)
					# Default to MBR
					;;
			esac
			;;
		*)
			# Default to grub
			;;
	esac

	# --- Processing

	# Combine into a string
	cmd_str=""
	for c in "${chroot_commands[@]}"; do
		cmd_str+="\n$c;"
	done

	# Cat commands into script file in mount root
	mount_Root=$dir_Mount/root
	script_to_exe=chroot-comms.sh
	if [[ "$MODE" == "DEBUG" ]]; then
		echo -e "$cmd_str"
	else
		echo -e "$cmd_str" > $mount_Root/$script_to_exe
	fi

	# Execute in arch-chroot
    # Future Codes deemed stable *enough*, thanks Past self for retaining legacy codes
    # for debugging
	external_scripts+=(
		### Append all external scripts used ###
		$mount_Root/$script_to_exe
	)

	if [[ "$MODE" == "DEBUG" ]]; then
		echo "chmod +x $mount_Root/$script_to_exe"
		echo "arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe""
	else
		chmod +x $mount_Root/$script_to_exe
		arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe"
	fi
	# --- Output
}

installer()
{
	#
	# Main setup installer
	#
    echo -e "(S) Starting Base Installation..."

	echo "========================"
	echo "Stage 1: Prepare Network"
	echo "========================"
    echo "(S) 1. Testing Network..."
	network_Enabled="$(verify_network)"
	if [[ "$network_Enabled" == "False" ]]; then
		sudo dhcpcd && \
            echo -e "(+) Network is activated" || \
            echo -e "(+) Error starting Network"
    else
        echo -e "(+) Network is active"
	fi
    echo "(D) Network testing completed."

    if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "=========================================="
	echo "Stage 2: Verify Boot Mode (i.e. UEFI/BIOS)"
	echo "=========================================="
    echo -e "(S) Verifying Boot Mode..."
	boot_Mode="$(verify_boot_Mode)"
    echo -e "(+) Boot Mode: $boot_Mode"
    echo -e "(D) Boot Mode verification completed."

    if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "============================"
	echo "Stage 3: Update System Clock"
	echo "============================"
    echo -e "(S) Updating System Clock..."
    update_system_Clock
    echo -e "(D) System clock updated."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "============================"
	echo "Stage 4: Partition the Disks"
	echo "============================"
    echo -e "(S) Starting Disk Management..."
    device_partition_Manager
    echo -e "(D) Disk Management completed."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "===================="
	echo "Stage 5: Mount Disks"
	echo "===================="
    echo -e "(S) Mounting disks..."
	mount_Disks
    echo -e "(D) Disks mounted."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "======================="
	echo "Stage 6: Select Mirrors"
	echo "======================="
    echo -e "(S) Selecting mirrors..."
	echo $EDITOR /etc/pacman.d/mirrorlist
    echo -e "(D) Mirror selected."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==================================="
	echo "Stage 7: Install essential packages"
	echo "==================================="
    echo -e "(S) Strapping packages to mount point..."
	base_system_Install
    echo -e "(D) Packages strapped."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==========================================="
	echo "Stage 8: Generate fstab (File System Table)"
	echo "==========================================="
    echo -e "(S) Generating Filesystems Table in /etc/fstab"
	fstab_Generate
    echo -e "(D) Filesystems Table generated."

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "==========================="
	echo "Stage 9: Chroot and execute"
	echo "==========================="
    echo -e "(S) Executing chroot commands"
	chroot_Exec # Execute commands in arch-chroot
    echo -e "(D) Commands executed"

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "======================="
	echo "Installation Completed."
	echo "======================="

	echo ""

	echo "================="
	echo "Post-Installation"
	echo "================="
    echo -e "(S) Starting Basic Post-Installation"

    echo -e "(+) Running post-installation..."
	postinstallation
    echo -e "(+) Post-Installation execution completed"

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

	echo "========================"
	echo "Sanitization and Cleanup"
	echo "========================"
    echo -e "(+) Running finalization and sanitization..."
	postinstall_sanitize
    echo -e "(+) Sanitization completed"

	if [[ "$MODE" == "DEBUG" ]]; then
		read -p "Press anything to continue..." tmp
	fi

	echo ""

    echo -e "(D) Basic Post-Installation processes completed."


    read -p "(D) Finished, press anything to quit." finish	
}

