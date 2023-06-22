@echo off


if "%1" == "release" (
  mkdir bin\release
  odin build src\main.odin -file -out:bin\release\pong.exe -show-timings
  .\bin\release\pong.exe

) else (

  mkdir bin\debug
  odin build src\main.odin -file -out:bin\debug\pong.exe -debug -show-timings
  .\bin\debug\pong.exe
)
