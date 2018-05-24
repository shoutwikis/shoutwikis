#Region
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#EndRegion

#include <Memory.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <misc.au3>
#include "../../激战接口.au3"
HotKeySet("{ESC}", "_exit")

Global $vCharName

GUICreate("", 170, 35)

Initialize(ProcessExists("gw.exe"))

$btn1 = GUICtrlCreateButton("拿弓", 5, 5, 160, 20, $WS_GROUP)

GUISetState(@SW_SHOW)

  While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg = $btn1
				Dialog(0x0000008A) ;138
        EndSelect
    WEnd

func _exit()
    Exit
endfunc