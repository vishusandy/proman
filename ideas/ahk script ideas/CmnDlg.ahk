; Title:	CmnDlg
;			*Color, Font, Icon, Find & Rename standard OS dialogs*

;----------------------------------------------------------------------------------------------
; Function:		ChooseColor
;				Display standard color dialog
;
; Parameters: 
;				pColor	- Initial color and output in RGB format, 
;				hGui	- Optional handle to parents HWND
;  
; Returns:	
;				False if user canceled the dialog or if error occurred	
; 
;
CmnDlg_ChooseColor(ByRef pColor, hGui=0)
{ 
  ;covert from rgb
    clr := ((pColor & 0xFF) << 16) + (pColor & 0xFF00) + ((pColor >> 16) & 0xFF) 

    VarSetCapacity(sCHOOSECOLOR, 0x24, 0) 
    VarSetCapacity(aChooseColor, 64, 0) 

    NumPut(0x24,		 sCHOOSECOLOR, 0)      ; DWORD lStructSize 
    NumPut(hGui,		 sCHOOSECOLOR, 4)      ; HWND hwndOwner (makes dialog "modal"). 
    NumPut(clr,			 sCHOOSECOLOR, 12)     ; clr.rgbResult 
    NumPut(&aChooseColor,sCHOOSECOLOR, 16)     ; COLORREF *lpCustColors 
    NumPut(0x00000103,	 sCHOOSECOLOR, 20)     ; Flag: CC_ANYCOLOR || CC_RGBINIT 

    nRC := DllCall("comdlg32\ChooseColorA", str, sCHOOSECOLOR)  ; Display the dialog. 
    if (errorlevel <> 0) || (nRC = 0) 
       return  false 

  
    clr := NumGet(sCHOOSECOLOR, 12) 
    
    oldFormat := A_FormatInteger 
    SetFormat, integer, hex  ; Show RGB color extracted below in hex format. 

 ;convert to rgb 
    pColor := (clr & 0xff00) + ((clr & 0xff0000) >> 16) + ((clr & 0xff) << 16) 
    StringTrimLeft, pColor, pColor, 2 
    loop, % 6-strlen(pColor) 
      pColor=0%pColor% 
    pColor=0x%pColor% 
    SetFormat, integer, %oldFormat% 

	return true
}

;----------------------------------------------------------------------------------------------
; Function:  ChooseFont
;            Display standard font dialog
;
; Parameters:
;            pFace		- Initial font,  output
;            pStyle		- Initial style, output
;            pColor		- Initial text color, output
;			 pEffects   - Set to false to disable effects (strikeout, underline, color)
;            hGui		- Parent's handle, affects position
;
;  Returns:
;            False if user canceled the dialog or if error occurred
;
CmnDlg_ChooseFont(ByRef pFace, ByRef pStyle, ByRef pColor, pEffects=true, hGui=0) {

   RegRead, LogPixels, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI, LogPixels
   VarSetCapacity(SLogFont, 128, 0)

   pEffects := pEffects ? 0x100 : 0

   ;set initial name
   DllCall("RtlMoveMemory", "uint", &SLogFont+28, "Uint", &pFace, "Uint", 32)

   ;convert from rgb  
   clr := ((pColor & 0xFF) << 16) + (pColor & 0xFF00) + ((pColor >> 16) & 0xFF) 

   ;set intial data
   if InStr(pStyle, "bold")
      NumPut(700, SLogFont, 16)

   if InStr(pStyle, "italic")
      NumPut(255, SLogFont, 20, 1   )

   if InStr(pStyle, "underline")
      NumPut(1, SLogFont, 21, 1)
   
   if InStr(pStyle, "strikeout")
      NumPut(1, SLogFont, 22, 1)

   if RegExMatch( pStyle, "s[1-9][0-9]*", s){
      StringTrimLeft, s, s, 1      
      s := -DllCall("MulDiv", "int", s, "int", LogPixels, "int", 72)
      NumPut(s, SLogFont, 0)				; set size
   }
   else  NumPut(16, SLogFont, 0)         ; set default size

   VarSetCapacity(SChooseFont, 60, 0)
   NumPut(60,		SChooseFont, 0)		; DWORD lStructSize
   NumPut(hGui,      SChooseFont, 4)		; HWND hwndOwner (makes dialog "modal").
   NumPut(&SLogFont, SChooseFont, 12)	; LPLOGFONT lpLogFont
   NumPut(0x041 + pEffects,	SChooseFont, 20)	; CF_EFFECTS = 0x100, CF_SCREENFONTS = 1, CF_INITTOLOGFONTSTRUCT = 0x40
   NumPut(clr,    SChooseFont, 24)		; rgbColors

   r := DllCall("comdlg32\ChooseFontA", "uint", &SChooseFont)  ; Display the dialog.
   if !r
      return false

   ;font name
   VarSetCapacity(pFace, 32)
   DllCall("RtlMoveMemory", "str", pFace, "Uint", &SLogFont + 28, "Uint", 32)
   pStyle := "s" NumGet(SChooseFont, 16) // 10

   ;color
   old := A_FormatInteger
   SetFormat, integer, hex                      ; Show RGB color extracted below in hex format.
   pColor := NumGet(SChooseFont, 24)
   SetFormat, integer, %old%

   ;styles
   pStyle =
   VarSetCapacity(s, 3)
   DllCall("RtlMoveMemory", "str", s, "Uint", &SLogFont + 20, "Uint", 3)

   if NumGet(SLogFont, 16) >= 700
      pStyle .= "bold "

   if NumGet(SLogFont, 20, "UChar")
      pStyle .= "italic "
   
   if NumGet(SLogFont, 21, "UChar")
      pStyle .= "underline "

   if NumGet(SLogFont, 22, "UChar")
      pStyle .= "strikeout "

   s := NumGet(sLogFont, 0)
   pStyle .= "s" Abs(DllCall("MulDiv", "int", abs(s), "int", 72, "int", LogPixels))

 ;convert to rgb 
	oldFormat := A_FormatInteger 
    SetFormat, integer, hex  ; Show RGB color extracted below in hex format. 

    pColor := (pColor & 0xff00) + ((pColor & 0xff0000) >> 16) + ((pColor & 0xff) << 16) 
    StringTrimLeft, pColor, pColor, 2 
    loop, % 6-strlen(pColor) 
      pColor=0%pColor% 
    pColor=0x%pColor% 
    SetFormat, integer, %oldFormat% 

   return 1
}

