#Region Header
#Include-once

#Include <GUIConstantsEx.au3>
#Include <GUIButton.au3>
#Include <GUIImageList.au3>
#Include <SendMessage.au3>
#Include <StaticConstants.au3>
#Include <WinAPI.au3>
#Include <WindowsConstants.au3>

#EndRegion Header

#Region Global Variables and Constants

Global Const $CP_FLAG_CHOOSERBUTTON = 0x01
Global Const $CP_FLAG_TIP = 0x02
Global Const $CP_FLAG_MAGNIFICATION = 0x04
Global Const $CP_FLAG_ARROWSTYLE = 0x08
;Global Const $CP_FLAG_HANDCURSOR = 0x10
Global Const $CP_FLAG_MOUSEWHEEL = 0x20
Global Const $CP_FLAG_DEFAULT = BitOR($CP_FLAG_MAGNIFICATION, $CP_FLAG_MOUSEWHEEL)

#EndRegion Global Variables and Constants

#Region Local Variables and Constants

Global Const $CP_WM_ACTIVATE = 0x0006
Global Const $CP_WM_COMMAND = 0x0111
Global Const $CP_WM_MOUSEWHEEL = 0x020A
Global Const $CP_WM_SETCURSOR = 0x0020

Global Const $cpWidth = 8
Global Const $cpHeight = 5

Dim $cpPalette[$cpWidth * $cpHeight][2] = _
   [[0x000000, 'Black'   ], [0x993300, 'Brown'       ], [0x333300, 'Olive Green' ], [0x003300, 'Dark Green'  ], [0x003366, 'Dark Teal'      ], [0x000080, 'Dark Blue' ], [0x333399, 'Indigo'   ], [0x333333, 'Gray-80%'], _
	[0x800000, 'Dark Red'], [0xFF6600, 'Orange'      ], [0x808000, 'Dark Yellow' ], [0x008000, 'Green'       ], [0x008080, 'Teal'           ], [0x0000FF, 'Blue'      ], [0x666699, 'Blue-Gray'], [0x808080, 'Gray-50%'], _
	[0xFF0000, 'Red'     ], [0xFF9900, 'Light Orange'], [0x99CC00, 'Lime'        ], [0x339966, 'Sea Green'   ], [0x33CCCC, 'Aqua'           ], [0x3366FF, 'Light Blue'], [0x800080, 'Violet'   ], [0x999999, 'Gray-40%'], _
	[0xFF00FF, 'Pink'    ], [0xFFCC00, 'Gold'        ], [0xFFFF00, 'Yellow'      ], [0x00FF00, 'Bright Green'], [0x00FFFF, 'Turquoise'      ], [0x00CCFF, 'Sky Blue'  ], [0x993366, 'Plum'     ], [0xC0C0C0, 'Gray-25%'], _
	[0xFF99CC, 'Rose'    ], [0xFFCC99, 'Tan'         ], [0xFFFF99, 'Light Yellow'], [0xCCFFCC, 'Light Green' ], [0xCCFFFF, 'Light Turquoise'], [0x99CCFF, 'Pale Blue' ], [0xCC99FF, 'Lavender' ], [0xFFFFFF, 'White'   ]]

Dim $cpId[1][17] = [[0, 0, 0, 0, 0, 0]]
Global $__CP_WM0111 = 0
Global $__CP_WM0020 = 0

#EndRegion Local Variables and Constants

#Region Initialization
GUIRegisterMsg($CP_WM_ACTIVATE, 'CP_WM_ACTIVATE')
GUIRegisterMsg($CP_WM_COMMAND, 'CP_WM_COMMAND')
GUIRegisterMsg($CP_WM_MOUSEWHEEL, 'CP_WM_MOUSEWHEEL')
GUIRegisterMsg($CP_WM_SETCURSOR, 'CP_WM_SETCURSOR')

#EndRegion Initialization

