#!/usr/bin/env bash

#build openalpr
function build_openalpr() {

    #enter src folder
    src_dir='./src'
    echo "Entering sorce folder: ${src_dir}"
    cd ${src_dir}
	
    #Save current directory
    current_dir="${PWD}"

    #The folder in which we will build openalpr
    build_dir='./build'
    if [ -d $build_dir ]; then
        echo "Deleted folder: ${build_dir}"
        rm -rf $build_dir
    fi

    #Create building folder
    echo "Created building folder: ${build_dir}"
    mkdir $build_dir

    echo "Entering folder: ${build_dir}"
    cd $build_dir

    echo "Start building openalpr ..."
    if [ $1 -eq 1 ]; then
        cmake .. -DCMAKE_BUILD_TYPE=debug -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc -DWITH_DAEMON=OFF $cmake_gen
    else
        cmake .. -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc -DWITH_DAEMON=OFF $cmake_gen
    fi

    #If errors then exit
    if [ "$?" != "0" ]; then
        exit -1
    fi
    
    $make_program $make_flags
    
    #If errors then exit
    if [ "$?" != "0" ]; then
        exit -1
    fi

    echo "Installing ..."
    $make_program install

    #Go back to the current directory
    cd $current_dir
    #Ok!
}

make_program=make
make_flags=''
cmake_gen=''
parallel=1

case $(uname) in
 FreeBSD)
    nproc=$(sysctl -n hw.ncpu)
    ;;
 Darwin)
    nproc=$(sysctl -n hw.ncpu) # sysctl -n hw.ncpu is the equivalent to nproc on macOS.
    ;;
 *)
    nproc=$(nproc)
    ;;
esac

# simulate ninja's parallelism
case nproc in
 1)
    parallel=$(( nproc + 1 ))
    ;;
 2)
    parallel=$(( nproc + 1 ))
    ;;
 *)
    parallel=$(( nproc + 2 ))
    ;;
esac

if [ -f /bin/ninja ]; then
    make_program=ninja
    cmake_gen='-GNinja'
else
    make_flags="$make_flags -j$parallel"
fi

if [ "$1" = "-debug" ]; then
    build_openalpr 1
else
    build_openalpr 0
fi
