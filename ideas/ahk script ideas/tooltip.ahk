#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

CoordMode, Mouse, Screen

~LButton::
    MouseGetPos, begin_x, begin_y
    while GetKeyState("LButton")
    {
        MouseGetPos, x, y
        ToolTip, % "Starting x: " begin_x ", y: " begin_y "`nArea " Abs(begin_x-x) " x " Abs(begin_y-y) "`nEnding x: " x ", y: " y
        Sleep, 30
    }
    ToolTip
return