@Echo off
@Setlocal enabledelayedexpansion


::------------- Game ----------------::
call :WelcomeScreen
call :initGame
call :Play
call :displayWinner
::-----------------------------------::


::------------- Funcs ---------------::
:WelcomeScreen
    @Mode 78,15
    @Title Tic Tac Toe Game 1.0 ^| Psi505 ^(c^) 2020
    color 1e
    :: Hide the cursor
    Batbox /h 0
    
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
    echo                              Author : Psi505
    echo.
    echo  :=------------------------------------------------------------------------=:
Timeout /t 4 >nul


:initGame
    @Mode 35,14
    @Title Tic Tac Toe Game
    cls
    color 07
    
    :: Define the grid
    set upperSide=/g 11 2 /a 218 /a 196 /a 196 /a 196 /a 194 /a 196 /a 196 /a 196 /a 194 /a 196 /a 196 /a 196 /a 191
    set lowerSide=/g 11 8 /a 192 /a 196 /a 196 /a 196 /a 193 /a 196 /a 196 /a 196 /a 193 /a 196 /a 196 /a 196 /a 217
    set seperator1=/g 11 4 /a 195 /a 196 /a 196 /a 196 /a 197 /a 196 /a 196 /a 196 /a 197 /a 196 /a 196 /a 196 /a 180
    set seperator2=/g 11 6 /a 195 /a 196 /a 196 /a 196 /a 197 /a 196 /a 196 /a 196 /a 197 /a 196 /a 196 /a 196 /a 180
    set middle1=/g 11 3 /a 179 /g 15 3 /a 179 /g 19 3 /a 179 /g 23 3 /a 179
    set middle2=/g 11 5 /a 179 /g 15 5 /a 179 /g 19 5 /a 179 /g 23 5 /a 179
    set middle3= /g 11 7 /a 179 /g 15 7 /a 179 /g 19 7 /a 179 /g 23 7 /a 179

    :: Draw the whole grid
    batbox %upperSide% %middle1% %seperator1% %middle2% %seperator2% %middle3% %lowerSide%
    
    :: Set box positions to display player input
    set Positions=13.3 17.3 21.3 13.5 17.5 21.5 13.7 17.7 21.7
    for %%p in (%Positions%) do (
        set %%p=%%p
        set x=!%%p:~0,2!
        set y=!%%p:~3,1!
        set "%%p= "
        batbox /g !x! !y! /d !%%p!
    )
    
    :: Randomly assign players as X and O
    set /a rand=(%random%*2)/32767 + 1
    batbox /g 17 12 /d "|"
    if %rand%==1 (
        set "Player1=X" & set "Player2=O" & set Player=Player1
    ) else (
        set "Player1=O" & set "Player2=X" & set Player=Player2
    )
Exit /b


