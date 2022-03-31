if [ "$1" == optimal ];
then
    echo optimal
    cpupower frequency-set -g performance
    echo auto > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo 56500000 > /sys/class/drm/card0/device/hwmon/hwmon2/power1_cap
elif [ "$1" == performance ];
then
    echo performance
    cpupower frequency-set -g performance
    echo auto > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo 96500000 > /sys/class/drm/card0/device/hwmon/hwmon2/power1_cap
else
    echo default
    cpupower frequency-set -g schedutil
    echo low > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo 165000000 > /sys/class/drm/card0/device/hwmon/hwmon2/power1_cap
fi
