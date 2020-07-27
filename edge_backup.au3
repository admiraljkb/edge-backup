#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=c:\Program Files (x86)\AutoIt3\Aut2Exe\Icons\SETUP11.ICO
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Backup for Garmin Edge and Forerunner Devices
#AutoIt3Wrapper_Res_Fileversion=0.9.7.10
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Edge-Backup
#AutoIt3Wrapper_Res_ProductVersion=0.97
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
Global $sItem

$oDirectory_File = ObjCreate("Scripting.Dictionary")
If @error Then
	MsgBox(0, '', 'Error creating the dictionary object')
	Exit (1)
Else
	; Add keys with items
	$oDirectory_File.Add("\Garmin\Locations", "*.fit")
	$oDirectory_File.Add("\Garmin\Records", "*.fit")
	$oDirectory_File.Add("\Garmin\Settings", "*.fit")
	$oDirectory_File.Add("\Garmin\Sports", "*.fit")
	$oDirectory_File.Add("\Garmin\Totals", "*.fit")
	$oDirectory_File.Add("\Garmin\Weight", "*.fit")
	$oDirectory_File.Add("\Garmin\Activities", "*.fit")
	$oDirectory_File.Add("\Garmin\Courses", "*.fit")
	$oDirectory_File.Add("\Garmin\HMD", "*.fit")

	$oDirectory_File.Add("\Garmin\Apps", "*.prg")
	$oDirectory_File.Add("\Garmin\Apps\SETTINGS", "*.set")
EndIf


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
Global $TargetDir = $homedocs & "\Backups\BACKUP-" & $rep3
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

If @Compiled Then
	_log4a_Info("edge_backup version: " & FileGetVersion(@ScriptFullPath))
Else

EndIf

;log the above vars after vars and logging setup
_log4a_Info('Documents folder for user detected as : ' & $homedocs)
_log4a_Info('Initial Captured System Date and Time String: ' & $sTime)
_log4a_Info('logging output at: ' & $logfile)


; Time to find the Garmin Edge unit.  Note - it needs plugged in before running
$drive = DriveGetDrive("REMOVABLE")
If Not @error Then
	For $i = 1 To $drive[0]
		If DriveGetLabel($drive[$i]) = "GARMIN" Then
			$garmindrive = ($drive[$i])
			$devicetype = IniRead($garmindrive & "\AUTORUN.INF", "autorun", "label", "nope")
			$newtarget = $homedocs & "\Backups\" & $devicetype & "_BACKUP-" & $rep3
			Sleep(100)

			For $vKey In $oDirectory_File
				$sItem &= $oDirectory_File.Item($vKey) & @CRLF
			Next

			; Add items into an array
			$aItems = $oDirectory_File.Items
			; Add keys into an array
			$aKeys = $oDirectory_File.Keys

			_BackuptheThings($garmindrive, $devicetype, $newtarget)
			;Debugs - uncomment below to get prompted with var
			;MsgBox(4096, "", "Garmindrive var is " & $garmindrive)
		EndIf
	Next
EndIf

If $garmindrive = "nope" Then
	MsgBox(4096, "", "Garmin Edge / Forerunner unit not detected")
	_log4a_Info('Garmin Edge / Forerunner unit NOT detected.  Exiting with sadness and fail')
	Exit (1)
Else

EndIf


; Debugs- uncomment below to get prompted with var
; MsgBox(4096, "", "Doco drive " & $homedocs)

; Backup all the directories indicated to backup from Garmin Support
; Yeah, I know... Should have done an array, but well, yeah, I didn't.  :)
Func _BackuptheThings($gdrive, $dtype, $newtarget)
	If (DirCreate($TargetDir) > 0) Then
		_log4a_Info('Creation of Backup Directory Successful: ' & $TargetDir)
	Else
		_log4a_Error('Creation of Backup Directory Failed: ' & $TargetDir)
	EndIf
	DirMove($TargetDir, $newtarget)
	Local $logfile = $newtarget & '\edge-backup.log'
	_log4a_SetLogFile($logfile)
	Sleep(300)
	_log4a_Info("*** moved " & $TargetDir & " to " & $newtarget & " ***")
	_log4a_Info($dtype & ' found at: ' & $gdrive)
	Global $garmindirsize = DirGetSize($gdrive & '\Garmin')
	_log4a_Info($dtype & " detected. " & $gdrive & "\Garmin directory size is " & Round($garmindirsize / 1024 / 1024) & "MB")
	Global $garmindrivefree = DriveSpaceFree($gdrive)
	_log4a_Info($dtype & " detected. " & $gdrive & " free space is " & Round($garmindrivefree / 1024 / 1024) & "MB")

	For $i = 0 To $oDirectory_File.Count - 1
		$backupDir = _BackupFiles($gdrive & $aKeys[$i], $newtarget, $aItems[$i], $sTime)
		If @error Then
			_log4a_Info("Errors detected backing up " & $aKeys[$i] & "\" & $aItems[$i])
		EndIf
	Next

	MsgBox(4096, "Displaying Results", $dtype & " Files backed up to: " & @LF & $newtarget)
	_log4a_Info($dtype & " Files backed up under " & $newtarget)
	_log4a_Info("")
	_log4a_Info("****   Restore Info Follows  ****")
	_log4a_Info("Plug Garmin into PC (x below is the drive letter assigned to your " & $dtype)
	_log4a_Info("Copy all .FIT files to x:\Garmin\NewFiles")
	_log4a_Info("*** When you have apps/widgets, then also do the following ***")
	_log4a_Info("Copy .PRG files to x:\Garmin\Apps")
	_log4a_Info("Copy .SET files to x:\Garmin\Apps\SETTINGS")
EndFunc   ;==>_BackuptheThings
