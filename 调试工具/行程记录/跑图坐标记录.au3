#include-once
#NoTrayIcon
#include <Misc.au3>
#include <Array.au3>
#include <Constants.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>
#include <StaticConstants.au3>
#include <Date.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <file.au3>
#Include <WinAPI.au3>
#include "../../激战接口.au3"
#include "常数.au3"

Opt("ExpandVarStrings", 1)

Global Const $sKeyPaste = "{Ins}"
Global Const $sKeyExit = "{End}"

OnAutoItExitRegister("TerminateFinal")
_Singleton(@ScriptName)

Global Const $hUser32 = DllOpen("user32.dll")
Global Const $hKernel32 = DllOpen("kernel32.dll")
Global Const $hGWPID = ClientSelect()
Global Const $iHWndGW = HWnd(@extended)
Global Const $hGWProcess = OpenProcess($hGWPID)
Global Const $sClipSave = ClipGet()
Global $sClipString

Global $XLocation = 0
Global $YLocation = 0
Global $LastX = 0
Global $LastY = 0
Global $MapID = 0
Global $HeroCount = 0
Global $SkillBar = 0
Global $Skills[9]
Global $Dialog = 0
Global $Heros[8]
Global $NearestNPC = 0
Global $IAmMoving = True
Global $MoveTimer

__Main__()

Func __Main__()
	Local $iCoordAddress = ScanForPtr($hGWProcess, "D8658485FFD9C0", -4)

	If (@error = 1) Then Exit 3

	Local $sDefaultTip = ("等待输入...@CRLF@按 $sKeyExit$ 键退出")
	Local $fClickX1, $fClickY1, $fClickX2, $fClickY2, $iTipTimer
	Local $dCoordStruct = DllStructCreate("float ClickX;float ClickY")
	Local $iStructSize = DllStructGetSize($dCoordStruct)
	Local $iStructPtr = DllStructGetPtr($dCoordStruct)

	TraySetClick(8)
	Opt("TrayAutoPause", 0)
	Opt("TrayOnEventMode", 1)
	TraySetIcon("shell32.dll", -147)
	TraySetToolTip("行动记录器")
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "ActivateWindow")

	HotKeySet($sKeyExit, "Terminate")
	HotKeySet($sKeyPaste, "PasteToScITE")

	WinActivate($iHWndGW)

	Local $aTipPos = WinGetPos($iHWndGW)

	$aTipPos[0] += 5
	$aTipPos[1] += 5

	ToolTip($sDefaultTip, $aTipPos[0], $aTipPos[1])
	Local $hToolTip = WinWait($sDefaultTip)

	If (Not IsDeclared("WS_EX_NOACTIVATE")) Then Assign("WS_EX_NOACTIVATE", 0x08000000)
	_WinAPI_SetWindowLong($hToolTip, $GWL_EXSTYLE, Eval("WS_EX_NOACTIVATE"))

	$XLocation = XLocation()
	$YLocation = YLocation()
	$NearestNPC = 0
	$MapID = GetMapID()
