hwmonPath=/sys/class/hwmon/hwmon4

usagePercent=$(cat /sys/class/drm/card0/device/gpu_busy_percent)

freq=$(cat $hwmonPath/freq1_input)
mhzFreq=$(echo "$freq/1000000" | bc)

temp=$(cat $hwmonPath/temp1_input)
temp=$(echo "$temp/1000" | bc)

echo "$usagePercent% $mhzFreq MHz $temp C"