#Region Public Functions
Func _GUIColorPicker_Create($sText, $iLeft, $iTop, $iWidth, $iHeight, $iRGB = 0, $iFlags = -1, $aPalette = 0, $iWidthPalette = -1, $iHeightPalette = -1, $hCursor = 0, $sTitle = '', $sButton = 'Custom...', $sColorFunc = '')

	If $iFlags < 0 Then
		$iFlags = $CP_FLAG_DEFAULT
	EndIf

	$sText = StringStripWS($sText, 3)
	$sTitle = StringStripWS($sTitle, 3)
	$sButton = StringStripWS($sButton, 3)
	$sColorFunc = StringStripWS($sColorFunc, 3)
	$iFlags = BitOR($iFlags, 0x0080 * (StringLen($sText) = 0), 0x0100 * (StringLen($sTitle) > 0))

	Local $ID = GUICtrlCreateButton($sText, $iLeft, $iTop, $iWidth, $iHeight)

	If $ID = 0 Then
		Return 0
	EndIf

	Local $aData, $hPrev, $hImageList, $hID = GUICtrlGetHandle($ID)

	If BitAND($iFlags, 0x0080) Then
		If BitAND($iFlags, $CP_FLAG_ARROWSTYLE) Then
			$aData = CP_CreateArrowBitmap($iRGB, $iWidth - 10, $iHeight - 10)
		Else
			$aData = CP_CreateSolidBitmap($iRGB, $iWidth - 10, $iHeight - 10)
		EndIf
		$hImageList = _GUIImageList_Create($iWidth - 10, $iHeight - 10, 5, 1)
		_GUIImageList_Add($hImageList, $aData[0], $aData[1])
		_GUICtrlButton_SetImageList($hID, $hImageList, 4)
		For $i = 0 To 1
			_WinAPI_DeleteObject($aData[$i])
		Next
	EndIf
	If $iWidthPalette < 4 Then
		$iWidthPalette = $cpWidth
	EndIf
	If $iHeightPalette < 4 Then
		$iHeightPalette = $cpHeight
	EndIf
	If $hCursor Then
		Switch $hCursor
			Case 32512 To 32516, 32640 To 32650
				$hCursor = DllCall('user32.dll', 'ptr', 'LoadCursor', 'ptr', 0, 'dword', $hCursor)
			Case Else
				$hCursor = DllCall('user32.dll', 'ptr', 'CopyIcon', 'ptr', $hCursor)
		EndSwitch
		If (Not @error) And ($hCursor[0]) Then
			$hCursor = $hCursor[0]
		Else
			$hCursor = 0
		EndIf
	EndIf
	ReDim $cpId[$cpId[0][0] + 2][UBound($cpId, 2)]
	$cpId[0][0] += 1
	$cpId[$cpId[0][0]][0 ] = $ID
	$cpId[$cpId[0][0]][1 ] = $hID
	$cpId[$cpId[0][0]][2 ] = $hImageList
	$cpId[$cpId[0][0]][3 ] = $iRGB
	$cpId[$cpId[0][0]][4 ] = CP_ValidatePalette($aPalette, $iWidthPalette * $iHeightPalette, 0xFFFFFF)
	$cpId[$cpId[0][0]][5 ] = $sText
	$cpId[$cpId[0][0]][6 ] = $sTitle
	$cpId[$cpId[0][0]][7 ] = $iFlags
	$cpId[$cpId[0][0]][8 ] = $sButton
	$cpId[$cpId[0][0]][9 ] = $iWidthPalette
	$cpId[$cpId[0][0]][10] = $iHeightPalette
	$cpId[$cpId[0][0]][11] = $iWidth
	$cpId[$cpId[0][0]][12] = $iHeight
	$cpId[$cpId[0][0]][13] = _WinAPI_GetParent($hID)
	$cpId[$cpId[0][0]][14] = $hCursor
	$cpId[$cpId[0][0]][15] = $sColorFunc
	$cpId[$cpId[0][0]][16] = 0
	Return $ID
EndFunc   ;==>_GUIColorPicker_Create

