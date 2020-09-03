function Get-WSL2WindowsHost {
  return wsl cat /etc/resolv.conf `| grep nameserver `| cut -d ' ' -f 2
}
function Get-WSL2IPAdrress {
  return (wsl hostname -I).Trim()
}


$host_ip=Get-WSL2WindowsHost
"host:"
$host_ip
$client_ip=Get-WSL2IPAdrress
"client:"
$client_ip



powershell .\start_wsl_jack.ps1
$dummy = Read-Host -Prompt 'Enter wsl sudo password before pressing return to continue'

powershell .\start_wsl_jacktrip.ps1
$dummy = Read-Host -Prompt 'Enter wsl sudo password before pressing return to continue'

powershell .\start_local_jack
powershell .\start_local_jacktrip.ps1

Start-Process -FilePath "wsl" `
  -ArgumentList "sudo jack_metro --bpm 100"
$dummy = Read-Host -Prompt 'Enter wsl sudo password before pressing return to continue'


wsl sudo jack_lsp
wsl sudo jack_connect metro:100_bpm JackTrip:send_1
& 'C:/Program Files (x86)/Jack/jack_connect.exe' ($client_ip + ':receive_1') system:playback_1
