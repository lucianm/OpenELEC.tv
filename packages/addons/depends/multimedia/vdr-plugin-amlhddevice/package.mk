################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="vdr-plugin-amlhddevice"
PKG_VERSION="b0fe61c"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_SITE="https://projects.vdr-developer.org/projects/plg-amlhddevice"
PKG_GIT_URL="https://projects.vdr-developer.org/git/${PKG_NAME}.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain vdr libamcodec"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="VDR HD output device for Amlogic SoC"
PKG_LONGDESC="VDR HD output device for Amlogic SoC"

PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

pre_make_target() {
  # dont build parallel
  MAKEFLAGS=-j1
}

make_target() {
  VDR_DIR=$(get_build_dir vdr)
  export PKG_CONFIG_PATH=$VDR_DIR:$PKG_CONFIG_PATH
  export CPLUS_INCLUDE_PATH=$VDR_DIR/include

  mkdir po

  make \
    LIBDIR="." \
    LOCDIR="./locale" \
    SYSROOT_PREFIX=$SYSROOT_PREFIX \
    all install-i18n
#    libvdr-amlhddevice.so
}

post_make_target() {
  VDR_DIR=$(get_build_dir vdr)
  VDR_APIVERSION=`sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$/\1/p' $VDR_DIR/config.h`
  LIB_NAME=lib${PKG_NAME/-plugin/}

  cp --remove-destination $ROOT/$PKG_BUILD/${LIB_NAME}.so $ROOT/$PKG_BUILD/${LIB_NAME}.so.${VDR_APIVERSION}
  $STRIP libvdr-*.so*
}

makeinstall_target() {
  : # installation not needed, done by create-addon script
}
