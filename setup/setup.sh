#!/usr/bin/env bash

# Load subfunctions
source $setup_path/setup/audio/setup.sh

# Function from https://github.com/RPi-Distro/raspi-config/blob/master/raspi-config
CONFIG=/boot/config.txt
set_config_var() {
  lua - "$1" "$2" "$3" <<EOF > "/tmp/config.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
  if line:match("^#?%s*"..key.."=.*$") then
    line=key.."="..value
    made_change=true
  end
  print(line)
end
if not made_change then
  print(key.."="..value)
end
EOF
sudo cp "/tmp/config.bak" "$3" --no-preserve=mode,ownership
rm "/tmp/config.bak"
}

setup_system()
{
    echo -e "\e[33mChanging hostname to \e[4m$hostname\e[0m."
    sudo sed -i.bak -e "s:raspberrypi:$hostname:g" /etc/hosts
    echo "$hostname" | sudo tee /etc/hostname >/dev/null
    sudo hostname "$hostname"
    echo -e "Done."
}

setup_user()
{
    username=$1
    password=$2

    echo -e "\e[33mChanging password of \e[4m$username/$password\e[0m."
    sudo passwd "$username" <<EOF
$password
$password
EOF
    #echo -e "\e[33mRenaming user to \e[4m$username\e[0m."
    #sudo usermod -l "$username" pi
    #sudo usermod -m -d "/home/$username" "$username"

    echo -e "Done."
}

setup_dependencies()
{
    echo -e "\e[33mInstalling system dependencies\e[0m."
    # Dependencies in system repository
    sudo apt-get update
    sudo apt-get install -y -q=1 --force-yes \
        avahi-autoipd                        \
        avahi-daemon                         \
        uptimed                              \
        git                                  \
        python2.7                            \
        python-setuptools                    \
        python-pygame                        \
        python-numpy                         \
        python-xlib                          \
        python-opencv                        \
        python-alsaaudio                     \
        python-dev                           \
#        ipython-notebook                     \
    echo -e "Done."

    echo -e "\e[33mInstalling pip\e[0m."
    wget bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
    sudo python /tmp/get-pip.py
    echo -e "Done."

    # Dependencies in pypi
    echo -e "\e[33mInstalling Python dependencies\e[0m."
    sudo pip install python-midi bottle
    echo -e "Done."
}

setup_workspace()
{
    config_file=$1
    config_joy=$2
    echo -e "\e[33mSetting up Arbalet workspace\e[0m."
    sed -i.bak -e "s/#alias /alias /g" /home/$username/.bashrc
    pwd=`pwd`
    cd "/home/$username" && mkdir -p Arbalet && cd Arbalet
    git clone --recursive https://github.com/arbalet-project/arbasdk.git
    git clone https://github.com/arbalet-project/arbapps.git
    git clone https://github.com/arbalet-project/arbadoc.git
    cat > arbasdk/arbalet/config/default.cfg << EOF
[DEFAULT]
config: $config_file.json
joystick: $config_joy.json
EOF
    echo -e "Done."
    echo -e "\e[33mInstalling Arbalet SDK\e[0m."
    cd "/home/$username/Arbalet/arbasdk" && sudo python setup.py --quiet install
    echo -e "Done."
    for dir in /home/"$username"/Arbalet/arbasdk/hardware/raspberrypi/*
    do
        if [ -f "$dir/setup.py" ]; then
            echo -e "\e[33mInstalling Arbalet for Raspberry Pi dependency \e[4m$dir\e[0m."
            cd "$dir"
            sudo python setup.py --quiet install
            cd -
        fi
    done
    echo -e "Done."
    echo -e "\e[33mInstalling Arbalet applications\e[0m."
    cd "/home/$username/Arbalet/arbapps" && sudo python setup.py --quiet install
    cd $pwd
    echo -e "Done."
}

setup_ssh()
{
    authorized_keys="$2/authorized_keys"
    if [ -f $authorized_keys ]; then
        echo -e "\e[33mInstalling SSH authorized keys file\e[0m."
        mkdir -p  "/home/$1/.ssh"
        cp $authorized_keys "/home/$1/.ssh/authorized_keys"
        sudo update-rc.d ssh enable && sudo invoke-rc.d ssh start
        echo -e "Done."
    else
        echo -e "No SSH authorized keys file specified"
    fi
}

setup_arbalet()
{
    username=$1

    echo -e "\e[33mSetting up the SPI device\e[0m."
    set_config_var dtparam=spi on $CONFIG  # Enable the SPI device
    echo -e "Done."

    echo -e "\e[33mSetting up autostart\e[0m."
    sudo systemctl set-default multi-user.target
    sudo ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

    # TODO the file below contains a hardcoded "pi" username, replace with envsubst command in gettext package
    sudo cp setup/arbalet-sequencer.service /lib/systemd/system/arbalet-sequencer.service
    cp setup/pi.json /home/$username/Arbalet/arbapps/arbalet/tools/sequencer/sequences
    sudo systemctl daemon-reload
    sudo systemctl enable arbalet-sequencer.service
    echo -e "Done."
}
