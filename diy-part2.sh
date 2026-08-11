#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 1. 简单粗暴，直接强行把你的专属 DTS 拷贝到官方指定的唯一目录
cp -f $GITHUB_WORKSPACE/mt7981b-ikuai-q3000.dts target/linux/mediatek/dts/

# 2. 动态向云端的 filogic.mk 写入 Q3000 硬件定义 (安全追加模式)
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
