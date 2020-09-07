# test-jacktrip-wsl
Test audio generation on wsl played back using host windows with jack/jacktrip as a backend.

# Installation

- Setup WSL2
- Install and configure linux tools
- Install and configure windows tools
- test




# One time setup of WSL2

Setting up WSL2 is pretty well documented so the bare-minimum instructions are given here, based on [this site](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10).  If you encounter problems or for more information about system requirements have a look there.

## Activate WSL2
Open PowerShell as Administrator and run the following commands

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

```
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

```
wsl --set-default-version 2
```

## Install Microsoft Terminal

This isn't strictly necessary, but it is nicer to use than PowerShell (even though you will probably be running PowerShell under the hood)

[Microsoft Store link](https://www.microsoft.com/en-gb/p/windows-terminal/9n0dx20hk701)


## Install Ubuntu

[Microsoft Store link](https://www.microsoft.com/en-gb/p/ubuntu-2004-lts/9n6svws3rx71)


## Initial setup

- Open the Ubuntu terminal from the start menu shortcut
- Choose a username and password. N.B. These are independent of your Windows login details
- Make sure everything is up to date

```
sudo apt update
sudo apt upgrade
```

The rest of these instructions assume you only have one WSL distribution installed or that you are using your default distribution.
Using PowerShell check the name and then set the default
```
wsl --list --verbose
wsl --set-default Ubuntu-20.04
```

# Install and configure linux tools

Open the Ubuntu Terminal

## Install jack
```
sudo apt install jackd2
```
When prompted to allow real-time priorities, choose "yes".

Check it's been installed to `/usr/bin/jackd`
```
which jackd
```

Check that you can run it
```
jackd -d dummy -r48000 -p128
```


## Install jacktrip

### Should be easy - but not working!!
```
wget https://ccrma.stanford.edu/software/jacktrip/linux/jacktrip_1.1-1.deb
sudo dpkg -i jacktrip_1.1-1.deb
```

### Compile from source the old way using qmake (QT Tools)

Haven't got an exact record of the syntax
```
git clone https://github.com/jacktrip/jacktrip.git
cd jacktrip/src/

sudo apt install qtbase5-dev qt5-qmake
qtchooser -run-tool=qmake -qt=qt5 jacktrip.pro
qmake jacktrip.pro
 make release
```

```

sudo apt install -y --no-install-recommends build-essential librtaudio-dev qt5-default autoconf automake libtool make libjack-jackd2-dev

git clone https://github.com/jacktrip/jacktrip.git
cd jacktrip/src/
./build
```

```
cd ../builddir
sudo cp jacktrip /usr/local/bin/
sudo chmod 755 /usr/local/bin/jacktrip
```

Check you have it installed
```
cd ~
jacktrip -v
```
