#!/bin/bash
set -euo pipefail
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

custom_dts="$GITHUB_WORKSPACE/mt7981b-ikuai-q3000.dts"
image_makefile="target/linux/mediatek/image/filogic.mk"

test -f "$custom_dts"
test -f "$image_makefile"
cp "$custom_dts" target/linux/mediatek/dts/

# Keep the device definition in this repository so source updates cannot
# silently replace it. A duplicate usually means the upstream target changed.
if grep -q '^define Device/ikuai_q3000$' "$image_makefile"; then
	echo "ikuai_q3000 is already defined in $image_makefile" >&2
	exit 1
fi

cat >> "$image_makefile" <<'EOF'

define Device/ikuai_q3000
  DEVICE_VENDOR := iKuai
  DEVICE_MODEL := IK-Q3000
  DEVICE_DTS := mt7981b-ikuai-q3000
  DEVICE_DTS_DIR := ../dts
  SUPPORTED_DEVICES := ikuai,q3000
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7981-firmware mt7981-wo-firmware
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  IMAGE_SIZE := 114816k
  KERNEL_IN_UBI := 1
  IMAGES += factory.bin
  IMAGE/factory.bin := append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += ikuai_q3000
EOF
