@echo off
setlocal

REM Change the text here to whatever locale you like.
set MSG_nobackup=Failed to find backup.bat

REM variables!
set backupscript=%~dp0backup.bat

REM Check if backup script is here.
if not exist "%~dp0backup.bat" (
  echo %MSG_nobackup%
  pause
  exit
  )

REM Run the game!
start steam://rungameid/374320

REM Loop forever, asking for backups.
:doit
call %backupscript%
goto doit
