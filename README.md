# automation
automate all the boring things

#Install O365 with exclusions

Needs to be ran in PS

`choco install microsoft-office-deployment --params='/64bit /Product:HomeStudent2019Retail /Exclude=Publisher,Outlook,Lync,Groove,Access'`
