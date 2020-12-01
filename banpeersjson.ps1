#set the bantime in seconds (31536000s = 1 year) (86400s = 1 day)
cd "C:\Program Files\PolisCore\daemon"
$BanDuration=86400
clear
#set the version to check for
$BadVersions=@("1.6.0","1.6.1","1.6.2","1.6.3","1.6.4","1.6.5","1.6.6")

do {
$FoundOne = $false
#get the peerinfo
$jsonContent=./polis-cli getpeerinfo | ConvertFrom-Json;
$VersionArray = $jsonContent.psobject.Properties.value.subver
$IPArray = $jsonContent.psobject.Properties.value.addr
For ($loop=0; $loop -lt $IPArray.Length; $loop++) {
    $IPArray[$loop] = $IPArray[$loop].Substring(0, $IPArray[$loop].IndexOf(':'))
    $VersionArray[$loop]=$VersionArray[$loop].Substring(12, 5)
    Write-Host $IPArray[$loop] $VersionArray[$loop]
    if ($VersionArray[$loop] -in $BadVersions) {
        ./polis-cli setban $IPArray[$loop] add $BanDuration
        $FoundOne = $true
    }
    
}
Sleep 10
}
While ($FoundOne)