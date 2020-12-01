#set the bantime in seconds (31536000s = 1 year) (86400s = 1 day)
$BanDuration=86400
clear
#set the version to ban
$BadVersions=@("1.6.0","1.6.1","1.6.2","1.6.3","1.6.4","1.6.5","1.6.6")

#execute the do at least once
do {
#before running this iteration set found tracking variable to false
$FoundOne = $false
#get the peerinfo
$jsonContent=& 'C:\Program Files\PolisCore\daemon\polis-cli.exe' getpeerinfo | ConvertFrom-Json;
#extract the version and IP information from the JSON data
$VersionArray = $jsonContent.psobject.Properties.value.subver
$IPArray = $jsonContent.psobject.Properties.value.addr
#print a table header
Write-Host "Peer IP `t`t Version"
#run one iteration of the loop for each peer
For ($loop=0; $loop -lt $IPArray.Length; $loop++) {
    #clean up the strings
    $IPArray[$loop] = $IPArray[$loop].Substring(0, $IPArray[$loop].IndexOf(':'))
    $VersionArray[$loop]=$VersionArray[$loop].Substring(12, 5)
    #print the peer IP address and its Polis Core version
    Write-Host $IPArray[$loop] "`t"$VersionArray[$loop]
    #if the version is one of the bad ones then ban it for a day and set the tracking variable to true
    if ($VersionArray[$loop] -in $BadVersions) {
        & 'C:\Program Files\PolisCore\daemon\polis-cli.exe' setban $IPArray[$loop] add $BanDuration
        $FoundOne = $true
    }
    
}
#if a peer was banned then wait for 10 seconds while the node finds a new peer
if ($FoundOne) {Sleep 10}
}
#if a peer was banned then repeat the interation over for the new set of peers
While ($FoundOne)
