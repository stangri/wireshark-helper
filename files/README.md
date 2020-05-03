# Wireshark Helper

## Description

This service can be used to configure a router to sniff packets to/from a monitored device on the device running the Wireshark application.

Pick an IP address of the monitored device, an IP address of the device running the Wireshark application and start the service (from the Web UI or manually).

In the Wireshark app, set the filter to the monitored IP, for example if the IP of the device you want to sniff packets to/from is 192.168.1.121, then set the Wireshark filter to ```(ip.src == 192.168.9.121) || (ip.dst == 192.168.9.121)```.

## How to install

Install ```wireshark-helper``` and ```luci-app-wireshark-helper``` packages from the Web UI or run the following in a command line:

```sh
opkg update; opkg install wireshark-helper luci-app-wireshark-helper
```

If ```wireshark-helper``` and ```luci-app-wireshark-helper``` packages are not found in the official feed/repo for your version of OpenWrt/LEDE Project, you will need to add a custom repo to your router following instructions on [GitHub](https://github.com/stangri/openwrt_packages/blob/master/README.md#on-your-router)/[jsDelivr](https://cdn.jsdelivr.net/gh/stangri/openwrt_packages@master/README.md#on-your-router) first.

## Thanks

Credit for ```iptables``` rules and instructions goes to [Ayoma Gayan Wijethunga](https://www.ayomaonline.com/security/analyzing-network-traffic-with-openwrt/).