;~ 	PasteToScITE2("    If GetMapID() <> " & $MapID & " Then ;" & $MAP_ID[$MapID])
;~ 	PasteToScITE2("            TravelTo(" & $MapID & ")")
;~ 	PasteToScITE2("        EndIf")
;~ 	PasteToScITE2("        SwitchMode(1)")
;~ 	PasteToScITE2("        RndSleep(250)")
;~ 	PasteToScITE2("    EndIf")
;~
;	PasteToScITE2(";; 起始地图的序号: " & $MapID & ", 地图是: " & $MAP_ID[$MapID])
	PasteToScITE2('["'&$MAP_ID[$MapID]&'", '&$MapID&', 0, 0], _')
	For $i = 1 To 8
		$Skills[$i] = GetSkillbarSkillID($i)
	Next
	$Dialog = GetLastDialogIdHex()
	$HeroCount = GetHeroCount()
	If $HeroCount > 0 Then
		For $i = 1 To $HeroCount

			$Heros[$i] = GetHeroID($i)
		Next
	EndIf

	While 1
		DllCall($hKernel32, "int", "ReadProcessMemory", "int", $hGWProcess, "int", $iCoordAddress, "ptr", $iStructPtr, "int", $iStructSize, "int*", 0)
		$fClickX1 = DllStructGetData($dCoordStruct, "ClickX")
		$fClickY1 = DllStructGetData($dCoordStruct, "ClickY")

		Do
			DllCall($hKernel32, "int", "ReadProcessMemory", "int", $hGWProcess, "int", $iCoordAddress, "ptr", $iStructPtr, "int", $iStructSize, "int*", 0)
			$fClickX2 = DllStructGetData($dCoordStruct, "ClickX")
			$fClickY2 = DllStructGetData($dCoordStruct, "ClickY")

			If (($fClickX1 <> $fClickX2) Or ($fClickY1 <> $fClickY2)) Then
				If (($fClickX2 == "1.#INF") Or ($fClickY2 == "1.#INF")) Then ExitLoop

				If _IsPressed("01", $hUser32) Then

					If GetMapLoading() == $INSTANCETYPE_OUTPOST Then
						$sClipString = ("MoveTo(" & NormalizeDigits($fClickX2) & ", " & NormalizeDigits($fClickY2) & ") ; 地图序号: " & $MapID)
					ElseIf GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then
						$sClipString = ("MoveAggroing(" & NormalizeDigits($fClickX2) & ", " & NormalizeDigits($fClickY2) & ") ; 地图序号: " & $MapID)
					EndIf

					ClipPut($sClipString)

					ToolTip("$sClipString$@CRLF@已复制.@CRLF@也可按 $sKeyPaste$ 键 以手动复制到 Autoit 编辑器内", $aTipPos[0], $aTipPos[1])

					$iTipTimer = TimerInit()

					While _IsPressed("01", $hUser32)
						Sleep(10)
						UpdateToolTip($hToolTip, $iTipTimer, $aTipPos, $sDefaultTip)
					WEnd
				EndIf

				ExitLoop
			EndIf

			If GetMapLoading() == $INSTANCETYPE_OUTPOST Then
				For $i = 1 To 8
					$NewSkillID = GetSkillbarSkillID($i)
					If $Skills[$i] <> $NewSkillID And $NewSkillID <> 0 Then
						$Skills[$i] = $NewSkillID
						PasteToScITE2("SetSkillbarSkill(" & $i & ", " & $Skills[$i] & ")")
					EndIf
				Next
				If ComputeDistance($XLocation, $YLocation, XLocation(), YLocation()) > 500 Then
					$XLocation = XLocation()
					$YLocation = YLocation()
					If $XLocation <> 0 And $YLocation <> 0 Then
						;PasteToScITE2("MoveTo(" & Round($XLocation, 0) & ", " & Round($YLocation, 0) & ")")
						PasteToScITE2('['&Round($XLocation, 0)&', '& Round($YLocation, 0)&', "市", '& GetMapID() &'], _')
					EndIf
				EndIf
