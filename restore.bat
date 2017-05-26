@echo off
setlocal enabledelayedexpansion

REM Our messages. Change if you want a different language.
set nosave=Cannot find save file.
set nobackup=Cannot find the backup folder.
set restore=Pick a backup number to restore.
set confirm=Restoring this backup will override any progress you have made. Are you sure?
set abort=Restore aborted.
set done=Backup restored.
set restoring=Restoring
set success=Restore success. Have fun.

REM Our variables!
set backup=%~dp0Backups\
set savegame=%appdata%\DarkSoulsIII\
set restorelimit=8

REM Quit if savefile cannot be found.
if not exist "%savegame%" (
  echo %nosave%
  goto eof
  )

REM Quit if backup folder cannot be found.
if not exist "%backup%" (
  echo %nobackup%
  goto eof
  )

REM Get backups.
set files=
set count=%restorelimit%
for /d %%D in ("%backup%*") do (
  if !count! gtr 0 (
    set /a count=!count! - 1
    set files=!files! "%%~nxD"
    )
  )

REM Ask for backup selection.
set count=0
for %%m in (!files!) do (
  set /a count=!count! + 1
  echo !count! -- %%m
  )

:ask
set /p restorenum="%restore% [1 ~ !count!]-> "
if %restorenum% lss 1 (
  goto ask
  )
if %restorenum% gtr !count! (
  goto ask
  )

REM Ask for confirmation and restore.
set /p yesno="%confirm% [Y/N] -> "
if /I "%yesno%" equ "y" (
  set count=0
  for %%f in (!files!) do (
    set /a count=!count! + 1
    if !count! equ %restorenum% (
      echo %restoring% %%f
      xcopy /s /e /q /y "%backup%%%~nf\*" "%savegame%"
      echo %success%
      goto eof
        )
    )
  ) else (
    echo %abort%
    )
:eof
pause
