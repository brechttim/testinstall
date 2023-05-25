##################################################
# write .exe
##################################################

Install-Module ps2exe

Invoke-ps2exe .\run_speedtest.ps1 .\run_speedtest.exe -noConsole


##################################################
# package .zip
##################################################

Compress-Archive -Path .\run_speedtest.ps1 -DestinationPath speedtest.zip
Compress-Archive -Path .\run_speedtest.exe -Update -DestinationPath speedtest.zip
Compress-Archive -Path .\speedtest.exe -Update -DestinationPath speedtest.zip
