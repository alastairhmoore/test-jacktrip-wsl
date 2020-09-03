Start-Process -FilePath "wsl" `
  -ArgumentList "sudo jackd -d dummy -r48000 -p128"
