# Arbalet Pi
The repository contains scripts to setup a Raspberry Pi as an Arbalet workstation.

## Authorized SSH keys (optional)
Before running the script, eventually add SSH keys to the file `authorized_keys` to be able to connect to the Arbalet Pi from your workstation without password prompt.
Run the command below on your workstation to get the public key to be pasted in `authorized_keys`:
```
cat ~/.ssh/id_rsa.pub
```

## Arbapi-fy your Raspberry Pi

 1. Perform a fresh Raspbian install on your Pi
 2. Login as `pi` with default password `raspberry`
 3. Make sure your Pi is connected to the Internet via Ethernet
 4. Move all the content of this repository on a USB stick
 5. Connect the stick to your Pi and run the root script `arbapify.sh` to execute the installing procedure
 6. Default password of user `pi` is changed into `arbalet` after installing
