# OpenWRT-iKuai-Q3000-24.10

GitHub Actions build configuration for the iKuai IK-Q3000, based on the
ImmortalWrt `openwrt-24.10` branch.

## What this repository does

The repository does not contain the full OpenWrt source tree. The workflow
clones ImmortalWrt, installs feeds, applies the Q3000 device tree and image
definition, and builds the firmware.

The Q3000-specific files are:

- `.config`: target and package selection;
- `diy-part1.sh`: feed configuration;
- `diy-part2.sh`: Q3000 DTS and image definition injection;
- `mt7981b-ikuai-q3000.dts`: board description.

Run **OpenWrt Builder** manually from the Actions tab. The workflow also
publishes a new build when the tracked ImmortalWrt branch changes.

## Firmware files

- `*-initramfs-kernel.bin`: intended for RAM boot or development workflows. It
  does not replace the installed firmware by itself.
- `*-squashfs-factory.bin`: first installation from a compatible factory or
  recovery interface.
- `*-squashfs-sysupgrade.bin`: upgrade image for an already compatible
  OpenWrt installation.

Always verify the device name, file checksum, image size, and upgrade method
before flashing. Do not use `factory.bin` or `sysupgrade.bin` interchangeably.
Keep a backup of the original firmware, bootloader, factory calibration data,
and partition information. A failed flash may require a 3.3 V TTL serial
connection or an external programmer to recover the router.

## Hardware assumptions

The device definition assumes an iKuai Q3000 with MediaTek MT7981, 512 MiB
RAM, SPI-NAND storage, MT7531 switch, and the GPIO/port layout described in
the DTS. Different hardware revisions may require a different device tree.
Check the generated manifest and the device's partition layout before making
any permanent change.

## Package selection

The default image includes SQM, Argon, ttyd, and UPnP LuCI packages. Package
availability is validated by `make defconfig`; the final manifest in each
release is authoritative.

## Source and maintenance

The build source is:

```text
https://github.com/immortalwrt/immortalwrt
branch: openwrt-24.10
```

This repository is a device build configuration, not an official ImmortalWrt
distribution. Review upstream changes and run a build before using a new
release on production hardware.
