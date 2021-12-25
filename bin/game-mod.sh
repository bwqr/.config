if [ "$1" == optimal ];
then
    cpupower frequency-set -g performance
    echo auto > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo 46500000 > /sys/class/drm/card0/device/hwmon/hwmon2/power1_cap
elif [ "$1" == performance ];
then
    cpupower frequency-set -g performance
    echo auto > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo 96500000 > /sys/class/drm/card0/device/hwmon/hwmon2/power1_cap
else
    cpupower frequency-set -g schedutil
    echo low > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo 165000000 > /sys/class/drm/card0/device/hwmon/hwmon2/power1_cap
fi
