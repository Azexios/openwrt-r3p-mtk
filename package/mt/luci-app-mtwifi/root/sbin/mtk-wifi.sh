#!/bin/sh

mkdir -p /tmp/mtk/wifi

for dat in $(ls -1 /etc/wireless/mt7615)
do
	cp -f /etc/wireless/mt7615/$dat /tmp/mtk/wifi/$dat.last
done

sleep 60

# For MT7621
# Move 2.4GHz and 5GHz MTK-Wi-Fi to CPU1 and CPU2

mask=2
for irq in $(grep -E 'ra(.{0,1}0)' /proc/interrupts | cut -d: -f1 | sed 's, *,,')
do
	echo "$mask" > "/proc/irq/$irq/smp_affinity"
	mask=4
done
