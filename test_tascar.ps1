function Get-WSL2IPAdrress {
  return (wsl hostname -I).Trim()
}

$client_ip=Get-WSL2IPAdrress
"client: " + $client_ip
""

# start the metronome process in new window
Start-Process -FilePath "wsl" `
  -ArgumentList "-u root tascar_cli tascar/binaural_demo.tsc"

""
"Showing jack connections for debug purposes. The list should include:"
"render.main:out_l"
"    JackTrip:send_1"
"render.main:out_r"
"    JackTrip:send_2"
""
"Connections:"
wsl -u root bash -c "sleep 0.2; jack_lsp -c"


# connect jactrip to local soundcard
& 'C:/Program Files (x86)/Jack/jack_connect.exe' ($client_ip + ':receive_1') system:playback_1
& 'C:/Program Files (x86)/Jack/jack_connect.exe' ($client_ip + ':receive_2') system:playback_2

# user check
""
"Verify that you can hear the audio..."
$dummy = Read-Host -Prompt "Press return to end"

# disconnect and end the metronome process
& 'C:/Program Files (x86)/Jack/jack_disconnect.exe' ($client_ip + ':receive_1') system:playback_1
& 'C:/Program Files (x86)/Jack/jack_disconnect.exe' ($client_ip + ':receive_2') system:playback_2
wsl -u root bash -c "pkill -f tascar_cli"
