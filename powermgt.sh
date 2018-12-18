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

# Clears console
clear

# Finds out distro os
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OSID=$ID
    OS=$NAME
    VER=$VERSION_ID
 elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
 elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OSID=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
 elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
 elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
 elif [ -f /etc/centos-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
 else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

package9=ncurses

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
LYELLOW='\033[1;33m'

if [ $OSID = "alpine" ]; then
    printf "${GREEN}[INFO] ${NC}Checking system if ncurses is installed for Alpine Linux\n"
  if apk info $package9 > /dev/null ; then
    printf "${GREEN}[INFO] ${NC}The package $package9 is installed\n"
  else
    printf "${RED}[ERROR] ${NC}The package $package9 is not installed\n"
  fi
fi

bold=$(tput bold)
normal=$(tput sgr0)

# Checks for root access
if [[ $EUID -ne 0 ]]; then
  printf "${RED}${bold}[ERROR] ${NC}${normal}This script must be run as root\n"
  exit 1
elif [[ $EUID -ne 1 ]]; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}This script is running as root\n"
fi

# PAckages that needs to be installed
package=util-linux
package2=kernel-tools
package3=linux-tools-generic
package4=linux-tools
package5=linux-cpupower
package6=linux-tools-common
package7=ruby
package8=facter
package9=acpi

printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking system if it meets the requirements\n"

# Checks if the user has installed util-linux
if [ $OSID = "arch" ]; then
  if pacman -Qs $package > /dev/null ; then
   printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
  fi

elif [ $OSID = "alpine" ]; then
    if apk info $package > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
    else
       printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
    fi

elif [ $OSID = "ubuntu" ]; then
  if dpkg-query -W $package > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
  fi

elif [ $OSID == "kali" ]; then
  if dpkg-query -W $package > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
  fi

elif [ $OSID = "LinuxMint" ]; then
  if dpkg-query -W $package > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
  fi

# Kubuntu
elif [ $OSID = "Ubuntu" ]; then
  if dpkg-query -W $package > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
  fi

elif [ $OSID = "centos" ]; then
  if yum list installed "$package-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
  fi

elif [ $OSID = "fedora" ]; then
  if yum list installed "$package-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package is not installed\n"
  fi

  else
     clear
     printf "${RED}${bold}[ERROR] ${NC}${normal}Your OS is not supported at this time\n"
     exit 0
fi

# Checks if the user has installed kernel-tools
if [ $OSID = "arch" ]; then
  if pacman -Qs $package4 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package4 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package4 is not installed\n"
     exit 0
  fi

elif [ $OSID = "alpine" ]; then
    if apk info $package4 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package4 is installed\n"
    else
       printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package4 is not installed\n"
       exit 0
    fi

elif [ $OSID = "ubuntu" ]; then
  if dpkg-query -W $package3 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package3 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package3 is not installed\n"
     exit 0
  fi

elif [ $OSID = "kali" ]; then
  if dpkg-query -W $package5 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package5 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package5 is not installed\n"
     exit 0
  fi

elif [ $OSID = "LinuxMint" ]; then
  if dpkg-query -W $package6 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package6 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package6 is not installed\n"
     exit 0
  fi

# Kubuntu
elif [ $OSID = "Ubuntu" ]; then
  if dpkg-query -W $package3 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package3 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package3 is not installed\n"
     exit 0
  fi

elif [ $OSID = "centos" ]; then
  if yum list installed "$package2-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package2 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package2 is not installed\n"
     exit 0
  fi

elif [ $OSID = "fedora" ]; then
  if yum list installed "$package2-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package2 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package2 is not installed\n"
     exit 0
  fi
fi

# Checks if the user has installed acpi
if [ $OSID = "arch" ]; then
  if pacman -Qs $package9 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
     exit 0
  fi

elif [ $OSID = "alpine" ]; then
    if apk info $package9 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
    else
       printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
       exit 0
    fi

elif [ $OSID = "ubuntu" ]; then
  if dpkg-query -W $package9 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
     exit 0
  fi

elif [ $OSID = "kali" ]; then
  if dpkg-query -W $package9 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
     exit 0
  fi

elif [ $OSID = "LinuxMint" ]; then
  if dpkg-query -W $package9 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
     exit 0
  fi

# Kubuntu
elif [ $OSID = "Ubuntu" ]; then
  if dpkg-query -W $package9 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
     exit 0
  fi

elif [ $OSID = "centos" ]; then
  if yum list installed "$package9-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
     exit 0
  fi

elif [ $OSID = "fedora" ]; then
  if yum list installed "$package9-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package9 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package9 is not installed\n"
     exit 0
  fi
fi

# Checks if the user installed ruby
if [ $OSID = "arch" ]; then
  if pacman -Qs $package7 > /dev/null ; then
   printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
  fi

elif [ $OSID = "alpine" ]; then
    if apk info $package7 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
    else
       printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
    fi

elif [ $OSID = "ubuntu" ]; then
  if dpkg-query -W $package7 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
  fi

elif [ $OSID == "kali" ]; then
  if dpkg-query -W $package7 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
  fi

