#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 1. 智能查找 24.10 的 DTS 目录并拷贝文件
DTS_TARGET_DIR=$(find target/linux/mediatek -type d -path "*/arch/arm64/boot/dts/mediatek" | head -n 1)
if [ -z "$DTS_TARGET_DIR" ]; then
    DTS_TARGET_DIR="target/linux/mediatek/dts"
    mkdir -p "$DTS_TARGET_DIR"
fi
cp -f $GITHUB_WORKSPACE/mt7981b-ikuai-q3000.dts "$DTS_TARGET_DIR/"

# 2. 动态向云端的 filogic.mk 写入 Q3000 硬件定义 (安全追加模式，不破坏原有文件)
# 注意：补充了 DEVICE_PACKAGES 确保 Wi-Fi 驱动被正确打包进去！
cat >> target/linux/mediatek/image/filogic.mk <<'EOF'

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
