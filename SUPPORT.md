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
+ bios   : A legacy motherboard firmware; Support Status: Unused
+ (u)efi : The Unified Extension Firmware Interface; a modern motherboard firmware used as replacement of the BIOS firmware; Support Status: Unused

### Partition Table Label/Format
+ msdos  : aka Master Boot Record (MBR) partitioning; Legacy format used with the BIOS motherboard bootloader firmware for disk with max size <= 2TB; Support Status: Supported
+ gpt    : The UEFI/GPT partition table format; Used for disks with max size > 2TB; Support Status: to be tested

### Filesystem Type
+ ext4
+ btrfs : WIP - Currently not supported

### Filesystem Label
+ /dev/sdX : For SATA HDD/SSD Drives; related to AHCI; Support Status: Supported
+ /dev/nvme[drive-number]p[partition-number] : For NVME Drives; WIP - Currently not supported)

### Bootloader Support
- grub
    + Bootloader Option and Parameter support

## Resources

## References

## Remarks
