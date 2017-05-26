@echo off
setlocal enabledelayedexpansion

REM Our messages. Change if you want a different language.
set MSG_nosave=Cannot find save file.
set MSG_nobackup=Cannot find the backup folder.
set MSG_restore=Pick a backup number to restore.
set MSG_confirm=Restoring this backup will override any progress you have made. Are you sure?
set MSG_abort=Restore aborted.
set MSG_restoring=Restoring
set MSG_success=Restore success. Have fun.

REM Our variables!
set backup=%~dp0Backups\
set savegame=%appdata%\DarkSoulsIII\
set restorelimit=8

REM Quit if savefile cannot be found.
if not exist "%savegame%" (
  echo %MSG_nosave%
  goto eof
  )

REM Quit if backup folder cannot be found.
if not exist "%backup%" (
  echo %MSG_nobackup%
  goto eof
  )

REM Get backups.
set files=
set count=%restorelimit%
for /f "delims=" %%D in ('dir %backup% /b /ad /o-n') do (
  if !count! gtr 0 (
    set /a count=!count! - 1
    set files=!files! "%%D"
    )
  )


REM Ask for backup selection.
set count=0
for %%m in (!files!) do (
  set /a count=!count! + 1
  echo !count! -- %%m
  )

:ask
set /p restorenum="%MSG_restore% [1 ~ !count!]-> "
if %restorenum% lss 1 (
  goto ask
  )
if %restorenum% gtr !count! (
  goto ask
  )

REM Ask for confirmation and restore.
set /p yesno="%MSG_confirm% [Y/N] -> "
if /I "%yesno%" equ "y" (
  set count=0
  for %%f in (!files!) do (
    set /a count=!count! + 1
    if !count! equ %restorenum% (
      echo %MSG_restoring% %%f
      xcopy /s /e /q /y "%backup%%%~nf\*" "%savegame%"
      echo %MSG_success%
      goto eof
        )
    )
  ) else (
    echo %MSG_abort%
    )
:eof
pause
