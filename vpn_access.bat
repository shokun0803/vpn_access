@SETLOCAL&SETLOCAL ENABLEDELAYEDEXPANSION&(chcp 65001>NUL)&PUSHD "%~dp0"&(SET SCRIPT_PATH=%~f0)&(SET SCRIPT_DIR=%~dp0)&(SET SCRIPT_NAME=%~nx0)&(SET SCRIPT_BASE_NAME=%~n0)&(SET SCRIPT_EXTENSION=%~x0)&(SET SCRIPT_ARGUMENTS=%*)&(POWERSHELL -NoLogo -Sta -NoProfile -ExecutionPolicy Unrestricted "&([scriptblock]::create('$OutputEncoding=[Console]::OutputEncoding;'+\"`n\"+((gc -Encoding UTF8 -Path \"!SCRIPT_PATH!\"|?{$_.readcount -gt 1})-join\"`n\")))" !SCRIPT_ARGUMENTS!)&(SET EXIT_CODE=!ERRORLEVEL!)&POPD&PAUSE&EXIT !EXIT_CODE!&ENDLOCAL&GOTO :EOF

# VPN サーバー接続情報設定
$server = 'VPN'
$ipaddress = '000.000.000.000'
$hub = 'DEFAULT'
$L2tpPsk = 'password'

# VPN 接続情報設定
$user = 'username'
$pass = 'password'

$vpnUser = $hub + '\' + $user

# リモートデスクトップ接続情報設定
$userName = 'user name'
$pcName = '192.168.0.10'

# VPN 接続を確認
$vpn = Get-VpnConnection

if( $vpn.Name -eq $server ) {
	# VPN 接続
	rasdial.exe $server $vpnUser $pass
} else {
	# Windows の VPN 接続を新規作成
	Add-VpnConnection -Name $server -ServerAddress $ipaddress -RememberCredential -TunnelType L2TP -L2tpPsk $L2tpPsk -Force

	# VPN 接続
	rasdial.exe $server $vpnUser $pass
}

$A = ipconfig | Select-String $server

if($A.length -eq "0"){
	Write-Host "VPN 接続に失敗しました、終了します。"

	# VPN 接続を削除
	Remove-VpnConnection -Name $server -Force -PassThru
	exit
}

# リモートデスクトップ接続
$ScriptDir = Get-ChildItem env:SCRIPT_DIR
$rdpPass = Join-Path $ScriptDir.Value remoto.rdp

# RDP ファイルを自動生成
if( -not ( Test-Path -Path $rdpPass ) ) {
	$rdp = @()
	$rdp += 'screen mode id:i:2'
	$rdp += 'use multimon:i:1'
	$rdp += 'desktopwidth:i:1920'
	$rdp += 'desktopheight:i:1080'
	$rdp += 'session bpp:i:32'
	$rdp += 'winposstr:s:0,1,576,212,1872,1019'
	$rdp += 'compression:i:1'
	$rdp += 'keyboardhook:i:2'
	$rdp += 'audiocapturemode:i:0'
	$rdp += 'videoplaybackmode:i:1'
	$rdp += 'connection type:i:6'
	$rdp += 'displayconnectionbar:i:1'
	$rdp += 'disable wallpaper:i:1'
	$rdp += 'allow font smoothing:i:1'
	$rdp += 'allow desktop composition:i:1'
	$rdp += 'disable full window drag:i:1'
	$rdp += 'disable menu anims:i:1'
	$rdp += 'disable themes:i:1'
	$rdp += 'disable cursor setting:i:0'
	$rdp += 'bitmapcachepersistenable:i:1'
	$rdp += 'full address:s:' + $pcName
	$rdp += 'audiomode:i:0'
	$rdp += 'redirectprinters:i:0'
	$rdp += 'redirectcomports:i:0'
	$rdp += 'redirectsmartcards:i:0'
	$rdp += 'redirectclipboard:i:0'
	$rdp += 'redirectposdevices:i:0'
	$rdp += 'redirectdirectx:i:1'
	$rdp += 'autoreconnection enabled:i:0'
	$rdp += 'authentication level:i:2'
	$rdp += 'prompt for credentials:i:1'
	$rdp += 'negotiate security layer:i:1'
	$rdp += 'remoteapplicationmode:i:0'
	$rdp += 'alternate shell:s:'
	$rdp += 'shell working directory:s:'
	$rdp += 'gatewayhostname:s:'
	$rdp += 'gatewayusagemethod:i:4'
	$rdp += 'gatewaycredentialssource:i:4'
	$rdp += 'gatewayprofileusagemethod:i:0'
	$rdp += 'promptcredentialonce:i:1'
	$rdp += 'use redirection server name:i:0'
	$rdp += 'drivestoredirect:s:'
	$rdp += 'networkautodetect:i:1'
	$rdp += 'bandwidthautodetect:i:1'
	$rdp += 'enableworkspacereconnect:i:0'
	$rdp += 'gatewaybrokeringtype:i:0'
	$rdp += 'rdgiskdcproxy:i:0'
	$rdp += 'kdcproxyname:s:'
	$rdp += 'username:s:' + $userName

	# RDP 接続ファイルを書き出し
	$rdp | Out-File $rdpPass
}

# リモートデスクトップ接続を開始
Start mstsc ./remoto.rdp

# VPN 接続後の切断待機処理
Write-Host "VPN に接続中です。切断するには何かキーを押してください。"

Try
{
	Pause
	exit
}
Finally
{
	# VPN 切断
	rasdial.exe $server /disconnect
	Write-Host "VPN から切断しました。"

	# VPN 接続を削除
	Remove-VpnConnection -Name $server -Force -PassThru

	# RDP ファイルを削除
	Remove-Item -Path $rdpPass
}