;~ 				$NewHeroCount = GetHeroCount()
;~ 				If $NewHeroCount <> $HeroCount Then
;~ 					If $NewHeroCount == 0 Then
;~ 						PasteToScITE2("LeaveGroup()")
;~ 					ElseIf $NewHeroCount > $HeroCount Then
;~ 						For $i = $HeroCount + 1 To $NewHeroCount
;~ 							$Heros[$i] = GetHeroID($i)
;~ 							PasteToScITE2("AddHero(" & $Heros[$i] & ")")
;~ 						Next
;~ 					Else
;~ 						For $i = 1 To $HeroCount
;~ 							If $i > $NewHeroCount Then PasteToScITE2("KickHero(" & $Heros[$i] & ")")
;~ 							$Heros[$i] = GetHeroID($i)
;~ 						Next
;~ 					EndIf
;~ 					$HeroCount = $NewHeroCount
;~ 				EndIf

			ElseIf GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then
				If ComputeDistance($XLocation, $YLocation, XLocation(), YLocation()) > 500 Then
					$XLocation = XLocation()
					$YLocation = YLocation()
					If $XLocation <> 0 And $YLocation <> 0 Then
						;PasteToScITE2("MoveAggroing(" & Round($XLocation, 0) & ", " & Round($YLocation, 0) & ")")
						PasteToScITE2('['&Round($XLocation, 0)&', '& Round($YLocation, 0)&', "郊", '& GetMapID() &'], _')
					EndIf
				EndIf
			EndIf

			If GetMapLoading() <> $INSTANCETYPE_LOADING Then
				If GetIsMoving(-2) And XLocation() <> 0 Then
					$IAmMoving = True
					$MoveTimer = TimerInit()
					$LastX = XLocation()
					$LastY = YLocation()
				ElseIf TimerDiff($MoveTimer) > 1500 Then
					$MoveTimer = 5000000
					$IAmMoving == False
				EndIf

				$NewMapID = GetMapID()
				If $MapID <> $NewMapID And $NewMapID <> 0 Then
					Local $lastMap = $MapID
					$MapID = $NewMapID
					;PasteToScITE2(";  新地图是: " & $MAP_ID[$MapID] & ", 地图序号是: " & $MapID)
					If TimerDiff($MoveTimer) < 2000 Then
						;PasteToScITE2("Move(" & Round($LastX, 0) & ", " & Round($LastY, 0) & ")")
						PasteToScITE2('['&Round($LastX, 0)&', '& Round($LastY, 0)&', "正", '& $MapID &'], _ ;'&$MAP_ID[$MapID])
						;PasteToScITE2("WaitMapLoading(" & $MapID & ") ;  New Map " & $MAP_ID[$MapID])
						;PasteToScITE2('["'&$MAP_ID[$MapID]&'", '&$MapID&', 0, 0], _'&@CRLF&'[1, 1, "反", "向"], _')
						PasteToScITE2('[1, 1, "反", '&$lastMap&'], _')
					Else
						;PasteToScITE2("TravelTo(" & $MapID & ") ;  New Map " & $MAP_ID[$MapID])
						PasteToScITE2('["飞往", '&$MAP_ID[$MapID]&', 0, 0], _')
					EndIf
				EndIf

				$NewDialog = GetLastDialogIdHex()
				If $Dialog <> $NewDialog And $NewDialog <> 0 Then
					$Dialog = $NewDialog
					PasteToScITE2("Dialog(" & $Dialog & ")")
					If StringInStr($Dialog, "01") Then
						$QuestID = StringSplit($Dialog, "")
						If $QuestID[5] == 0 And $QuestID[6] == 1 Then
							PasteToScITE2(";  已接任务: " & $Quest[Dec($QuestID[4])] & ", 任务序号是: " & Dec($QuestID[4]))
						ElseIf $QuestID[6] == 0 And $QuestID[7] == 1 Then
							PasteToScITE2(";  已接任务: " & $Quest[Dec($QuestID[4] & $QuestID[5])] & ", 任务序号是: " & Dec($QuestID[4] & $QuestID[5]))
						ElseIf $QuestID[7] == 0 And $QuestID[8] == 1 Then
							PasteToScITE2(";  已接任务: " & $Quest[Dec($QuestID[4] & $QuestID[5] & $QuestID[6])] & ", 任务序号是: " & Dec($QuestID[4] & $QuestID[5] & $QuestID[6]))
						ElseIf $QuestID[8] == 0 And $QuestID[9] == 1 Then
							PasteToScITE2(";  已接任务: " & $Quest[Dec($QuestID[4] & $QuestID[5] & $QuestID[6] & $QuestID[7])] & ", 任务序号是: " & Dec($QuestID[4] & $QuestID[5] & $QuestID[6] & $QuestID[7]))
						EndIf
					EndIf
					If StringInStr($Dialog, "07") Then
						$QuestID = StringSplit($Dialog, "")
						If $QuestID[5] == 0 And $QuestID[6] == 7 Then
							PasteToScITE2(";  上交任务: " & $Quest[Dec($QuestID[4])] & ", 任务序号是: " & Dec($QuestID[4]))
						ElseIf $QuestID[6] == 0 And $QuestID[7] == 7 Then
							PasteToScITE2(";  上交任务: " & $Quest[Dec($QuestID[4] & $QuestID[5])] & ", 任务序号是: " & Dec($QuestID[4] & $QuestID[5]))
						ElseIf $QuestID[7] == 0 And $QuestID[8] == 7 Then
							PasteToScITE2(";  上交任务: " & $Quest[Dec($QuestID[4] & $QuestID[5] & $QuestID[6])] & ", 任务序号是: " & Dec($QuestID[4] & $QuestID[5] & $QuestID[6]))
						ElseIf $QuestID[8] == 0 And $QuestID[9] == 7 Then
							PasteToScITE2(";  上交任务: " & $Quest[Dec($QuestID[4] & $QuestID[5] & $QuestID[6] & $QuestID[7])] & ", 任务序号是: " & Dec($QuestID[4] & $QuestID[5] & $QuestID[6] & $QuestID[7]))
						EndIf
					EndIf
				EndIf

				$ThisNPC = GetNearestNPCToAgent(-2)
				If DllStructGetData($ThisNPC, 'ID') == GetCurrentTargetID() And GetDistance($ThisNPC) < 150 And $NearestNPC <> DllStructGetData($ThisNPC, 'ID') And DllStructGetData($ThisNPC, 'ID') <> 0 Then
					$NearestNPC = DllStructGetData($ThisNPC, 'ID')
					$XLocation = XLocation()
					$YLocation = YLocation()
					PasteToScITE2("GoToNPCNearestCoords(" & Round(XLocation($ThisNPC), 0) & ", " & Round(YLocation($ThisNPC), 0) & ")  ; " & GetAgentName($ThisNPC))
				EndIf
			Else
				WaitMapLoading()
			EndIf


			UpdateToolTip($hToolTip, $iTipTimer, $aTipPos, $sDefaultTip)
		Until (Not Sleep(10))
	WEnd
