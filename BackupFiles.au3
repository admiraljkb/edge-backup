#include-once
#include <Date.au3>
#include <FileConstants.au3>
#include "log4a.au3"


; #FUNCTION# ====================================================================================================================
; Name ..........: _BackupFiles
; Description ...:
; Syntax ........: _BackupFiles($from, $to, $filespec)
; Parameters ....: $from        - dirctory you wish to back up
;                  $to          - base directory where output goes
;                  $filespec    - filename. supports wildcards
;								- if $filespec = '' then it copies entire directory and all files
;				   $sTime		- System time var.  Declared in calling script and passed into function.
; Return values .: Unique, Time/Date stamped folder name containing the backups
; Author ........: Peter Martin
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _BackupFiles($from, $to, $filespec, $sTime)
	; Get the time
	; now passing sTime in as VAR. /jkb
	; Local $sTime = _Date_Time_GetSystemTime()
	; convert to string
	; $sTime = _Date_Time_SystemTimeToDateTimeStr($sTime)
	; $sTime = StringFormat("%04d/%02d/%02d %02d:%02d:%02d", @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
	; _log4a_Info('Inside BackupFiles Function - Captured System Date and Time String: ' & $sTime)

	Local $rep1 = StringReplace($sTime, " ", "-")
	Local $rep2 = StringReplace($rep1, "/", "-")
	Local $rep3 = StringReplace($rep2, ":", "-")
	$rep3 = StringReplace($rep2, ":", "-")
	; Set dir string
    Local $TargetDir = $to &"\Backups\BACKUP-" & $rep3

	If (DirCreate($TargetDir) > 0) Then
		_log4a_Info('Creation of Backup Directory Successful: ' & $TargetDir)
		; copy file to backup location
		If ( Stringlen($filespec) = 0 ) Then
			If (DirCopy($from, $TargetDir, 1) = 1) Then
				_log4a_Info('Directory Copy Successful: ' & $TargetDir & '\' & $filespec)
			Else
				_log4a_Info('Directory Copy Unsuccessful: ' & $TargetDir & '\' & $filespec)
			Endif
		Else
			If (FileCopy($from &"\"&$filespec, $TargetDir, 1) = 1) Then
				_log4a_Info('File Copy Successful: ' & $TargetDir & '\' & $filespec)
			Else
				_log4a_Info('File Copy Unsuccessful: ' & $TargetDir & '\' & $filespec)
			EndIf
		EndIf
	Else
		_log4a_Error('Creation of Backup Directory Failed: ' & $TargetDir)
	EndIf

	return($TargetDir)
EndFunc
