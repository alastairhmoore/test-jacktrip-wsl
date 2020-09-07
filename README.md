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

# Install linux tools

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


### Compile from source - latest
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
If you see something like this, you have successfully installed Jacktrip:
```
JackTrip VERSION: 1.xx
Copyright (c) 2008-2020 Juan-Pablo Caceres, Chris Chafe.
SoundWIRE group at CCRMA, Stanford University
```


# Install windows tools

Instructions for Windows are up-to-date (as of 5-Aug-2020, v1.2.1 stable) and available from [CCRMA](https://ccrma.stanford.edu/software/jacktrip/windows/index.html)

The steps are

- install asio4all (this is the only known working driver on windows)
- install jack
- intall JackTrip

The installer for jack should put the jack executable at `C:/Program Files (x86)/Jack/jackd.exe`. If it is not, please let me know and I will make the scripts more intelligent.

You can choose where to put JackTrip.exe. These scripts require the JackTrip executable to be placed at `C:\jacktrip_v1.2.1\jacktrip.exe`

# Test that everything works

Using PowerShell (or Microsoft Terminal) navigate to the root of this repository and do the following...

## Start the WSL processes...

Note that interactions JACK on WSL needs root privileges so you will be prompted for you password twice - once for jack and once for JackTrip

```
.\start_wsl.ps1
```

## Start the local processes...

Spawn two more windows - one each for jack and JackTrip on windows
```
.\start_local.ps1
```

## Test that audio works...

Start a metronome on WSL and connect it up to the left speaker, then disconnect/stop whilst leaving the jack/JackTrip processes running for future use.

```
.\test_metronome.ps1
```
