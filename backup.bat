@echo off
setlocal enableextensions enabledelayedexpansion

REM Our messages. Change if you want a different language.
set MSG_prompt=What have you achieved?
set MSG_creatingbackup=Creating backup.
set MSG_nosave=Cannot find save file.
set MSG_createfolder=Creating backup folder.
set MSG_backupexsits=Backup already exists.
set MSG_success=Backup successful.

REM Our variables!
set backup=%~dp0Backups\
set savegame=%appdata%\DarkSoulsIII\

REM Quit if savefile cannot be found.
if not exist "%savegame%" (
  echo %MSG_nosave%
  goto eof
  )

REM Create a backup folder if one cannot be found.
if not exist "%backup%" (
  echo %MSG_createfolder%
  mkdir %backup%
  )

REM Request a name for our backup.
set /p comment="%MSG_prompt% -> "

REM Sanitize input.
REM https://stackoverflow.com/questions/19855925/removing-non-alphanumeric-characters-in-a-batch-variable
set _input="%date%_%time%_%comment%"
set "_output="
:loop
if not defined _input goto endLoop
set "_buf=!_input:~0,1!"
set "_input=!_input:~1!"
echo "!_buf!"|findstr /i /r /c:"[a-z 0-9_]" > nul && set "_output=!_output!!_buf!"
goto loop
:endLoop
set latest=%backup%!_output!\

REM Check folder isn't already there.
if exist "%latest%" (
  echo %MSG_backupexsits%
  goto eof
  )

REM Make the folder and copy over game files.
echo %MSG_creatingbackup%
mkdir "%latest%"
xcopy /s /e /q "%savegame%*" "%latest%"
echo %MSG_success%

REM Pause if executed directly.
REM https://stackoverflow.com/questions/3551888/pausing-a-batch-file-when-double-clicked-but-not-when-run-from-a-console-window
:eof
ECHO %cmdcmdline% | findstr /i /c:"%~nx0" >NUL 2>&1 && PAUSE
