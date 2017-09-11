SetBatchLines, -1
#SingleInstance, force
	gui, show, w100 h200
	
	msgbox % ChooseIconEx(1, "", "settings.ini")
	exitapp
return

ChooseIconEx(pParent=1, pFile="", pSettings="", pGuiNum=69)
{
	local GuiPos, GuiW, GuiH, File, w, h, res

	critical, off        ;can block parent script without this

	ChooseIconEx_settings := pSettings
	ChooseIconEx_guiNum := pGuiNum

	if file =
		if not (file := ChooseIconEx_GetConfigVal( "File" ))
			file = %A_WinDir%\system32\shell32.dll

	GuiPos	:= ChooseIconEx_GetConfigVal( "GuiPos" )
	GuiW	:= ChooseIconEx_GetConfigVal( "GuiW", 500)
	GuiH	:= ChooseIconEx_GetConfigVal( "GuiH", 600)

	Gui, +lastfound
	parenthandle := WinExist()
	
	Gui, %ChooseIconEx_guiNum%:Default
	Gui, +ToolWindow +Resize

    gui +Owner%pParent%
    gui %pParent%:+Disabled


	;add combo
	w := GuiW - 0*(16+6)
	Gui, Add, ComboBox, x0 w%w% , %File%||

	;add buttons, for future
;	Gui, Add, Button, +0x8000 x+5 y h16 w16, 1
;	Gui, Add, Button, +0x8000 x+5 y h16 w16, 2

	;add listview
	h := GuiH - 30
	Gui, Add, ListView, x0 w%GuiW% h%h% -Multi AltSubmit Icons g_ChooseIconEx_OnIconClick	,Icon|File name


	Gui, +LastFound
	ChooseIconEx_hwnd := WinExist()

	Gui, +LabelChooseIconEx_
	
	
	;set hotkeys
	Hotkey, IfWinActive, ahk_id %ChooseIconEx_hwnd%
	Hotkey, ~Backspace, _ChooseIconEx_Hotkey_Backspace, on
	Hotkey, ~Enter, _ChooseIconEx_Hotkey_Enter, on

	;show it	
	Gui, Show, %GuiPos% w%GuiW% h%GuiH%, Choose Icons
	ControlFocus, SysListView321

	ChooseIconEx_Scan(pFile)

    loop
    {
       sleep 200
       IfWinNotExist ahk_id %ChooseIconEx_hwnd% 
         break
    }

	res := ChooseIconEx_result
	ChooseIconEx_result =

	gui %pParent%:-Disabled
	gui %pParent%:Default

	Winactivate, ahk_id %parentHandle%
	return res
}

ChooseIconEx_HasIcons( pFile ){

	FileGetAttrib, attrib , %pFile%
	If attrib contains D
		return 1

	dummyList := IL_Create(1, 1)
	idx := IL_Add(dummyList, pFile, 2)
	IL_Destroy(dummyList)

	return %idx%
}

