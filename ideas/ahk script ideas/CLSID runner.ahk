#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

Loop {
	InputBox, runCLSID, Enter the CLSID, Please enter the CLSID, , , 130
	if ErrorLevel
		ExitApp
	else {
		Run, %runCLSID%, , UseErrorLevel
		if ErrorLevel
			MsgBox, Invalid CLSID %runCLSID%
	}
}