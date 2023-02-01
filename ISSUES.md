# ISSUES

* Current Issues and Bugs encountered that needs to be solved

## Bugs
- distinstall
	- mount_Disks()
		- [] Mounting of directories to partitions - after removing the static root, boot and home partitions in favour of Dynamic partitions - are now inconsistent
		   	+ Due to the mounting order being incorrect
		   	- Issue : Unmounting via 'sudo make clean' will not unmount the test mounted partition '/mnt/home'
				- Temporary Solution: Unmounting via 'umount -l /mnt' using the unit test case needs to be repeated twice; once with '/mnt' and another with '/mnt/home'
			- Note
			   - The mounting process itself still works and the system will still boot and mount properly, just that this seems to be an irritating issue that happens if the order of arrangement with regards to mounting the partitions in the following order respectively : 'root' partition => 'boot' and 'home'
			+ Issue Opened: 2023-01-26 22:39H by Asura