elif [ $OSID = "LinuxMint" ]; then
  if dpkg-query -W $package7 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
  fi

# Kubuntu
elif [ $OSID = "Ubuntu" ]; then
  if dpkg-query -W $package7 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
  fi

elif [ $OSID = "centos" ]; then
  if yum list installed "$package7-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
  fi

elif [ $OSID = "fedora" ]; then
  if yum list installed "$package7-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package7 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package7 is not installed\n"
  fi

  else
     clear
     printf "${RED}${bold}[ERROR] ${NC}${normal}Your OS is not supported at this time\n"
     exit 0
fi

# Checks if the user has installed facter
if [ $OSID = "arch" ]; then
  if pacman -Qs $package8 > /dev/null ; then
   printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
     exit 0
  fi

elif [ $OSID = "alpine" ]; then
    if apk info $package8 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
    else
       printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
       exit 0
    fi

elif [ $OSID = "ubuntu" ]; then
  if dpkg-query -W $package8 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
     exit 0
  fi

elif [ $OSID == "kali" ]; then
  if dpkg-query -W $package8 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
     exit 0
  fi

elif [ $OSID = "LinuxMint" ]; then
  if dpkg-query -W $package8 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
     exit 0
  fi

# Kubuntu
elif [ $OSID = "Ubuntu" ]; then
  if dpkg-query -W $package8 > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
     exit 0
  fi

elif [ $OSID = "centos" ]; then
  if yum list installed "$package8-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
     exit 0
  fi

elif [ $OSID = "fedora" ]; then
  if yum list installed "$package8-*" > /dev/null ; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}The package $package8 is installed\n"
  else
     printf "${RED}${bold}[ERROR] ${NC}${normal}The package $package8 is not installed\n"
     exit 0
  fi

  else
     clear
     printf "${RED}${bold}[ERROR] ${NC}${normal}Your OS is not supported at this time\n"
     exit 0
fi

VM=$(facter virtual)

# Checks if user is using virtual machine
if [ $VM = "kvm" ]; then
  printf "${LYELLOW}${bold}[WARN] ${NC}${normal}Running a virtual machine\n"
  printf "${LYELLOW}${bold}[WARN] ${NC}${normal}Some features might not work\n"
elif [ $VM = "physical" ]; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}Running a physical machine\n"
fi

# Loop back to menu
while true; do

# Sets the console to 50x75
printf '\033[8;50;75t'

version="1.3.2rc"

# Title
printf "${YELLOW}${bold}"
echo ""
echo "                 ____                          __  ___      __  "
echo "                / __ \____ _      _____  _____/  |/  /_____/ /_ "
echo "               / /_/ / __ \ | /| / / _ \/ ___/ /|_/ / __  / __/ "
echo "              / ____/ /_/ / |/ |/ /  __/ /  / /  / / /_/ / /_   "
echo "             /_/    \____/|__/|__/\___/_/  /_/  /_/\__, /\__/   "
echo "                                                  /____/        "
echo "					        v$version 	      "
echo "                             Ryan Wong 2018"
echo ""
echo ""

# Checking cpu, kernel, and distro info
printf "${CYAN}${bold}CPU Info: ${NC}${normal}"
if [ $OSID = "fedora" ] || [ $OSID = "centos" ] || [ $OSID = "arch" ]; then
  lscpu | sed -nr '/Model name/ s/.*:\s*(.*) @ .*/\1/p'
elif [ $OSID = "ubuntu" ] || [ $OSID = "Ubuntu" ] || [ $OSID = "LinuxMint" ] || [ $OSID = "alpine" ] || [ $OSID = "kali" ]; then
  lscpu | sed -nr '/Model name/ p'
else
  printf "${RED}${bold}[ERROR] Cannot find CPU information${NC}${normal}\n"
fi

printf "${CYAN}${bold}Kernel Info: ${NC}${normal}"
uname -r
printf "${CYAN}${bold}Distro Info: ${NC}${normal}"
echo "$OS $VER"
echo ""
printf "${CYAN}${bold}Battery Info: ${NC}${normal}"
acpi
echo ""
echo ""

# Checking available cpu governors and current cpu governors
printf "${CYAN}${bold}Available CPU Governors: ${NC}${normal}"
if [ $OSID = "fedora" ] || [ $OSID = "centos" ] || [ $OSID = "arch" ] || [ $OSID = "ubuntu" ] || [ $OSID = "Ubuntu" ] || [ $OSID = "LinuxMint" ] || [ $OSID = "alpine" ]; then
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
elif [ $OSID = "arch" ] || [ $OSID = "ubuntu" ] || [ $OSID = "Ubuntu" ] || [ $OSID = "LinuxMint" ] || [ $OSID = "alpine" ] || [ $OSID = "kali" ]; then
  cpupower frequency-info --policy
else
  printf "${RED}${bold}[ERROR] Cannot find available CPU governors${NC}${normal}\n"
fi

