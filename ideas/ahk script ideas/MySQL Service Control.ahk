#NoEnv
#SingleInstance, Force
#include Service.ahk
SetBatchLines -1
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen

Menu, Tray, Start, myStart("MySQL")
Menu, Tray, Stop, myStop("MySQL")
Menu, Tray, Restart, myRestart("MySQL")

Draw:
	if(Service_State("MySQL")!=4 and Service_State("MySQL")!=2) {

	}
		
return

myStart(){
	
}

myStop(){
	
return

myRestart(func) {
	myStop(func)
	myStart(func)
}

