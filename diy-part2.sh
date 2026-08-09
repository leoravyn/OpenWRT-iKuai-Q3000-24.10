#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
# 1. 在 OpenWrt 源码里建一个 mediatek 的专属包厢
mkdir -p target/linux/mediatek/dts/mediatek

# 2. 把图纸精准复制到包厢里面！
cp -f $GITHUB_WORKSPACE/mt7981b-ikuai-q3000.dts target/linux/mediatek/dts/mediatek/mt7981b-ikuai-q3000.dts

# 3. 正常替换配置文件
cp -f $GITHUB_WORKSPACE/filogic.mk target/linux/mediatek/image/filogic.mk
