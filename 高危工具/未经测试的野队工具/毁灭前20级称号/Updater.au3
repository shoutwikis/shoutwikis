#include <file.au3>

_OnAutoItErrorRegister("")

Global $UpdateHeaders = True
Global $UpdateOffsets = True
Global $UpdateLines = True

$FileName = FileOpenDialog("Open", @ScriptDir, "Autoit (*.au3)")
Local $FileArray
_FileReadToArray($FileName, $FileArray, 1)
ProgressOn ( "GWA2 Updater!", "Updating...")
For $i = 1 To $FileArray[0]
   If Not CheckValidString($FileArray[$i]) Then ContinueLoop
   If $UpdateOffsets Then
	  If StringRegExp($FileArray[$i-1], "(\[2\]).*(0x2C)") And StringRegExp($FileArray[$i-2], "(\[1\]).*(0x18)") Then
		 $lTemp = UpdateOffsetMulti($FileArray[$i])
		 If $lTemp Then
			ConsoleWrite($FileArray[$i] & ' -> ' & $lTemp & @CRLF)
			$FileArray[$i] = $lTemp
			ContinueLoop
		 EndIf
	  EndIf
	  $lTemp = UpdateOffset($FileArray[$i])
	  If $lTemp Then
		 ConsoleWrite($FileArray[$i] & ' -> ' & $lTemp & @CRLF)
		 $FileArray[$i] = $lTemp
		 ContinueLoop
	  EndIf
   EndIf
   If $UpdateHeaders Then
	  $lTemp = UpdateHeader($FileArray[$i])
	  If $lTemp Then
		 ConsoleWrite($FileArray[$i] & ' -> ' & $lTemp & @CRLF)
		 $FileArray[$i] = $lTemp
		 ContinueLoop
	  EndIf
   EndIf
   If $UpdateLines Then
	  $lTemp = UpdateLine($FileArray[$i])
	  If $lTemp Then
		 ConsoleWrite($FileArray[$i] & ' -> ' & $lTemp & @CRLF)
		 $FileArray[$i] = $lTemp
		 ContinueLoop
	  EndIf
   EndIf
   ProgressSet ($i/$FileArray[0]*100)
Next
$NewFileName = StringTrimRight($FileName, 4) & "_new.au3"
_FileWriteFromArray($NewFileName, $FileArray, 1)

#Region Update Functions
;~ Description: Returns true if string is to be processed.
Func CheckValidString($aString)
   If StringInStr($aString, "Func ") Then Return False
   Return True
EndFunc

;~ Description: Adds 0x1 to packet header.
Func UpdateHeader($aString)
   $lStart = StringInStr($aString, "Sendpacket(")
   If $lStart = 0 Then Return ; no sendpacket, doh
   $lHeaderStart = StringInStr($aString, ",", 0, 1, $lStart) + 1
   $lHeaderEnd = StringInStr($aString, ",", 0, 1, $lHeaderStart)
   If $lHeaderEnd = 0 Then
	  $lHeaderEnd = StringInStr($aString, ")", 0, 1, $lHeaderStart)
   EndIf
   $lHeaderString = Int(StringStripWS(StringMid($aString, $lHeaderStart, $lHeaderEnd - $lHeaderStart), 1))
   $lHeaderString += 1
   $lHeaderString = StringFormat("0x%X", $lHeaderString) ; kudos 4D1
   Return StringLeft($aString, $lHeaderStart) & $lHeaderString & StringRight($aString, StringLen($aString) - $lHeaderEnd + 1)
EndFunc

;~ Description: Adds 0x64 to offset, if offset array is declared in one line.
Func UpdateOffset($aString)
   $lStart = StringInStr($aString, "0x18,")
   If $lStart = 0 Then Return
   $lStart = StringInStr($aString, "0x2C,", 0, 1, $lStart + 5)
   If $lStart = 0 Then Return
   $lStart += 5
   $lEnd = StringInStr($aString, ",", 0, 1, $lStart) - 1
   If $lEnd < 0 Then
	  $lEnd = StringInStr($aString, "]", 0, 1, $lStart) - 1
   EndIf
   If $lEnd < 0 Then
	  $lEnd = StringLen($aString)
   EndIf
   $lOffset = Int(StringStripWS(StringMid($aString, $lStart, $lEnd - $lStart + 1), 1))
   If $lOffset < 173 Then Return
   $lOffset = $lOffset + 100
   $lOffset = StringFormat("0x%X", $lOffset)
   Return StringLeft($aString, $lStart) & $lOffSet & StringRight($aString, StringLen($aString) - $lEnd)
EndFunc

