#!/bin/sh
set -e
set -v

export ARCH=arm ARM_ARCH=armv7-a
export HOST="$(printf '%s\n' "$MACHTYPE" | sed "s/-[^-]*/-cross/")"
export TARGET=arm-linux-musleabihf FLOAT=hard FPU=vfpv4

export ROOT="$(pwd)"
export DOWNLOADS="$(pwd)/src" TOOLS="$(pwd)/tools" BUILD="$(pwd)/build"
mkdir -p "$DOWNLOADS" "$TOOLS" "$BUILD"

export DEVICE=sun8i-h3-orangepi-one DEFCONFIG=sunxi
export BOOTARGS="loglevel=1 cma=64M root=/dev/mmcblk0p1 rootwait"

export UBOOT_DEFCONFIG=orangepi_one UBOOT_IMAGE=u-boot-sunxi-with-spl.bin

export PATH="$PATH:$(pwd)/scripts"
