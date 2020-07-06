#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=c:\Program Files (x86)\AutoIt3\Aut2Exe\Icons\SETUP11.ICO
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Backup for Garmin Edge Devices
#AutoIt3Wrapper_Res_Fileversion=0.9.5.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Edge-Backup
#AutoIt3Wrapper_Res_ProductVersion=0.95
#AutoIt3Wrapper_Res_LegalCopyright=2020 - Jeff Burns
#AutoIt3Wrapper_Res_LegalTradeMarks=Licensed under the GNU General Public License v3.0
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
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
; Add'l info used from aweatherall: https://forums.garmin.com/sports-fitness/cycling/f/edge-1030/224731/profile-backup-when-exchanging-unit
; and after the initial 0.50 basic version which took 4 hours, I'm up to a lot more now.  But still less than 3 days effort to get to 0.9.2 ... /jkb :)


;Declare vars
Global $garmindrive = "nope"
Global $homedocs = @HomeDrive & @HomePath & '\Documents'

; Get the time and set that timevar
$sTime = _Date_Time_GetSystemTime()
$sTime = _Date_Time_SystemTimeToDateTimeStr($sTime)
$sTime = StringFormat("%04d/%02d/%02d %02d:%02d:%02d", @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
; Moving the directory string replace stuff into here so it's usable for log target as well.
Local $rep1 = StringReplace($sTime, " ", "-")
Local $rep2 = StringReplace($rep1, "/", "-")
Local $rep3 = StringReplace($rep2, ":", "-")
$rep3 = StringReplace($rep2, ":", "-")
; Set dir string
Local $TargetDir = $homedocs & "\Backups\BACKUP-" & $rep3
Global $logfile = $TargetDir & '\edge-backup.log'

#Region ;**** Logging ****
; Enable logging and don't write to stderr
_log4a_SetEnable()
; Write to stderr, set min level to warn, customize message format
_log4a_SetErrorStream()
_log4a_SetLogFile($logfile)
_log4a_SetCompiledOutput($LOG4A_OUTPUT_FILE)
_log4a_SetMinLevel($LOG4A_LEVEL_DEBUG)
; If @compiled Then _log4a_SetMinLevel($LOG4A_LEVEL_WARN) ; Change the min level if the script is compiled
_log4a_SetFormat("${date} | ${host} | ${level} | ${message}")
#EndRegion ;**** Logging ****

;create logging directory sooner
If (DirCreate($TargetDir) > 0) Then
	_log4a_Info('Creation of Backup Directory Successful: ' & $TargetDir)
Else
	_log4a_Error('Creation of Backup Directory Failed: ' & $TargetDir)
EndIf

;log the above vars after vars and logging setup
_log4a_Info('Documents folder for user detected as : ' & $homedocs)
_log4a_Info('Initial Captured System Date and Time String: ' & $sTime)
_log4a_Info('logging output at: ' & $logfile)


; Time to find the Garmin Edge unit.  Note - it needs plugged in before running
$var = DriveGetDrive("REMOVABLE")
If Not @error Then
	For $i = 1 To $var[0]
		If DriveGetLabel($var[$i]) = "GARMIN" Then
			$garmindrive = ($var[$i])
			_log4a_Info('Garmin Edge unit detected as: ' & $garmindrive)
			;Debugs - uncomment below to get prompted with var
			;MsgBox(4096, "", "Garmindrive var is " & $garmindrive)
		EndIf
	Next
EndIf

If $garmindrive = "nope" Then
	MsgBox(4096, "", "Garmin Edge unit not detected")
	_log4a_Info('Garmin Edge unit NOT detected.  Exiting with sadness and fail')
	Exit (1)
Else
	$garmindirsize = DirGetSize($garmindrive & '\Garmin')
	_log4a_Info("Garmin Edge unit detected. " & $garmindrive & "\Garmin directory size is " & Round($garmindirsize / 1024 / 1024) & "MB")
	$garmindrivefree = DriveSpaceFree($garmindrive)
	_log4a_Info("Garmin Edge unit detected. " & $garmindrive & "\Garmin Edge free space is " & Round($garmindrivefree / 1024 / 1024) & "MB")
	Sleep(100)
EndIf


; Debugs- uncomment below to get prompted with var
; MsgBox(4096, "", "Doco drive " & $homedocs)

; Backup all the directories indicated to backup from Garmin Support
; Yeah, I know... Should have done an array, but well, yeah, I didn't.  :)
Global $backupDir = _BackupFiles($garmindrive & '\Garmin\Locations', $homedocs, '*.fit', $sTime)
Sleep(100)

Global $backupDir2 = _BackupFiles($garmindrive & '\Garmin\Records', $homedocs, '*.fit', $sTime)
Sleep(100)
Global $backupDir3 = _BackupFiles($garmindrive & '\Garmin\Settings', $homedocs, '*.fit', $sTime)
Sleep(100)
Global $backupDir4 = _BackupFiles($garmindrive & '\Garmin\Sports', $homedocs, '*.fit', $sTime)
Sleep(100)
Global $backupDir5 = _BackupFiles($garmindrive & '\Garmin\Totals', $homedocs, '*.fit', $sTime)
Sleep(100)
Global $backupDir6 = _BackupFiles($garmindrive & '\Garmin\Weight', $homedocs, '*.fit', $sTime)

;Adding more directories from aweatherall's post in this thread:  https://forums.garmin.com/sports-fitness/cycling/f/edge-1030/224731/profile-backup-when-exchanging-unit
Global $backupDir7 = _BackupFiles($garmindrive & '\Garmin\Activities', $homedocs, '*.fit', $sTime)
Sleep(100)
Global $backupDir8 = _BackupFiles($garmindrive & '\Garmin\Courses', $homedocs, '*.fit', $sTime)
Sleep(100)
Global $backupDir9 = _BackupFiles($garmindrive & '\Garmin\HMD', $homedocs, '*.fit', $sTime)
Sleep(100)
Global $backupDir10 = _BackupFiles($garmindrive & '\Garmin\Totals', $homedocs, '*.fit', $sTime)
Sleep(100)

;Backing up Apps and their settings
Global $backupDir20 = _BackupFiles($garmindrive & '\Garmin\Apps', $homedocs, '*.prg', $sTime)
Sleep(100)
Global $backupDir21 = _BackupFiles($garmindrive & '\Garmin\Apps\SETTINGS', $homedocs, '*.set', $sTime)
Sleep(100)

MsgBox(4096, "Displaying Results", "Garmin Edge Files backed up to: " & @LF & $TargetDir)
_log4a_Info("Garmin Edge Files backed up under " & $TargetDir)
_log4a_Info("")
_log4a_Info("****   Restore Info Follows  ****")
_log4a_Info("Plug Garmin into PC (x below is the drive letter assigned to your Garmin EDGE")
_log4a_Info("Copy all .FIT files to x:\Garmin\NewFiles")
_log4a_Info("*** When you have apps/widgets, then also do the following ***")
_log4a_Info("Copy .PRG files to x:\Garmin\Apps")
_log4a_Info("Copy .SET files to x:\Garmin\Apps\SETTINGS")