;~ Description: Adds 0x64 to offset, if offset array is declared using multiple lines.
Func UpdateOffsetMulti($aString)
   $lStart = StringInStr($aString, "=")
   If $lStart = 0 Then Return
   $lStart += 1
   $lOffset = StringStripWS(StringRight($aString, StringLen($aString) - $lStart), 1)
   If $lOffset < 173 Then Return
   $lOffset = Int($lOffset + 100)
   $lOffset = StringFormat("0x%X", $lOffset)
   Return StringLeft($aString, $lStart) & $lOffset
EndFunc

;~ Description: Update whole lines.
Func UpdateLine($aString)
   ; UseHeroSkill
   If StringRegExp($aString, "SetValue\(.UseHeroSkillFunction") Then
	  Return StringLeft($aString, StringInStr($aString, "SetValue") - 1) & "SetValue('UseHeroSkillFunction', '0x' & Hex(GetScannedAddress('ScanUseHeroSkillFunction', -0xA1), 8))" ; kudos 4D1
   EndIf
   If StringInStr($aString, "8B782C8B333BB7") <> 0 Then
	  Return StringLeft($aString, StringInStr($aString, "AddPattern") - 1) & "AddPattern('8D0C765F5E8B')"
   EndIf
   ; DecreaseAttribute
   If StringRegExp($aString, "SetValue\(.DecreaseAttributeFunction") Then
	  Return StringLeft($aString, StringInStr($aString, "SetValue") - 1) & "SetValue('DecreaseAttributeFunction', '0x' & Hex(GetScannedAddress('ScanIncreaseAttributeFunction', -288), 8))"
   EndIf
   ; SendChat
   If StringRegExp(StringStripWS($aString, 8), "DllStructSetData\(\$mSendChat,2") Then
	  Return StringLeft($aString, StringInStr($aString, "DllStruct") - 1) & "DllStructSetData($mSendChat, 2, 0x5E)"
   EndIf
   ; MaxAttributes
   If StringRegExp(StringStripWS($aString, 8), "DllStructSetData\(\$mMaxAttributes,3") Then
	  Return StringLeft($aString, StringInStr($aString, "DllStruct") - 1) & "DllStructSetData($mMaxAttributes, 3, 9)"
   EndIf
   If StringRegExp(StringStripWS($aString, 8), "DllStructSetData\(\$mMaxAttributes,5") Then
	  Return StringLeft($aString, StringInStr($aString, "DllStruct") - 1) & "DllStructSetData($mMaxAttributes, 5, 3)"
   EndIf
   If StringRegExp(StringStripWS($aString, 8), "DllStructSetData\(\$mMaxAttributes,22") Then
	  Return StringLeft($aString, StringInStr($aString, "DllStruct") - 1) & "DllStructSetData($mMaxAttributes, 22, 3)"
   EndIf
   ; SetAttributes
   If StringRegExp(StringStripWS($aString, 8), "DllStructSetData\(\$mSetAttributes,3") Then
	  Return StringLeft($aString, StringInStr($aString, "DllStruct") - 1) & "DllStructSetData($mSetAttributes, 3, 9)"
   EndIf
   ; $lOffset[3] = 0x4A4
   If $UpdateOffsets And StringInStr(StringStripWS($aString, 8), "[3]=0x4A4") Then
	  Return StringLeft($aString, StringInStr($aString, "$") - 1) & "$lOffset[3] = 0x508"
   EndIf
EndFunc
#EndRegion

