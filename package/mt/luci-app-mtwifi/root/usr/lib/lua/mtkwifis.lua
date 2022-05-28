#!/usr/bin/env lua

 -- Associated Stations MTK Wi-Fi
 -- For MT7615
 -- For MT7603 (MT7603+MT7615) regular expressions are available in my repository >
 -- https://github.com/Azexios/openwrt-r3p-mtk/blob/6ca7bcbb7ea32f8464ca5bea9e1352e9fec4ffa4/For_MT7603%2BMT7615/package/mt/luci-app-mtwifi/root/usr/lib/lua/mtkwifi.lua#L117

local mtkwifis = {}

function mtkwifis.read_pipe(pipe)
	local fp = io.popen(pipe)
	local txt =  fp:read("*a")
	fp:close()
	return txt
end

dme = mtkwifis.read_pipe("dmesg -c > /dev/null && iwpriv ra0 show stainfo 2>/dev/null & iwpriv rai0 show stainfo 2>/dev/null")
os.execute("sleep 0.5")
MAC = mtkwifis.read_pipe("dmesg | grep -oE '([A-Z0-9]{2}:){5}..' 2>/dev/null") or "?"
RSSI = mtkwifis.read_pipe("dmesg | grep -oE '([-0-9]{3}\/){3}...' 2>/dev/null") or "?"
RSSI_M = mtkwifis.read_pipe("dmesg | grep -oE '([-0-9]{3}\/){2}...' 2>/dev/null") or "?"
BW = mtkwifis.read_pipe("dmesg | grep -oE '([0-9]{2,3}[A-Z]{1})\\/.{3,4}' 2>/dev/null" ) or "?"
MCS = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}[A-Z]{1})\\/.{3,4}/{n;p;}' | grep -ioE '([-a-z0-9]{1,9}\/).{1,9}' 2>/dev/null" ) or "?"
SGI = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}[A-Z]{1})\\/.{3,4}/{n;n;p;}' | grep -oE '([0-1]\/.)' 2>/dev/null" ) or "?"
rate = mtkwifis.read_pipe("dmesg | grep -B 1 '0%' | grep -oE '([0-9]{1,4}\/[0-9]{1,4})' 2>/dev/null" ) or "?"

return mtkwifis
