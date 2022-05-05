#!/usr/bin/env bash

if ! magick --version | grep -Pq '^(?=.*heic)(?=.*jng)(?=.*png)(?=.*jp2)(?=.*webp)' ; then
       echo "Installing Image/Mini Magik Support"
       # Adding /usr/local/lib to ldconfig
       # 11.26.21 This is commented out. Adding a custom file to /etc/ld.so.conf.d above
       sudo ln -s /usr/local/lib64/lib*.so /lib64
       sudo ln -s /usr/local/lib/lib*.so /lib64
       sudo /sbin/ldconfig /lib64
       sudo /sbin/ldconfig -v
       
       ARCHITECTURE=$(uname -m)
       
       echo $(cmake --version)
       if ! cmake --version | grep -E '3.22.0' ; then
              echo "Installing latest CMAKE"
              curl -L https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0-linux-$ARCHITECTURE.sh --output cmake-3.22.0-linux-$ARCHITECTURE.sh
              sudo mkdir -p /opt/cmake
              sudo sh cmake-3.22.0-linux-$ARCHITECTURE.sh --skip-license --prefix=/opt/cmake
              sudo rm -rf /usr/bin/cmake
              sudo ln -s /opt/cmake/bin/cmake /usr/bin/cmake
              rm -rf cmake-3.22.0-linux-$ARCHITECTURE.sh
              echo $(cmake --version)
       fi
       
       echo $(sudo /sbin/ldconfig -p | grep 'libpng16')
       if ! sudo /sbin/ldconfig -p | grep 'libpng16' &> /dev/null; then
              echo "Installing libpng"
              wget https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz
              tar xvf libpng-1.6.37.tar.gz
              rm -f libpng-1.6.37.tar.gz
              cd libpng-1.6.37/
              sudo ./configure && sudo make && sudo make install
              cd ..
              sudo rm -rf libpng-1.6.37
       fi
       
       echo $(sudo /sbin/ldconfig -p | grep 'libde265')
       if ! sudo /sbin/ldconfig -p | grep 'libde265' &> /dev/null; then
              echo "Installing libde265"
              git clone https://github.com/strukturag/libde265.git
              cd libde265/
              sudo ./autogen.sh && sudo ./configure
              export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
              sudo make && sudo make install
              cd ..
              sudo rm -rf libde265
       fi
       
       echo $(sudo /sbin/ldconfig -p | grep 'libheif')
       if ! sudo /sbin/ldconfig -p | grep 'libheif' &> /dev/null; then
              echo "Installing libheif"
              git clone https://github.com/strukturag/libheif.git
              cd libheif/
              sudo ./autogen.sh && sudo libpng_CFLAGS=-I/usr/local/include/libpng16 libpng_LIBS=-lpng16 ./configure && sudo make && sudo make install
              cd ..
              sudo rm -rf libheif
              LIBHEIF_INSTALL=$(pkg-config libheif --variable builtin_h265_decoder)
              echo "Successful install: $LIBHEIF_INSTALL"
       fi
       
       echo $(sudo /sbin/ldconfig -p | grep 'libwebp')
       # Needs to be rebuilt on AWS AMI
       #if ! sudo /sbin/ldconfig -p | grep 'libwebp' &> /dev/null; then
              echo "Installing webp"
              wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz
              tar xvzf libwebp-1.1.0.tar.gz
              sudo rm -f libwebp-1.1.0.tar.gz
              cd libwebp-1.1.0/
              sudo ./configure && sudo make && sudo make install
              sudo yum -y install libwebp-devel.$ARCHITECTURE
              cd ..
              sudo rm -rf libwebp-1.1.0
       #fi
       
       echo $(sudo /sbin/ldconfig -p | grep 'libopenjp2')
       # Needs to be rebuilt on AWS AMI
       if ! sudo /sbin/ldconfig -p | grep 'libopenjp2' &> /dev/null; then
              wget https://github.com/uclouvain/openjpeg/archive/master.zip
              unzip master.zip
              rm -rf master.zip
              cd openjpeg-master/
              mkdir -p build
              cd build
              cmake .. -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_BUILD_TYPE=Release
              make
              sudo make install
              sudo make clean
              cd ../..
              sudo rm -rf openjpeg-master
       fi
       
       echo $(sudo /sbin/ldconfig -p | grep 'libOpenEXR')
       if ! sudo /sbin/ldconfig -p | grep 'libOpenEXR' &> /dev/null; then
              curl -L https://github.com/AcademySoftwareFoundation/openexr/tarball/master | tar xvz
              cd AcademySoftwareFoundation*
              mkdir -p build
              cd build/
              cmake ..
              sudo make && sudo make install
              #sudo ln -s /usr/local/lib64/libOpenEXR*.so /usr/local/lib/
              sudo ln -s /usr/local/lib64/lib*.so /usr/local/lib
              sudo ln -s /usr/local/lib64/pkgconfig/OpenEXR.pc /usr/local/lib/pkgconfig/OpenEXR.pc
              cd ../..
              rm -rf AcademySoftwareFoundation*
       fi
       
       if ! command -v magick &> /dev/null; then
              echo "magick could not be found"
       else
              MAGICK_VERSION=$(magick --version)
              echo "Current Install: $MAGICK_VERSION"
       fi

       echo "Installing ImageMagick"
       sudo yum -y remove ImageMagick
       sudo yum -y install ImageMagick-devel
       git clone https://github.com/ImageMagick/ImageMagick.git ImageMagick
       cd ImageMagick
       autoreconf -fiv
       automake
       export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig && export LDFLAGS=-L/usr/local/lib:/usr/local/lib64 && export CPPFLAGS=-I/usr/local/include/libheif
       ./configure --with-heic=yes --with-jpeg=yes --with-webp=yes --with-openjp2=yes --with-openexr=yes
       sudo make && sudo make install
       #hash -d magick
       #hash -d animate
       #hash -d compare
       #hash -d composite
       #hash -d conjure
       #hash -d convert
       #hash -d display
       #hash -d identify
       #hash -d import
       #hash -d magick-script
       #hash -d mogrify
       #hash -d montage
       #hash -d stream
       cd ..
       # Build kept failing because sudo could not find magick
       sudo rm -f /bin/magick
       sudo ln -s /usr/local/bin/magick /bin/magick
       sudo rm -rf ImageMagick
       echo "New Install: $(magick --version)"
       echo "Completed ImageMagick Install..."
fi