# RemoteDomainJoin
We have Endpoint Configuration Manager on-site, but after the pandemic hit we really needed a way to image systems from anywhere. That included joining those systems to the domain from a remote location.

Prerequisites:
Direct Access installed and setup
Active Directory Domain controller
PSD MDT (https://github.com/FriendsOfMDT/PSD)


Prior to imaging new system you'll need to setup the computer account and add it to the proper Direct Access client group with this Powershell script (DomainJoin.ps1)

