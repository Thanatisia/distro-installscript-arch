# Hardware/Software Support

## Support

### Architectures 
- supported/tested
    + i386-pc : Generic x86_64 CPU architecture
- testing
    + amd64
    + arm
    + x86_64
    + x86_64-efi : x86_64 for UEFI/GPT

### Kernel
- supported/tested
    + linux : The base/latest Linux kernel
- testing
    + linux-lts
    + linux-zen

### Motherboard Bootloader Firmware
+ MSDOS  : The MSDOS motherboard firmware; To be replaced with the term 'BIOS'
+ (U)EFI : The UEFI  motherboard firmware

### Partition Table Format
+ BIOS   : The BIOS/Master Boot Record (MBR) (To be replaced with the keyword 'MSDOS'/'MBR'; Legacy format used for disk with max size <= 2TB
+ MSDOS  : WIP; To replace 'BIOS' with this and/or 'MBR'
+ GPT    : The UEFI/GPT partition table format; Used for disks with max size > 2TB

### Filesystem Type
+ ext4
+ btrfs : WIP - Currently not supported

### Filesystem Label
+ /dev/sdX : For SATA HDD/SSD Drives; related to AHCI
+ /dev/nvme[drive-number]p[partition-number] : For NVME Drives; WIP - Currently not supported)

### Bootloader Support
- grub
    + Bootloader Option and Parameter support

## Resources

## References

## Remarks