;-----------------------------------------------------------------------------------------------
; Function:	ChooseIcon 
;			Display standard icon dialog
;
; Parameters:
;			sIcon   - Default icon resource, output
;			idx     - Default index within resource, output
;			hGui	- Optional handle of the parent GUI.
;
; Returns:
;			False if user canceled the dialog or if error occurred 
;		
; See also:
;			<ChooseIconEx>
;
CmnDlg_ChooseIcon(ByRef sIcon, ByRef idx, hGui=0) 
{      
   global       

    VarSetCapacity(wIcon, 1025, 0) 
    If sIcon 
    { 
        R := DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "Str", sIcon, "Int", StrLen(sIcon), "UInt", &wIcon, "Int", 1025) 

        If !R 
      Return False    
    } 
    
   idx-- 
   R := DllCall(DllCall("GetProcAddress", "Uint", DllCall("LoadLibrary", "str", "shell32.dll"), "Uint", 62), "uint", hGui, "uint", &wIcon, "uint", 1025, "intp", idx) 
   idx++ 
    
   If !R 
   Return False 

   Len := DllCall("lstrlenW", "UInt", &wIcon) 
   VarSetCapacity(sIcon, len, 0) 
   R := DllCall("WideCharToMultiByte" , "UInt", 0, "UInt", 0, "UInt", &wIcon, "Int", len, "Str", sIcon, "Int", len, "UInt", 0, "UInt", 0) 

    If !R 
   Return False 

    Return True 
}

;----------------------------------------------------------------------------------------------
; Function:     Find / Replace
;               Display standard Find and Replace dialog boxes.
;
; Parameters: 
;               hGui    - Handle to parents HWND
;               lbl     - Label used for communication with dialog. CmnDlg_Event, CmnDlg_FindWhat and CmnDlg_Flags hold the dialog data
;               flags   - Creation flags, see below.
;               deff    - Default text to be displayed at the start of the dialog box in find edit box
;               defr    - Default text to be displayed at the start of the dialog box in replace edit box
;
; Flags:        
;				String containing list of creation flags. You can use "-" prefix to hide that GUI field.
;
;                d - down radio button selected in Find dialog
;                w - whole word selected
;                c - match case selected
;
; Globals:      
;				Dialog box is not modal, so it communicates with the script using 4 global variables:
;
;                   Event    - "close", "find", "replace", "replace_all"
;                   Flags    - string contaning flags about user selection; each letter means user has selected that particular GUI element.
;                   FindWhat - user find text
;                ReplaceWith - user replace text
;   
; Returns:      
;               Handle of the dialog or 0 if dialog can't be created. Can also return "Invalid Label" if lbl is not valid.
; 
CmnDlg_Find( hGui, lbl, flags="d", deff="") {
	static FINDMSGSTRING = "commdlg_FindReplace"
	static FR_DOWN=1, FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_HIDEWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000
	static buf, FR, len := 256

	if !Islabel(lbl)
		return "Invalid Label"

	
	f := 0
	f |= InStr(flags, "d")  ? FR_DOWN : 0 
	f |= InStr(flags, "c")  ? FR_MATCHCASE : 0
	f |= InStr(flags, "w")  ? FR_WHOLEWORD : 0
	f |= InStr(flags, "-d") ? FR_HIDEUPDOWN : 0
	f |= InStr(flags, "-w") ? FR_HIDEWHOLEWORD :0 
	f |= InStr(flags, "-c") ? FR_HIDEMATCHCASE :0

	if FR =
		VarSetCapacity(FR, 40, 0), VarSetCapacity(buf, len)
	
	if deff !=
		buf := deff
	
	NumPut( 40,		FR, 0)	;size
	NumPut( hGui,	FR, 4)	;hwndOwner
	NumPut( f,		FR, 12)	;Flags
	NumPut( &buf,	FR, 16)	;lpstrFindWhat
	NumPut( len,	FR, 24) ;wFindWhatLen


	CmnDlg_callback(lbl,"","","")
	OnMessage( DllCall("RegisterWindowMessage", "str", FINDMSGSTRING), "CmnDlg_callback" )

	return DllCall("comdlg32\FindTextA", "str", FR)
}


