#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

Loop {
	InputBox, runCmd, Enter A Command, Please enter the command to run, , , 130
	if ErrorLevel
		ExitApp
	else {
		Run, %runCmd%, , UseErrorLevel
		if ErrorLevel
			MsgBox, Invalid Command %runCmd%
	}
}