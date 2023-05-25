##################################################
# Set Frequency
##################################################
$everyMinutes = 15.0

##################################################
# Set Functions
##################################################
function Write-DattoUserDefinedField {
    param (
        [String] $KeyName,
        [String] $Value
    )
    $registryPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\CentraStage"
    # check if registry path exists
    if(Test-Path $registryPath) {
        New-ItemProperty -Path $registryPath -Name $KeyName -Value $Value -PropertyType String -Force | Out-Null
    } else {
        New-Item -Path $registryPath -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name $KeyName -Value $Value -PropertyType String -Force | Out-Null
    }
}
##################################################
# Download and install test executable
##################################################
$downloadLink = "https://github.com/brechttim/testinstall/raw/master/speedtest.zip"
$programName = "speedtest"
$programFileName = $programName+".exe"
# $scriptFileName = "run_speedtest.exe"
$scriptFileName = "run_speedtest.ps1"
$scriptProgramFileName = "run_speedtest.exe"
$programFileNameRaw = $programName+".zip"
$programRoot = $Env:Programfiles+"\Pikoworks"
$programLocation = $programRoot+"\"+$programName
$programFileLocation = $programLocation +"\"+$programFileName
$programFileLocationRaw = $programLocation +"\"+$programFileNameRaw
$scriptFileLocation = $programLocation +"\"+$scriptFileName
$scriptProgramFileLocation = $programLocation +"\"+$scriptProgramFileName

# test path
if (Test-Path -Path $programLocation) {
    Write-Host "<-Path exists!->"
} else {
    Write-Host "<-Path doesn't exist -> Create->"
    New-Item -Path $programRoot -Name $programName -ItemType "directory"
    Write-Host "<-Created->"
}

# test if file exists, download
if (Test-Path -Path $programFileLocation) {
    Write-Host "<-Program is installed -> Reinstall/Update ->"
    Invoke-WebRequest $downloadLink -OutFile $programFileLocationRaw
    Expand-Archive $programFileLocationRaw -DestinationPath $programLocation -Force
    Write-Host "<-Update Complete->"
}   else{
    Write-Host "<-Exe doesn't exist -> Download and install->"
    Invoke-WebRequest $downloadLink -OutFile $programFileLocationRaw
    Expand-Archive $programFileLocationRaw -DestinationPath $programLocation -Force
    Write-Host "<-Installed->"
}

##################################################
# Create Cronjob
##################################################

if (Test-Path -Path $scriptFileLocation) {
    Write-Host "<-Scheduler Script is installed! Create Cronjob ->"
    # $action = New-ScheduledTaskAction -Execute PowerShell.exe -Argument $scriptFileLocation
    $action = New-ScheduledTaskAction -Execute $scriptProgramFileLocation
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $everyMinutes) 
    Register-ScheduledTask -TaskName "Speedtest"  -Trigger $trigger -Action $action -RunLevel Highest –Force
    Start-ScheduledTask -TaskName "Speedtest"
    Write-Host "<- Cronjob Created ->"
    Get-ScheduledTaskInfo -TaskName "Speedtest"
    
    exit 0
    
} else {
    Write-Host "<-Scheduler Script is not installed! error ->"
    
    exit 1
}





