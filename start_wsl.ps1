""
""
"Launching jackd process on wsl in new terminal window..."
""
Start-Process -FilePath "wsl" `
  -ArgumentList 'sudo jackd -d dummy -p 128'
"Enter your wsl sudo password in the new window..."
$dummy = Read-Host -Prompt 'Then press any key here to continue'

""
""
"Launching jacktrip process on wsl in new terminal window..."
""
Start-Process -FilePath "wsl" `
  -ArgumentList "sudo jacktrip -s --nojackportsconnect"
"Enter your wsl sudo password in the new window..."
$dummy = Read-Host -Prompt 'Then press any key here to continue'

""
""
"Done...list of running processes should now show jackd and jacktrip"
""
$dummy = Read-Host -Prompt 'Press any key to check, then q to finish'
wsl top

# Start-Process -FilePath "wsl" `
#   -ArgumentList "sudo jacktrip -s --nojackportsconnect" `
#   -Wait `
#   -RedirectStandardError "log_wsl_jacktrip_errors.txt"
