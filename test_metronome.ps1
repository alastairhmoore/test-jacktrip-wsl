function Get-WSL2IPAdrress {
  return (wsl hostname -I).Trim()
}

$client_ip=Get-WSL2IPAdrress
"client:"
$client_ip

Start-Process -FilePath "wsl" `
  -ArgumentList "sudo jack_metro --bpm 100"
$dummy = Read-Host -Prompt 'Enter wsl sudo password before pressing return to continue'
#
#
# wsl sudo bash -c "jack_metro --bpm 100"

wsl sudo bash -c "jack_lsp; jack_connect metro:100_bpm JackTrip:send_1"
# wsl sudo ./test_metro_start.sh

& 'C:/Program Files (x86)/Jack/jack_connect.exe' ($client_ip + ':receive_1') system:playback_1

$dummy = Read-Host -Prompt 'Verify that you can hear the audio.../nPress return to end'

& 'C:/Program Files (x86)/Jack/jack_disconnect.exe' ($client_ip + ':receive_1') system:playback_1
wsl sudo bash -c "jack_disconnect metro:100_bpm JackTrip:send_1; pkill -9 -f jack_metro"
