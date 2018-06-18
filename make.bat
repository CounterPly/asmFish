@echo off
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "datestamp=%YYYY%-%MM%-%DD%" & set "timestamp=%HH%%Min%%Sec%" & set "fullstamp=%YYYY%-%MM%-%DD%_%HH%%Min%%Sec%"

REM "asmFish\fasm.exe" "asmFish\asmFishW_base.asm"      -m 50000 "Windows\asmFishW_%datestamp%_base.exe"
REM "asmFish\fasm.exe" "asmFish\asmFishW_popcnt.asm"    -m 50000 "Windows\asmFishW_%datestamp%_popcnt.exe"

"asmFish\fasm.exe" "asmFish\asmFishW_bmi2.asm"      -m 50000 "Windows\asmFishW_%datestamp%_bmi2.exe"

cd Windows

asmFishW_%datestamp%_bmi2 bench 

cd ..
REM "asmFish\fasm.exe" "asmFish\asmFishL_base.asm"      -m 50000 "Linux\asmFishL_%datestamp%_base"
REM "asmFish\fasm.exe" "asmFish\asmFishL_popcnt.asm"    -m 50000 "Linux\asmFishL_%datestamp%_popcnt"
REM "asmFish\fasm.exe" "asmFish\asmFishL_bmi2.asm"      -m 50000 "Linux\asmFishL_%datestamp%_bmi2"

REM "asmFish\fasm.exe" "asmFish\mateFishW_base.asm"      -m 50000 "Matefinder\mateFishW_%datestamp%_base.exe"
REM "asmFish\fasm.exe" "asmFish\mateFishW_popcnt.asm"    -m 50000 "Matefinder\mateFishW_%datestamp%_popcnt.exe"
REM "asmFish\fasm.exe" "asmFish\mateFishW_bmi2.asm"      -m 50000 "Matefinder\mateFishW_%datestamp%_bmi2.exe"
REM "asmFish\fasm.exe" "asmFish\mateFishL_base.asm"      -m 50000 "Matefinder\mateFishL_%datestamp%_base"
REM "asmFish\fasm.exe" "asmFish\mateFishL_popcnt.asm"    -m 50000 "Matefinder\mateFishL_%datestamp%_popcnt"
REM "asmFish\fasm.exe" "asmFish\mateFishL_bmi2.asm"      -m 50000 "Matefinder\mateFishL_%datestamp%_bmi2"

