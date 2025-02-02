card=/sys/devices/pci0000:00/0000:00:03.1/0000:0a:00.0
hwmon="$card/hwmon/$(ls $card/hwmon | head -n 1)"

if [ "$1" == optimal ];
then
    echo 59500000 > "${hwmon}/power1_cap"
elif [ "$1" == performance ];
then
    echo 110500000 > "${hwmon}/power1_cap"
else
    echo 8500000 > "${hwmon}/power1_cap"
fi
