WinGet, azpid, PID, Azureus
Process, WaitClose, %azpid%, 30
if ErrorLevel <> 0
	MsgBox The process %azpid% could not be closed!