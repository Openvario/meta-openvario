#!/bin/busybox sh

echo "Rebooting..."

# Synchronise file systems that might be mounted
cd /
sync

# Work around for reboot
echo 1 > /proc/sys/kernel/sysrq
echo s > /proc/sysrq-trigger
echo u > /proc/sysrq-trigger
echo b > /proc/sysrq-trigger
