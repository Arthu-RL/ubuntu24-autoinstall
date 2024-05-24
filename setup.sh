#!/bin/bash

# Update and upgrade the system
apt update
apt upgrade -y

# Install necessary packages
apt-get install -y build-essential vim curl ca-certificates gnupg lsb-release dpkg git \
                    qtdeclarative5-dev qml-module-qtquick-layouts qml-module-qtquick-controls \
                    qml-module-qtquick-controls2 qml-module-qtquick2 qml-module-qt-labs-settings \
                    qml-module-qtquick-dialogs libc6 libgcc-s1 libqt5core5a libqt5gui5 \
                    libqt5multimedia5 libqt5multimedia5-plugins libqt5qml5 libqt5quick5 \
                    qml-module-qtquick2 xterm openssh-server libboost-all-dev libmbedtls-dev \
                    libcppunit-dev libxml2 libxml2-dev python3-dev wget gpg apt-transport-https \
                    zsh zsh-autosuggestions zsh-syntax-highlighting

# Add NVIDIA repository and install NVIDIA driver and CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt update
apt search nvidia-driver
apt-get install -y nvidia-driver-550 cuda-drivers-550

# Install NVIDIA container toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt update
apt-get install -y nvidia-container-toolkit

# Installing and fixing drivers dependencies
ubuntu-drivers install -y

# Installing code 
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
apt update
apt-get install -y code

# Add Docker repository and install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Change the default shell to zsh
export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Installing plugins and theme
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Update the .zshrc file to use the plugins and theme
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

chsh -s /bin/zsh

echo -e "All packages installed and configurations applied \0033[32msuccessfully\0033[0m!"
echo "Reboot your machine"
