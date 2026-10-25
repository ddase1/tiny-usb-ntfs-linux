#!/bin/bash
set -euo pipefail

KERNEL_VER="6.6.60"
KERNEL_SRC="linux-${KERNEL_VER}"
TAR_FILE="${KERNEL_SRC}.tar.xz"

if [ ! -d "${KERNEL_SRC}" ]; then
    echo ">>> Download kernel ${KERNEL_VER}"
    wget -q "https://cdn.kernel.org/pub/linux/kernel/v6.x/${TAR_FILE}"
    tar -xf "${TAR_FILE}"
fi

cd "${KERNEL_SRC}"

cp ../configs/tiny-usb-ntfs.config .config
make olddefconfig

make -j"$(nproc)" bzImage
make -j"$(nproc)" modules

rm -rf ../out-modules
make modules_install \
    INSTALL_MOD_PATH=../out-modules \
    INSTALL_MOD_STRIP=1

mkdir -p ../out
cp arch/x86/boot/bzImage ../out/

echo "=== Build done ==="
echo "Kernel: out/bzImage"
echo "Modules: out-modules/lib/modules/"
