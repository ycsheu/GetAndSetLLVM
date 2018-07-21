set -eux
version="$1"
THREADS=1
CMAKE=cmake
INSTALL_PATH=${HOME}/compilers/llvm-${version}
TARGETS="X86"
COMP_FORMAT=xz
CLANG_NAME=cfe
#if test -f gcc-"$version".tar.xz
#then
#echo 'already exist gcc-"$version".tar.xz'
#else
mkdir -p llvm-${version}
cd llvm-${version}
mkdir -p source_code
cd source_code
if test -f llvm-${version}.src
then
echo 'already exist llvm source code'
else
wget -c http://releases.llvm.org/${version}/llvm-${version}.src.tar.${COMP_FORMAT}
tar -xf llvm-${version}.src.tar.${COMP_FORMAT}
fi
if test -f llvm-${version}.src/tools/clang
then
echo 'already exist clang'
else
wget -c http://releases.llvm.org/${version}/${CLANG_NAME}-${version}.src.tar.${COMP_FORMAT}
tar -xf ${CLANG_NAME}-${version}.src.tar.${COMP_FORMAT}
mv ${CLANG_NAME}-${version}.src llvm-${version}.src/tools/clang
fi
if test -f llvm-${version}.src/projects/compiler-rt
then
echo 'already exist compiler-rt'
else
wget -c http://releases.llvm.org/${version}/compiler-rt-${version}.src.tar.${COMP_FORMAT}
tar -xf compiler-rt-${version}.src.tar.${COMP_FORMAT}
mv compiler-rt-${version}.src llvm-${version}.src/projects/compiler-rt
fi
cd ..
mkdir -p build
cd build
${CMAKE} ../source_code/llvm-${version}.src -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} -DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_TARGETS_TO_BUILD=${TARGETS} -DLLVM_BUILD_TESTS=ON -DLLVM_BUILD_EXAMPLES=ON
make -j${THREADS}
make check-all
make install
