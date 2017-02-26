#!/usr/bin/env bash

setup_audio_dependencies()
{
    echo -e "\e[33mInstalling audio dependencies\e[0m."
    # Dependencies in system repository
    sudo apt-get install -y -q=1 --force-yes \
        python-pyaudio                        \
        libportaudio-dev
    echo -e "Done."
}

setup_audio_usb_mount()
{
    echo -e "\e[33mInstalling auto USB mount\e[0m."
    sudo apt-get install -y -q=1 --force-yes \
        usbmount
    echo -e "Done."
}

setup_audio_loopback()
{
    username=$1

    echo -e "\e[33mSetting up audio loopback device\e[0m."
    sudo bash -c "echo -e 'snd-bcm2835 \n' >> /etc/modules "
    sudo bash -c "echo -e 'snd-aloop \n' >> /etc/modules "

    sudo cp setup/audio/asound.conf /etc/asound.conf
    echo -e "Done."
}
