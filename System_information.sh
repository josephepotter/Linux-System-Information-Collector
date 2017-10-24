#!/bin/sh
#Title: System Information Collector
#Author: Joseph Potter
#Last Edited: 10/23/2017
#Description: Collects information about linux systems such as distro, number of files in directories, system usage, etc.
green=$(tput setaf 2)
red=$(tput setaf 1)
normal=$(tput sgr0)
printf "${green}SYSTEM:\n\n${normal}"
#shows distributor, description, and release
lsb_release -a 2>/dev/null | grep -E "Distributor|Description|Release"
printf "\n"
printf "${green}NETWORK INFORMATION:\n\n${normal}"
ifconfig | grep  -E "encap|Mask"
printf "\n"
printf "${green}FILES IN DIRECTORIES:\n\n${normal}"
#shows the counts of files for the home directory and the root directory
printf "Home: "
ls ~ | wc -l 
printf "Root: "
ls / | wc -l 
printf "\n"
printf "${green}SYSTEM USAGE:\n\n${normal}"
#shows usage of RAM and Hard Drive
free -m | grep Mem | awk '{ printf "TOTAL_MEMORY=" $2 "M\nFREE_MEMORY=" $4 "M\nAVAILABLE_MEMORY=" $7 "M\n\n" }'
df -h --total | grep total |awk '{ printf "TOTAL_DISK_SPACE=" $2 "\nDISK_SPACE_AVAILABLE=" $4 "\nDISC_SPACE_USED=" $3 "\n\n" }'
printf "${green}AVAILABLE SHELLS:\n\n${normal}"
cat /etc/shells | tail -n +2
printf "\n"
printf "${green}CURRENT USERS:\n\n${normal}"
#shows logged in users
users
printf "\n"
printf "${green}SCHEDULED TASKS:\n\n${normal}"
crontab -l
printf "\n"
printf "${green}DEVICES:\n\n${normal}"
row_count=$(lspci | wc -l)
for (( c=1; c<=${row_count}; c++ ))
do
	lspci| sed  "${c}q;d" | cut -c 9-
done
printf "\n"
printf "${green}COMMON PACKAGES:\n\n${normal}"
#checks if packages in the list are installed and tells thier version
packages=("python" "mysql" "ruby" "perl" "bash" "ssh" "telnet")
#packages can be added above to search more packages
for i in "${packages[@]}"
do
	printf "PACKAGE:${i}\t"
    version=$(apt-cache show $i 2>/dev/null|grep -m 1 Version | wc -l )
	if [ $version == 1 ]
	then
		#if the package is installed, show the version
		apt-cache show $i 2>/dev/null|grep -m 1 Version|awk '{ printf "VERSION:" $2 "\n" }'
	else
		printf "${red}NOT INSTALLED\n${normal}"
	fi
done
