#!/usr/bin/env lua

-- Associated Stations MTK Wi-Fi
-- For MT7615
-- https://github.com/Azexios/openwrt-r3p-mtk

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
RSSI = mtkwifis.read_pipe("dmesg | grep -oE '([-0-9]{3}\\/){3}...' 2>/dev/null") or "?"
BW = mtkwifis.read_pipe("dmesg | grep -oE '([0-9]{2,3}[A-Z]{1})\\/.{3,4}' 2>/dev/null" ) or "?"
MCS = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}[A-Z]{1})\\/.{3,4}/{n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?"
SGI = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}[A-Z]{1})\\/.{3,4}/{n;n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?"
Rate = mtkwifis.read_pipe("dmesg | awk '/0%/ {print a}{a=$NF}' 2>/dev/null" ) or "?"

for _,mac in ipairs(string.split(mtkwifis.read_pipe("dmesg | grep -oE '([A-Z0-9]{2}:){5}..'"), "\n"))
do
	os.execute("cat /tmp/dhcp.leases | grep -i '"..mac.."' | awk '{ print $4\" - \"$3 }' | grep '.*' >> /tmp/mtk/host || echo - >> /tmp/mtk/host")
end

Host = mtkwifis.read_pipe("cat /tmp/mtk/host 2>/dev/null") or "?"
os.execute("rm -rf /tmp/mtk/host")

return mtkwifis
