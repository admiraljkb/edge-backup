#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=c:\Program Files (x86)\AutoIt3\Aut2Exe\Icons\SETUP11.ICO
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Backup for Garmin Edge Devices
#AutoIt3Wrapper_Res_Fileversion=0.1.0.7
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Edge-Backup
#AutoIt3Wrapper_Res_ProductVersion=0.10
#AutoIt3Wrapper_Res_LegalCopyright=2020 - Jeff Burns
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include 'BackupFiles.au3'
#include 'log4a.au3'

; Garmin Edge Backup Utility
; Author - Jeff Burns
; Created because Garmin 1030 units seem to need a lot of hard resets, particularly after 9.x version firmware
; Reconfiguring is quite a pain after a reset, and so is manually backing up.  So here we are with "EdgeBackup"!
; Garmin - this util only took me roughly 4 hours.  Why couldn't y'all do it?  XOXO  :)
; Using info provided from Garmin Support here: https://support.garmin.com/en-MY/?faq=eWswdSH4aC3xrXxmQj7U9A

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

;Declare vars
Global $garmindrive
Global $homedocs = @HomeDrive & @HomePath & '\Documents'

; Time to find the Garmin Edge unit.  Note - it needs plugged in before running
$var = DriveGetDrive("REMOVABLE")
If Not @error Then
	For $i = 1 To $var[0]
		If DriveGetLabel($var[$i]) = "GARMIN" Then
			$garmindrive = ($var[$i])
			;Debugs - uncomment below to get prompted with var
			;MsgBox(4096, "", "Garmindrive var is " & $garmindrive)
		EndIf
	Next
EndIf

; Debugs- uncomment below to get prompted with var
; MsgBox(4096, "", "Doco drive " & $homedocs)

; Backup all the directories indicated to backup from Garmin Support
; Yeah, I should have done an array, but well, yeah, I didn't.  :)
Global $backupDir = _BackupFiles($garmindrive & '\Garmin\Locations', $homedocs, '*.fit')
Global $backupDir2 = _BackupFiles($garmindrive & '\Garmin\Records', $homedocs, '*.fit')
Global $backupDir3 = _BackupFiles($garmindrive & '\Garmin\Settings', $homedocs, '*.fit')
Global $backupDir4 = _BackupFiles($garmindrive & '\Garmin\Sports', $homedocs, '*.fit')
Global $backupDir5 = _BackupFiles($garmindrive & '\Garmin\Totals', $homedocs, '*.fit')
Global $backupDir6 = _BackupFiles($garmindrive & '\Garmin\Weight', $homedocs, '*.fit')
