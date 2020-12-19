cls
write-output "Welcome to Dantamaf's reset chain script for Windows! This script will:"
Write-Output "1. Install 7-zip if it isn't already installed(there might be a popup asking to make changes to the system)"
Write-Output "2. Download the bootstrap file from my server."
Write-Output "3. Stop Polis if it is running."
Write-Output "4. Delete the chain data folders from your PolisCore data directory."
Write-Output "5. Decompress the bootstrap file."
Write-Output "6. Add banscore=1 to polis.conf to eliminate bad peers in the future."
Write-Output "7. Start Polis."
read-host "Press ENTER to continue..."
$ProgressPreference = 'SilentlyContinue'
#the bootstrap gets remade at the top of every hour and takes 5 minutes so wait until is is 5 past the hour to start
while ((Get-Date).Minute -lt 5)
{
  echo "The bootstrap file is being updated on the server. Waiting until 5 minutes after the hour. Pausing for 15 seconds."
  sleep 15
}

if ([Environment]::Is64BitOperatingSystem)
{
    #Download and install 7-zip if is isn't already installed
    if (!(Test-Path "C:\Program Files\7-Zip\7z.exe"))
    {
        Write-Output "1. Installing 7zip. Click Yes if you get a popup Window."
        Invoke-WebRequest -Uri https://www.7-zip.org/a/7z1900-x64.exe -OutFile $env:USERPROFILE\Downloads\7zip-x64.exe
        & $env:USERPROFILE\Downloads\7zip-x64.exe /S
    }
    else
    {
        Write-Output "1. 7-zip already installed."
    }
}
else
{
if (!(Test-Path "C:\Program Files(x86)\7-Zip\7z.exe"))
    {
        Write-Output "Installing 7zip"
        Invoke-WebRequest -Uri https://www.7-zip.org/a/7z1900-x32.exe -OutFile $env:USERPROFILE\Downloads\7zip-x32.exe
        & $env:USERPROFILE\Downloads\7zip-x32.exe /S
    }
    else
    {
        Write-Output "1. 7-zip already installed."
    }
}

Write-Output "2. Downloading bootstrap. This will take a few minutes depending on download speeds."
Invoke-WebRequest -Uri http://159.203.48.172/bootstrap.7z -OutFile $env:USERPROFILE\Downloads\bootstrap.7z
Write-Output "3. Stopping Polis. This will take 30 seconds."
if ([Environment]::Is64BitOperatingSystem)
{
    & 'C:\Program Files\PolisCore\daemon\polis-cli.exe' stop 2>&1>$null
}
else
{
    & 'C:\Program Files (x86)\PolisCore\daemon\polis-cli.exe' stop 2>&1>$null
}

sleep 30
echo "4. Erasing chain data."
Remove-Item $env:APPDATA\PolisCore\sporks.dat -ErrorAction Ignore
Remove-Item $env:APPDATA\PolisCore\llmq\ -ErrorAction Ignore -Recurse
Remove-Item $env:APPDATA\PolisCore\evodb\ -ErrorAction Ignore -Recurse
Remove-Item $env:APPDATA\PolisCore\blocks\ -ErrorAction Ignore -Recurse
Remove-Item $env:APPDATA\PolisCore\chainstate\ -ErrorAction Ignore -Recurse
Remove-Item $env:APPDATA\PolisCore\database\ -ErrorAction Ignore -Recurse

Write-Output "5. Extracting the bootstrap file."
if ([Environment]::Is64BitOperatingSystem)
{
    & 'C:\Program Files\7-Zip\7z.exe' x "$env:USERPROFILE\Downloads\bootstrap.7z" -o"$env:APPDATA\PolisCore\" 2>&1>$null
}
else
{
    & 'C:\Program Files (x86)\7-Zip\7z.exe' x "$env:USERPROFILE\Downloads\bootstrap.7z" -o"$env:APPDATA\PolisCore\" 2>&1>$null
}

if (Select-String -Path $env:APPDATA\PolisCore\polis.conf -Pattern "banscore")
{
    Write-Output "6. banscore already exists in polis.conf"
    }
    else
    { 
    Write-Output "6. Adding banscore=1 to polis.conf"
    Add-Content $env:APPDATA\PolisCore\polis.conf "`nbanscore=1"
    }

Write-Output "7. Starting Polis"
if ([Environment]::Is64BitOperatingSystem)
{
    & 'C:\Program Files\PolisCore\polis-qt.exe'
}
else
{
    & 'C:\Program Files (x86)\PolisCore\polis-qt.exe'
}
Write-Output "`nScript complete. Polis will complete syncing shortly. Thank you for being a member of the Polis community!"
pause
