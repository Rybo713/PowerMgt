<h1 align="center">PowerManagement</h1>
<p align="center">A command-line utilty that controls and moniters cpu governors and disk schedulers written in bash 4.4+ </p>

<img src="https://i.imgur.com/PeWCHYT.png" alt="PowerMgt" align="left" height="520px">

PowerMgt is a command-line utilty that controls and moniters cpu governors and disk schedulers written in `bash 4.4+`. PowerMgt displays information about your cpu, disk, and kernel and allows you to change the governors and schedulers easily.

The purpose of PowerMgt is to allow users to change their cpu governors and disk schedulers easily. 

## Requirements 

`util-linux`

`kernel-tools` or `linux-tools-generic` 

`acpi`

`ruby`

`facter`

## Installation

1. Git clone the repo.
  
  `git clone https://github.com/Rybo713/PowerMgt`
  
  or 
  
  Download the zip

2. Change working directory to `PowerMgt`
   
   `cd PowerMgt`

3. Give bash script permissions
  
  `chmod -x powermgt.sh`

4. Run the script with root
   
   `sudo ./powermgt.sh`
   
## Supported Distros

- Arch Linux
- Fedora
- CentOS
- Ubuntu
- Kubuntu
- Kali Linux
- Alpine Linux
