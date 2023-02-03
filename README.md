# vpn_access
This is a batch file that automates everything from Windows VPN connection to remote desktop connection using SoftEther VPN Server.
## prerequisite
* SoftEther VPN Server must be built.
* You need to be able to connect to the VPN server with a fixed IP address, etc.
* You need to set up port forwarding on your router.
* The connected Windows terminal must be capable of remote desktop connection.
* WoL must be executable to enforce WoL.
## execution procedure
Set the following properties according to your environment.
* VPN server connection information settings
```
$server = ''
$hub = ''
$ServerAddress = ''
$L2tpPsk = ''
```

* VPN connection information setting
```
$user = ''
$pass = ''
```

* WoL configuration information
```
$macaddress = ''
$broadcastaddress = ''
$IPAddress = ''
```

* Remote desktop connection information settings
```
$userName = ''
```

## Detailed information (Japanese)
https://qiita.com/shokun0803/items/def4683a1b4d5c2aeabf
