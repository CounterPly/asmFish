@echo off
cd ..
ECHO.
ECHO ==========
ECHO AUTO-BENCH
ECHO ==========
ECHO.

ECHO === Building Windows BMI2 Executable ===
set include=x86\include\
"fasmg.exe" "x86\fish.asm" "asmFish_benchMatch_bmi2.exe" -e 1000 -i "VERSION_OS='W'" -i "PEDANTIC = 1" -i "VERSION_POST = 'bmi2'"
ECHO.
ECHO Performing Bench...
ECHO.
ECHO ===========================
call asmFish_benchMatch_bmi2.exe bench
del asmFish_benchMatch_bmi2.exe
ECHO.
ECHO Bench Complete!
cd x86


REM ECHO === Building Windows Base Executable ===
REM set include=x86\include\
REM :: "fasmg.exe" "x86\fish.asm" "asmFish_benchMatch_base.exe" -e 1000 -i "VERSION_OS='W'" -i "PEDANTIC = 1" -i "VERSION_POST = 'base'"
REM "fasmg.exe" "x86\fish.asm" "asmFish_benchMatch_base.exe" -e 1000 -i "VERSION_OS='W'" -i "PEDANTIC = 1" -i "VERSION_POST = 'base'"
REM ECHO.
REM ECHO Performing Bench...
REM ECHO.
REM ECHO ===========================
REM call asmFish_benchMatch_base.exe bench
REM del asmFish_benchMatch_base.exe
REM ECHO.
REM ECHO Bench Complete!
REM cd x86