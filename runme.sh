do_cmd() {
    echo "Executing: $1"
    eval $1
    if [ $? -ne 0 ]; then
        echo "Command failed: $1"
        exit 1
    fi
}
mkdir -p build
cd build 
cp /opt/forge/include . -Rf
cp /opt/forge/include/* . -Rf
cmd="cmake -GNinja"
cmd+=" -DCMAKE_INSTALL_PREFIX=/opt/arrayfire"
cmd+=" -DForge_DIR=/opt/forge/share/Forge/cmake/CMakeModules"
cmd+=" -DAF_BUILD_FORGE=OFF"
cmd+=" -DTHRUST_IGNORE_DEPRECATED_CPP_11=ON"
cmd+=" .."
do_cmd "$cmd"
[[ $? -ne 0 ]] && echo "cmake failed" && exit 1
do_cmd ninja
[[ $? -ne 0 ]] && echo "ninja failed" && exit 1
do_cmd "sudo ninja install"

