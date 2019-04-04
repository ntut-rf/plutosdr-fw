#!/bin/bash
PART_START=$(parted $1 -ms unit s p | grep "^2" | cut -f 2 -d: | sed 's/[^0-9]//g')
echo ${PART_START}
fdisk -u $1 <<EOF
p
d
2
n
p
2
${PART_START}

p
w
EOF