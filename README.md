# test-jacktrip-wsl
Test audio generation on wsl played back using host windows with jack/jacktrip as a backend.

We will be using the command line to interact with the windows host and the windows subsystem for linux (WSL) "guest". Also, some windows commands need to be run with elevated permissions ('As Administrator'). This can get confusing so take care to enter the commands into the specified shell.

These instructions are organised as follows:

- Prerequisites
  - Enable scripts to run on Windows
  - Setup WSL2
  - Install and configure linux tools
  - Install and configure windows tools
- Test
  - Clone this repository
  - Unblock scripts
  - Start jack & JackTrip on WSL
  - Start jack & JackTrip on Windows
  - Test audio pathway using metronome
- Integrate TASCAR
  - Install
  - Test


# Prerequisites
## Enable scripts to run on Windows

By default, Windows won't allow you to run scripts on the command line. We need to modify the 'ExecutionPolicy' to something more liberal. More information on the available values for ExecutionPolicy is can be found in [this Microsoft article](https://go.microsoft.com/fwlink/?LinkID=135170)

PowerShell As Administrator:
```PowerShell
Set-ExecutionPolicy RemoteSigned
```

## One time setup of WSL2

Setting up WSL2 is pretty well documented so the bare-minimum instructions are given here, based on [this site](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10).  If you encounter problems or for more information about system requirements have a look there.

### Activate WSL2
PowerShell As Administrator:
```PowerShell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

PowerShell As Administrator:
```PowerShell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

PowerShell:
```PowerShell
wsl --set-default-version 2
```

### Install Microsoft Terminal

Microsoft Terminal is a new interface for interacting with the command line. It looks and feels much nicer than PowerShell even when it is actually running PowerShell. One can also setup profiles to make running other shells easier and also run with certain configuration options. The default configuration of PowerShell is fine for running 'normal' PowerShell commands. Apparently it can't be used for PowerShell As Administrator commands.

Get it using this [Microsoft Store link](https://www.microsoft.com/en-gb/p/windows-terminal/9n0dx20hk701)


### Install Ubuntu

These instructions use Ubuntu 20.04.

Get it using this [Microsoft Store link](https://www.microsoft.com/en-gb/p/ubuntu-2004-lts/9n6svws3rx71)


### Initial setup

- Open the Ubuntu terminal from the start menu shortcut
- Choose a username and password. N.B. These are independent of your Windows login details
- Make sure everything is up to date

Ubuntu terminal
```bash
$ sudo apt update
$ sudo apt upgrade
```

The rest of these instructions assume you only have one WSL distribution installed or that you are using your default distribution.
Using PowerShell check the name and then set the default.

PowerShell:
```PowerShell
wsl --list --verbose
wsl --set-default Ubuntu-20.04
```

## Install Linux tools

*All commands in this section are run from the Ubuntu terminal*

### Install jack
```bash
sudo apt install jackd2
```
When prompted to allow real-time priorities, choose "yes".

Check it's been installed to `/usr/bin/jackd`
```bash
which jackd
```

Check that you can run it
```bash
jackd -d dummy -r48000 -p128
```

Once you have confirmed it is running, press `ctrl+c` to kill it.

### Install jacktrip


#### Compile from source - latest

```bash
sudo apt install -y --no-install-recommends build-essential librtaudio-dev qt5-default autoconf automake libtool make libjack-jackd2-dev
git clone https://github.com/jacktrip/jacktrip.git
cd jacktrip/src/
./build
```

```bash
cd ../builddir
sudo cp jacktrip /usr/local/bin/
sudo chmod 755 /usr/local/bin/jacktrip
```

Check you have it installed
```bash
cd ~
jacktrip -v
```
If you see something like this, you have successfully installed Jacktrip:
```
JackTrip VERSION: 1.xx
Copyright (c) 2008-2020 Juan-Pablo Caceres, Chris Chafe.
SoundWIRE group at CCRMA, Stanford University
```


## Install windows tools

This section follows the JackTrip installation instructions from [CCRMA](https://ccrma.stanford.edu/software/jacktrip/windows/index.html) which are up to date as of 5-Aug-2020 (v1.2.1 stable).

*N.B. The scripts distributed in this repository assume that `jackd.exe` and `jacktrip.exe` are installed in particular locations.*

Briefly, the steps are...

### Install asio4all

This is the audio driver that jack will use to ingest/output audio from the sound card and is the only known working driver on windows).

Download the installer from [here](http://www.asio4all.org/downloads_11/ASIO4ALL_2_14_English.exe) and run it.

### Install jack

Download the installer from [here](https://github.com/jackaudio/jackaudio.github.com/releases/download/1.9.11/Jack_v1.9.11_64_setup.exe) and run it.

The installer for jack should put the jack executable at `C:/Program Files (x86)/Jack/jackd.exe`. If it is not, please let me know and I will make the scripts more intelligent.


### Install JackTrip

- Create a new folder at `C:\jacktrip_v1.2.1`
- Download the `jacktrip.exe` executable directly from [here](https://ccrma.stanford.edu/software/jacktrip/windows/jacktrip.exe) and place it in the newly created folder.

You should now have the JackTrip executable at `C:\jacktrip_v1.2.1\jacktrip.exe`

# Test that everything works

## Clone this repository

It shouldn't matter where you put it, but generally it is wise to avoid spaces in the path. For simplicity these instructions use the Windows root directory

PowerShell:
```PowerShell
git clone https://github.com/alastairhmoore/test-jacktrip-wsl.git C:\test-jacktrip-wsl
```

The remaining commands assume that you are in the folder you just cloned, i.e., in our case

PowerShell:
```PowerShell
cd C:\test-jacktrip-wsl
```

<!-- Using PowerShell (or Microsoft Terminal) navigate to the root of this repository and do the following... -->

## Unblock the scripts

As part of the prerequisites the ExecutionPolicy was set so that scripts you create yourself can now be run. However the scripts in this repository were downloaded and so need to be specifically unblocked.

PowerShell As Administrator:
```PowerShell
dir C:\test-jacktrip-wsl\*.ps1 | Unblock-File
```


## Start the WSL processes...

Note that JACK on WSL needs root privileges. The script runs processes on WSL as the root user (of the distribution). This is safe enough *as long as you run this script from a normal shell in windows* (i.e. don't do a 'run as administrator')

PowerShell:
```PowerShell
.\start_wsl.ps1
```

## Start the local processes...

Spawn two more windows - one each for jack and JackTrip on windows

PowerShell:
```PowerShell
.\start_local.ps1
```

## Test that audio works...

Start a metronome on WSL and connect it up to the left speaker, then disconnect/stop whilst leaving the jack/JackTrip processes running for future use.

PowerShell:
```PowerShell
.\test_metronome.ps1
```

# Integrate TASCAR

## Install
Follow instructions from [tascar.org](http://www.tascar.org/install.html)

For Ubuntu 20.04 these are

Ubuntu terminal:
```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7D6CDF547DA4ABD
sudo apt-add-repository 'deb [arch=amd64] http://apt.hoertech.de/ focal universe'
sudo apt update
sudo apt install tascarpro
```

## Test

PowerShell:
```PowerShell
.\start_wsl.ps1
.\start_local.ps1
.\test_tascar.ps1
```

You should hear

- a harmonic complex (tone) to the left
- pink noise to the right
- a click train circling your head on the horizontal plane
