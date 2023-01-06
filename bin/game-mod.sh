card=/sys/class/drm/card0/device
hwmon="${card}/hwmon/hwmon4"

if [ "$1" == optimal ];
then
    cpupower frequency-set -g performance
    echo manual > "${card}/power_dpm_force_performance_level"
    echo '0 1' > "${card}/pp_dpm_sclk"
    echo '0 1 2' > "${card}/pp_dpm_mclk"
    echo '0 1' > "${card}/pp_dpm_pcie"
    echo 56500000 > "${hwmon}/power1_cap"
elif [ "$1" == performance ];
then
    cpupower frequency-set -g performance
    echo manual > "${card}/power_dpm_force_performance_level"
    echo '0 1 2 3' > "${card}/pp_dpm_sclk"
    echo '0 1 2' > "${card}/pp_dpm_mclk"
    echo '0 1' > "${card}/pp_dpm_pcie"
    echo 100500000 > "${hwmon}/power1_cap"
else
    cpupower frequency-set -g performance
    echo low > "${card}/power_dpm_force_performance_level"
    echo `cat ${hwmon}/power1_cap_default` > "${hwmon}/power1_cap"
fi
