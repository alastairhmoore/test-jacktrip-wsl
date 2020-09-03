Start-Process -FilePath "C:/Program Files (x86)/Jack/jackd.exe" `
  -ArgumentList "-S -dportaudio -d""ASIO::ASIO4ALL v2"" -r48000 -p128"