ChooseIconEx_Scan( pFile="" ){
	local attrib, ListID

	Gui, %ChooseIconEx_guiNum%:Default		;hm.. ? why ? doesn't work without it 
	ChooseIconEx_scanning := true

	if pFile =
		  GuiControlGet, pFile, ,ComboBox1
	else  GuiControl, ,  ComboBox1, %pFile%||

	;clear list of files
	LV_Delete()

	;create new list of large images and replace and delete old one
	ChooseIconEx_idIconList := IL_Create(100, 100, True)
	ListID := LV_SetImageList(ChooseIconEx_idIconList)
	If ListID
	  IL_Destroy(ListID)

	;check for wrong path, previous list cleaned already
	if !FileExist(pFile) and !(pfile=">drives") {
		LV_Add("","path ?")
		return
	}

	FileGetAttrib, attrib , %pFile%

	If attrib contains D
			ChooseIconEx_ScanFolder( pFile )
	else
		if ChooseIconEx_HasIcons( pFile ) or (pFile = ">drives")
			ChooseIconEx_ScanFile( pFile )
		else 
		{
			pFile := SubStr( pFile, 1 , InStr(pFile, "\", 0, 0) - 1)
			GuiControl, ,  ComboBox1, %pFile%||
			ChooseIconEx_ScanFolder( pFile )	
		}

	ChooseIconEx_scanning := false
}

ChooseIconEx_AddDrives() 
{
	local icn, driveIcon, cdIcon, floppyIcon, shell32dll, remoteIcon, drives, r

	shell32dll := A_WINDIR "\system32\shell32.dll"
	driveIcon  := IL_Add(ChooseIconEx_idIconList, shell32dll , 8)
	floppyIcon := IL_Add(ChooseIconEx_idIconList, shell32dll , 7)
	cdIcon	   := IL_Add(ChooseIconEx_idIconList, shell32dll , 12)
	remoteIcon := IL_Add(ChooseIconEx_idIconList, shell32dll , 11)

	DriveGet drives, List

	Loop, parse, drives
	{
		r := DllCall("GetDriveType", "str", A_LoopField ":")
		if r = 3	;cdrom
			icn := driveIcon
		else if r = 5
			icn := cdIcon
		else if r = 4
			icn := remoteIcon
		else if r = 2
			icn := floppyIcon

		LV_Add("Icon" . icn, A_LoopField ":", A_LoopField ":")
	}

}

ChooseIconEx_ScanFile( file ) {
	local idx, folderIcon, shell32dll

	shell32dll := A_WINDIR "\system32\shell32.dll"
	folderIcon  := IL_Add(ChooseIconEx_idIconList, shell32dll , 5)

	if (file = ">drives")
		return ChooseIconEx_AddDrives()


	LV_Add("Icon" . folderIcon, ". .", ". .")
	;Search for 9999 icons in the selected file
	Loop, 9999
    {
	  If !ChooseIconEx_scanning
         break
     
	  if idx := IL_Add(ChooseIconEx_idIconList, File , A_Index)
	  {
	
		LV_Add("Icon" . idx, idx-1, File ":" idx-1)
	    ChooseIconEx_SetStatus("adding icon " . idx-1 . " : " . file )  		
	   } else break  
    }

	ChooseIconEx_SetStatus( "" )
}

ChooseIconEx_ScanFolder( folder ){
	local idx, attrib, shell32dll, folderIcon, goUpIcon

	shell32dll := A_WINDIR "\system32\shell32.dll"

	;add folders
	ChooseIconEx_SetStatus( "adding folders ..." )
	folderIcon := IL_Add(ChooseIconEx_idIconList, shell32dll , 4)
	goUpIcon   := IL_Add(ChooseIconEx_idIconList, shell32dll , 5)

	LV_Add("Icon" . goUpIcon, ". .", ". .")

	Loop, %folder%\*, 2 
	{
		If !ChooseIconEx_scanning
		   break	
	
		;don't addd hiden and system
		FileGetAttrib, attrib , %A_LoopFileFullPath%
		If attrib contains H,S
			continue

		LV_Add("Icon" . folderIcon, A_LoopFileName, A_LoopFileFullPath)		
	}

	;files	  
	Loop, %folder%\*
	{
		 If !ChooseIconEx_scanning
		   break

		idx := IL_Add(ChooseIconEx_idIconList, A_LoopFileFullPath , 1)
		if !idx
			continue

		if  ChooseIconEx_HasIcons( A_LoopFileFullPath )
			 LV_Add("Icon" . idx, A_LoopFileName ">", A_LoopFileFullPath)		
		else LV_Add("Icon" . idx, A_LoopFileName, A_LoopFileFullPath)

		 ChooseIconEx_SetStatus("adding icon " . idx . " : " A_LoopFIleName)
	}

	ChooseIconEx_SetStatus( "" )
}
	

ChooseIconEx_SetStatus( s ){
	global

	if s=""
		WinSetTitle, ahk_id %ChooseIconEx_hwnd%, ,Choose Icon
	else
		WinSetTitle, ahk_id %ChooseIconEx_hwnd%, ,Choose Icon %s%
}

ChooseIconEx_OnIconClick(eventInfo){
	local file

	Gui, %ChooseIconEx_guiNum%:Default		;hm.. ? why ? doesn't work without it 
	LV_GetText(file, eventInfo, 2)

	if (file = ". ."){
		GuiControlGet, file, ,ComboBox1
		file := SubStr( file, 1 , InStr(file, "\", 0, 0) - 1)

		if StrLen(file) = 1
			file := ">drives"
	}

	if (FileExist( file ) AND ChooseIconEx_HasIcons( file )) OR (file = ">drives")
	{
		ChooseIconEx_scanning := false

		SetTimer, ChooseIconEx_ScanTimer, 100
		ChooseIconEx_nextFile := file
		return
	}

	;its not the resource, not the folder, this is the icon to return
	ChooseIconEx_result := file
	ChooseIconEx_Exit()
}


_ChooseIconEx_OnIconClick:
	critical
	If ( A_GuiEvent = "A" )
		ChooseIconEx_OnIconClick(A_EventInfo)
return

ChooseIconEx_ScanTimer:
	SetTimer, ChooseIconEx_ScanTimer, off
	ChooseIconEx_Scan( ChooseIconEx_nextFile )
return



Anchor(c, a, r = false) { ; v3.5 - Titan
	static d
	GuiControlGet,  p, Pos, %c%
	If !A_Gui or ErrorLevel
		Return
	i = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%.`n%A_Gui%:%c%=
	StringSplit, i, i, .
	d .= (n := !InStr(d, i9)) ? i9 : ""
	Loop, 4
		x := A_Index, j := i%x%, i6 += x = 3, k` := !RegExMatch(a, j . "([\d.]+)", v)
		+ (v1 ? v1 : 0), e := p%j% - i%i6% * k, d .= n ? e . i5 : "", RegExMatch(d
		, i9 . "(?:([\d.\-]+)/){" . x . "}", v), l .= InStr(a, j) ? j . v1 + i%i6% * k : ""
	r := r ? "Draw" : ""
	GuiControl, Move%r%, %c%, %l%
}


ChooseIconEx_Size:
	Anchor("ComboBox1"       , "w")
	Anchor("SysListView321"  , "wh")
	Anchor("Button1"		 , "x")
	Anchor("Button2"		 , "x")
Return


ChooseIconEx_Close:
ChooseIconEx_Escape:
	critical
	ChooseIconEx_Exit()
Return

ChooseIconEx_Exit(){

	local w, h, x, y, file
	
	if ChooseIconEx_settings !=									 
	{
		VarSetCapacity(sRect, 16)
		DllCall("GetClientRect", "uint", ChooseIconEx_hwnd, "uint", &sRect) 	
		w := ExtractInteger(sRect, 8), 	h := ExtractInteger(sRect, 12)
		WinGetPos, x, y, ,,ahk_id %ChooseIconEx_hwnd%

		ChooseIconEx_SetConfigVal( "GuiPos", "x" x " y" y )
		ChooseIconEx_SetConfigVal( "GuiW", w )
		ChooseIconEx_SetConfigVal( "GuiH", h )
		GuiControlGet, file, , ComboBox1
		ChooseIconEx_SetConfigVal( "File", file )
	}


	ChooseIconEx_settings	=
	ChooseIconEx_hwnd		=
	ChooseIconEx_scanning	=
	ChooseIconEx_nextFile	=
	ChooseIconEx_guiNum		=
	ChooseIconEx_idIconList =
	
	Gui, Destroy
}

ChooseIconEx_GetConfigVal( var, def="" ){
	global

	IniRead, var, %ChooseIconEx_settings%, ChooseIconEx, %var%, %A_SPACE%
    if var =
      return def

	return var
}

ChooseIconEx_SetConfigVal( var, value ) {
	global
;	msgbox  % var " " value
    IniWrite, %value%, %ChooseIconEx_settings%, ChooseIconEx, %var%
}


_ChooseIconEx_Hotkey_Enter:
	ChooseIconEx_Hotkey_Enter()
return 

_ChooseIconEx_Hotkey_Backspace:
	ChooseIconEx_Hotkey_Backspace()
return

ChooseIconEx_Hotkey_Enter() {
	local var

	ControlGetFocus, var, ahk_id %ChooseIconEx_hwnd%
	if (var="Edit1")
		ChooseIconEx_Scan()

	if (var="SysListView321") {
		Gui, %ChooseIconEx_guiNum%:Default		;hm.. ? why ? doesn't work without it 
		ChooseIconEx_OnIconClick( LV_GetNext() )

	}
}

ChooseIconEx_Hotkey_Backspace(){
	local var

	ControlGetFocus, var, ahk_id %ChooseIconEx_hwnd%
	if (var="SysListView321")
		ChooseIconEx_OnIconClick( 1 )
}

ChooseIconEx_About() {
	local msg
	local version := "0.91"

	msg .= "ChooseIconEx" . "  " . version . "`n"
	msg .= "Icon viewer dialog addon for AutoHotKey`n`n`n"

	msg .= "Created by:`t`t    Miodrag Milic`n"
	msg .= "e-mail:`t`t miodrag.milic@gmail.com`n`n`n"



	msg .= "code.r-moth.com   |  www.r-moth.com `n             r-moth.deviantart.com`n"

	MsgBox, 64, About MMenu,  %msg%
}