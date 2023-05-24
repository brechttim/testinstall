
##################################################
# package .zip
##################################################

Compress-Archive -Path .\run_speedtest.ps1 -DestinationPath speedtest.zip
Compress-Archive -Path .\speedtest.exe -Update -DestinationPath speedtest.zip