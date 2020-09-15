REM run as admin
@echo off
schtasks /create /tn "Chocolatey Update" /tr "cup all -y" /sc daily /st 04:00 /ru System 
