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

PKG_NAME="qt"
PKG_VERSION="4.8.6"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL="http://download.qt.io/official_releases/qt/4.8/$PKG_VERSION/$PKG_NAME-everywhere-opensource-src-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="lang"
PKG_SHORTDESC=""
PKG_LONGDESC=""
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  mv $BUILD/${PKG_NAME}-everywhere-opensource-src-$PKG_VERSION $PKG_BUILD
}

pre_configure_host() {
  export LD=$CXX
  export ROOT=$ROOT
  export TOOLCHAIN=$TOOLCHAIN
}

configure_host() {
  $ROOT/$PKG_BUILD/configure -prefix $ROOT/$TOOLCHAIN \
              -opensource \
              -confirm-license \
              -embedded \
              -shared \
              -no-qt3support \
              -no-multimedia \
              -no-audio-backend \
              -no-phonon \
              -no-phonon-backend \
              -no-svg \
              -no-webkit \
              -no-javascript-jit \
              -no-script \
              -no-scripttools \
              -no-declarative \
              -no-declarative-debug \
              -no-libmng \
              -no-nis \
              -no-cups \
              -optimized-qmake \
              -no-iconv \
              -no-dbus \
              -no-gtkstyle \
              -no-nas-sound \
              -no-opengl \
              -no-openvg \
              -no-sm \
              -no-xshape \
              -no-xvideo \
              -no-xsync \
              -no-xinerama \
              -no-xcursor \
              -no-xfixes \
              -no-xrandr \
              -no-xrender \
              -no-mitshm \
              -no-fontconfig \
              -no-xinput \
              -no-xkb \
              -nomake demos \
              -nomake examples \
              -nomake docs \
              -nomake translations
}

pre_configure_target() {
  export LD=$CXX
  export ROOT=$ROOT
  export TOOLCHAIN=$TOOLCHAIN

  mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/
  ln -sf $ROOT/$TOOLCHAIN/bin/qmake $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/qmake
  ln -sf $ROOT/$TOOLCHAIN/bin/moc $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/moc
  ln -sf $ROOT/$TOOLCHAIN/bin/rcc $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/rcc
  ln -sf $ROOT/$TOOLCHAIN/bin/uic $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/uic
  ln -sf $ROOT/$TOOLCHAIN/bin/uic3 $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/uic3
  ln -sf $ROOT/$TOOLCHAIN/bin/idc $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/idc

  sed -i 's|SUBDIRS = $$TOOLS_SUBDIRS $$SUBDIRS|SUBDIRS = $$SUBDIRS|g' $ROOT/$PKG_BUILD/src/tools/tools.pro 
}

configure_target() {
  $ROOT/$PKG_BUILD/configure -prefix $SYSROOT_PREFIX \
              -opensource \
              -confirm-license \
              -embedded arm \
              -xplatform qws/linux-arm-g++ \
              -little-endian \
              -shared \
              -no-qt3support \
              -no-multimedia \
              -no-audio-backend \
              -no-phonon \
              -no-phonon-backend \
              -no-svg \
              -no-webkit \
              -no-javascript-jit \
              -no-script \
              -no-scripttools \
              -no-declarative \
              -no-declarative-debug \
              -no-libmng \
              -no-nis \
              -no-cups \
              -optimized-qmake \
              -no-iconv \
              -no-dbus \
              -no-gtkstyle \
              -no-nas-sound \
              -no-opengl \
              -no-openvg \
              -no-sm \
              -no-xshape \
              -no-xvideo \
              -no-xsync \
              -no-xinerama \
              -no-xcursor \
              -no-xfixes \
              -no-xrandr \
              -no-xrender \
              -no-mitshm \
              -no-fontconfig \
              -no-xinput \
              -no-xkb \
              -stl \
              -nomake tools \
              -nomake demos \
              -nomake examples \
              -nomake docs \
              -nomake translations \
              -nomake qmake
}

pre_make_target() {
  # adjust qmake.conf
  QMAKE_CONF="$ROOT/$PKG_BUILD/.$TARGET_NAME/mkspecs/qws/linux-arm-g++/qmake.conf"
  sed -i "s|QMAKE_CC.*|QMAKE_CC = ${TARGET_CC}|g" $QMAKE_CONF
  sed -i "s|QMAKE_CXX.*|QMAKE_CXX = ${TARGET_CXX}|g" $QMAKE_CONF
  sed -i "s|QMAKE_LINK.*|QMAKE_LINK = ${TARGET_CXX}|g" $QMAKE_CONF
  sed -i "s|QMAKE_LINK_SHLIB.*|QMAKE_LINK_SHLIB = ${TARGET_CXX}|g" $QMAKE_CONF
  sed -i "s|QMAKE_AR.*|QMAKE_AR = ${TARGET_AR}|g" $QMAKE_CONF
  sed -i "s|QMAKE_OBJCOPY.*|QMAKE_OBJCOPY = ${TARGET_OBJCOPY}|g" $QMAKE_CONF
  sed -i "s|QMAKE_STRIP.*|QMAKE_STRIP = ${TARGET_STRIP}|g" $QMAKE_CONF

  sed -i "\$iQMAKE_INCDIR = ${TARGET_INCDIR}" $QMAKE_CONF
  sed -i "\$iQMAKE_LIBDIR = ${TARGET_LIBDIR}" $QMAKE_CONF
  
  sed -i "\$iQMAKE_CFLAGS = ${TARGET_CFLAGS}" $QMAKE_CONF
  sed -i "\$iQMAKE_CXXFLAGS = ${TARGET_CXXFLAGS}" $QMAKE_CONF
  sed -i "\$iQMAKE_LFLAGS = ${TARGET_LDFLAGS}" $QMAKE_CONF
}
