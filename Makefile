# Copyright 2017-2018 Stan Grishin (stangri@melmac.net)
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_NAME:=wireshark-helper
PKG_VERSION:=0.0.1
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0-or-later
PKG_MAINTAINER:=Stan Grishin <stangri@melmac.net>

include $(INCLUDE_DIR)/package.mk

define Package/wireshark-helper
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+iptables-mod-tee
	TITLE:=wireshark-helper Service
	PKGARCH:=all
endef

define Package/wireshark-helper/description
This service can be used to set up iptables rules required for WireShark.
endef

define Package/wireshark-helper/conffiles
/etc/config/wireshark-helper
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/files/
	$(CP) ./files/wireshark-helper.init $(PKG_BUILD_DIR)/files/wireshark-helper.init
	sed -i "s|^\(PKG_VERSION\).*|\1='$(PKG_VERSION)-$(PKG_RELEASE)'|" $(PKG_BUILD_DIR)/files/wireshark-helper.init
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/wireshark-helper/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/wireshark-helper.init $(1)/etc/init.d/wireshark-helper
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/wireshark-helper.conf $(1)/etc/config/wireshark-helper
endef

define Package/wireshark-helper/postinst
	#!/bin/sh
	# check if we are on real system
	if [ -z "$${IPKG_INSTROOT}" ]; then
		/etc/init.d/wireshark-helper enable

		while [ ! -z "$(uci -q get ucitrack.@wireshark-helper[-1] 2>/dev/null)" ] ; do
			uci -q delete ucitrack.@wireshark-helper[-1]
			uci commit ucitrack
		done

		uci -q batch <<-EOF >/dev/null
			add ucitrack wireshark-helper
			set ucitrack.@wireshark-helper[-1].init='wireshark-helper'
			commit ucitrack
	EOF
	fi
	exit 0
endef

define Package/wireshark-helper/prerm
	#!/bin/sh
	# check if we are on real system
	if [ -z "$${IPKG_INSTROOT}" ]; then
		echo "Stopping service and removing rc.d symlink for wireshark-helper"
		/etc/init.d/wireshark-helper stop || true
		/etc/init.d/wireshark-helper disable || true
		while [ ! -z "$(uci -q get ucitrack.@wireshark-helper[-1] 2>/dev/null)" ] ; do
			uci -q delete ucitrack.@wireshark-helper[-1]
			uci commit ucitrack
		done
	fi
	exit 0
endef

$(eval $(call BuildPackage,wireshark-helper))
