#!/usr/bin/env lua

--[[
  Associated Stations MTK Wi-Fi

  Supported driver versions:
  5.1.0.0 - MT7615
  4.1.2.0 - MT7603
  3.0.5.0 - MT7612

  https://github.com/Azexios/openwrt-r3p-mtk
]]

local mtkwifis = {}

function mtkwifis.read_pipe(pipe)
	local fp = io.popen(pipe)
	local txt =  fp:read("*a")
	fp:close()
	return txt
end

function mtkwifis.exists(path)
	local fp = io.open(path, "rb")
	if fp then fp:close() end
	return fp ~= nil
end

os.execute("dmesg -c > /dev/null && iwpriv ra0 show stainfo 2>/dev/null; iwpriv rai0 show stainfo 2>/dev/null")

if not mtkwifis.exists("/etc/wireless/mt7603/") then -- MT7615
	MAC = mtkwifis.read_pipe("dmesg | grep -oE '([A-Z0-9]{2}:){5}..' 2>/dev/null") or "?"
	RSSI = mtkwifis.read_pipe("dmesg | grep -oE '[^] I]([-0-9 ]{1,}\\/){3}[-0-9]{1,}' 2>/dev/null") or "?"
	BW = mtkwifis.read_pipe("dmesg | grep -oE '([0-9]{2,3}M)\\/[0-9]{2,3}M' 2>/dev/null" ) or "?"
	MCS = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}M)\\/[0-9]{2,3}M/{n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?" -- BW>MCS
	SGI = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}M)\\/[0-9]{2,3}M/{n;n;p;}' | awk '{print $NF}' | sed 's/0/Long/g;s/1/Short/g' 2>/dev/null" ) or "?" -- BW>SGI
	Rate = mtkwifis.read_pipe("dmesg | awk '/0%/ {print a}{a=$NF \" Mbit/s\"}' 2>/dev/null" ) or "?"

	for _,mac in ipairs(string.split(mtkwifis.read_pipe("dmesg | grep -oE '([A-Z0-9]{2}:){5}..'"), "\n"))
	do
		os.execute("cat /tmp/dhcp.leases | grep -i '"..mac.."' | awk '{print $3\" \"$4}' | grep '.*' >> /tmp/mtk/host || echo - - >> /tmp/mtk/host")
	end

	Host = mtkwifis.read_pipe("awk '{print $2}' /tmp/mtk/host 2>/dev/null") or "?"
	IP = mtkwifis.read_pipe("awk '{print $1}' /tmp/mtk/host 2>/dev/null") or "?"
	os.execute("rm -rf /tmp/mtk/host")
elseif mtkwifis.exists("/etc/wireless/mt7603/") and mtkwifis.exists("/etc/wireless/mt7612/") then -- MT7603+MT7612
	MAC = mtkwifis.read_pipe("dmesg | grep -oE '([A-Z0-9]{2}:){5}..' 2>/dev/null") or "?"
	RSSI = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | sed '1!G;h;$!d' | sed -nE '/[0-9]{2,3}M/{n;n;p;}' | sed 's/    /\\//g' | awk '{print $NF}' | cut -d '/' -f1-2 | sed '1!G;h;$!d' 2>/dev/null") or "?" -- BW>RSSI
	BW = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | grep -oE '[0-9]{2,3}M' 2>/dev/null" ) or "?"
	MCS = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | sed -nE '/[0-9]{2,3}M/{n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?" -- BW>MCS
	SGI = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | sed -nE '/[0-9]{2,3}M/{n;n;p;}' | awk '{print $NF}' | sed 's/0/Long/g;s/1/Short/g' 2>/dev/null" ) or "?" -- BW>SGI
	Rate = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | sed -nE '/[0-9]{2,3}M/{n;n;n;n;n;p;}' | awk '{print $NF \" Mbit/s\"}' 2>/dev/null" ) or "?"

	for _,mac in ipairs(string.split(mtkwifis.read_pipe("dmesg | grep -oE '([A-Z0-9]{2}:){5}..'"), "\n"))
	do
		os.execute("cat /tmp/dhcp.leases | grep -i '"..mac.."' | awk '{print $3\" \"$4}' | grep '.*' >> /tmp/mtk/host || echo - - >> /tmp/mtk/host")
	end

	Host = mtkwifis.read_pipe("awk '{print $2}' /tmp/mtk/host 2>/dev/null") or "?"
	IP = mtkwifis.read_pipe("awk '{print $1}' /tmp/mtk/host 2>/dev/null") or "?"
	os.execute("rm -rf /tmp/mtk/host")
