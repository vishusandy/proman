

ClearWebHistory(pCommand) {
   ValidCmdList    = Files,Cookies,History,Forms,Passwords,All,All2
   Files          = 8 ; Clear Temporary Internet Files
   Cookies       = 2 ; Clear Cookies
   History       = 1 ; Clear History
   Forms          = 16 ; Clear Form Data
   Passwords       = 32 ; Clear Passwords
   All          = 255 ; Clear all
   All2          = 4351 ; Clear All and Also delete files and settings stored by add-ons
   If pCommand in %ValidCmdList%
      DllCall("InetCpl.cpl\ClearMyTracksByProcess", uint, %pCommand%)
   Else
      MsgBox Invalid Command -%pCommand%-`nValid commands are`n%ValidCmdList%
   }