#Region Autoit UDFs
; #FUNCTION# ====================================================================================================
; Name...........:	_OnAutoItErrorRegister
; Description....:	Registers a function to be called when AutoIt produces a critical error (syntax error usualy).
; Syntax.........:	_OnAutoItErrorRegister( [$sFunction = "" [, $vParams = "" [, $sTitleMsg = -1 [, $sErrorMsgFormat = -1 [, $bUseStdOutMethod = True]]]]])
; Parameters.....:	$sFunction        - [Optional] The name of the user function to call.
;                                                 If this parameter is empty (""), then default (built-in) error message function is called.
;					$vParams          - [Optional] Parameter(s) that passed to $sFunction (default is "" - no parameters).
;					$sTitleMsg        - [Optional] The title of the default error message dialog (used only if $sFunction = "").
;					$sErrorMsgFormat  - [Optional] Formated error message string of the default error message dialog (used only if $sFunction = "").
;					$bUseStdOutMethod - [Optional] Defines the method that will be used to catch AutoIt errors (default is True - use StdOut).
;
; Return values..:	None.
; Author.........:	G.Sandler (CreatoR), www.autoit-script.ru, www.creator-lab.ucoz.ru
; Modified.......:
; Remarks........:	The UDF can not handle crashes that triggered by memory leaks, such as DllCall crashes.
;                   This UDF uses StdOut method by default (it's not compatible with CUI application),
;                    if you don't like it you can set "AutoIt error window catching" method by passing False in $bUseStdOutMethod parameter.
; Related........:
; Link...........:
; Example........:	Yes.
; ===============================================================================================================
Func _OnAutoItErrorRegister($sFunction = "", $vParams = "", $sTitleMsg = -1, $sErrorMsgFormat = -1, $bUseStdOutMethod = True)
	Local $hAutoItWin = __OnAutoItErrorRegister_WinGetHandleByPID(@AutoItPID)
	Local $sText = ControlGetText($hAutoItWin, '', 'Edit1')

	If StringInStr($sText, '/OAER') Then
		ControlSetText($hAutoItWin, '', 'Edit1', StringTrimRight($sText, 5))
		Return
	Else
		Opt("TrayIconHide", 1)
	EndIf

	Local $sErrorMsg = "", $sRunLine, $iPID, $iWinExists

	If $bUseStdOutMethod Then
		$sRunLine = @AutoItExe & ' /ErrorStdOut /AutoIt3ExecuteScript "' & @ScriptFullPath & '"'

		If $CmdLine[0] > 0 Then
			For $i = 1 To $CmdLine[0]
				$sRunLine &= ' ' & $CmdLine[$i]
			Next
		EndIf

		$iPID = Run($sRunLine, @ScriptDir, 0, 2 + 4)

		$hAutoItWin = __OnAutoItErrorRegister_WinWaitByPID($iPID, '[CLASS:AutoIt v3]')
		$sText = ControlGetText($hAutoItWin, '', 'Edit1')
		ControlSetText($hAutoItWin, '', 'Edit1', $sText & '/OAER')

		While 1
			$sErrorMsg &= StdoutRead($iPID)

			If @error Or StderrRead($iPID) = -1 Then
				ExitLoop
			EndIf

			Sleep(10)
		WEnd
	Else
		$sRunLine = @AutoItExe & ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '"'

		If $CmdLine[0] > 0 Then
			For $i = 1 To $CmdLine[0]
				$sRunLine &= ' ' & $CmdLine[$i]
			Next
		EndIf

		$iPID = Run($sRunLine, @ScriptDir, 0, 4)

		Opt("WinWaitDelay", 0)

		$hAutoItWin = __OnAutoItErrorRegister_WinWaitByPID($iPID, '[CLASS:AutoIt v3]')
		$sText = ControlGetText($hAutoItWin, '', 'Edit1')
		ControlSetText($hAutoItWin, '', 'Edit1', $sText & '/OAER')

		$iWinExists = 0

		While ProcessExists($iPID)
			$iWinExists = WinExists("[CLASS:#32770;REGEXPTITLE:.*? Error]", "Line ")

			If $iWinExists Or StderrRead($iPID) = -1 Then
				ExitLoop
			EndIf

			Sleep(10)
		WEnd

		If Not $iWinExists Then
			Exit
		EndIf

		$sErrorMsg = ControlGetText("[CLASS:#32770;REGEXPTITLE:.*? Error]", "Line ", "Static2")
		WinClose("[CLASS:#32770;REGEXPTITLE:.*? Error]", "Line ")
	EndIf

	If $sErrorMsg = "" Then
		Exit
	EndIf

	If $sFunction = "" Then
;~ 		__OnAutoItErrorRegister_ShowDefaultErrorDbgMsg($sTitleMsg, $sErrorMsgFormat, $sErrorMsg, $bUseStdOutMethod)
	Else
		Call($sFunction, $vParams)

		If @error Then
			Call($sFunction)
		EndIf
	EndIf

	Exit
 EndFunc

 Func __OnAutoItErrorRegister_WinGetHandleByPID($iPID, $sTitle = '[CLASS:AutoIt v3]')
	Local $aWinList = WinList($sTitle)

	For $i = 1 To $aWinList[0][0]
		;Hidden and belong to process in $iPID
		If Not BitAND(WinGetState($aWinList[$i][1]), 2) And WinGetProcess($aWinList[$i][1]) = $iPID Then
			Return $aWinList[$i][1]
		EndIf
	Next

	Return 0
EndFunc

Func __OnAutoItErrorRegister_WinWaitByPID($iPID, $sTitle = '[CLASS:AutoIt v3]', $iTimeout = 0)
	Local $iTimer = TimerInit(), $hWin

	While 1
		$hWin = __OnAutoItErrorRegister_WinGetHandleByPID($iPID, $sTitle)

		If $hWin <> 0 Then
			Return $hWin
		EndIf

		If $iTimeout > 0 And TimerDiff($iTimer) >= $iTimeout Then
			ExitLoop
		EndIf

		Sleep(10)
	WEnd

	Return 0
EndFunc
#EndRegion