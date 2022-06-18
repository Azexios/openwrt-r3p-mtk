#!/usr/bin/env lua

-- Associated Stations MTK Wi-Fi
-- For MT7603+MT7615 and driver version 4.1.2.0 _ 5.1.0.0
-- https://github.com/Azexios/openwrt-r3p-mtk/tree/7603+7615

local mtkwifis = {}

function mtkwifis.read_pipe(pipe)
	local fp = io.popen(pipe)
	local txt =  fp:read("*a")
	fp:close()
	return txt
end

dme = mtkwifis.read_pipe("dmesg -c > /dev/null && iwpriv ra0 show stainfo 2>/dev/null; iwpriv rai0 show stainfo 2>/dev/null")
MAC = mtkwifis.read_pipe("dmesg | grep -B 23 ' 0%' | grep -oE '([A-Z0-9]{2}:){5}..' 2>/dev/null") or "?"
MAC2 = mtkwifis.read_pipe("dmesg | grep -B 21 '100%' | grep -oE '([A-Z0-9]{2}:){5}..' 2>/dev/null") or "?"
RSSI = mtkwifis.read_pipe("dmesg | grep -oE '[^] I]([-0-9 ]{1,}\\/){3}[-0-9]{1,}' 2>/dev/null") or "?"
RSSI2 = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | grep -oE '[^] ]([-0-9 ]{1,}\\/)[-0-9 ]{1,}' 2>/dev/null") or "?"
BW = mtkwifis.read_pipe("dmesg | grep -oE '([0-9]{2,3}M)\\/[0-9]{2,3}M' 2>/dev/null" ) or "?"
BW2 = mtkwifis.read_pipe("dmesg | grep -A 5 '100%' | grep -oE '[0-9]{2,3}M' 2>/dev/null" ) or "?"
MCS = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}M)\\/[0-9]{2,3}M/{n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?" -- BW>MCS
MCS2 = mtkwifis.read_pipe("dmesg | sed -n '/100%/{n;n;n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?"
SGI = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}M)\\/[0-9]{2,3}M/{n;n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?" -- BW>SGI
SGI2 = mtkwifis.read_pipe("dmesg | sed -n '/100%/{n;n;n;n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?"
Rate = mtkwifis.read_pipe("dmesg | awk '/ 0%/ {print a}{a=$NF}' 2>/dev/null" ) or "?"
Rate2 = mtkwifis.read_pipe("dmesg | awk '/100%/ {print a}{a=$NF}' 2>/dev/null" ) or "?"

for _,mac in ipairs(string.split(mtkwifis.read_pipe("dmesg | grep -B 23 ' 0%' | grep -oE '([A-Z0-9]{2}:){5}..'"), "\n"))
do
	os.execute("cat /tmp/dhcp.leases | grep -i '"..mac.."' | awk '{ print $4\" - \"$3 }' | grep '.*' >> /tmp/mtk/host || echo - >> /tmp/mtk/host")
end

for _,mac2 in ipairs(string.split(mtkwifis.read_pipe("dmesg | grep -B 21 '100%' | grep -oE '([A-Z0-9]{2}:){5}..'"), "\n"))
do
	os.execute("cat /tmp/dhcp.leases | grep -i '"..mac2.."' | awk '{ print $4\" - \"$3 }' | grep '.*' >> /tmp/mtk/host2 || echo - >> /tmp/mtk/host2")
end

Host = mtkwifis.read_pipe("cat /tmp/mtk/host 2>/dev/null") or "?"
Host2 = mtkwifis.read_pipe("cat /tmp/mtk/host2 2>/dev/null") or "?"
os.execute("rm -rf /tmp/mtk/host")
os.execute("rm -rf /tmp/mtk/host2")

return mtkwifis
