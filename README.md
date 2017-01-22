# Arbalet Pi
The repository contains scripts to setup a Raspberry Pi as an Arbalet workstation.

## Authorized SSH keys (optional)
Before running the script, eventually add SSH keys to the file `authorized_keys` to be able to connect to the Arbalet Pi from your workstation without password prompt.
Run the command below on your workstation to get the public key to be pasted in `authorized_keys`:
```
cat ~/.ssh/id_rsa.pub
```

## Arbapi-fy your Raspberry Pi

 1. From your workstation perform a fresh Raspbian install on your SD card, e.g.
 ```
 sudo dd bs=4M if=2016-11-25-raspbian-jessie-lite.img of=/dev/mmcblk0
 ```
 
 2. From your workstation, download this repository on your SD card, e.g.
 ```
 wget https://github.com/arbalet-project/arbapi/archive/master.zip -O /tmp/arbapi.zip
 unzip /tmp/arbapi.zip -d /media/<MY_SD_CARD_NAME>/home/pi
 ```
 
 3. Optionally, populate `authorized_keys` with your workstation's key
 4. Boot on the Raspberry Pi and login as `pi` with default password `raspberry`
 5. Make sure your Pi is connected to the Internet via Ethernet
 6. Run the root script `arbapify.sh` to execute the installing procedure:
 ```
 cd /home/pi/arbapi-master
 ./arbapify.sh
 ```
 Be patient, the procedure typically lasts about 20 minutes
 7. Reboot your Raspberry Pi:
 ```
 sudo reboot
 ```
 It must reboot and activate the Arbalet application sequencer automatically
 8. Default password of user `pi` is changed into `arbalet` after installing
