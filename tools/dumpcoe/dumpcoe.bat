@echo off

@REM Usage: Write MIPS asm in test.asm, execute this batch, and coe file will
@REM        be generated as test.coe. If not, check STDOUT or mars.out for 
@REM        MARS' error message.

del mars.out
del test.coe
del hex.txt

echo.
echo --- MIPS asm ---
type test.asm

@REM MARS command arguments:
@REM     a        = assemble
@REM     dump     = dump
@REM     .text    = code segment
@REM     HexText  = dump format is hex of the instructions

java -jar mars.jar a dump .text HexText hex.txt test.asm >mars.out

echo.
echo.
echo --- MIPS hex ---
type hex.txt

python dump2coe.py

echo.
echo --- generated COE ---
type test.coe