@Echo off
@Setlocal enabledelayedexpansion


::------------- Game ----------------::
call :Info
call :Settings
call :Play
call :Winner_Display
::-----------------------------------::


::------------- Funcs ---------------::
:Info
    @Mode 78,15
    @Title Tic Tac Toe Game 1.0 ^| Hamza Guesmi ^(c^) 2020
    color 1e
    echo.
    echo  :=------------------------------------------------------------------------=:
    echo.
    echo        ______  _             ______                    ______             
    echo       /_  __/ ^(_^) _____     /_  __/ ____ _  _____     /_  __/ ____   ___ 
    echo        / /   / / / ___/      / /   / __ `/ / ___/      / /   / __ \ / _ \
    echo       / /   / / / /__       / /   / /_/ / / /__       / /   / /_/ //  __/
    echo      /_/   /_/  \___/      /_/    \__,_/  \___/      /_/    \____/ \___/
    echo.
    echo.
    echo.
    echo                              Author : Hamza Guesmi
    echo.
    echo  :=------------------------------------------------------------------------=:
Timeout /t 4 >nul


:Settings
    @Mode 35,14
    @Title Tic Tac Toe Game
    cls
    :: Generating files
    if not exist Batbox.exe (certutil -decode Batbox Batbox.exe 1>nul)
    if not exist fn.dll (certutil -decode Batbox fn.dll 1>nul)

    Fn.dll font 8
    Batbox /h 0
    batbox /g 14 2 /a 218 /a 196 /a 194 /a 196 /a 194 /a 196 /a 191
    batbox /g 14 3 /a 179 /g 16 3 /a 179 /g 18 3 /a 179 /g 20 3 /a 179
    batbox /g 14 4 /a 195 /a 196 /a 197 /a 196 /a 197 /a 196 /a 180
    batbox /g 14 5 /a 179 /g 16 5 /a 179 /g 18 5 /a 179 /g 20 5 /a 179
    batbox /g 14 6 /a 195 /a 196 /a 197 /a 196 /a 197 /a 196 /a 180
    batbox /g 14 7 /a 179 /g 16 7 /a 179 /g 18 7 /a 179 /g 20 7 /a 179
    batbox /g 14 8 /a 192 /a 196 /a 193 /a 196 /a 193 /a 196 /a 217
    set Positions=15.3 17.3 19.3 15.5 17.5 19.5 15.7 17.7 19.7
    for %%p in (%Positions%) do (
        set %%p=%%p
        set x=!%%p:~0,2!
        set y=!%%p:~3,1!
        set "%%p= "
        batbox /g !x! !y! /d !%%p!
    )
    set /a rand=(%random%*2)/32767 + 1
    batbox /g 17 12 /d "|" 
    batbox /g 1 12 /d "   Player 1    "
    batbox /g 19 12  /d "    Player 2   "
    if %rand%==1 (
        set "Player1=X" & set "Player2=O" & set Player=Player1
    ) else (
        set "Player1=O" & set "Player2=X" & set Player=Player2
    )
Exit /b


:Play
    if "%Player%"=="Player1" (
        batbox /c 0x70 /g 1 12 /d "   Player 1    " /c 0X07 /g 19 12  /d "    Player 2   "
    ) else (
        batbox /c 0X70 /g 19 12  /d "    Player 2   " /c 0x07 /g 1 12 /d "   Player 1    "
    )

    :Click
        set clicked=False
        for /f "delims=: tokens=1,2" %%x in ('Batbox /m') do (set pos=%%x.%%y)
        for %%p in (%Positions%) do (
            if "%pos%"=="%%p" if "!%%p!"==" " (
                set clicked=True
                set %%p=!%Player%!
                set x=!pos:~0,2!
                set y=!pos:~3,1!
                batbox /g !x! !y! /d !%%p!
            )
        )
    if !clicked!==False (goto Click)
    
    :: Checking for winner
    call :Winner_Check Winner
    if !errorlevel!==1 (call :Winner_Display !Winner!)
    if !errorlevel!==2 (call :Winner_Display)
    if "%Player%"=="Player1" (set Player=Player2) else (set player=Player1)
Goto Play


:Winner_Check
    :: Horizontal
    if not "!15.3!"==" "  if "!15.3!"=="!17.3!"  if "!17.3!"=="!19.3!" (set "char=!15.3!" & goto Winner_Found)
    if not "!15.5!"==" "  if "!15.5!"=="!17.5!"  if "!17.5!"=="!19.5!" (set "cahr=!15.5!" & goto Winner_Found)
    if not "!15.7!"==" "  if "!15.7!"=="!17.7!"  if "!17.7!"=="!19.7!" (set "char=!15.7!" & goto Winner_Found)

    :: Vertical
    if not "!15.3!"==" "  if "!15.3!"=="!15.5!"  if "!15.5!"=="!15.7!" (set "char=!15.3!" & goto Winner_Found)
    if not "!17.3!"==" "  if "!17.3!"=="!17.5!"  if "!17.5!"=="!17.7!" (set "char=!17.3!" & goto Winner_Found)
    if not "!19.3!"==" "  if "!19.3!"=="!19.5!"  if "!19.5!"=="!19.7!" (set "char=!19.3!" & goto Winner_Found)

    :: Diagonal
    if not "!15.3!"==" "  if "!15.3!"=="!17.5!"  if "!17.5!"=="!19.7!" (set "char=!15.3!" & goto Winner_Found)
    if not "!15.7!"==" "  if "!15.7!"=="!17.5!"  if "!17.5!"=="!19.3!" (set "char=!15.7!" & goto Winner_Found)

    :: Checking if there is no winner
    for %%p in (%Positions%) do (if "!%%p!"==" " (Exit /B 0))
    
    Exit /B 2  &:: Tie

    :Winner_Found
    if "!Player1!"=="!char!" (set %~1=Player1) else (set %~1=Player2)
Exit /B 1


:Winner_Display
    if not "%1"=="" (title Winner : %1) else (title Tie)
    pause>nul 
Exit /B
::-----------------------------------::