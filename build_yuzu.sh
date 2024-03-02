#!/usr/bin/env zsh

# ANSI color codes
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${PURPLE}Checking for Homebrew installation...${NC}"

# Check if Homebrew is installed
# if ! command -v brew &> /dev/null; then
#     echo -e "${PURPLE}Homebrew not found. Installing Homebrew...${NC}"
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# else
#     echo -e "${PURPLE}Homebrew found. Updating Homebrew...${NC}"
#     brew update && brew upgrade
# fi

# Install needed dependencies
echo -e "${PURPLE}Checking for Homebrew dependencies...${NC}"
brew_install() {
	if [ -d "$(brew --prefix)/opt/$1" ]; then
		echo -e "${GREEN}found $1...${NC}"
	else
 		echo -e "${PURPLE}Did not find $1. Installing...${NC}"
		brew install $1
	fi
}

deps=( autoconf automake boost ccache cmake ffmpeg fmt glslang hidapi libtool libusb llvm@17 lz4 ninja nlohmann-json openssl pkg-config qt@6 sdl2 speexdsp vulkan-loader zlib zstd )

for dep in $deps[@]
do 
	brew_install $dep
done

# Clone the Yuzu repository if not already cloned
if [ ! -d "yuzu" ]; then
    echo -e "${PURPLE}Cloning Yuzu repository...${NC}"
    git clone --recursive https://github.com/yuzu-emu/yuzu
    cd yuzu
else
    echo -e "${PURPLE}Yuzu repository already exists. Updating...${NC}"
    cd yuzu

    echo -e "${PURPLE}Fetching latest changes...${NC}"
    
    git fetch origin master

    echo -e "${PURPLE}Removing existing submodules...${NC}"
    git submodule deinit -f .

    echo -e "${PURPLE}Fetching new submodules...${NC}"
    git submodule update --init --recursive
fi

echo -e "${PURPLE}Exporting necessary environment variables...${NC}"

# Export necessary environment variables
export LLVM_DIR=$(brew --prefix)/opt/llvm@17
export FFMPEG_DIR=$(brew --prefix)/opt/ffmpeg
