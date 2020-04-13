$DOWNLOAD = $HOME + '\Downloads'

$MINGW_URL = 'https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z'
$MINGW_ZIP = 'mingw64.7z'

$CLION_URL = 'https://download.jetbrains.com/cpp/CLion-2019.3.5.exe'
$CLION_EXE = 'clion.exe'
$CLION_INSTALL_DIR = 'C:\CLion'
$CLION_CONFIG_URL = 'https://download.jetbrains.com/cpp/silent.config'
$CLION_CONFIG = 'silent.config'


# Change Work Dir
Set-Location $Download

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $PSCommandPath = $MyInvocation.PSCommandPath
    Start-Process powershell.exe @("-File $PSCommandPath") -Verb runAs
    exit
}

# Kill TrAsH cHiYoU
Rename-Item "C:\Program Files (x86)\CHIYOU\REDAgent.exe" "BLUEAgent.exe" -Force
taskkill.exe /F /T /IM "REDAgent.exe"

function dl ($url, $file) {
    .\aria2c.exe --dir=$DOWNLOAD --out=$file $url --file-allocation=none
}

# MinGW-w64
dl -url $MINGW_URL -file $MINGW_ZIP
.\7z.exe x -oC:\ $MINGW_ZIP

# Edit System Path
$path = [System.Environment]::GetEnvironmentVariable("Path", "Machine").Split(";") | Where-Object { $_ -notlike "*msys*"}
[System.Environment]::SetEnvironmentVariable("Path", 'C:\mingw64\bin;' + ($path -join ';'), "Machine")

# CLion
dl -url $CLION_URL -file $CLION_EXE
dl -url $CLION_CONFIG_URL -file $CLION_CONFIG
Start-Process $CLION_EXE @("/S", "/CONFIG=$CLION_CONFIG", "/D=$CLION_INSTALL_DIR") -Wait

# Logout
shutdown.exe /l