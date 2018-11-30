#! /bin/bash
# 
#
# PowerMgt: A command-line utilty that controls adn moniters cpu governors and disk schedulers written in bash 4.4+_
# https://github.com/Rybo173/PowerMgt
#
# The MIT License (MIT)
#
# Copyright (c) 2018 Ryan WOng
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Checks for root access
if [[ $EUID -ne 0 ]]; then
   echo "[ERROR] This script must be run as root" 
   exit 1
fi

# Clears console
clear


RED='\033[0;31m'
LGREEN='\033[1;32m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

bold=$(tput bold)
normal=$(tput sgr0)

# Sets the console to 50x75
printf '\033[8;50;75t'

version="1.0"

# Title
printf "${RED}${bold}NOTE: Only works with NVME SSDs right now\n${NC}${normal}"
printf "${YELLOW}"
echo ""
echo "                 ____                          __  ___      __  "
echo "                / __ \____ _      _____  _____/  |/  /_____/ /_ "
echo "               / /_/ / __ \ | /| / / _ \/ ___/ /|_/ / __  / __/ "
echo "              / ____/ /_/ / |/ |/ /  __/ /  / /  / / /_/ / /_   "
echo "             /_/    \____/|__/|__/\___/_/  /_/  /_/\__, /\__/   "
echo "                                                  /____/        "     
echo "					           v$version 	      "
echo "                             Ryan Wong 2018"
printf "${YELLOW}"
echo ""
echo ""

# Checking cpu and kernel info and the current and available governors 
printf "${GREEN}${bold}CPU Info: ${NC}${normal}"
lscpu | sed -nr '/Model name/ s/.*:\s*(.*) @ .*/\1/p'
printf "${GREEN}${bold}Kernel Info: ${NC}${normal}"
uname -r
echo ""
cpupower frequency-info --policy
cpupower frequency-info --governors
echo ""
echo ""

# Checking disk info and figuring out which type of disk drive you're using
    if [[ -f "/sys/block/nvme0n1/queue/scheduler" ]]; then
	printf "${GREEN}${bold}Disk Info: ${NC}${normal}"
	udevadm info --query=all --name=/dev/nvme0n1 | grep ID_SERIAL=
	printf "${BLUE}${bold}NVME: ${NC}${normal}"
        cat /sys/block/nvme0n1/queue/scheduler
    fi

    if [[ -f "/sys/block/sda/queue/scheduler" ]]; then
	printf "${GREEN}${bold}Disk Info: ${NC}${normal}"
	udevadm info --query=all --name=/dev/sda | grep ID_SERIAL=
	printf "${BLUE}${bold}SATA: ${NC}${normal}"
        cat /sys/block/sda/queue/scheduler
    fi

    if [[ -f "/sys/block/hda/queue/scheduler" ]]; then
	printf "${GREEN}${bold}Disk Info: ${NC}${normal}"
	udevadm info --query=all --name=/dev/hda | grep ID_SERIAL=
	printf "${BLUE}${bold}HDD: ${NC}${normal}"
        cat /sys/block/hda/queue/scheduler
    fi

echo ""
echo ""

# Options to change cpu governors and disk schedulers
echo "OPTIONS:"
echo ""
echo "CPU Governor:"
echo "1. Performance"
echo "2. Powersave"
echo ""
echo "Disk Scheduler:"
echo "3. None"
echo "4. MQ-Deadline"
echo ""
echo "Script Settings:"
echo "5. exit"
echo ""

read -p "> " input

if [ $input = 1 ]; then
   cpupower frequency-set --governor performance
   echo "Finished setting CPU Governor to performance"
fi

if [ $input = 2 ]; then
   cpupower frequency-set --governor powersave
   echo "Finished setting CPU Governor to powersave"
fi

if [ $input = 3 ]; then
   echo "none" > /sys/block/nvme0n1/queue/scheduler
   echo "Finished setting Disk Scheduler to none"
fi

if [ $input = 4 ]; then
   echo "mq-deadline" > /sys/block/nvme0n1/queue/scheduler
   echo "Finished setting Disk Scheduler to MQ-Deadline"
fi

if [ $input = 5 ] || [ $input = "exit" ]; then
   echo "Goodbye!"
   exit 0
fi

#Combinng 2 options
if [ $input = 24 ] || [ $input = 42 ]; then
   cpupower frequency-set --governor powersave
   echo "mq-deadline" > /sys/block/nvme0n1/queue/scheduler
   echo "Finished setting Disk Scheduler to MQ-Deadline and CPU Governor to powersave"
fi

if [ $input = 23 ] || [ $input = 32 ]; then
   cpupower frequency-set --governor powersave
   echo "none" > /sys/block/nvme0n1/queue/scheduler
   echo "Finished setting Disk Scheduler to none and CPU Governor to powersave"
fi

if [ $input = 14 ] || [ $input = 41 ]; then
   cpupower frequency-set --governor performance
   echo "mq-deadline" > /sys/block/nvme0n1/queue/scheduler
   echo "Finished setting Disk Scheduler to MQ-Deadline and CPU Governor to performance"
fi

if [ $input = 13 ] || [ $input = 31 ]; then
   cpupower frequency-set --governor performance
   echo "none" > /sys/block/nvme0n1/queue/scheduler
   echo "Finished setting Disk Scheduler to none and CPU Governor to performance"
fi

# Not for users to see
if [ $input = "fix" ]; then
   echo ""
   echo "Need to Fix/Do" 
   echo "1. maybe return to script menu after finishing an option"
fi

