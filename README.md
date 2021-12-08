# MTK Wi-Fi driver for OpenWrt (For Xiaomi Mi R3P).

Can be used for other devices - https://github.com/Azexios/openwrt-r3p-mtk/blob/23d676a989d62d03e4cb8dfd804870dc87f6ecc1/package/mt/drivers/mt_wifi/Makefile#L12  
You may need to edit the WirelessMode values:  
https://github.com/Azexios/openwrt-r3p-mtk/blob/d2b2dbb9c2f64c667693be61c974762e50dac604/package/mt/luci-app-mtwifi/root/usr/lib/lua/mtkwifi.lua#L236 (lines 236-267).  
https://github.com/Azexios/openwrt-r3p-mtk/blob/d2b2dbb9c2f64c667693be61c974762e50dac604/package/mt/luci-app-mtwifi/luasrc/view/admin_mtk/mtk_wifi_dev_cfg.htm#L57 (lines 57-64).

### Инструкция по сборке (In Russian)
https://4pda.to/forum/index.php?s=&showtopic=821686&view=findpost&p=111402096

### Screenshot
![Image alt](https://raw.githubusercontent.com/Azexios/openwrt-r3p-mtk/main/0312.PNG)

### Sources
https://github.com/openwrt/openwrt  
https://github.com/coolsnowwolf/lede  
https://github.com/Nossiac/mtk-openwrt-feeds/tree/master/mtk-luci-plugin/luci-app-mtkwifi
