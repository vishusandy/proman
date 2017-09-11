DetectHiddenText, On
SetTitleMatchMode, 2
ControlGet, exTxt, List, Selected, SysListView321, Services
FileAppend, %exTxt%, C:\serviceList.txt