Func _GUIColorPicker_Delete($controlID)
	For $i = 1 To $cpId[0][0]
		If $cpId[$i][0] = $controlID Then
			If Not GUICtrlDelete($cpId[$i][0]) Then
				Return 0
			EndIf
			If BitAND($cpId[$i][7], 0x0080) Then
				$cpId[$i][3] = -1
				CP_SetColor($i)
			EndIf
			If $cpId[$i][14] Then
				DllCall('user32.dll', 'int', 'DestroyCursor', 'ptr', $cpId[$i][14])
			EndIf
			For $j = $i To $cpId[0][0] - 1
				For $k = 0 To UBound($cpId, 2) - 1
					$cpId[$j][$k] = $cpId[$j + 1][$k]
				Next
			Next
			$cpId[0][0] -= 1
			ReDim $cpId[$cpId[0][0] + 1][UBound($cpId, 2)]
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>_GUIColorPicker_Delete

Func _GUIColorPicker_Release($hWnd)

	If Not WinExists($hWnd) Then
		Return SetError(1, 0, 0)
	EndIf

	Local $Count = 1, $Result = 0

	While $Count <= $cpId[0][0]
		If $cpId[$Count][13] = $hWnd Then
			If Not _GUIColorPicker_Delete($cpId[$Count][0]) Then
				Return 0
			EndIf
			$Result = 1
		Else
			$Count += 1
		EndIf
	WEnd
	Return $Result
EndFunc   ;==>_GUIColorPicker_Release

Func _GUIColorPicker_GetColor($controlID, $iFlag = 0)

	Local $Data, $Palette, $Name = ''

	For $i = 1 To $cpId[0][0]
		If $cpId[$i][0] = $controlID Then
			If $iFlag Then
				$Palette = $cpId[$i][4]
				For $j = 0 To UBound($Palette) - 1
					If $cpId[$i][3] = $Palette[$j][0] Then
						$Name = $Palette[$j][1]
						ExitLoop
					EndIf
				Next
				Dim $Data[2] = [$cpId[$i][3], $Name]
				Return $Data
			Else
				Return $cpId[$i][3]
			EndIf
		EndIf
	Next
	Return -1
EndFunc   ;==>_GUIColorPicker_GetColor

Func _GUIColorPicker_SetColor($controlID, $iRGB)
	For $i = 1 To $cpId[0][0]
		If $cpId[$i][0] = $controlID Then
			$cpId[$i][3] = $iRGB
			If BitAND($cpId[$i][7], 0x0080) Then
				CP_SetColor($i)
			EndIf
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>_GUIColorPicker_SetColor

Func _GUIColorPicker_GetPalette($controlID, $iFlag = 0)

	Local $Data, $Palette

	For $i = 1 To $cpId[0][0]
		If $cpId[$i][0] = $controlID Then
			If $iFlag Then
				Return $cpId[$i][4]
			Else
				$Palette = $cpId[$i][4]
				Dim $Data[UBound($Palette)]
				For $i = 0 To UBound($Palette) - 1
					$Data[$i] = $Palette[$i][0]
				Next
				Return $Data
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>_GUIColorPicker_GetPalette

Func _GUIColorPicker_SetPalette($controlID, $aPalette)
	For $i = 1 To $cpId[0][0]
		If $cpId[$i][0] = $controlID Then
			$cpId[$i][4] = CP_ValidatePalette($aPalette, $cpId[$i][9] * $cpId[$i][10], 0xFFFFFF)
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>_GUIColorPicker_SetPalette

#EndRegion Public Functions

#Region Internal Functions

Func CP_Assign(ByRef $iVariable, $iValue)
	$iVariable = $iValue
EndFunc   ;==>CP_Assign