:Play
    :: Select the current player
    if "%Player%"=="Player1" (
        batbox /c 0x70 /g 1 12 /d "   Player 1    " /c 0X07 /g 19 12  /d "    Player 2   "
    ) else (
        batbox /c 0X70 /g 19 12  /d "    Player 2   " /c 0x07 /g 1 12 /d "   Player 1    "
    )

    :: Disable Quick Edit for the player to click on cmd with the mouse easily
    disableQuickEdit.exe

    :clickBox
        set clicked=False
        for /f "delims=: tokens=1,2" %%x in ('Batbox /m') do (
            set x=%%x
            set y=%%y
        )

        :: Perform a button press check to identify the pressed area (each box has 3 possible positions)
        if !y!==3 (
            if !x! geq 12 if !x! leq 14 if "!13.3!"==" " (set clicked=True& set "pos=13.3" & goto :Next)
            if !x! geq 16 if !x! leq 18 if "!17.3!"==" " (set clicked=True& set "pos=17.3" & goto :Next)
            if !x! geq 20 if !x! leq 22 if "!21.3!"==" " (set clicked=True& set "pos=21.3" & goto :Next)
        )

        if !y!==5 (
            if !x! geq 12 if !x! leq 14 if "!13.5!"==" " (set clicked=True& set "pos=13.5" & goto :Next)
            if !x! geq 16 if !x! leq 18 if "!17.5!"==" " (set clicked=True& set "pos=17.5" & goto :Next)
            if !x! geq 20 if !x! leq 22 if "!21.5!"==" " (set clicked=True& set "pos=21.5" & goto :Next)
        )

        if !y!==7 (
            if !x! geq 12 if !x! leq 14 if "!13.7!"==" " (set clicked=True& set "pos=13.7" & goto :Next)
            if !x! geq 16 if !x! leq 18 if "!17.7!"==" " (set clicked=True& set "pos=17.7" & goto :Next)
            if !x! geq 20 if !x! leq 22 if "!21.7!"==" " (set clicked=True& set "pos=21.7" & goto :Next)
        )

    if !clicked!==False (goto clickBox)
    
    :: Display 'X' or 'O' at the correct position
    :Next
    set %pos%=!%Player%!
    set x=!pos:~0,2!
    set y=!pos:~3,1!
    batbox /g !x! !y! /d !%pos%!

    
    :: Check for winner
    call :checkWinner Winner
    if !errorlevel!==1 (call :displayWinner !Winner!)
    if !errorlevel!==2 (call :displayWinner)
    if "%Player%"=="Player1" (set Player=Player2) else (set player=Player1)
Goto Play


:checkWinner
    :: Horizontal
    if not "!13.3!"==" "  if "!13.3!"=="!17.3!"  if "!17.3!"=="!21.3!" (set "char=!13.3!" & goto foundWinner)
    if not "!13.5!"==" "  if "!13.5!"=="!17.5!"  if "!17.5!"=="!21.5!" (set "cahr=!17.5!" & goto foundWinner)
    if not "!13.7!"==" "  if "!13.7!"=="!17.7!"  if "!17.7!"=="!21.7!" (set "char=!17.7!" & goto foundWinner)

    :: Vertical
    if not "!13.3!"==" "  if "!13.3!"=="!13.5!"  if "!13.5!"=="!13.7!" (set "char=!13.3!" & goto foundWinner)
    if not "!17.3!"==" "  if "!17.3!"=="!17.5!"  if "!17.5!"=="!17.7!" (set "char=!17.3!" & goto foundWinner)
    if not "!21.3!"==" "  if "!21.3!"=="!21.5!"  if "!21.5!"=="!21.7!" (set "char=!21.3!" & goto foundWinner)

    :: Diagonal
    if not "!13.3!"==" "  if "!13.3!"=="!17.5!"  if "!17.5!"=="!21.7!" (set "char=!13.3!" & goto foundWinner)
    if not "!13.7!"==" "  if "!13.7!"=="!17.5!"  if "!17.5!"=="!21.3!" (set "char=!13.7!" & goto foundWinner)

    :: Confirm no winner exists
    for %%p in (%Positions%) do (if "!%%p!"==" " (Exit /B 0))
    
    Exit /B 2  &:: Tie

    :foundWinner
    if "!Player1!"=="!char!" (set %~1=Player1) else (set %~1=Player2)
Exit /B 1


:displayWinner
    if not "%1"=="" (
        set Winner=%1
        title Winner : %Winner%
    ) else (
        title Tie
    )

    :: Restart button
    batbox /c 0x70 /g 12 10 /d "  Restart  "

    :: Disable Quick Edit for the player to click on cmd with the mouse easily
    disableQuickEdit.exe

    :: Check for a button press on the Restart button
    :clickRestart
        set clickedR=False
        for /f "delims=: tokens=1,2" %%x in ('Batbox /m') do (
            set x=%%x
            set y=%%y
        )
        if !y!==10 if !x! geq 12 if !x! leq 22 (
            set clickedR=True
            set "clear=           "
            batbox /g 12 10 /d !clear!
            goto :initGame
        )
    
    if !clickedR!==False (goto clickRestart)
Exit /B
::-----------------------------------::
