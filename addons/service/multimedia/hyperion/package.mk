################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="hyperion"
PKG_VERSION="bedde91"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL="http://storage.freestylephenoms.com/devel/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain protobuf:host qt:target libusb Python bcm2835-driver"
PKG_PRIORITY="optional"
PKG_SECTION="service/multimedia"
PKG_SHORTDESC=""
PKG_LONGDESC=""
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_gold
}

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DQT_QTCORE_LIBRARY_RELEASE=$ROOT/$TOOLCHAIN/lib/libQtCore.so \
        -DQT_INCLUDE_DIR=$ROOT/$TOOLCHAIN/include/Qt \
        -DQT_QTCORE_INCLUDE_DIR=$ROOT/$TOOLCHAIN/include/QtCore \
        -DQT_QTGUI_INCLUDE_DIR=$ROOT/$TOOLCHAIN/include/QtGui \
        -DQT_QTNETWORK_INCLUDE_DIR=$ROOT/$TOOLCHAIN/include/QtNetwork \
        -DPROTOBUF_INCLUDE_DIRS=$TOOLCHAIN/include/google/protobuf \
        -DPROTOBUF_PROTOC_EXECUTABLE=$TOOLCHAIN/bin/protoc \
        --build "$TARGET_BUILD_DIR" "$ROOT/$PKG_BUILD"
}
