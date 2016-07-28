#!/bin/bash

GIT_V=$(git --version)
CMAKE_V=$(cmake --version)



if [ "$GIT_V" == "git version 2.7.4" ]; then
	echo;echo "- - - - - - - - - - git already installed"
else
	echo;echo "+ + + + + + + + + + start install git"
	sudo apt-get install -y git
fi

if [ "$CMAKE_V" == "cmake version 3.5.1

CMake suite maintained and supported by Kitware (kitware.com/cmake)." ]; then
	echo;echo "- - - - - - - - - - cmake already installed"
else
	echo;echo "+ + + + + + + + + + start install cmake"
	sudo apt-get install -y cmake
fi

echo;echo "* * * * * * * * * * start install cmake-extras"
sudo apt-get install -y cmake-extras

if [ -d "extra-cmake-modules" ]; then
	echo;echo "- - - - - - - - - - extra-cmake-modules already installed"
else
	echo;echo "+ + + + + + + + + + start install extra-cmake-modules"
	git clone git://anongit.kde.org/extra-cmake-modules.git
	cd extra-cmake-modules/
	mkdir build
	cd build/
	cmake ..
	make -j8
	sudo make install
	cd ../..
fi

if [ -d "libxslt" ]; then
	echo;echo "- - - - - - - - - - libxslt already installed"
else
	echo;echo "+ + + + + + + + + + start install libxslt"
	git clone git://git.gnome.org/libxslt
	cd libxslt
	make
	sudo make install
	cd ..
fi

sudo apt-get install -y dh-autoreconf

if [ -d "libunwind" ]; then
	echo;echo "- - - - - - - - - - libunwind already installed"
else
	echo;echo "+ + + + + + + + + + start install libunwind"
	git clone https://github.com/pathscale/libunwind.git
	cd libunwind
	./autogen.sh
	./configure
	make
	sudo make install
	cd ..
fi

if [ -d "dolphin" ]; then
	echo;echo "- - - - - - - - - - dolphin already installed"
else
	echo;echo "+ + + + + + + + + + start install dolphin"
	git clone git://anongit.kde.org/dolphin
	cd dolphin
	mkdir build
	cd build
	cmake ..
	cd ..
	sudo make install
	cd ..
fi

if [ -d "boost_1_61_0" ]; then
	echo;echo "- - - - - - - - - - boost_1_61_0 already installed"
else
	echo;echo "+ + + + + + + + + + start install boost_1_61_0"
	
	cd boost_1_61_0
	./configure
	make
	sudo make install
	cd ..
fi

#if [ -d "boost" ]; then
#	echo;echo "- - - - - - - - - - boost already installed"
#else
#	echo;echo "+ + + + + + + + + + start install boost"
#	git clone https://github.com/boostorg/boost.git
#	cd boost
#	./configure
#	make
#	sudo make install
#	cd ..
#fi


#if [ -d "qt5" ]; then	
#	echo;echo "- - - - - - - - - - qt5 already installed"
#else
#	echo;echo "* * * * * * * * * * start install qt5"
#	git clone git://code.qt.io/qt/qt5.git
#	cd qt5
#	perl init-repository --module-subset=default,-qtwebkit,-qtwebkit-examples,-qtwebengine
#	./configure -developer-build -opensource -nomake examples -nomake tests
#	make -j4
#	make install
#	cd ..
#fi
sudo apt-get install -y elfutils
sudo apt-get install -y qt5-default
sudo apt-get install -y libxcb-xinerama0-dev
sudo apt-get install -y qtscript5-dev
sudo apt-get install -y qttools5-dev
sudo apt-get install -y kdoctools5
sudo apt-get install -y libqt5svg5-dev 
sudo apt-get install -y libqt5opengl5-dev 
sudo apt-get install -y libpolkit-qt-1-dev 
sudo apt-get install -y libxslt1-dev 
sudo apt-get install -y libqt5x11extras5-dev 
sudo apt-get install -y qttools5-dev 
sudo apt-get install -y libsparsehash-dev 
sudo apt-get install -y libqt5svg5-dev 
sudo apt-get install -y qtscript5-dev




echo;echo "* * * * * * * * * * start set pkg"
set -e
     
PKG="
kcoreaddons,f8e8360e33b052d2716167399f660bddeb6d2de6
ki18n,7646dc9a9bda3b2f9dd0be1e9f1bf0169fba0710
kitemmodels,8ce7f030ae22927d4f04e5dc5175abce6bd887e8
threadweaver,ddf1c4b7f64c33ad7fbd1b770cf0703c73b6275b
kauth,4878a94b5e44b5dc79dd14efb7c21e28fb09eeea
kcodecs,dbbd4d0c3980d4fbdb989cec25fe39fa280e6298
kconfig,30d5270305a196a452579e2a45068f5c744fee0c
karchive,1816049a3316c9f93e9722d68bf007edcca0ec8c
kdoctools,741507710068cfcd7ceaa2d331bbea92b32dbe61
kguiaddons,8a774f8d9845f852af66771cb9cea897bbe34910
kwidgetsaddons,eaa8db04232e66f1cea7b9efccfad435c6c0fb60
kconfigwidgets,7d98e905c5dc26e1adcc4a62be96dd305e0d06e6
kdiagram,master
"
 
for i in $PKG; do
	PKG_NAME=$(echo;echo "$i" | awk -F"," '{print $1}') 
	if [ -d $PKG_NAME ]; then
		echo;echo "- - - - - - - - - - $PKG_NAME already installed"
	else
		echo;echo "* * * * * * * * * * start install $PKG_NAME"
	    	IFS=","; set $i;
	    	git clone https://github.com/KDE/$1.git
	   	cd $1
	    	git checkout $2
	   	mkdir build && cd build
	    	cmake ..
	    	make -j8
	    	sudo make install
	    	cd ../..
	fi
done

echo;echo "* * * * * * * * * * start install heaptrack"
git clone git://anongit.kde.org/heaptrack
cd heaptrack
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
make install

