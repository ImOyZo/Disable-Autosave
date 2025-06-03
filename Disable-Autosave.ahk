; I dont even know what this shit mean
#NoEnv
#Persistent
#SingleInstance Ignore
SendMode Input
SetWorkingDir %A_ScriptDir%
SetKeyDelay 0
SetWinDelay 0
SetBatchLines -1
SetControlDelay 0
SetTitleMatchMode, 2

global fw_name:="" ; Set Global variable for firewall rule name
global ip_addr:="192.81.241.171"
; Check if the script is running with administrator privileges
if not A_IsAdmin
{	
	Run *RunAs "%A_ScriptFullPath%",, UseErrorLevel
	if ErrorLevel != 0
	{
	MsgBox, 48, Error, This script requires administrator priviliges! Please run it again with the correct priviliges.
	}
	ExitApp
}

OnExit("AppExit")

;CTRL+F9 to toggle the firewall rule
<^f9::
	; Check if firewall rule already exists
    if (fw_name != "") {
        ToolTip, Firewall rule %fw_name% is already active!, 10, 10
        Sleep 3000
		ToolTip, Active Firewall: %fw_name% `nAutosave Disabled `nGo Ngentot, 10, 10
        return  ; Exit hotkey if rule exists
    }
	;Generate Random Firewall Rule Name
	Random fw_name, 10000000, 99999999
	; Create a new firewall rule with the generated name
	RunWait netsh advfirewall firewall add rule name="%fw_name%" dir=out action=block remoteip="%ip_addr%" ,,hide
	ToolTip, Active Firewall: %fw_name% `nAutosave Disabled `nGo Ngentot, 10, 10
return

; CTRL+F12 to delete the firewall rule
<^f12::
	; Check if a firewall rule already exists
    if (fw_name = "") {
        ToolTip, No active Firewall to be disabled, 10, 10
		Sleep, 3000
		ToolTip, No active Firewall `nAutosave Enabled `nDon't Ngentot, 10, 10
        return
    }
	; Delete the existing firewall rule
	RunWait netsh advfirewall firewall delete rule name="%fw_name%" ,,hide
	fw_name := ""  ; Clear the global variable
	ToolTip, No active Firewall `nAutosave Enabled `nDon't Ngentot, 10, 10
return

; Function to clean up on exit
AppExit()
{
	RunWait netsh advfirewall firewall delete rule name="%fw_name%" ,,hide
	fw_name := ""  ; Clear the global variable
}
