#!/bin/bash

#
# This script fixes CPU frequency thus effectively stopping the kernel from changing cpu frequency
# You can change the frequency if you wish. To do so just change the value of CPU_FIX_FREQ to a different
# number. Beware: it must be a supported frequency
#

CPU_FIX_FREQ=720000

echo $CPU_FIX_FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $CPU_FIX_FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $CPU_FIX_FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo $CPU_FIX_FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
