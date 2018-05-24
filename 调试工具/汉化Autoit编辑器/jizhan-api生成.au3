#include <file.au3>
#include <StringConstants.au3>

;~ created by Ralle 1976 Team Awsome Mai 2015
;~ This lite Script generated CallTips from GW-API for SciTE
;~ You find the instructions in the How To!
;~
;~ Global Varlist is unless for SciTE but if you need it for some one else change it stores the Vars in a Array
;~ you only have to definate your the Ouput Format self or do what ever you want with it
;~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



; the Number here "8" defined the line he had to check across the Func Line if its start with ";"
SciTECallTipGenerator(8)


Func SciTECallTipGenerator($max, $set_global_var = False , $pthat_for_global = @ScriptDir & "\GlobalVarsList.api", $New_StringGlobal = "au3.keywords.eureUDF = ")

Local $errorarray1[] =[5, "1 - Error opening specified file", "2 - $aArray is not an array", "3 - Error writing to file", "4 - $aArray is not a 1D or 2D array", "5 - Start index is greater than the $iUbound parameter"]
Local $errorarray3[] =[2, "1 = File selection failed.", "2 = Bad file filter"]

Local $message, $FileName, $StringSplitFileNames
$message = "Hold down Ctrl or Shift to choose multiple files."
$FileName = FileOpenDialog($message, @ScriptDir, "Autoit (*.au3)", 1 + 4)
$StringSplitFileNames = StringSplit($FileName , "|")


;If @error Then ErrorCheck($errorarray3, "FileOpenDialog", False)

