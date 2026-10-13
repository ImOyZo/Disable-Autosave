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

ShowStatus("No active Firewall", "Autosave Enabled", "FF5555", "Don't Ngentot")

<^f9::
    if (fw_name != "") {
        ShowStatus("Firewall rule " fw_name " is already active!", "Autosave Disabled", "33FF33", "Go Ngentot")
        return  ; Exit hotkey if rule exists
    }

	Random fw_name, 10000000, 99999999
	RunWait netsh advfirewall firewall add rule name="%fw_name%" dir=out action=block remoteip="%ip_addr%" ,,hide
	ShowStatus("Active Firewall: " fw_name, "Autosave Disabled", "33FF33", "Go Ngentot")
return

<^f12::
    if (fw_name = "") {
        ShowStatus("No active Firewall to be disabled", "Autosave Enabled", "FF5555", "Don't Ngentot")
        return
    }
	RunWait netsh advfirewall firewall delete rule name="%fw_name%" ,,hide
	fw_name := ""
	ShowStatus("No active Firewall", "Autosave Enabled", "FF5555", "Don't Ngentot")
return

ShowStatus(line1, line2, color2, line3) {
    Gui, StatusGui:Destroy
    Gui, StatusGui:New, -Caption +AlwaysOnTop +ToolWindow +LastFound +E0x08000000
    Gui, StatusGui:Color, FFFFFF
    Gui, StatusGui:Margin, 12, 8
    Gui, StatusGui:Font, c000000, Segoe UI
    Gui, StatusGui:Add, Text, , %line1%
    Gui, StatusGui:Font, c%color2% Bold
    Gui, StatusGui:Add, Text, , %line2%
    Gui, StatusGui:Font, c000000 Norm
    Gui, StatusGui:Add, Text, c%color2% , %line3%
    Gui, StatusGui:Show, x10 y10 NoActivate, Status
}

AppExit()
{
	RunWait netsh advfirewall firewall delete rule name="%fw_name%" ,,hide
	fw_name := ""
}
