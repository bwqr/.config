hwmonPath=/sys/class/hwmon/hwmon2

freq=$(cat $hwmonPath/freq1_input)
mhzFreq=$(echo "$freq/1000000" | bc)

temp=$(cat $hwmonPath/temp1_input)
temp=$(echo "$temp/1000" | bc)

fan=$(cat $hwmonPath/pwm1)

echo "$mhzFreq MHz $temp C $fan RPM"
