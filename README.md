# vpn_access
This is a batch file that automates everything from Windows VPN connection to remote desktop connection using SoftEther VPN Server.
## prerequisite
* SoftEther VPN Server must be built.
* You need to be able to connect to the VPN server with a fixed IP address, etc.
* You need to set up port forwarding on your router.
* The connected Windows terminal must be capable of remote desktop connection.
## execution procedure
Set the following properties according to your environment.
* VPN server connection information settings
```
$server = ''
$ipaddress = ''
$hub = ''
$L2tpPsk = ''
```

* VPN connection information setting
```
$user = ''
$pass = ''
```

* Remote desktop connection information settings
```
$userName = ''
$pcName = ''
```

## Detailed information (Japanese)
making…
