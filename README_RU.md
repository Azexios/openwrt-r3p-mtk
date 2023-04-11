Для сборки прошивки я использую **Ubuntu 22.04 LTS** (на других OS не проверял).  
\**Инструкция только о том как заменить драйвер, Вы должны уметь собирать OpenWrt из исходников.*  

1. Клонировать исходный код и перенести в каталог openwrt (вместо /home/alex/openwrt указать свой путь до openwrt):

    ```bash
    cd
    git clone https://github.com/Azexios/openwrt-r3p-mtk.git
    rsync -av openwrt-r3p-mtk/target/ /home/alex/openwrt/target && rsync -av --delete openwrt-r3p-mtk/package/mt/ /home/alex/openwrt/package/mt
    ```

2. Перейти в каталог openwrt, удалить свой .config - запустить make menuconfig, выбрать своё устройство, перейти в раздел - LuCI > Applications - включить <\*> luci-app-mtwifi, далее в Kernel modules > Wireless Drivers > включить <\*> нужный драйвер/драйвера mtk и зайти в их настройки (выбрать нужные параметры или использовать дефолтные), запомнить настройки/сделать скриншоты и аналогично с Network > Wireless > mt_wifi - MT_WIFI Configuration.

3. Скачать конфиг (для сборки OpenWrt с правильным .vermagiс), ниже пример для OpenWrt 22.03.4 и устройств с CPU mt7621:

    ```bash
    wget -O .config https://downloads.openwrt.org/releases/22.03.4/targets/ramips/mt7621/config.buildinfo
    make defconfig
    ```

4. Запустить make menuconfig, выбрать своё устройство, в Kernel modules > Wireless Drivers - включить <\*> нужный драйвер/драйвера mtk и зайти в их настройки - выставить настройки полученные на 2 пункте.  
В LuCI > Applications - включить <\*> luci-app-mtwifi.  
В Network > Wireless - выставить настройки в mt_wifi из 2 пункта.  
В Network > WirelessAPD - отключить wpad-basic-wolfssl и выбрать как модуль \<M> hostapd-common.  
Не обязательно - открыть profiles.json (для mt7621 и OpenWrt 22.03.4 - https://downloads.openwrt.org/releases/22.03.4/targets/ramips/mt7621/profiles.json), найти своё устройство и посмотреть какие пакеты (device_packages, кроме Wi-Fi драйверов) нужно дополнительно включить в прошивку.

5. Выйти, сохранив настройки и собрать прошивку:

    ```bash
    make -j$(($(nproc) + 1)) download V=s
    make -j$(($(nproc) + 1)) V=s 2>&1 | grep -i -E "^make.*(error|[12345]...Entering dir)"
    ```
---
#### Если нужно обновить:
*Заменить /home/alex/openwrt на свой путь до openwrt*
```bash
cd
cd openwrt-r3p-mtk
git pull
rsync -av target/ /home/alex/openwrt/target && rsync -av --delete package/mt/ /home/alex/openwrt/package/mt
```
