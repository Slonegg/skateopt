#!/bin/sh

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
	# build debug
	mkdir -p .build/v120_x64d
	cd .build/v120_x64d
	conan install ../../ -s arch="x86_64" -s build_type="Debug" -s compiler="Visual Studio" -s compiler.runtime="MDd" -s compiler.version="12" -s os="Windows"
	cmake ../../ -G "Visual Studio 12 2013 Win64" -T v120 -DCMAKE_CONFIGURATION_TYPES=Debug
	cmake --build . --config "Debug" -- /maxcpucount
	cd ../..

	# build release
	mkdir -p .build/v120_x64
	cd .build/v120_x64
	conan install ../../ -s arch="x86_64" -s build_type="Release" -s compiler="Visual Studio" -s compiler.runtime="MD" -s compiler.version="12" -s os="Windows"
	cmake ../../ -G "Visual Studio 12 2013 Win64" -T v120 -DCMAKE_CONFIGURATION_TYPES=Release -DCMAKE_CXX_FLAGS_RELEASE="/MD /Zi /O2 /D NDEBUG" -DCMAKE_C_FLAGS_RELEASE="/MD /Zi /O2 /D NDEBUG" -DCMAKE_EXE_LINKER_FLAGS_RELEASE="/DEBUG /INCREMENTAL:NO" -DCMAKE_SHARED_LINKER_FLAGS_RELEASE="/DEBUG /INCREMENTAL:NO"
	cmake --build . --config "Release" -- /maxcpucount
	cd ../..  
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	# build debug
	mkdir -p .build/gcc_x64d
	cd .build/gcc_x64d
	conan install ../../ --build=missing -s arch="x86_64" -s build_type="Debug" -s compiler="gcc" -s compiler.libcxx=libstdc++11
	cmake ../../ -DCMAKE_BUILD_TYPE=Debug
	cmake --build .
	cd ../..

	# build release
	mkdir -p .build/gcc_x64
	cd .build/gcc_x64
	conan install ../../ --build=missing -s arch="x86_64" -s build_type="Release" -s compiler="gcc" -s compiler.libcxx=libstdc++11
	cmake ../../ -DCMAKE_BUILD_TYPE=Release
	cmake --build .
	cd ../..
else
	echo "Unknown platform"
	exit 1
fi

