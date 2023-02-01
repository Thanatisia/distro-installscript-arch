# Installer Configuration

## Customization and Configuration


## Configuration file

### File Information
- File Name: 
	+ Default: config.sh
- Notes
	+ Please change the default file name in the installer script to use a different configuration file name
	+ Ability to use a custom configuration file name via CLI arguments/flags/parameters is currently a WIP

### Disk/Device Parameters
- deviceParams_devType : The storage device type
	- Description
		```
		Used as an identifier if hardware information is required
		```
	- Possible Values:
		+ HDD : Hard Disk Drive
		+ SSD : Solid State Drive
		+ Flashdrive : Flashdrive/Thumbdrive
		+ MicroSD : MicroSD Card
		+ VHD : Virtual HDD
- deviceParams_Name : The disk label; aka the name of the Disk (i.e. /dev/sdX, /dev/sda etc)
	- Default Value
		+ $TARGET_DISK_NAME
- deviceParams_Size : The total size of the disk
	- Possible Values:
		+ x GB : Size in Gigabytes
		+ x GiB : Size in Gibibytes
		+ x MB : Size in Megabytes
		+ x MiB : Size in Mebibytes
- devicePrams_Boot : The bootloader firmware types
	- Possible Values:
		+ msdos : The DOS firmware type; aka BIOS
		+ uefi : The Unified Extensible Firmware Interface; Supports MBR hard drive bootloader partition table
- deviceParams_Label : The Bootloader Partition Table
	- Possible Values:
		- mbr : The Master Boot Record
			+ Only supports drives of 2TB and lower
			- Partition Types
				- Primary : The main read-writable partition type
					+ Can only create 4 total Primary partitions
				- Extended : Containers for logical partitions
					- Logical
		+ gpt : The GUID Partition Table; part of the UEFI
			+ Supports drives 2TB and above
- boot_Partition : The disk/filesystem partition definition you wish to create on the disk
	+ Data Type: Associative Array; HashMap; Dictionary
	- Notes
		- The column "partition_Name" is used primarily in the GPT partition table
			- in the case of MBR, the "partition_Name" column will be used for personal identification of the partition
				+ in the filesystem/partition schema design 
	- Synopsis/Syntax
		- Components
			+ partition_Number : The partition number of the current partition/disk label (aka name)
			- partition_Name : The partition/disk label/name (aka partition name)
				- Examples
					+ /dev/sda
					+ /dev/sdX
			- partition_Type : The partition type of the 
				- Important Notes
					+ Depending on your partition table of your storage disk (mbr/gpt etc), your partition types may vary
				- Partition Table Types
					> The following are specified above in the variable 'devicePrams_Boot'
					- Master Boot Record (MBR):
						+ Primary 
						- Extended
							+ Logical
					- GUID Partition Table (GPT):
						+ The GPT partition table does not use partition types
						+ Instead, these will be your partition "Labels", effectively like the name.
						+ Please refer to the array column "partition_Name" for the partition label
			- partition_file_Type : The filesystem type of the current partition
				- Valid Partition Filesystems
					> The following are tested and implemented
					+ ext4
				- Examples
					+ fat{8,16,32}
					+ ext{1,2,3,4}
					+ btrfs
					+ zfs
			- partition_start_Size : The starting size/space to start allocation and writing of current partition's filesystem
				- Hints
					- You can use percentage (%) values to indicate relative instead of absolute values
						+ 0% : Right at the beginning of the available storage space
						+ 25% : 1/4 of the total storage available in the device
						+ 50% : Half of the total storage available in the device
						+ 75% : 3/4 of the total storage available in the device
						+ 100% : Right at the end of the available storage space
					+ The start size can be used on the exact space that you ended from the previous partition
			- partition_end_Size : The ending/last size/space to stop/end the writing of the current partition's filesystem
				- Hints
					- You can use percentage (%) values to indicate relative instead of absolute values
						+ 0% : Right at the beginning of the available storage space
						+ 25% : 1/4 of the total storage available in the device
						+ 50% : Half of the total storage available in the device
						+ 75% : 3/4 of the total storage available in the device
						+ 100% : Right at the end of the available storage space
			- partition_Bootable : Indicate if the partition is bootable
				- Type: Boolean (True|False)
				- Default Value: False
				- Possible Values
					+ True
					+ False
			- partition_Others : Additional/Other flags to append and add into the partition process; Currently unused
				- Possible Values
					+ NIL
	- Structure
    	```shellscript
		boot_Partition=(
			# Append this and append a [n]="${boot_Partition[<n-1>]}" in
			#	partition_Configuration
			# <partition_Number>;<partition_Name>;<partition_Type>;<partition_file_Type>;<partition_start_Size>;<partition_end_Size>;<partition_Bootable>;<partition_Others>
			"1;Boot;primary;ext4;0%;1024MiB;True;NIL"
			"2;Root;primary;ext4;1024MiB;<x1MiB>;False;NIL"
			"3;Home;primary;ext4;<x1MiB>;100%;False;NIL"
		)
		```
	- Examples
		- 51200MiB (50GiB) storage device using ext4
			```shellscript
			boot_Partition=(
				"1;Boot;primary;ext4;0%;1024MiB;True;NIL"
				"2;Root;primary;ext4;1024MiB;32768MiB;False;NIL"
				"3;Home;primary;ext4;32768MiB;100%;False;NIL"
			)
			```
