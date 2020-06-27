#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=Backup for Garmin Edge Devices
#AutoIt3Wrapper_Res_Fileversion=0.1.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Edge-Backup
#AutoIt3Wrapper_Res_ProductVersion=0.10
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include 'BackupFiles.au3'
#include 'log4a.au3'


#Region ;**** Logging ****
; Enable logging and don't write to stderr
_log4a_SetEnable()
; Write to stderr, set min level to warn, customize message format
_log4a_SetErrorStream()
_log4a_SetCompiledOutput($LOG4A_OUTPUT_FILE)
_log4a_SetMinLevel($LOG4A_LEVEL_DEBUG)
; If @compiled Then _log4a_SetMinLevel($LOG4A_LEVEL_WARN) ; Change the min level if the script is compiled
_log4a_SetFormat("${date} | ${host} | ${level} | ${message}")
#EndRegion ;**** Logging ****


Global $backupDir = _BackupFiles('G:\Garmin\Locations', 'c:\Temp', '*.fit')
Global $backupDir2 = _BackupFiles('G:\Garmin\Records', 'c:\Temp', '*.fit')
Global $backupDir3 = _BackupFiles('G:\Garmin\Settings', 'c:\Temp', '*.fit')
Global $backupDir4 = _BackupFiles('G:\Garmin\Sports', 'c:\Temp', '*.fit')
Global $backupDir5 = _BackupFiles('G:\Garmin\Totals', 'c:\Temp', '*.fit')
Global $backupDir6 = _BackupFiles('G:\Garmin\Weight', 'c:\Temp', '*.fit')
