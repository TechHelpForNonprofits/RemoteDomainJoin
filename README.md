# RemoteDomainJoin
We have Endpoint Configuration Manager on-site, but after the pandemic hit we really needed a way to image systems from anywhere. That included joining those systems to the domain from a remote location.

<b><u>Prerequisites:</b></u><br>
Direct Access installed and setup <i>(or another way to connect back to domain over Internet)</i><br>
Active Directory Domain controller<br>
PSD MDT (https://github.com/FriendsOfMDT/PSD)<br>


Prior to imaging new system you'll need to setup the computer account and add it to the proper Direct Access client group with this Powershell script (<a href="https://github.com/TechHelpForNonprofits/RemoteDomainJoin/blob/main/DomainJoin-1.ps1" target="_blank">DomainJoin.ps1</a>)

After Task Sequence runs on new system put in a step to reboot system then run this as a command line task.

`powershell.exe -ExecutionPolicy Bypass -Command "$Filelocation = 'c:\OfflineJoinDomain\' + $env:computername + '.txt'; cmd /c Djoin.exe /requestodj /loadfile $FileLocation /windowspath %windir% /localos"`
