@echo off

tasm loop.asm
tlink loop.obj

dir loop.*

pause
