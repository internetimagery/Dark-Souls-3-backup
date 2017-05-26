@echo off

REM Our variables!
set backup=%~dp0Backups\
set savegame=%appdata%\DarkSoulsIII\

REM Quit if savefile cannot be found.
if not exist %savegame% (
  echo Cannot find save file.
  pause
  exit
  )

REM Create a backup folder if one cannot be found.
if not exist %backup% (
  echo Creating backup folder.
  mkdir %backup%
  )

REM Request a name for our backup.
set /p name="What did you do last? -> "

REM Get the current date and time.
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%b-%%a)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
echo %mydate%_%mytime%


for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%
echo Local date is [%ldt%]

pushd "%temp%"
makecab /D RptFileName=~.rpt /D InfFileName=~.inf /f nul >nul
for /f "tokens=3-7" %%a in ('find /i "makecab"^<~.rpt') do (
   set "current-date=%%e-%%b-%%c"
   set "current-time=%%d"
   set "weekday=%%a"
)
del ~.*
popd
echo %weekday% %current-date% %current-time%
pause
