1. Клонировать исходный код и перенести всё (за исключением README.md, README_RU.md, screenshots и .git) в каталог openwrt, пример (вместо /home/alex/openwrt указать свой путь до openwrt):

    ```bash
    cd
    git clone https://github.com/Azexios/openwrt-r3p-mtk.git
    rsync -av openwrt-r3p-mtk/ /home/alex/openwrt --exclude '.git' --exclude 'README.md' --exclude 'README_RU.md' --exclude 'screenshots'
    ```

2. Перейти в каталог openwrt, удалить свой .config - запустить make menuconfig, выбрать своё устройство, перейти в раздел - Kernel modules > Wireless Drivers > выбрать драйвер mtk и зайти в настройки драйвера (выбрать нужные параметры или использовать дефолтные настройки), запомнить настройки/сделать скриншоты и аналогично с Network > Wireless > mt_wifi - MT_WIFI Configuration.

3. Скачать конфиг (стандартно для сборки OpenWrt с правильным .vermagiс, для mt7621) на примере 21.02.3:

    ```bash
    wget -O .config https://downloads.openwrt.org/releases/21.02.3/targets/ramips/mt7621/config.buildinfo
    make defconfig
    make menuconfig
    ```

4. Запустить make menuconfig, выбрать своё устройство, в Kernel modules > Wireless Drivers - для Wi-Fi драйвера от OpenWrt должно быть выставлено M, выбрать драйвер от mtk и зайти в настройки драйвера - выставить настройки полученные на 2 пункте.  
В LuCI > Applications - выбрать luci-app-mtwifi.  
В Network > Wireless - выставить настройки в mt_wifi из 2 пункта.  
В Network > WirelessAPD - отключить wpad-basic-wolfssl и для hostapd-common выставить M.  
Открыть profiles.json (для mt7621 - https://downloads.openwrt.org/releases/21.02.3/targets/ramips/mt7621/profiles.json), найти своё устройство и посмотреть какие пакеты (device_packages, кроме Wi-Fi драйверов) нужно дополнительно выбрать/включить.

5. Выйти, сохранив настройки и собрать прошивку:

    ```bash
    make -j$(($(nproc) + 1)) V=s 2>&1 | grep -i -E "^make.*(error|[12345]...Entering dir)"
    ```
