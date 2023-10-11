@echo off
color 0E
echo ^+-------------------------------------------------^+
echo ^|------ AUTO CREATE PROJECT STRUCTURE TSK ------- ^|
echo ^|--------------- Make by NTD -------------------- ^|
echo ^|                                                 ^|
echo ^|                                                 ^|
echo ^|     " _____             ____        _          "^|
echo ^|     "|_   _|_ _ _ __   |  _ \  __ _| |_        "^|
echo ^|     "  | |/ _` | '_ \  | | | |/ _` | __|       "^|
echo ^|     "  | | (_| | | | | | |_| | (_| | |_        "^|
echo ^|     "  |_|\__,_|_| |_| |____/ \__,_|\__|       "^|
echo ^|                                                 ^|
echo ^|                                                 ^|
echo ^| Link project to pull :                          ^|
echo ^| https://cube-vn.backlog.com/git/TSK/TSK_TMP.git ^|
echo ^|                                                 ^|
echo ^+-------------------------------------------------^+
echo.

setlocal
REM Set the URL of the Git repository
set gitRepoUrl=https://cube-vn.backlog.com/git/TSK/TSK_TMP.git

REM Set the local directory where you want to clone the repository
set localDirectory=C:\Users\tandat\Desktop\TSK

REM Check if the local directory exists; if not, create it
if not exist "%localDirectory%" (
	mkdir "%localDirectory%"
)

REM Change the current working directory to the local directory
cd /d "%localDirectory%"
echo Local directory to clone : %localDirectory%
echo.

:checkfolder
set /p userInput=Please enter your branch you need checkout before pull: 
echo.

echo Branch name want to checkout : %userInput%

REM Combine the local directory with user input to create a full path
set fullPath=%localDirectory%\%userInput%
if exist "%fullPath%" (
	echo.
	echo The folder exists. Please check again
	set userInput=
	goto checkfolder
)
echo.

echo Checking git repository ...
git ls-remote "%gitRepoUrl%" > nul 2>&1
echo.
if errorlevel 1 (
	echo The Git repository does not exist or is not available.
) else (
	echo The Git repository is available.
)

cd /d "%localDirectory%"
git clone "%gitRepoUrl%" %userInput%

if errorlevel 1 (
	echo Cloning failed.
) else (
	echo Repository has been cloned into "%userInput%" folder.
)

cd /d "%fullPath%"
git checkout develop
git checkout  -b %userInput% develop
echo.
echo Created and switched to branch %branchName% successfully.
echo.

setlocal enabledelayedexpansion

:menu
echo Select an program you want to open this:
echo [1] Visual Studio Code
echo [2] Microsoft Visual Studio
echo [3] Exit

set "option=1"
choice /n /c:1234 /m " "

if errorlevel 3 (
	echo Exiting the menu.
	exit /b
) else (
	set "option=!errorlevel!"
	goto execute_option
)

:execute_option
if %option%==1 (
	for /r "%fullPath%" %%i in (*.sln) do (
		start %%i
	)
) else if %option%==2 (
	code %fullPath% | exit
) else if %option%==3 (
	exit	
)
