#!/usr/bin/env bash

setup_audio_dependencies()
{
    echo -e "\e[33mInstalling audio dependencies\e[0m."
    # Dependencies in system repository
    sudo apt-get install -y -q=1 --force-yes \
        python-pyaudio                        \
        libportaudio-dev                      \
        python-pyaudio                        \
    echo -e "Done."
}

setup_audio_loopback()
{
    # From https://www.raspberrypi.org/forums/viewtopic.php?t=86115&p=610070
    username=$1

    echo -e "\e[33mSetting up audio loopback device\e[0m."
    sudo bash -c "echo -e 'snd-bcm2835 \n' >> /etc/modules "
    sudo bash -c "echo -e 'snd-aloop \n' >> /etc/modules "

    cat > /home/$username/.asoundrc << EOF
pcm.!default {
    type asym
    playback.pcm "alsa_sink"
    capture.pcm "alsa_monitor"
}

pcm.alsa_sink {
    type plug
    slave {pcm "alsa_loopback"}
    route_policy "duplicate"
}

pcm.alsa_monitor {
    type plug
    slave {pcm "hw:Loopback,1,0"}
}

pcm.alsa_loopback {
    type multi

    slaves.a.pcm "hw:0,0"
    slaves.a.channels 2
    slaves.b.pcm "hw:Loopback,0,0"
    slaves.b.channels 2

    bindings.0.slave a
    bindings.0.channel 0
    bindings.1.slave a
    bindings.1.channel 1
    bindings.2.slave b
    bindings.2.channel 0
    bindings.3.slave b
    bindings.3.channel 1
}

EOF
    echo -e "Done."
}