Func CP_CreateArrowBitmap($iRGB, $iWidth, $iHeight)

	Local $hDC, $hBackDC, $hFrontDC, $hFront, $hBack, $hPen
	Local $aData[2]

	$hDC = _WinAPI_GetDC(0)
	$hBackDC = _WinAPI_CreateCompatibleDC($hDC)
	$hBack = _WinAPI_CreateSolidBitmap(0, 0, $iWidth, $iHeight)
	_WinAPI_SelectObject($hBackDC, $hBack)
	$hFrontDC = _WinAPI_CreateCompatibleDC($hDC)
	$hFront = _WinAPI_CreateSolidBitmap(0, 0xFFFFFF, $iWidth - 11, $iHeight)
	_WinAPI_SelectObject($hFrontDC, $hFront)
	_WinAPI_BitBlt($hBackDC, 0, 0, $iWidth - 11, $iHeight, $hFrontDC, 0, 0, $SRCCOPY)
	_WinAPI_DeleteObject($hFront)
	$hFront = _WinAPI_CreateSolidBitmap(0, $iRGB, $iWidth - 11 - 2, $iHeight - 2)
	_WinAPI_SelectObject($hFrontDC, $hFront)
	_WinAPI_BitBlt($hBackDC, 1, 1, $iWidth - 11 - 2, $iHeight - 2, $hFrontDC, 0, 0, $SRCCOPY)
	$aData[0] = $hBack
	_WinAPI_DeleteObject($hFront)
	$hBack = _WinAPI_CreateSolidBitmap(0, 0xFFFFFF, $iWidth, $iHeight)
	_WinAPI_SelectObject($hBackDC, $hBack)
	$hFront = _WinAPI_CreateSolidBitmap(0, 0, $iWidth - 11, $iHeight)
	_WinAPI_SelectObject($hFrontDC, $hFront)
	_WinAPI_BitBlt($hBackDC, 0, 0, $iWidth - 11, $iHeight, $hFrontDC, 0, 0, $SRCCOPY)
	_WinAPI_DeleteObject($hFront)
	$hPen = _WinAPI_CreatePen($PS_SOLID, 1, 0)
	_WinAPI_SelectObject($hBackDC, $hPen)
	For $i = 1 To 4
		_WinAPI_DrawLine($hBackDC, $iWidth - $i - 4, Int($iHeight / 2) + Mod($iHeight, 2) - $i + 2, $iWidth + $i - 5, Int($iHeight / 2) + Mod($iHeight, 2) - $i + 2)
	Next
	$aData[1] = $hBack
	_WinAPI_DeleteObject($hPen)
	_WinAPI_ReleaseDC(0, $hDC)
	_WinAPI_DeleteDC($hFrontDC)
	_WinAPI_DeleteDC($hBackDC)
	Return $aData
EndFunc   ;==>CP_CreateArrowBitmap

Func CP_CreateSolidBitmap($iRGB, $iWidth, $iHeight)

	Local $hDC, $hBackDC, $hFrontDC, $hFront, $hBack
	Local $aData[2]

	$hDC = _WinAPI_GetDC(0)
	$hBackDC = _WinAPI_CreateCompatibleDC($hDC)
	$hBack = _WinAPI_CreateSolidBitmap(0, 0xFFFFFF, $iWidth, $iHeight)
	_WinAPI_SelectObject($hBackDC, $hBack)
	$hFrontDC = _WinAPI_CreateCompatibleDC($hDC)
	$hFront = _WinAPI_CreateSolidBitmap(0, $iRGB, $iWidth - 2, $iHeight - 2)
	_WinAPI_SelectObject($hFrontDC, $hFront)
	_WinAPI_BitBlt($hBackDC, 1, 1, $iWidth - 2, $iHeight - 2, $hFrontDC, 0, 0, $SRCCOPY)
	$aData[0] = $hBack
	$aData[1] = 0
	_WinAPI_DeleteObject($hFront)
	_WinAPI_ReleaseDC(0, $hDC)
	_WinAPI_DeleteDC($hFrontDC)
	_WinAPI_DeleteDC($hBackDC)
	Return $aData
EndFunc   ;==>CP_CreateSolidBitmap