else -- MT7603+MT7615
	MAC = mtkwifis.read_pipe("dmesg | grep -B 23 ' 0%' | grep -oE '([A-Z0-9]{2}:){5}..' 2>/dev/null") or "?"
	MAC2 = mtkwifis.read_pipe("dmesg | grep -B 21 '100%' | grep -oE '([A-Z0-9]{2}:){5}..' 2>/dev/null") or "?"
	RSSI = mtkwifis.read_pipe("dmesg | grep -oE '[^] I]([-0-9 ]{1,}\\/){3}[-0-9]{1,}' 2>/dev/null") or "?"
	RSSI2 = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | grep -oE '[^] ]([-0-9 ]{1,}\\/)[-0-9 ]{1,}' 2>/dev/null") or "?"
	BW = mtkwifis.read_pipe("dmesg | grep -oE '([0-9]{2,3}M)\\/[0-9]{2,3}M' 2>/dev/null" ) or "?"
	BW2 = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | grep -oE '[0-9]{2,3}M' 2>/dev/null" ) or "?"
	MCS = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}M)\\/[0-9]{2,3}M/{n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?" -- BW>MCS
	MCS2 = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | sed -nE '/[0-9]{2,3}M/{n;p;}' | awk '{print $NF}' 2>/dev/null" ) or "?" -- BW2>MCS2
	SGI = mtkwifis.read_pipe("dmesg | sed -nE '/([0-9]{2,3}M)\\/[0-9]{2,3}M/{n;n;p;}' | awk '{print $NF}' | sed 's/0/Long/g;s/1/Short/g' 2>/dev/null" ) or "?" -- BW>SGI
	SGI2 = mtkwifis.read_pipe("dmesg | grep -B 14 '100%' | sed -nE '/[0-9]{2,3}M/{n;n;p;}' | awk '{print $NF}' | sed 's/0/Long/g;s/1/Short/g' 2>/dev/null" ) or "?" -- BW2>SGI2
	Rate = mtkwifis.read_pipe("dmesg | awk '/ 0%/ {print a}{a=$NF \" Mbit/s\"}' 2>/dev/null" ) or "?"
	Rate2 = mtkwifis.read_pipe("dmesg | awk '/100%/ {print a}{a=$NF \" Mbit/s\"}' 2>/dev/null" ) or "?"

	for _,mac in ipairs(string.split(mtkwifis.read_pipe("dmesg | grep -B 23 ' 0%' | grep -oE '([A-Z0-9]{2}:){5}..'"), "\n"))
	do
		os.execute("cat /tmp/dhcp.leases | grep -i '"..mac.."' | awk '{print $3\" \"$4}' | grep '.*' >> /tmp/mtk/host || echo - - >> /tmp/mtk/host")
	end

	for _,mac2 in ipairs(string.split(mtkwifis.read_pipe("dmesg | grep -B 21 '100%' | grep -oE '([A-Z0-9]{2}:){5}..'"), "\n"))
	do
		os.execute("cat /tmp/dhcp.leases | grep -i '"..mac2.."' | awk '{print $3\" \"$4}' | grep '.*' >> /tmp/mtk/host2 || echo - - >> /tmp/mtk/host2")
	end

	Host = mtkwifis.read_pipe("awk '{print $2}' /tmp/mtk/host 2>/dev/null") or "?"
	Host2 = mtkwifis.read_pipe("awk '{print $2}' /tmp/mtk/host2 2>/dev/null") or "?"
	IP = mtkwifis.read_pipe("awk '{print $1}' /tmp/mtk/host 2>/dev/null") or "?"
	IP2 = mtkwifis.read_pipe("awk '{print $1}' /tmp/mtk/host2 2>/dev/null") or "?"
	os.execute("rm -rf /tmp/mtk/host /tmp/mtk/host2")
end

return mtkwifis
