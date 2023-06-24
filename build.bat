@echo off


if "%1" == "release" (
  mkdir bin\release
  mkdir bin\release\data
  mkdir bin\release\data\fonts
  cp data\fonts\MadeleinaSans-2VY3.ttf bin\release\data\fonts
  odin build src\main.odin -file -out:bin\release\pong.exe -show-timings
  .\bin\release\pong.exe

) else (

  mkdir bin\debug
  mkdir bin\debug\data
  mkdir bin\debug\data\fonts
  cp data\fonts\MadeleinaSans-2VY3.ttf bin\debug\data\fonts
  odin build src\main.odin -file -out:bin\debug\pong.exe -debug -show-timings
  .\bin\debug\pong.exe
)