- mount_Paths : Specify all paths and directories you want to mount corresponding to the partition number specified in 'boot_Partition'
	+ Data Type: ArrayList; List
	- Notes
		+ Please seperate all parameters with delimiter ','
		+ Please seperate all subvalues with delimiter ';'
	- Syntax/Synopsis
		- Components
			+ Partition Name : This is the name of the partition you wish to mount the corresponding mount path to; the partition name is the same as the one specified in 'boot_Partition'
			+ Mount Path : This is the path to the mount filesystem/directory
	- Structure
		```shellscript
		mount_Paths=(
			# Add a seperate path/directory you want to mount corresponding to the partition number specified in 'boot_Partition'
			# "[Partition Name],[Mount Path]"
			"Partition Name,/directory/to/mount/filesystem/or/directory/path/1" # partition 1
			"Partition Name,/directory/to/mount/filesystem/or/directory/path/2" # partition 2
			"Partition Name,/directory/to/mount/filesystem/or/directory/path/3" # partition 3
		)
		```
	- Examples
		```shellscript
		mount_Paths=(
			"Boot,/mnt/boot"	# Boot
			"Root,/mnt"         # Root
			"Home,/mnt/home"	# Home
		)
		```

### Filesystem/System Information
- pacstrap_pkgs : Specify and list all packages you wish to bootstrap into the arch system automatically by default from the get go
	- Recommended packages:
		+ base : The gnu/linux base system packages; generally required
		+ linux : The Linux base kernel; required if you dont have a kernel; recommended if you are not manually compiling your own kernel
		+ linux-firmware : Additional firmware and utilities for the linux base kernel
		+ linux-lts : The Linux Long Term Release kernel; required if you dont have a kernel; recommended as backup in case of breakage
		+ linux-lts-headers : Header files for the Linux LTS kernel
		+ base-devel : The GNU/linux base development package. Contains various development utilities for making/building/compiling source codes; Recommended to have at all times as you might need to compile packages
		+ networkmanager : The Linux Network Manager utility
	- Structure
		```shellscript
		pacstrap_pkgs=(
			# EDIT: MODIFY THIS
			# Add the packages you want to strap in here
			"package-name"
		)
		```
	- Examples
		```shellscript
		pacstrap_pkgs=(
			# EDIT: MODIFY THIS
			# Add the packages you want to strap in here
			"base"
			"linux"
			"linux-firmware"
			"linux-lts"
			"linux-lts-headers"
			"base-devel"
			"nano"
			"vim"
			"networkmanager"
			"os-prober"
		)
		```
- location_Region : Your system's region
	- Recommendation
		+ Refer to '/usr/share/zoneinfo' for your region
	- Syntax/Synopsis
		```shellscript
		location_Region="<your-region (Asia|US etc)>"
		```
