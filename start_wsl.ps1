Start-Process -FilePath "wsl" `
  -ArgumentList 'sudo jackd -d dummy -p 128'

Start-Process -FilePath "wsl" `
  -ArgumentList "sudo jacktrip -s --nojackportsconnect"
# Start-Process -FilePath "wsl" `
#   -ArgumentList "sudo jacktrip -s --nojackportsconnect" `
#   -Wait `
#   -RedirectStandardError "log_wsl_jacktrip_errors.txt"