Func CP_ColorChooserDlg($iRGB, $hWnd)

	Local $tCHOOSECOLOR = DllStructCreate('dword;hwnd;hwnd;dword;ptr;dword;lparam;ptr;ptr')
	Local $tCC = DllStructCreate('int[16]')

	DllStructSetData($tCHOOSECOLOR, 1, DllStructGetSize($tCHOOSECOLOR))
	DllStructSetData($tCHOOSECOLOR, 2, $hWnd)
	DllStructSetData($tCHOOSECOLOR, 4, CP_SwitchColor($iRGB))
	DllStructSetData($tCHOOSECOLOR, 5, DllStructGetPtr($tCC))
	DllStructSetData($tCHOOSECOLOR, 6, 0x103)

	Local $Ret = DllCall('comdlg32.dll', 'long', 'ChooseColor', 'ptr', DllStructGetPtr($tCHOOSECOLOR))

	If $Ret[0] = 0 Then
		Return -1
	EndIf
	Return CP_SwitchColor(DllStructGetData($tCHOOSECOLOR, 4))
EndFunc   ;==>CP_ColorChooserDlg

Func CP_Index($controlID, ByRef $aData)
	For $i = 0 To UBound($aData) - 1
		If $aData[$i] = $controlID Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>CP_Index

Func CP_PickerDlg($ID)

	Local $Msg, $X, $Y, $Cursor, $Index, $Prev, $Rgb, $Size, $Active = 0, $Custom = -1, $Result = 0, $Pressed = False
	Local $Label[$cpId[$ID][9] * $cpId[$ID][10]]
	Local $Accel[2][2] = [['{ENTER}', 0], ['{ESC}', 0]]
	Local $Width = 25 * $cpId[$ID][9] + 3, $Height = 25 * $cpId[$ID][10] + 3
	Local $dH = 28 * (BitAND($cpId[$ID][7], 0x0100) = 0x0100)
	Local $tRECT = _WinAPI_GetWindowRect($cpId[$ID][1])
	Local $GUIOnEventMode = Opt('GUIOnEventMode', 0)
	Local $Taskbar = CP_TaskbarHeight()
	Local $Palette = $cpId[$ID][4]

	$X = DllStructGetData($tRECT, 1)
	$Y = DllStructGetData($tRECT, 4)
	If $X < 0 Then
		$X = 0
	EndIf
	If $X > @DesktopWidth - ($Width + 6) Then
		$X = @DesktopWidth - ($Width + 6)
	EndIf
	If $Y < 0 Then
		$Y = 0
	EndIf
	If $Y > @DesktopHeight - $Taskbar - $dH - 28 * BitAND($cpId[$ID][7], $CP_FLAG_CHOOSERBUTTON) - ($Height + 6) Then
		$Y = @DesktopHeight - $Taskbar - $dH - 28 * BitAND($cpId[$ID][7], $CP_FLAG_CHOOSERBUTTON) - ($Height + 6)
	EndIf
	$cpId[0][2] = GUICreate('', $Width, $Height + $dH + 28 * BitAND($cpId[$ID][7], $CP_FLAG_CHOOSERBUTTON), $X, $Y, $WS_POPUP, $WS_EX_DLGMODALFRAME, $cpId[$ID][13])