EndFunc   ;==>__Main__

Func ActivateWindow()
	WinActivate($iHWndGW)
EndFunc   ;==>ActivateWindow

;~ Description: Returns the nearest NPC to a set of coordinates within 200 units
Func GetNearestNPCToCoordsClose($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 50000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 6 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = ($aX - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + ($aY - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2

		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestNPCToCoords

Func ClientSelect()
	Local $aWindows = WinList("[CLASS:ArenaNet_Dx_Window_Class; REGEXPTITLE:^\D+$]")

	Switch $aWindows[0][0]
		Case 0
			Exit 2

;~ 		Case 1
;~ 			Return SetExtended($aWindows[1][1], WinGetProcess($aWindows[1][1]))

		Case Else
			Local $hGUI = GUICreate("行动记录器", 310, 70, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), $WS_EX_TOPMOST)
			GUISetIcon("shell32.dll", -147)

			GUICtrlCreateGroup("选择角色", 10, 10, 290, 50)
			Local $iCombo = GUICtrlCreateCombo("", 20, 30, 160, 20, $CBS_DROPDOWNLIST)
			Local $iStart = GUICtrlCreateButton("开始", 215, 29, 75, 22.8)
			Local $iRefresh = GUICtrlCreateButton("", 185, 29, 22.8, 22.8, $BS_ICON)
			GUICtrlSetImage($iRefresh, "shell32.dll", -239, 0)

			GetClientData($aWindows)
			GUICtrlSetData($iCombo, $aWindows[0][2], $aWindows[0][1])

			GUICtrlSetState($iStart, $GUI_DEFBUTTON)
			HideTaskbarTab($hGUI)
			GUISetState(@SW_SHOW, $hGUI)

			While 1
				Switch GUIGetMsg()
					Case $iStart
						Local $i = _GUICtrlComboBox_GetCurSel($iCombo) + 1

						If ProcessExists($aWindows[$i][2]) Then
							Local $CharName = GUICtrlRead($iCombo)
							Initialize("")
							GUIDelete($hGUI)
							Return SetExtended($aWindows[$i][1], $aWindows[$i][2])
						Else
							SoundPlay("@WindowsDir@\media\Windows Error.wav")
							ContinueCase
						EndIf

					Case $iRefresh
						$aWindows = WinList("[CLASS:ArenaNet_Dx_Window_Class; REGEXPTITLE:^\D+$]")
						GetClientData($aWindows)
						GUICtrlSetData($iCombo, "")
						GUICtrlSetData($iCombo, $aWindows[0][2], $aWindows[0][1])

					Case $GUI_EVENT_CLOSE
						Exit 0
				EndSwitch
			WEnd
	EndSwitch
EndFunc   ;==>ClientSelect

Func CloseHandle($iHandle)
	DllCall($hKernel32, "int", "CloseHandle", "int", $iHandle)
EndFunc   ;==>CloseHandle

Func HideTaskbarTab($hWnd)
	Local Const $sCLSID_TaskbarList = "{56FDF344-FD6D-11D0-958A-006097C9A090}"
	Local Const $sIID_ITaskbarList = "{56FDF342-FD6D-11D0-958A-006097C9A090}"
	Local Const $sTagITaskbarList = "HrInit hresult(); AddTab hresult(hwnd); DeleteTab hresult(hwnd); ActivateTab hresult(hwnd); SetActiveAlt hresult(hwnd);"
	Local $oTaskbarList = ObjCreateInterface($sCLSID_TaskbarList, $sIID_ITaskbarList, $sTagITaskbarList)
	$oTaskbarList.HrInit()
	$oTaskbarList.DeleteTab($hWnd)
EndFunc   ;==>HideTaskbarTab

Func NormalizeDigits($fFloat)
	Return StringFormat("%0.2f", $fFloat)
EndFunc   ;==>NormalizeDigits

Func OpenProcess($iPID, $iAccess = 0x410) ;Default access: PROCESS_VM_READ | PROCESS_QUERY_INFORMATION
	Local Const $aProcess = DllCall($hKernel32, "int", "OpenProcess", "int", $iAccess, "int", 1, "int", $iPID)

	Return $aProcess[0]
EndFunc   ;==>OpenProcess

Func PasteToScITE()
	If (($sClipString == ClipGet()) And (StringLen($sClipString) > 0)) Then
		Local Const $hScITETab = ControlGetHandle(WinGetHandle("[CLASS:SciTEWindow]"), "", "[CLASS:Scintilla; INSTANCE:1]")

		If ($hScITETab > 0) Then
			ClipPut(@TAB & @TAB & $sClipString & @CRLF)

			DllCall($hUser32, "lresult", "SendMessageW", "hwnd", $hScITETab, "uint", $WM_PASTE, "wparam", 0, "lparam", 0)

			ClipPut($sClipString)
		Else
			SoundPlay("@WindowsDir@\media\Windows Error.wav")
		EndIf
	EndIf
EndFunc   ;==>PasteToScITE

Func PasteToScITE2($Text)
	Local Const $hScITETab = ControlGetHandle(WinGetHandle("[CLASS:SciTEWindow]"), "", "[CLASS:Scintilla; INSTANCE:1]")

	If ($hScITETab > 0) Then
		ClipPut($Text & @CRLF)

		DllCall($hUser32, "lresult", "SendMessageW", "hwnd", $hScITETab, "uint", $WM_PASTE, "wparam", 0, "lparam", 0)

		ClipPut($Text)
	Else
		SoundPlay("@WindowsDir@\media\Windows Error.wav")
	EndIf
EndFunc   ;==>PasteToScITE

Func ReadProcessMemory($hProcess, $iAddress, $sType = "dword")
	Local $dBuffer = DllStructCreate($sType)

	DllCall($hKernel32, "int", "ReadProcessMemory", "int", $hProcess, "int", $iAddress, "ptr", DllStructGetPtr($dBuffer), "int", DllStructGetSize($dBuffer), "int*", 0)

	Return DllStructGetData($dBuffer, 1)
EndFunc   ;==>ReadProcessMemory

Func ScanForPtr($hProcess, $sByteString, $iByteOffset = 0, $iPtrOffset = 0)
	Local Const $dQuery = DllStructCreate("dword;dword;dword;dword;dword;dword;dword")
	Local $iSearch, $sBinString, $dBuffer, $iBlockSize
	Local $iStartAddr = 0x401000

	$sByteString = BinaryToString("0x" & $sByteString)

	While ($iStartAddr < 0x900000)
		DllCall($hKernel32, "int", "VirtualQueryEx", "int", $hProcess, "int", $iStartAddr, "ptr", DllStructGetPtr($dQuery), "int", DllStructGetSize($dQuery))

		If (DllStructGetData($dQuery, 5) = 4096) Then
			$dBuffer = DllStructCreate("byte[" & DllStructGetData($dQuery, 4) & "]")
			DllCall($hKernel32, "int", "ReadProcessMemory", "int", $hProcess, "int", $iStartAddr, "ptr", DllStructGetPtr($dBuffer), "int", DllStructGetSize($dBuffer), "int*", 0)

			$sBinString = BinaryToString(DllStructGetData($dBuffer, 1))
			$iSearch = StringInStr($sBinString, $sByteString, 2)

			If ($iSearch > 0) Then
				Return SetExtended(($iStartAddr + $iSearch), (Ptr("0x" & SwapEndianness(Hex(StringToBinary(StringMid($sBinString, ($iSearch + $iByteOffset), 4))))) + $iPtrOffset))
			EndIf
		EndIf

		$iBlockSize = DllStructGetData($dQuery, 4)

		If (Not $iBlockSize) Then
			ExitLoop
		Else
			$iStartAddr += $iBlockSize
		EndIf
	WEnd

	Return SetError(1, 0, Ptr(0))
EndFunc   ;==>ScanForPtr

Func GetClientData(ByRef $aWindows)
	If (Not $aWindows[0][0]) Then Exit 2

	ReDim $aWindows[$aWindows[0][0] + 1][3]

	$aWindows[1][2] = WinGetProcess($aWindows[1][1])

	Local $hProc = OpenProcess($aWindows[1][2])
	Local Static $iNameAddress = ScanForPtr($hProc, "90909066C705", 6)

	If (@error = 1) Then Exit 3

	For $i = 1 To $aWindows[0][0]
		Switch $i
			Case 1
				$aWindows[$i][0] = ReadProcessMemory($hProc, $iNameAddress, "wchar[30]")
				If (Not StringLen($aWindows[$i][0])) Then $aWindows[$i][0] = "无名角色";Unknown Character
				$aWindows[0][1] = $aWindows[$i][0]
			Case Else
				$aWindows[$i][2] = WinGetProcess($aWindows[$i][1])
				CloseHandle($hProc)
				$hProc = OpenProcess($aWindows[$i][2])
				$aWindows[$i][0] = ReadProcessMemory($hProc, $iNameAddress, "wchar[30]")
		EndSwitch

		If (Not StringLen($aWindows[$i][0])) Then $aWindows[$i][0] = "无名角色"
	Next

	CloseHandle($hProc)

	_ArraySort($aWindows, 0, 1)

	For $i = 1 To $aWindows[0][0]
		$aWindows[0][2] &= $aWindows[$i][0]
		If ($i <> $aWindows[0][0]) Then $aWindows[0][2] &= "|"
	Next
EndFunc   ;==>GetClientData

Func SwapEndianness($iHex)
	Return StringMid($iHex, 7, 2) & StringMid($iHex, 5, 2) & StringMid($iHex, 3, 2) & StringMid($iHex, 1, 2)
EndFunc   ;==>SwapEndianness

Func Terminate()
	Exit 0
EndFunc   ;==>Terminate

Func TerminateFinal()
	ToolTip("")

	Switch @exitCode
		Case -1
			MsgBox(0x40040, "故障", "记录器已在运行，再次启动 会影响 快键的使用", 10)
		Case 2
			MsgBox(0x40030, "故障", "尚未打开激战游戏", 10)
		Case 3
			MsgBox(0x40010, "Fatal 故障", "坐标内存地址失寻", 10)
		Case 4
			MsgBox(0x40010, "故障", "角色名内存地址失寻", 10)
		Case 5
			MsgBox(0x40030, "故障", "激战游戏失寻", 10)
	EndSwitch

	If (IsDeclared("hGWProcess") And ($hGWProcess <> 0)) Then CloseHandle($hGWProcess)
	If IsDeclared("hKernel32") Then DllClose($hKernel32)
	If IsDeclared("hUser32") Then DllClose($hUser32)
	If IsDeclared("sClipSave") Then ClipPut(Eval("sClipSave"))

	HotKeySet($sKeyExit)
	HotKeySet($sKeyPaste)
EndFunc   ;==>TerminateFinal

Func UpdateToolTip(ByRef $hTip, ByRef $iTimer, ByRef $aPosition, ByRef $sTipText)
	Local $vWindow = WinGetState($iHWndGW)
	If (@error = 1) Then Exit 5

	Select
		Case (($iTimer <> -2) And ($vWindow <> 15))
			$iTimer = (ToolTip("") - 2)
			WaitClientActive()
			If ($vWindow = 23) Then WinWaitActive($iHWndGW)

		Case ((($iTimer > 1) And (TimerDiff($iTimer) > 3500)) Or ($iTimer = -2))
			$iTimer = ToolTip($sTipText, $aPosition[0], $aPosition[1])
			Return 0
	EndSelect

	$vWindow = WinGetPos($iHWndGW)

	$vWindow[0] += 5
	$vWindow[1] += 5

	If (($vWindow[0] <> $aPosition[0]) Or ($vWindow[1] <> $aPosition[1])) Then
		WinMove($hTip, "", $vWindow[0], $vWindow[1])
		$aPosition = $vWindow
	EndIf
EndFunc   ;==>UpdateToolTip

;#cs
;~ Description: Agents X Location
Func XLocation($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'X')
EndFunc   ;==>XLocation

;~ Description: Agents Y Location
Func YLocation($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'Y')
EndFunc   ;==>YLocation
;#ce

Func WaitClientActive()
	While (WinGetState($iHWndGW) <> 15)
		If (@error = 1) Then Exit 5
		Sleep(50)
	WEnd
EndFunc   ;==>WaitClientActive