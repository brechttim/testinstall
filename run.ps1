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
$scriptFileName = "run.ps1"
$programFileNameRaw = $programName+".zip"
$programRoot = $Env:Programfiles+"\Pikoworks"
$programLocation = $programRoot+"\"+$programName
$programFileLocation = $programLocation +"\"+$programFileName
$programFileLocationRaw = $programLocation +"\"+$programFileNameRaw
$scriptFileLocation = $programLocation +"\"+$scriptFileName

# test path
if (Test-Path -Path $programLocation) {
    Write-Host "<-Path exists!->"
} else {
    Write-Host "<-Path doesn't exist -> Create->"
    New-Item -Path $programRoot -Name $programName -ItemType "directory"
    Write-Host "<-Created->"
}

# test if file exists
if (Test-Path -Path $programFileLocation) {
    Write-Host "<-Program is installed!->"
}   else{
    Write-Host "<-Exe doesn't exist -> Download and install->"
    Invoke-WebRequest $downloadLink -OutFile $programFileLocationRaw
    Expand-Archive $programFileLocationRaw -DestinationPath $programLocation -Force
    Write-Host "<-Installed->"
}

##################################################
# Run Program and upload to Datto RMM Udf
##################################################
if (Test-Path -Path $scriptFileLocation) {
    Write-Host "<-Scheduler Script is installed! continue ->"
    $action = New-ScheduledTaskAction -Execute $scriptFileLocation
    $trigger = New-ScheduledTaskTrigger -RepetitionDuration 15 -Minutes

} else {
    Write-Host "<-Scheduler Script is not installed! error ->"
}







##################################################
# Run Program and upload to Datto RMM Udf
##################################################
write-host '<-Executing Test Program'
$speedtest = &$programFileLocation

write-host '<-Writing Testing Data into Custom Field->'
Write-DattoUserDefinedField -KeyName "Custom20" -Value $speedtest
if((Get-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\CentraStage").PSObject.Properties.Name -contains "Custom20"){
    write-host '<-Completed->'
} else {
    Write-Host '<-Completed with ERROR->'
}


exit 0
