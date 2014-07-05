#!/bin/sh

(cd cmake_ndk_build
	for d in */ ; do
		(cd "$d"
			make -j2
		)
	done
)


#cp -f ../AndroidCMake/Android.mk dist
mkdir -p dist/scripts
mkdir -p dist/scripts/socket
cp -f ../src/ltn12.lua dist/scripts
cp -f ../src/mime.lua dist/scripts
cp -f ../src/socket.lua dist/scripts
cp -f ../src/ftp.lua dist/scripts/socket
cp -f ../src/http.lua dist/scripts/socket
cp -f ../src/smtp.lua dist/scripts/socket
cp -f ../src/tp.lua dist/scripts/socket
cp -f ../src/url.lua dist/scripts/socket

mkdir -p dist/include
cp -f ../src/luasocket.h dist/include
cp -f ../src/mime.h dist/include
cp -f ../src/unix.h dist/include