- location_City : Your system's city
	- Recommendation
		+ Refer to '/usr/share/zoneinfo/<your-region>' for your City
	- Syntax/Synopsis
		```shellscript
		location_City="<your-city (Singapore etc)>"
		```
- location_Language : Your system's language and locale
	- Recommendation
		+ Refer to '/etc/locale.gen' for a list of all language codes
	- Syntax/Synopsis
		```shellscript
		location_Language="<language-code (en_US.UTF-8|en_SG.TF-8 etc)>"
		```
- location_KeyboardMapping : Your Keyboard Mapping
	- Recommendation
		+ Change this if you use this (TODO: 2022-06-17 2314H : At the moment this is not used)
	- Syntax/Synopsis
		```shellscript
		location_KeyboardMapping="en_UTF-8"
		```

### User Management
- user_ProfileInfo : Contains all user profiles as well as to create; Used by the associative array 'user_Info'
	- Notes
		+ Please seperate all parameters with delimiter ','
		+ Please seperate all subvalues with delimiter ';'
	- Syntax/Synopsis
		- Components
			+ username : The username of the current user
			+ primary group : The main group to assign to this user
			+ secondary group(s) : Additional subgroups to assign to this user; put 'NIL' if none
			+ custom directory path : Custom home directory path to create your user in; put 'NIL' if none
			+ other parameters : Any other parameters to append to the 'useradd' command to create
	- Structure
		```shellscript
		user_ProfileInfo=(
			# Append this and append a [n]="${user_ProfileInfo[<n-1>]}" in 'user_Info' (located in the install script itself)
			# Syntax:
			# "
			#	<username>,
			#	<primary_group>,
			#	<secondary_group (put NIL if none),
			#	<custom_directory_path (put NIL if none)>,
			#	<any_other_Parameters>
			# "
			"username,wheel,NIL,/home/profiles/username,NIL"	
		)
		```
	- Examples
		```shellscript
		user_ProfileInfo=(
			# ArchLinux/any other distros that uses 'wheel' for sudo roles/permissions
			"admin1,wheel,NIL,/home/admin,NIL"
			# Debian/any other distros that uses 'sudo' for sudo roles/permissions
			"admin2,sudo,NIL,/home/admin,NIL"
		)
		```
- networkConfig_hostname : Similar to workspace group name, This will assign a "network identifier" to your host to be identified on the network. Used by '/etc/hostname'
	- Syntax/Synopsis
		```shellscript
		networkConfig_hostname="<your-network-hostname>"
		```

### Bootloader and System Administration
- bootloader : Your bootloader
	- Notes
		+ at the moment - supported bootloaders are [grub, syslinux]
		+ tested:
			+ grub
		- TODO: 
			+ 2022-06-17 317H : Add more bootloaders (if available)
	- Possible Values:
		+ grub (Default)
		+ syslinux (to be added)
	- Syntax/Synopsis
		```shellscript
		bootloader="<your-bootloader>"
		```
- bootloader_Params : Bootloader Parameters to parse into the installation process
	- Notes
		+ This is used during the installation process of the bootloader you identified
		+ fill this if you have any, leave empty if NIL
	- Syntax/Synopsis
		```shellscript
		bootloader_Params=""
		```
	- Examples
		- GRUB
			```console
			bootloader_Params="--debug"
			```
- default_kernel : A Default Linux Kernel to assign to use in case none is identified
	- Notes
		+ This feature is still under testing
	- Synopsis/Syntax
		```shellscript
		default_kernel="<linux-kernel>"
		```
	- Examples
		```shellscript
		default_kernel="linux"
		```
- platform_Arch : This refers to your system/Platform Architecture
	- Brief Description
		- Your system architecture refers - more specifically - to your CPU architecture
	- Possible Values:
		+ i386-pc : Supports 32-bit and 64-bit CPU architectures; Recommended by default
		+ x86_64 : x86-64 (32-bit/64-bit)
	- Synopsis/Syntax
		```shellscript
		platform_Arch="<platform-architecture>"
		```
	- Examples
		```shellscript
		platform_Arch="i386-pc"
		```

## Resources
+ [GRUB bootloader](https://wiki.archlinux.org/title/GRUB)

## References

## Remarks