printf "${CYAN}${bold}Current CPU Governor: ${NC}${normal}"
if [ $OSID = "fedora" ] || [ $OSID = "centos" ] || [ $OSID = "arch" ] || [ $OSID = "ubuntu" ] || [ $OSID = "Ubuntu" ] || [ $OSID = "LinuxMint" ] || [ $OSID = "alpine" ]; then
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
elif [ $OSID = "arch" ] || [ $OSID = "ubuntu" ] || [ $OSID = "Ubuntu" ] || [ $OSID = "LinuxMint" ] || [ $OSID = "alpine" ] || [ $OSID = "kali" ]; then
  cpupower frequency-info --governor
else
  printf "${RED}${bold}[ERROR] Cannot find current CPU governor${NC}${normal}\n"
fi
echo ""
echo ""

# Checking disk info and figuring out which type of disk drive you're using
if [[ -f "/sys/block/nvme0n1/queue/scheduler" ]]; then
	      printf "${CYAN}${bold}Disk Info: ${NC}${normal}"
	      cat /sys/class/block/nvme0n1/device/model
	      printf "${BLUE}${bold}NVME: ${NC}${normal}"
        cat /sys/block/nvme0n1/queue/scheduler

  elif [[ -f "/sys/block/sda/queue/scheduler" ]]; then
        echo ""
	      printf "${CYAN}${bold}Disk Info: ${NC}${normal}"
	      cat /sys/class/block/sda/device/model
	      printf "${BLUE}${bold}SATA: ${NC}${normal}"
        cat /sys/block/sda/queue/scheduler

  elif [[ -f "/sys/block/hda/queue/scheduler" ]]; then
        echo ""
	      printf "${CYAN}${bold}Disk Info: ${NC}${normal}"
	      cat /sys/class/block/hda/device/model
	      printf "${BLUE}${bold}HDD: ${NC}${normal}"
        cat /sys/block/hda/queue/scheduler

  elif [[ -f "/sys/block/vda/queue/scheduler" ]]; then
        echo ""
        printf "${CYAN}${bold}Disk Info: ${NC}${normal}"
        cat /sys/class/block/vda/device/model
        printf "${BLUE}${bold}HDD: ${NC}${normal}"
        cat /sys/block/vda/queue/scheduler
    else
      printf "${RED}${bold}[ERROR] ${NC}${normal}Cannot find disk information\n"
fi

echo ""
echo ""

# Options to change cpu governors and disk schedulers
printf "${bold}OPTIONS:${normal}"
echo ""
echo "CPU Governors:"
echo "1. Performance"
echo "2. Powersave"
echo ""
echo "Disk Schedulers:"
echo "3. None"
echo "4. MQ-Deadline"
echo "5. Kyber"
echo "6. BFQ"
echo ""
echo "Script Settings:"
echo "r. refresh"
echo "a. about"
echo "q. exit"
echo ""

read -p "> " input

if [ $input = 1 ]; then
  if [ $VM = "physical" ]; then
    cpupower frequency-set --governor performance
    clear
    printf "${GREEN}${bold}[INFO] ${NC}${normal}Finished setting CPU Governor to performance"
  elif [ $VM = "kvm" ]; then
    clear
    printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set CPU Governor to performance"
  fi
fi

if [ $input = 2 ]; then
  if [ $VM = "physical" ]; then
   cpupower frequency-set --governor powersave
   clear
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Finished setting CPU Governor to powersave"
 elif [ $VM = "kvm" ]; then
   clear
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set CPU Governor to powersave"
 fi
fi

if [ $input = 3 ]; then
  if [ $VM = "physical" ]; then
   echo "none" > /sys/block/nvme0n1/queue/scheduler
   clear
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Finished setting Disk Scheduler to none"
 elif [ $VM = "kvm" ]; then
   clear
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to none"
 else
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to none"
 fi
fi

if [ $input = 4 ]; then
  if [ $VM = "physical" ]; then
   echo "mq-deadline" > /sys/block/nvme0n1/queue/scheduler
   clear
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Finished setting Disk Scheduler to MQ-Deadline"
 elif [ $VM = "kvm" ]; then
   clear
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to MQ-Deadline"
 else
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to MQ-Deadline"
 fi
fi

if [ $input = 5 ]; then
  if [ $VM = "physical" ]; then
   echo "kyber" > /sys/block/nvme0n1/queue/scheduler
   clear
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Finished setting Disk Scheduler to Kyber"
 elif [ $VM = "kvm" ]; then
   clear
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to Kyber"
 else
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to Kyber"
 fi
fi

if [ $input = 6 ]; then
  if [ $VM = "physical" ]; then
   echo "bfq" > /sys/block/nvme0n1/queue/scheduler
   clear
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Finished setting Disk Scheduler to BFQ"
 elif [ $VM = "kvm" ]; then
   clear
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to BFQ"
 else
   printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to set Disk Scheduler to BFQ"
 fi
fi

if [ $input = "q" ] || [ $input = "exit" ]; then
   echo "Goodbye!"
   exit 0
fi

if [ $input = "r" ] || [ $input = "refresh" ]; then
   clear
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Refreshed info"
fi

 if [ $input = "a" ] || [ $input = "about" ]; then
   clear
   printf "${GREEN}${bold}[INFO] ${NC}${normal}PowerMgt v$version by Ryan Wong"
 fi

done
