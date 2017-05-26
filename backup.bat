@echo off
setlocal enableextensions enabledelayedexpansion

REM Our messages. Change if you want a different language.
set prompt=What have you achieved?
set creatingbackup=Creating backup.
set nosave=Cannot find save file.
set createfolder=Creating backup folder.
set backupexsits=Backup already exists.
set success=Backup successful.

REM Our variables!
set backup=%~dp0Backups\
set savegame=%appdata%\DarkSoulsIII\

REM Quit if savefile cannot be found.
if not exist "%savegame%" (
  echo %nosave%
  pause
  exit
  )

REM Create a backup folder if one cannot be found.
if not exist "%backup%" (
  echo %createfolder%
  mkdir %backup%
  )

REM Request a name for our backup.
set /p comment="%prompt% -> "

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
  echo %backupexsits%
  pause
  exit
  )

REM Make the folder and copy over game files.
echo %creatingbackup%
mkdir "%latest%"
xcopy /s /e /q "%savegame%*" "%latest%"
echo %success%

REM Pause if executed directly.
REM https://stackoverflow.com/questions/3551888/pausing-a-batch-file-when-double-clicked-but-not-when-run-from-a-console-window
ECHO %cmdcmdline% | findstr /i /c:"%~nx0" >NUL 2>&1 && PAUSE
