#!/bin/bash

# Start at 1.2GB:
PARTITION3_START=2359296
# End at default (= maximum):
PARTITION3_END=

fdisk /dev/mmcblk0 << EOF
p
n
p
3
${PARTITION3_START}
${PARTITION3_END}
p
w
EOF
