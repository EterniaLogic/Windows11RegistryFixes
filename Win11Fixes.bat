@echo off
pause
title Windows 11
mode con:cols=80 lines=20

REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto firstpage
) else ( 
	goto gotAdmin
)

:firstpage
cls
echo Where are you running this script on?
echo.
echo  1. On the currently running Windows
echo  2. On the installation
echo.
echo.
echo Do NOT choose option 1 if you are on the installation!
echo It will cause an infinite loop!
echo.
set /p input=Input: 
if /i "%input%" == "1" (
	set "input="
	goto BatchGotAdmin
) 
if /i "%input%" == "2" (
	set "input="
	goto main
) else (
	set "input="
	goto firstpage
)

:BatchGotAdmin
REM https://sites.google.com/site/eneerge/scripts/batchgotadmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
	cls
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:main
cls
echo ================================================================================
echo  Windows 11 'Fixes'
echo ================================================================================
echo.

echo Adding key "BypassCPUCheck" into registry...
reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /f /t REG_DWORD /d 1 > nul
echo Adding key "BypassStorageCheck" into registry...
reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /f /t REG_DWORD /d 1 > nul
echo Adding key "BypassRAMCheck" into registry...
reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /f /t REG_DWORD /d 1 > nul
echo Adding key "BypassTPMCheck" into registry...
reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /f /t REG_DWORD /d 1 > nul
echo Adding key "BypassSecureBootCheck" into registry...
reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /f /t REG_DWORD /d 1 > nul
echo Adding additional key "AllowUpgradesWithUnsupportedTPMOrCPU" into registry...
reg add "HKLM\SYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /f /t REG_DWORD /d 1 > nul
echo.
echo special fixes... Context Menu, Search Settings, Bing Search, Cortana
pause
echo Adding Context Menu fix "InprocServer32" into registry...
reg add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /d "" /f
echo Disabling Search Highlights.
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDynamicSearchBoxEnabled" /d 0 /t REG_DWORD /f
echo Disabling Bing Search in Start Menu
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /f /t REG_DWORD /d 1
echo Disabling Cortana
reg add "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /f /t REG_DWORD /d 0
echo.
echo Please restart to make these changes.
pause
