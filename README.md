# Automation
Automate all the boring things

#Finding an old office key
cd 'C:\Program Files\Microsoft Office\Office16\'
cscript .\OSPP.vbs /dstatus

#Install O365 with exclusions

Needs to be ran in PS
Sample 1
```choco install microsoft-office-deployment --params='/64bit /Product:HomeStudent2019Retail /Exclude=Publisher,Outlook,Lync,Groove,Access'```
Sample 2
```choco install microsoft-office-deployment --params='/64bit /Product:Office19ProPlus2019R_Retail /Exclude=Publisher,Outlook,Lync,Groove,Access'```

#Convert Windows 10 Enterprise Eval to Windows 10 Enterprise

```
$GenericKey='NPPR9-FWDCX-D2C8J-H872K-2YT43'
$ProducKey=<NEED_TO_BUY>
wget https://appsforpcfree.net/skus-Windows-10.zip
unzip skus-Windows-10.zip C:\Windows\System32\spp\tokens\skus\
slmgr.vbs /rilc
slmgr.vbs /upk >nul 2>&1
slmgr.vbs /ckms >nul 2>&1
slmgr.vbs /cpky >nul 2>&1
slmgr.vbs /ipk $GenericKey
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
slmgr.vbs /ipk $ProductKey
shutdown /r /t 0```