Local $FileArray, $tempCallTip[1], $tempGlobalVars[1], $count1 = 1, $count2 = 1, $stringStartPos, _
$string_vars_, $New_String = "au3.keywords.user.udfs = ", $progresscounter, $count_ = 0, $NewFileName
ProgressOn ( "Func extracter!", "In Progress...")
$progresscounter = Round(100 / $StringSplitFileNames[0], 0)
$requires = WichApi($StringSplitFileNames)
If $StringSplitFileNames[0] > 1 Then
	For $s = 2 To $StringSplitFileNames[0]
		MainPart($StringSplitFileNames[1] & "\" & $StringSplitFileNames[$s], $tempGlobalVars, $FileArray, $tempCallTip, $count1, $count2, $count_, $New_String, $progresscounter, $requires, $set_global_var, $max)
	next
Else
	MainPart($StringSplitFileNames[1] , $tempGlobalVars, $FileArray, $tempCallTip, $count1, $count2, $count_, $New_String, $progresscounter, $requires, $set_global_var, $max)
EndIf


$NewFileName = @ScriptDir & "\au3.eureUDF.calltips.api"
If FileExists($NewFileName) Then FileDelete($NewFileName)
_FileWriteFromArray($NewFileName, $tempCallTip, 1)
If @error Then ErrorCheck($errorarray1, "_FileWriteFromArray")

;~ only from test i did igore it
;~ as i said Fromat your onw Output if you need the Global Vars for What Ever !
;~ Globals are stored in a Array
If $set_global_var Then
	$Count_Extra = 0
	For $n = 1 To $tempGlobalVars[0]
		If $Count_Extra < 5 Then
			$New_StringGlobal &= $tempGlobalVars[$n] & " "
			$Count_Extra += 1
		Else
			$New_StringGlobal &= $tempGlobalVars[$n] & "\" & @CRLF
			$Count_Extra = 0
		EndIf
	Next
	If FileExists($pthat_for_global) Then FileDelete($pthat_for_global)
	Sleep(100)
	FileWrite($pthat_for_global, $New_StringGlobal)
EndIf

$NewFileName = @ScriptDir & "\au3.eureUDF.properties"
If FileExists($NewFileName) Then FileDelete($NewFileName)
Sleep(100)
FileWrite($NewFileName, $New_String)
ProgressSet(100, "100% done")
Sleep(1500)
ProgressOff()
EndFunc

Func ErrorCheck(ByRef Const $errorarray, $Comefrom = "", $Exit_or_return = True)
ProgressOff()
For $i = 1 To $errorarray[0]
	If @error == $i  Then
		MsgBox(0, "ERROR", $errorarray[$i] & " come from " & $Comefrom & " !")
		ExitLoop
	EndIf
Next
If $Exit_or_return Then
	Exit
Else
	Return
EndIf
Endfunc

Func MainPart($filepath, Byref $tempGlobalVars, Byref $FileArray, Byref $tempCallTip, Byref $count1, byref $count2, Byref $count_, byref $New_String, $progresscounter, $requires, $set_global_var, $max = 6)
	Local $Count_Extra = 0, $errorarray2[] = [4, _
	"1 - Error opening specified file", _
	"2 - Unable to split the file", _
	"3 - File lines have different numbers of fields (only if $FRTA_INTARRAYS flag not set)", _
	"4 - No delimiters found (only if $FRTA_INTARRAYS flag not set)", False]

	If _FileReadToArray($filepath, $FileArray, 1) = 1 Then
		For $i = 1 To $FileArray[0]
			If $set_global_var And StringInStr($FileArray[$i], "Global $") = 1 Then
				If CreateVarList($FileArray[$i], $tempGlobalVars, $count2) Then ContinueLoop
			ElseIf StringInStr($FileArray[$i], "Func", 1) = 1 Then
				$stringStartPos = StringTrimLeft($FileArray[$i], 5)
				If $Count_Extra < 5 Then
					$New_String &= StringTrimRight($stringStartPos, StringLen($stringStartPos) - (StringInStr($stringStartPos, "(")-1)) & " "
					$Count_Extra += 1
				Else
					$New_String &= StringTrimRight($stringStartPos, StringLen($stringStartPos) - (StringInStr($stringStartPos, "(")-1)) & "\" & @CRLF
					$Count_Extra = 0
				EndIf
				Local $info = "",$temp[1], $lcount = 1
				For $u = 1  To $max
					If $FileArray[$i -$u] <> "" and StringInStr($FileArray[$i -$u], ";") = 1 Then
						$temp[0] = $lcount
						Redim $temp[$temp[0] +1]
						$temp[$temp[0]] = $FileArray[$i -$u]
						$lcount += 1
					Else
						ExitLoop
					Endif
				Next
				local $wich = 0
				For $d = $temp[0] To 1  Step -1
					$info &=  " " & StringRegExpReplace(StringStripWS($temp[$d], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES), "\;~", '') & ""
				Next
				$tempCallTip[0] = $count1
				ReDim $tempCallTip[$tempCallTip[0] + 1]
				If $requires <> '' Then $info &= ' Requires: a ' & $requires
				$tempCallTip[$tempCallTip[0]] = StringRegExpReplace(StringRegExpReplace($stringStartPos  , "\)", " )") &  StringRegExpReplace(StringTrimLeft($info, 1), ':', '(', 1)& " )","\(", " ( ", 1)
				$count1 += 1
			EndIf
		Next
		If $count_ < 93 Then $count_ += $progresscounter
		ProgressSet($count_, $count_ & " %  done ")
		Sleep(65)
	EndIf
	If @error Then ErrorCheck($errorarray2, "_FileReadToArray")
EndFunc

Func CreateVarList(Const Byref $string , Byref $tempGlobalVars, Byref $count2)
	local $string_var_abse = ""
	local $stringcheck1 = 0
	local $stringcheck2 = 0
	local $stringcheck3 = 0
	local $stringSplit = 0
	local $stringStartPos = 0

	$string_var_abse = StringTrimLeft($string, 7)
	$string_var_abse = StringStripWS($string_var_abse, 8)

	$stringcheck1 = StringInStr($string_var_abse, "[")
	$stringcheck2 = StringInStr($string_var_abse, "=")
	$stringcheck3 = StringInStr($string_var_abse, ",")

	$string_var_abse = StringRegExpReplace($string_var_abse, '\[', '|')
	$string_var_abse = StringRegExpReplace($string_var_abse, '\=', '|')

	If $stringcheck1 And TakeGlobalVars($tempGlobalVars, $count2, $string_var_abse) Then Return True
	If $stringcheck2 And TakeGlobalVars($tempGlobalVars, $count2, $string_var_abse) Then  Return True

	If $stringcheck3 Then
		$string_var_abse = StringRegExpReplace($string_var_abse, ',', '|')
		If TakeGlobalVars($tempGlobalVars, $count2, $string_var_abse) Then  Return True
	EndIf

	Return False
EndFunc

Func TakeGlobalVars(Byref $tempGlobalVars, Byref $count2, byref $stringSplit)
$stringSplit = StringSplit($stringSplit,"|")
If $stringSplit[0] > 0 Then
	If $stringSplit[0] > 1 Then
		For $z = 1 To $stringSplit[0]
			If StringInStr($stringSplit[$z], "$") == 1 Then
				$tempGlobalVars[0] = $count2
				ReDim $tempGlobalVars[$tempGlobalVars[0] + 1]
				$tempGlobalVars[$tempGlobalVars[0]] = $stringSplit[$z]
				$count2 += 1
			EndIf
		Next
		Return True
	Else
		If StringInStr($stringSplit[1], "$") == 1 Then
			$tempGlobalVars[0] = $count2
			ReDim $tempGlobalVars[$tempGlobalVars[0] + 1]
			$tempGlobalVars[$tempGlobalVars[0]] = $stringSplit[1]
			$count2 += 1
			Return True
		EndIf
	EndIf
EndIf
Return False
Endfunc

Func WichApi(Byref $array_)
If $array_[0] > 1 Then
	For $s = 2 To $array_[0]
		If StringInStr($array_[$s], "gwa") Then Return  $array_[$s]
	next
Else
	If StringInStr($array_[1], "gwa") Then
		local $stringSplit_ = StringSplit($array_[1], "\")
		Return  $stringSplit_[$stringSplit_[0]]
	EndIf
EndIf
Return ''
Endfunc