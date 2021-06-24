Param(
    [string]$NewComputer = $(Read-Host "Enter New computer name")
)

$UpdatedComputer = $NewComputer + "$"
$ComputerFile = $NewComputer + ".txt"
$MDTServer = "PSD"
$DomainController = "DC-Austin"
$DirectServer = "DirectAccess" 
$Domain = "advocacyinc.org"
$DirectGroup = "DirectAccess Clients"

If ($env:COMPUTERNAME -eq $MDTServer) {
        New-Item -ItemType directory -Path "c:\PSDeployment\OfflineJoinDomain" -ErrorAction SilentlyContinue
}    else {
Invoke-Command -ComputerName $MDTServer -ScriptBlock {
        New-Item -ItemType directory -Path "c:\PSDeployment\OfflineJoinDomain" -ErrorAction SilentlyContinue
    }
}

        New-Item -ItemType directory -Path "c:\OfflineJoinDomain" -ErrorAction SilentlyContinue
        cmd /c Djoin.exe /provision /domain $Domain /dcname $DomainController /machine $NewComputer /policynames "DirectAccess Client Settings" /rootcacerts /savefile "c:\OfflineJoinDomain\$ComputerFile" /reuse
        Copy-Item "c:\offlineJoinDomain\$ComputerFile" -Destination "\\psd\c$\PSDeployment\OfflineJoinDomain\$ComputerFile"  

Start-Sleep 6
If ($env:COMPUTERNAME -eq $DomainController) {
        Add-ADGroupMember -id $DirectGroup -members $UpdatedComputer
}   else {
        Invoke-Command -ComputerName $DomainController -ScriptBlock {
        Add-ADGroupMember -id $using:DirectGroup -members $using:UpdatedComputer
    }
}

Write-Host "The process has completed. You can now run the remote MDT install." -ForegroundColor Green