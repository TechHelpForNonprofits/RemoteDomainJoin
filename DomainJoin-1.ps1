#created by Carlton Whitmore
#This script creates a computer account and adds to the proper Direct Access Client group
#You can run this script from your any Windows system that has access to PSD/MDT server and Domain controller


Param(
    [string]$NewComputer = $(Read-Host "Enter New computer name")
)

###################################################################################################
#Change variable names below to reflect your environment
$UpdatedComputer = $NewComputer + "$"
$ComputerFile = $NewComputer + ".txt"
$MDTServer = "NAMEofYOurPSDServer"
$MDTShare = "Set PSD/MDT share folder" #mine was c:\PSDeployment
$DomainController = "DomainControllerName"
$DirectServer = "Direct Access Server Name" 
$Domain = "YourActiveDirectoryDomainName"
$DirectGroup = "DirectAccess Clients" #This is default name for the group; yours might be different
####################################################################################################


#Creates path inside PSD/MDT environment if not already created. 
If ($env:COMPUTERNAME -eq $MDTServer) {
        New-Item -ItemType directory -Path "c:\$MDTShare\OfflineJoinDomain" -ErrorAction SilentlyContinue
}    else {
Invoke-Command -ComputerName $MDTServer -ScriptBlock {
        New-Item -ItemType directory -Path "c:\$MDTShare\OfflineJoinDomain" -ErrorAction SilentlyContinue
    }
}
#creates local directory and runs domain join command
        New-Item -ItemType directory -Path "c:\OfflineJoinDomain" -ErrorAction SilentlyContinue
        cmd /c Djoin.exe /provision /domain $Domain /dcname $DomainController /machine $NewComputer /policynames "DirectAccess Client Settings" /rootcacerts /savefile "c:\OfflineJoinDomain\$ComputerFile" /reuse
        Copy-Item "c:\offlineJoinDomain\$ComputerFile" -Destination "\\$MDTServer\$MDTShare\OfflineJoinDomain\$ComputerFile"  

#waits 6 seconds then adds computer to necessary group for DirectAccess
Start-Sleep 6
If ($env:COMPUTERNAME -eq $DomainController) {
        Add-ADGroupMember -id $DirectGroup -members $UpdatedComputer
}   else {
        Invoke-Command -ComputerName $DomainController -ScriptBlock {
        Add-ADGroupMember -id $using:DirectGroup -members $using:UpdatedComputer
    }
}

Write-Host "The process has completed. You can now run the remote MDT install." -ForegroundColor Green
