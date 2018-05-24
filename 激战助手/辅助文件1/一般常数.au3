#include-once

Global $MainGui
Global $Transparency, $IsOnTop, $expandLeft
Global $gwHWND, $gwPID
Global $mainGui, $dummyGui, $timerGui, $healthGui, $distanceGui


Global Const $COLOR_GREY = 0x222222
Global Const $COLOR_TIMER_DEFAULT = 0x20FF20

Global Const $COLOR_URGOZ_OPENING = 0xFF7575
Global Const $COLOR_URGOZ_OPEN = 0x20D020
Global Const $COLOR_URGOZ_CLOSING = 0x007500
Global Const $COLOR_URGOZ_CLOSED = 0xD02020

Global $COLOR_TIMER
Global $COLOR_HEALTH_HIGH, $COLOR_HEALTH_MIDDLE, $COLOR_HEALTH_LOW
Global $COLOR_PARTY
Global $COLOR_DISTANCE

Global $buffsDrop
Global $party, $partylabels[9]
Global $timer, $timerGuiLabel
Global $distance

Global $hotkeyCount, $hotkeyInput, $hotkeyKey, $hotkeyName, $pconsHotkeyInput, $DialogHK1Input, $DialogHK2Input, $DialogHK3Input, $DialogHK4Input, $DialogHK5Input
Global $pconsIniSection


Global Const $currentVersion = "3.1"
Global Const $do_update = False

Global Const $GWToolbox = "GWToolbox"
Global Const $DataFolder = @ScriptDir&"\"&"设置"&"\";@AppDataDir
Global Const $iniFileName = "激战助手.ini"
Global Const $iniFullPath = $DataFolder&$iniFileName
Global Const $licenseFullPath = $DataFolder&"license.lic"
Global Const $keysIniFullPath = $DataFolder&"keys.ini"
Global Const $tmpFullPath = $DataFolder&"tmp"

Global $Host

; ini elements
Global Const $s_sfmacro = "sfmacro"

; ini
Global Const $s_slashkeysini = "\keys.ini"
Global Const $s_keysini = "keys.ini"
