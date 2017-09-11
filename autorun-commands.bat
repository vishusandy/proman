@echo off
:: HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\AutoRun\REG_SZ 
:: HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun REG_EXPAND_SZ

:: DOSKEY cd=cd $1$Tdir ^& inject_pm.bat
DOSKEY cd=cd $1 ^& inject_pm.bat

echo on