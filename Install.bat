rem Written By: Cole C. Patterson
rem Date: 2020.09.15

echo off
echo Installing NXLog Config file

rem Ask you to sign into a Admianistrator ccount
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

rem starts installing the NXLog program 
start /w \\Servername\NXLog.msi /passive


rem removes the default file that nxlog creates
del C:\"Program Files (x86)"\nxlog\conf\nxlog.conf 

rem copies our systems nxlog config
copy "\\Servername\nxlog.conf"  "C:\Program Files (x86)\nxlog\conf"

rem stops the service nxlog
net stop nxlog
rem starts the service nxlog
net start nxlog


rem removes all files that are copied over
del C:\Users\%username%\Desktop\NXLog.bat /q
