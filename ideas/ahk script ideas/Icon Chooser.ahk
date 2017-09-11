#Include CmnDlg.ahk
if CmnDlg_ChooseIcon(icon, idx := 4)
	msgbox Icon:   %idx%>%icon%`n Index Above
ExitApp 