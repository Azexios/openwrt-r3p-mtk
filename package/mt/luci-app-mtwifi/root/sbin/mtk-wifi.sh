#!/bin/sh

mkdir -p /tmp/mtk/wifi

for dat in $(ls -1 /etc/wireless/mt7615)
do
	cp -f /etc/wireless/mt7615/$dat /tmp/mtk/wifi/$dat.last
done

sleep 60

#ApCliAuto
#2.4GHz
if grep -q 'ApCliEnable=1' /etc/wireless/mt7615/mt7615.1.dat; then
	if grep -q 'ApCliAuto=1' /etc/wireless/mt7615/mt7615.1.dat; then
		if ip link ls up | grep -q apcli0; then
			logger -t MTK-Wi-Fi "iwpriv apcli0 set ApCliAutoConnect=3"
			iwpriv apcli0 set ApCliAutoConnect=3
		fi
	fi
fi
#5GHz
if grep -q 'ApCliEnable=1' /etc/wireless/mt7615/mt7615.2.dat; then
	if grep -q 'ApCliAuto=1' /etc/wireless/mt7615/mt7615.2.dat; then
		if ip link ls up | grep -q apclii0; then
			logger -t MTK-Wi-Fi "iwpriv apclii0 set ApCliAutoConnect=3"
			iwpriv apclii0 set ApCliAutoConnect=3
		fi
	fi
fi

#Move 2.4GHz and 5GHz Wi-Fi to CPU2 and CPU3
mask=4
for irq in $(grep -E 'ra(.{0,1}0)' /proc/interrupts | cut -d: -f1 | sed 's, *,,')
do
	echo "$mask" > "/proc/irq/$irq/smp_affinity"
	mask=8
done
