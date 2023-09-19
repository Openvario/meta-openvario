#!/bin/bash

#
# This script limits CPU frequency.
# Together with the changes to sun7i-a20.dtsi it prevents voltage changes in
# available frequency range. Beware: it must be a supported frequency
#

CPU_FIX_FREQ=864000

echo $CPU_FIX_FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $CPU_FIX_FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