;	GUISetBkColor(0xFCFCFC, $cpId[0][2])
	If BitAND($cpId[$ID][7], 0x0100) Then
		GUICtrlCreateLabel('', 4, 4, $Width - 8, 23, $SS_GRAYFRAME)
		GUICtrlCreateLabel($cpId[$ID][6], 6, 9, $Width - 12, 14, $SS_CENTER)
		GUICtrlSetFont(-1, 8.5, 400, 0, 'MS Shell Dlg')
	EndIf
	For $i = 1 To $cpId[$ID][10]
		For $j = 1 To $cpId[$ID][9]
			$Index = ($i - 1) * $cpId[$ID][9] + $j - 1
			If ($Active = 0) And ($cpId[$ID][3] = $Palette[$Index][0]) And (BitAND($cpId[$ID][7], $CP_FLAG_MAGNIFICATION)) Then
				$Label[$Index] = GUICtrlCreateLabel('', 2 + 25 * ($j - 1), 2 + $dH + 25 * ($i - 1), 24, 24, $SS_SUNKEN)
				$Active = $Label[$Index]
			Else
				$Label[$Index] = GUICtrlCreateLabel('', 4 + 25 * ($j - 1), 4 + $dH + 25 * ($i - 1), 20, 20, $SS_SUNKEN)
			EndIf
			GUICtrlSetBkColor(-1, $Palette[$Index][0])
			If BitAND($cpId[$ID][7], $CP_FLAG_TIP) Then
				GUICtrlSetTip(-1, $Palette[$Index][1])
			EndIf
			If $cpId[$ID][14] Then
				GUICtrlSetState(-1, $GUI_DISABLE)
			EndIf
		Next
	Next
	$cpId[0][3] = GUICtrlCreateDummy()
	For $i = 0 To 1
		$Accel[$i][1] = $cpId[0][3]
	Next
	If BitAND($cpId[$ID][7], $CP_FLAG_CHOOSERBUTTON) Then
		$Custom = GUICtrlCreateButton('', 0, 0)
		$Size = CP_StringSize($Custom, $cpId[$ID][8]) + 24
		If $Size > $Width - 6 Then
			$Size = $Width - 6
		EndIf
		GUICtrlSetPos(-1, Int(($Width - $Size) / 2), $Height + 2 + $dH, $Size + Mod($Width - $Size, 2), 21)
		GUICtrlSetFont(-1, 8.5, 400, 0, 'MS Shell Dlg')
		GUICtrlSetData(-1, $cpId[$ID][8])
	EndIf

	GUISetAccelerators($Accel, $cpId[0][2])
	GUISetState(@SW_SHOW, $cpId[0][2])

	While 1
		$Cursor = GUIGetCursorInfo($cpId[0][2])
		If Not @error Then
			If CP_PtInRect($Cursor[0], $Cursor[1], 2, 2 + $dH, 25 * $cpId[$ID][9], $dH + 25 * $cpId[$ID][10]) Then
				$cpId[0][4] = $cpId[$ID][14]
			Else
				$cpId[0][4] = 0
			EndIf
			If BitXOR($Active, $Cursor[4]) Then
				If Not $Cursor[2] Then
					For $i = 0 To UBound($Label) - 1
						If $Cursor[4] = $Label[$i] Then
							If BitAND($cpId[$ID][7], $CP_FLAG_MAGNIFICATION) Then
								$Index = CP_Index($Active, $Label)
								GUICtrlSetPos($Active, 4 + 25 * Mod($Index, $cpId[$ID][9]), 4 + $dH + 25 * ($Index - Mod($Index, $cpId[$ID][9])) / $cpId[$ID][9], 20, 20)
								GUICtrlSetPos($Label[$i], 2 + 25 * Mod($i, $cpId[$ID][9]), 2 + $dH + 25 * ($i - Mod($i, $cpId[$ID][9])) / $cpId[$ID][9], 24, 24)
							EndIf
							$Active = $Label[$i]
							ExitLoop
						EndIf
					Next
				EndIf
			Else
				If ($Cursor[2]) And (Not $Pressed) Then
					$Index = CP_Index($Cursor[4], $Label)
					If $Index > -1 Then
						$cpId[$ID][3] = $Palette[$Index][0]
						$Result = 2
						ExitLoop
					EndIf
				EndIf
			EndIf
			$Pressed = $Cursor[2]
		EndIf
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE, $cpId[0][3]
				ExitLoop
			Case $Custom
				$Result = 1
				ExitLoop
		EndSwitch
	WEnd

	$cpId[0][5] = 1

	GUIDelete($cpId[0][2])

	$cpId[0][2] = 0
	$cpId[0][3] = 0
	$cpId[0][4] = 0
	$cpId[0][5] = 0

	Opt('GUIOnEventMode', $GUIOnEventMode)

	Switch $Result
		Case 0
			Return 0
		Case 1
			If $cpId[$ID][15] = '' Then
				$Rgb = CP_ColorChooserDlg($cpId[$ID][3], $cpId[$ID][13])
			Else
				If (IsDeclared('ccData')) And ($cpId[$ID][15] = '_ColorChooserDialog') Then
					Execute('CP_Assign($Prev, $ccData[9])')
					Execute('CP_Assign($ccData[9], $cpId[$ID][14])')
					$Cursor = 1
				Else
					$Cursor = 0
				EndIf
				$Rgb = Call($cpId[$ID][15], $cpId[$ID][3], $cpId[$ID][13])
				If (@error = 0xDEAD) And (@extended = 0xBEEF) Then
					$Rgb = -1
				EndIf
				If $Cursor Then
					Execute('CP_Assign($ccData[9], $Prev)')
				EndIf
			EndIf
			If $Rgb < 0 Then
				_WinAPI_SetFocus($cpId[$ID][1])
				Return 0
			EndIf
			$cpId[$ID][3] = $Rgb
			ContinueCase
		Case 2
			If BitAND($cpId[$ID][7], 0x0080) Then
				CP_SetColor($ID)
			EndIf
	EndSwitch
	_WinAPI_SetFocus($cpId[$ID][1])
	Return 1
