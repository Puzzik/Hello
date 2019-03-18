$strSSID = "HomeNet5"
$strWiFipassword = "MAX17111993"
$strPath = "$home\desktop\Contact\wifi.png"
New-QRCodeWifiAccess -SSID $strSSID -Password $strWiFipassword -Width 10 -OutPath $strPath