CmnDlg_Replace( hGui, lbl, flags="", deff="", defr="") {
	static FINDMSGSTRING = "commdlg_FindReplace"
	static FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_HIDEWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000
	static buf_s, buf_r, FR, len := 256

	if !Islabel(lbl)
		return "Invalid Label"

	f := 0
	f |= InStr(flags, "c")  ? FR_MATCHCASE : 0
	f |= InStr(flags, "w")  ? FR_WHOLEWORD : 0
	f |= InStr(flags, "-w") ? FR_HIDEWHOLEWORD :0 
	f |= InStr(flags, "-c") ? FR_HIDEMATCHCASE :0

	if FR =
		VarSetCapacity(FR, 40, 0), VarSetCapacity(buf_s, len), VarSetCapacity(buf_r, len)
	
	if deff !=
		buf_s := deff
	if defr !=
		buf_r := defr
	
	NumPut( 40,		FR, 0)	;size
	NumPut( hGui,	FR, 4)	;hwndOwner
	NumPut( f,		FR, 12)	;Flags
	NumPut( &buf_s,	FR, 16)	;lpstrFindWhat
	NumPut( &buf_r,	FR, 20) ;lpstrReplaceWith
	NumPut( len,	FR, 24) ;wFindWhatLen
	NumPut( len,	FR, 26) ;wReplaceWithLen


	CmnDlg_callback(lbl,"","","")
	OnMessage( DllCall("RegisterWindowMessage", "str", FINDMSGSTRING), "CmnDlg_callback" )

	return DllCall("comdlg32\ReplaceTextA", "str", FR)
}

;private function
CmnDlg_callback(wparam, lparam, msg, hwnd) {
	global CmnDlg_Event, CmnDlg_Flags, CmnDlg_FindWhat, CmnDlg_ReplaceWith
	static FR_DIALOGTERM = 0x40, FR_DOWN=1, FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_HIDEWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000, FR_REPLACE=0x10, FR_REPLACEALL=0x20, FR_FINDNEXT=8
	static fun 

	if (hwnd = "")
		return fun := wparam

	flags := NumGet(lparam+0, 12), CmnDlg_Flags := "" 
	if (flags & FR_DIALOGTERM) {
		CmnDlg_Event := "close"
		gosub %fun%
		return
	}


	CmnDlg_Flags .= (Flags & FR_MATCHCASE) && !(Flags & FR_HIDEMATCHCASE)? "c" :
	CmnDlg_Flags .= (Flags & FR_WHOLEWORD) && !(Flags & FR_HIDEWHOLEWORD) ? "w" :
	CmnDlg_FindWhat := DllCall("MulDiv", "Int", NumGet(lparam+0, 16), "Int",1, "Int",1, "str") 

	if (flags & FR_FINDNEXT) {
		CmnDlg_Event := "find"
		CmnDlg_Flags .= (Flags & FR_DOWN) && !(Flags & FR_HIDEUPDOWN) ? "d" :
		gosub %fun%
		return 
	}

	if (flags & FR_REPLACE) or (flags & FR_REPLACEALL) {
		CmnDlg_Event := (flags & FR_REPLACEALL) ? "replace_all" : "replace"
		CmnDlg_ReplaceWith := DllCall("MulDiv", "Int", NumGet(lparam+0, 20), "Int",1, "Int",1, "str") 
		gosub %fun%
		return 
	}
}

;
;Group: Examples
;
;Example1: 
;
;>  ;basic usage
;>
;>  if CmnDlg_ChooseIcon(icon, idx := 4) 
;>       msgbox Icon:   %icon%`nIndex:  %idx% 
;>
;>   if CmnDlg_ChooseColor( color := 0xFF00AA ) 
;>      msgbox Color:  %color% 
;>
;>   if CmnDlg_ChooseFont( font := "Courier New", style := "s16 bold underline italic", color:=0x80) 
;>        msgbox Font:  %font%`nStyle:  %style%`nColor:  %color% 
;>return
;
;Example2:
;>	 ;create gui and set text color 
;>
;>   CmnDlg_ChooseFont( font := "Courier New", style := "s16 bold underline italic", color:=0xFF) 
;>
;>   Gui Font, %Style% c%Color%, %Font% 
;>   Gui, Add, Text, ,Hello world.....  :roll: 
;>   Gui, Show, Autosize 
;>return
;
;About:
;		o Ver 3.1 by majkinetor. See http://www.autohotkey.com/forum/topic17230.html
;		o Licenced under GNU GPL <http://creativecommons.org/licenses/GPL/2.0/>.