EndFunc   ;==>CP_PickerDlg

Func CP_PtInRect($iXn, $iYn, $iX1, $iY1, $iX2, $iY2)
	If ($iXn >= $iX1) And ($iXn <= $iX2) And ($iYn >= $iY1) And ($iYn <= $iY2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>CP_PtInRect

Func CP_SetColor($ID)

	Local $aData

	If $cpId[$ID][3] < 0 Then
		_GUIImageList_Destroy($cpId[$ID][2])
	Else
		If BitAND($cpId[$ID][7], $CP_FLAG_ARROWSTYLE) Then
			$aData = CP_CreateArrowBitmap($cpId[$ID][3], $cpId[$ID][11] - 10, $cpId[$ID][12] - 10)
		Else
			$aData = CP_CreateSolidBitmap($cpId[$ID][3], $cpId[$ID][11] - 10, $cpId[$ID][12] - 10)
		EndIf
		_GUIImageList_Remove($cpId[$ID][2])
		_GUIImageList_Add($cpId[$ID][2], $aData[0], $aData[1])
		_GUICtrlButton_SetImageList($cpId[$ID][1], $cpId[$ID][2], 4)
		For $i = 0 To 1
			_WinAPI_DeleteObject($aData[$i])
		Next
	EndIf
EndFunc   ;==>CP_SetColor

Func CP_StringSize($hWnd, $sText)

	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If Not $hWnd Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $hDC, $hFont, $hOld, $tSize

	$hDC = _WinAPI_GetDC($hWnd)
	$hFont = _SendMessage($hWnd, $WM_GETFONT)
	$hOld = _WinAPI_SelectObject($hDC, $hFont)
	$tSize = _WinAPI_GetTextExtentPoint32($hDC, $sText)
	_WinAPI_SelectObject($hDC, $hOld)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	Return SetError(0, 0, DllStructGetData($tSize, 1))
EndFunc   ;==>CP_StringSize

Func CP_SwitchColor($iRGB)
	Return BitOR(BitAND($iRGB, 0x00FF00), BitShift(BitAND($iRGB, 0x0000FF), -16), BitShift(BitAND($iRGB, 0xFF0000), 16))
EndFunc   ;==>CP_SwitchColor

Func CP_TaskbarHeight()

	Local $tRECT = DllStructCreate($tagRECT)
	Local $Ret = DllCall('user32.dll', 'int', 'SystemParametersInfo', 'int', 48, 'int', 0, 'ptr', DllStructGetPtr($tRECT), 'int', 0)

	If (@error) Or ($Ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf
	Return @DesktopHeight - DllStructGetData($tRECT, 4)
EndFunc   ;==>CP_TaskbarHeight

Func CP_ValidatePalette($aPalette, $iSize, $iRGB = 0)

	If Not IsArray($aPalette) Then
		$aPalette = $cpPalette
	EndIf

	Local $Data, $Dim = UBound($aPalette)

	Dim $Data[$Dim][2]
	Switch UBound($aPalette, 2)
		Case 0
			For $i = 0 To $Dim - 1
				$Data[$i][0] = $aPalette[$i]
				$Data[$i][1] = Hex($aPalette[$i], 6)
			Next
		Case 1
			For $i = 0 To $Dim - 1
				$Data[$i][0] = $aPalette[$i][0]
				$Data[$i][1] = Hex($aPalette[$i], 6)
			Next
		Case Else
			For $i = 0 To $Dim - 1
				$Data[$i][0] = $aPalette[$i][0]
				$Data[$i][1] = $aPalette[$i][1]
			Next
	EndSwitch
	Select
		Case $Dim > $iSize
			ReDim $Data[$Dim][2]
		Case $Dim < $iSize
			ReDim $Data[$iSize][2]
			For $i = $Dim To $iSize - 1
				$Data[$i][0] = $iRGB
				$Data[$i][1] = Hex($iRGB, 6)
			Next
	EndSelect
	Return $Data
EndFunc   ;==>CP_ValidatePalette

#EndRegion Internal Functions

#Region Windows Message Functions

Func CP_WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $cpId[0][2]
			Switch BitAND($wParam, 0xFFFF)
				Case 0 ; WA_INACTIVE
					If Not $cpId[0][5] Then
						$cpId[0][5] = 1
						_WinAPI_ShowWindow($cpId[0][2], @SW_HIDE)
						GUICtrlSendToDummy($cpId[0][3])
					EndIf
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>CP_WM_ACTIVATE

Func CP_WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)

	; Handler from ColorChooser.au3
	If (IsDeclared('__CC_WM0111')) And (Not Eval('__CC_WM0111')) Then
		$__CP_WM0111 = 1
		Call('CC' & '_WM_COMMAND', $hWnd, $iMsg, $wParam, $lParam)
		$__CP_WM0111 = 0
	EndIf

	For $i = 1 To $cpId[0][0]
		If $cpId[$i][1] = $lParam Then
			If Number($wParam) > 0 Then
				If Not CP_PickerDlg($i) Then
					Return 0
				EndIf
			EndIf
			ExitLoop
		EndIf
	Next
	Return $GUI_RUNDEFMSG
EndFunc   ;==>CP_WM_COMMAND

Func CP_WM_MOUSEWHEEL($hWnd, $iMsg, $wParam, $lParam)

	Local $Focus = _WinAPI_GetFocus()

	For $i = 1 To $cpId[0][0]
		If ($cpId[$i][1] = $Focus) And (BitAND($cpId[$i][7], BitOR($CP_FLAG_MOUSEWHEEL, 0x0080)) = BitOR($CP_FLAG_MOUSEWHEEL, 0x0080)) Then

			Local $Palette = $cpId[$i][4]
			Local $Wheel = Round(BitShift($wParam, 16) / 120)
			Local $Max = UBound($Palette) - 1
			Local $Pos, $Index = 0

			For $j = 0 To $Max
				If $cpId[$i][3] = $Palette[$j][0] Then
					$Index = $j
					ExitLoop
				EndIf
			Next
			$Pos = $Index - $Wheel
			If $Pos < 0 Then
				$Pos = 0
			EndIf
			If $Pos > $Max Then
				$Pos = $Max
			EndIf
			If BitXOR($Pos, $Index) Then
				$cpId[$i][3] = $Palette[$Pos][0]
				CP_SetColor($i)
				_WinAPI_SetFocus($cpId[$i][1])
				_SendMessage($hWnd, $CP_WM_COMMAND, 0, $cpId[$i][1])
			EndIf
		EndIf
	Next
	Return $GUI_RUNDEFMSG
EndFunc   ;==>CP_WM_MOUSEWHEEL

Func CP_WM_SETCURSOR($hWnd, $iMsg, $wParam, $lParam)

	Local $Result

	; Handler from ColorChooser.au3
	If (IsDeclared('__CC_WM0020')) And (Not Eval('__CC_WM0020')) Then
		$__CP_WM0020 = 1
		$Result = Call('CC' & '_WM_SETCURSOR', $hWnd, $iMsg, $wParam, $lParam)
		$__CP_WM0020 = 0
		If Not $Result Then
			Return  0
		EndIf
	EndIf

	Switch $hWnd
		Case $cpId[0][2]
			If $cpId[0][4] Then
				_WinAPI_SetCursor($cpId[0][4])
				Return 0
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>CP_WM_SETCURSOR

#EndRegion Windows Message Functions
