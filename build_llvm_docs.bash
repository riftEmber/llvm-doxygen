#!/usr/bin/env bash

# Build LLVM doxygen documentation at a specified version.

set -e
set -x

if [ -z "$1" ]; then
  echo "Usage: $0 <llvm_version>"
  exit 1
fi

LLVM_VERSION=$1

echo "Building LLVM doxygen documentation for version $LLVM_VERSION"

git clone -b "llvmorg-$LLVM_VERSION.0.0" --depth=1 https://github.com/llvm/llvm-project.git llvm-project-$LLVM_VERSION
cd llvm-project-$LLVM_VERSION

cd llvm
mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_DOXYGEN=ON -DLLVM_BUILD_DOCS=ON ..
make doxygen -j8

cp -r docs/doxygen/html ../../../llvm-doxygen-html-$LLVM_VERSION
