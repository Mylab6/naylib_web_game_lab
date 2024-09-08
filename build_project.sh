#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and install essential build tools
echo "Installing required dependencies..."
sudo apt-get update
sudo apt-get install -y cmake ninja-build git python3 wget unzip

# Install Wayland and XKB dependencies (in case they're needed, but can be skipped for WebAssembly)
sudo apt-get install -y libwayland-dev wayland-protocols libxkbcommon-dev libx11-dev libegl1-mesa-dev
sudo test -f /usr/share/doc/kitware-archive-keyring/copyright ||
sudo wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
sudo apt-get update
sudo apt-get install -y kitware-archive-keyring
sudo apt-get install -y cmake

# Install Emscripten
echo "Installing Emscripten..."
if [ -d "emsdk" ]; then
    echo "Emscripten is already installed, skipping..."
    
    cd emsdk
else
    echo "Installing Emscripten..."
    git clone https://github.com/emscripten-core/emsdk.git
    cd emsdk
fi

# Fetch and install the latest Emscripten SDK
./emsdk install latest

# Activate the latest Emscripten SDK
./emsdk activate latest

# Source the Emscripten environment variables (this is needed to build for WebAssembly)
source ./emsdk_env.sh

# Navigate back to the root directory
cd ..

# Ensure the build directory is clean
echo "Setting up build directory..."
rm -rf build
mkdir build
cd build

# Run the CMake configuration for WebAssembly (PLATFORM_WEB)
echo "Configuring project for WebAssembly build..."
emcmake cmake  -DPLATFORM=Web -DCMAKE_BUILD_TYPE=Release ..

# Build the project using emmake (Emscripten's version of make)
echo "Building project..."
emmake make

# Package the build into a zip file (assuming the output is index.html, .wasm, and .js files)
echo "Packaging build into a zip file..."
#cp my_game.html index.html

zip raylib_web_game.zip *.html *.wasm *.js *.data

echo "Build complete. Packaged as raylib_web_game.zip."
#python3 -m http.server 8000