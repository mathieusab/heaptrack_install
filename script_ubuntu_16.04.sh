#!/bin/bash

clear

# required packages to check
required="
cmake
cmake-extras
dh-autoreconf
elfutils
extra-cmake-modules
git
kdelibs5-dev
kdoctools
kio-dev
libboost-all-dev
libboost-date-time1.58.0
libboost-filesystem1.58.0
libboost-iostreams1.58.0
libboost-system1.58.0
libdrm2
libdrm-amdgpu1
libdrm-intel1
libdrm-nouveau2
libdrm-radeon1
libdwarf-dev
libelf-dev
libkf5archive5
libkf5archive-dev
libkf5codecs5
libkf5codecs-dev
libkf5configcore5
libkf5config-dev
libkf5configgui5
libkf5configwidgets-dev
libkf5coreaddons-dev
libkf5guiaddons5
libkf5guiaddons-dev
libkf5i18n-dev
libkf5itemmodels-dev
libkf5kiocore5
libkf5threadweaver-dev
libpolkit-qt-1-dev
libpython2.7
libpython2.7-minimal
libpython2.7-stdlib
libqt5core5a
libqt5dbus5
libqt5gui5
libqt5network5
libqt5opengl5
libqt5opengl5-dev
libqt5printsupport5
libqt5sql5
libqt5svg5-dev
libqt5svg5-dev
libqt5test5
libqt5widgets5
libqt5x11extras5-dev
libqt5xml5
libsparsehash-dev
libunwind-dev
libxcb-xinerama0-dev
libxslt1.1
libxslt1-dev
libxslt1-dev
python2.7
python2.7-minimal
qt-sdk
qt5-default
qtdeclarative4-kqtquickcharts-1
qtscript5-dev
qtscript5-dev
qttools5-dev
qttools5-dev
kdiagram
"
scan () 
{
	echo > not_found
	echo > found
	# get installed packages
	echo -en "\033[36mextracting installed packages...\033[0m"
	dpkg --get-selections > get-sel
	sed -i 's/$/000/' get-sel
	cat get-sel | grep "install000" | awk -F " " '{print $1}' > out_apt_list
	echo -e "\033[36mdone\033[0m"

	for package_searched in $required
	do
		# search packages
		package_is_installed=0
		echo -en "\033[36mlooking for package : $package_searched...\033[0m"


		for line in $(cat out_apt_list)
		do 
			if [ "$line" = "$package_searched" ] 
			then
				package_is_installed=1
			fi
		done
		
		if [ "$package_searched" = "kdiagram" ]
		then
			if [ -d $package_searched ]
			then
				echo -e "\033[42mfound\033[0m"
				echo $package_searched >> found
			else
				echo -e "\033[41mNOT FOUND\033[0m"
				echo $package_searched >> not_found
			fi
		else

			if [ $package_is_installed -eq 1 ] 
			then
				echo -e "\033[42mfound\033[0m"
				echo $package_searched >> found
			else
				echo -e "\033[41mNOT FOUND\033[0m"
				echo $package_searched >> not_found
			fi
		fi
	done

	# summary
	echo "o----------------+------------------------------------o"
	echo -e "| \033[42mFOUND PACKAGES\033[0m |                                    "
	echo "+--------------- +                                    "
	for line in $(cat found)
	do
	echo -e "| $line \t\t                                  "
	done
	echo "o--------------------+--------------------------------o"
	echo -e "| \033[41mNOT FOUND PACKAGES\033[0m |                                    "
	echo "+------------------- +                                    "
	for line in $(cat not_found)
	do
	echo -e "| $line \t\t                                  "
	done
	echo "o-----------------------------------------------------o"
}

install_packages ()
{
	# install missing packages
	for line in $(cat not_found)
	do
		if [ "$line" = "kdiagram" ]
		then
		    	git clone https://github.com/KDE/kdiagram.git
			cd kdiagram
			git checkout master
			mkdir build && cd build
			cmake ..
			make -j8
			sudo make install
			cd ../..
		else
			echo
			echo -e "\033[36mo-----------------------------------------------------o\033[0m"
			echo -e "\033[46mInstall : $line\033[0m"
			echo -e "\033[36mo-----------------------------------------------------o\033[0m"
			sudo apt-get install -y $line
			echo -e "\033[36mo-----------------------------------------------------o\033[0m"
			echo
		fi
	done
}

install_heaptrack ()
{
	git clone git://anongit.kde.org/heaptrack
	cd heaptrack
	mkdir build
	cd build
	cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
	sudo make install
}

# search for packages not installed
scan

# install these packages
install_packages

## New scan to check if all needed packages have been correctly installed
#scan

# if all packages have been found then not_found will be empty
if [ -s $not_found ]
then
	echo -e "\033[36mNo more packages to install, start install heaptrack\033[0m"
	echo -e "\033[36mType \"y\" to start install\033[0m"
	read q
	if [ "$q" = "y" ]
	then	
		echo -e "\033[36mStart install heaptrack\033[0m"
		install_heaptrack
	else
		echo -e "\033[36mQuit\033[0m"
	fi
fi
