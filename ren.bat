@echo off
for /D %%x in (%a%*) do if not defined f set "f=%%x"
SET pa=%p%%f%
ren "%pa%" "extract"
pause