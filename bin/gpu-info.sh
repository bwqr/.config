#!/bin/bash
cardPath=$1

if [[ -z $cardPath ]]; then
    echo "Invalid number of argument. Usage is ./gpu-info.sh <cardPath>"
    exit -1
fi

hwmonPath="$cardPath/hwmon/$(ls $cardPath/hwmon | head -n 1)"

usagePercent=$(cat $cardPath/gpu_busy_percent)

freq=$(echo "$(cat $hwmonPath/freq1_input)/1000000" | bc)
temp=$(echo "$(cat $hwmonPath/temp1_input)/1000" | bc)
power=$(echo "$(cat $hwmonPath/power1_input)/1000000" | bc)
limit=$(echo "$(cat $hwmonPath/power1_cap)/1000000" | bc)

text="$temp"
tooltip="Usage $usagePercent% Freq $freq MHz Power $power/$limit W Temp $temp°C"
percentage=$(echo "$temp*100.0/70" | bc)
class="normal"
if [[ $percentage -gt 100 ]]; then
    class="critical"
fi

echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"$class\", \"percentage\": $percentage }"
