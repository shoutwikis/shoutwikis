#RequireAdmin
#NoTrayIcon

#include-once
#include <string.au3>
#include "../../激战接口.au3"
#include "辅助文件\常数.au3"
#include "辅助文件\界面.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
#Include <WinAPI.au3>

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("MustDeclareVars", True)

Global $testCount = 0
Global $DATA
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Global $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
Global $result, $verifyResult
Global $suiJiDianYou = ""
Global $aSpace[3]
Global $digits = 15

For $i = 1 To $digits
    $aSpace[0] = Chr(Random(65, 90, 1))
    $aSpace[1] = Chr(Random(97, 122, 1))
    $aSpace[2] = Chr(Random(97, 122, 1))
    $suiJiDianYou &= $aSpace[Random(0, 2, 1)]
Next

while NOT $BotRunning
	sleep(100)
WEnd

SetEvent('', '', '', 'MessageReceive', '')

While true

	sleep(20)
	If (GetMapLoading() = 2) Then
		SetEvent('', '', '', '', '')
		WaitMapLoading()
		SetEvent('', '', '', 'MessageReceive', '')
		ContinueLoop
	EndIf
	if _WinAPI_GetFocus() = guictrlgethandle($GLOGBOX) then _WinAPI_SetFocus(GUICtrlGetHandle($messageInput))

WEnd

Func MessageSend()
	Local $sendthis = GUICtrlRead($messageInput)
	out("原文: " & $sendthis)
	$result = translateText($sendthis, $yuYan_xuanZe[1], $yuYan_xuanZe[0]) ;输出语言, 本国语言
	ClipPut($result)
	out("译文: " & $result)
	$verifyResult = translateText($result, $yuYan_xuanZe[0], $yuYan_xuanZe[1]) ;本国语言, 输出语言
	out("还原: " & $verifyResult)
	GUICtrlSetData($messageInput, "")
EndFunc

Func MessageReceive($mChannel, $mSender, $mMessage)
	if $testCount <> 0 Then out("同时使用翻译: " & $testCount)
	$testCount+=1
	Local $tIncoming
	if  (($mChannel == "地区频道") and (GUICtrlRead($tAll) = $GUI_CHECKED)) or _
		(($mChannel == "公会频道") and (GUICtrlRead($tGuild) = $GUI_CHECKED)) or _
		(($mChannel == "队伍频道") and (GUICtrlRead($tTeam) = $GUI_CHECKED)) or _
		(($mChannel == "交易频道") and (GUICtrlRead($tTrade) = $GUI_CHECKED)) or _
		(($mChannel == "同盟") and (GUICtrlRead($tAlly) = $GUI_CHECKED)) or _
		(($mChannel == "私聊") and (GUICtrlRead($tWhisper) = $GUI_CHECKED)) then

		out("原文: " & $mMessage)
		$tIncoming = translateText($mMessage, $yuYan_xuanZe[0], $yuYan_xuanZe[2]) ;本国语言, 频道语言
		out($mSender & ": " & $tIncoming)
	EndIf
	$testCount-=1
	clearmemory()
	_ReduceMemory()
EndFunc

Func translateText($TXT, $language = $yuYan_xuanZe[0], $source = $yuYan_xuanZe[2])
	Local $ENCODESSTRING, $READ
    $ENCODESSTRING = transformText($TXT)
	FileWriteLine($hFileOpen, "网址: "&@CRLF&"https://mymemory.translated.net/api/get?q="& $ENCODESSTRING &"&langpair="&$source&"%7C"&$language&"&de="&$suiJiDianYou&"@mailinator.com"&@CRLF)
	$READ = gtranslate("https://mymemory.translated.net/api/get?q="& $ENCODESSTRING &"&langpair="&$source&"%7C"&$language&"&de="&$suiJiDianYou&"@mailinator.com")
	FileWriteLine($hFileOpen, "答复: "&$READ&@CRLF&@CRLF)
	local $tempRegex = '(?i)\"translatedText\"\:\"(.+?)\",\"match\"\:'
	Local $nResult = StringRegExp($read, $tempRegex, 2)
	if $nResult <> 1 then
		local $nResultCopy = $nResult[1]
		local $lunicodeRegex = '(?i)(\\u....)'
		local $fResult = StringRegExp($nResult[1], $lunicodeRegex, 3)
		if $fResult <> 1 Then
			For $i = 0 To UBound($fResult) - 1
				$nResultCopy = StringReplace($nResultCopy, $fResult[$i], chrw(number("0x"&StringTrimLeft($fResult[$i],2))))
			Next
		EndIf
		return $nResultCopy
	Else
		return "| 翻译失败 | 原文是: " & $TXT
	endif
EndFunc

Func gtranslate($URL)
	with $oHTTP
		.Open("GET", $URL, False)
		.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; rv:9.0.1) Gecko/20100101 Firefox/9.0.1")
		.Send("")
		If @error Then out("发送过程出错: " & @error & ", 细节: " & @extended)
		Local $oReceived = .ResponseText
		Return $oReceived
	EndWith
EndFunc

Func _ReduceMemory($i_PID = -1)
	Local $ai_Return
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf

    Return $ai_Return[0]
EndFunc


Func MyErrFunc()
    Local $HexNumber = Hex($oMyError.number, 8)
    out("连网出错: " & @CRLF & _
            "错误号: " & $HexNumber & @CRLF & _
            "错误描述1: " & $oMyError.windescription & @CRLF & _
			"错误描述2: " & $oMyError.description & @CRLF & _
			"错误行数: " & $oMyError.scriptline & @CRLF)
    Return SetError(1, $HexNumber)
EndFunc

Func transformText($UnicodeURL)
	#cs
    Local $ADATA = StringSplit(BinaryToString(StringToBinary($SDATA, 4), 1), "")
    Local $NCHAR
    $SDATA = ""
    For $i = 1 To $ADATA[0]
        $NCHAR = Asc($ADATA[$i])
        Switch $NCHAR
            Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
                $SDATA &= $ADATA[$i]
            Case 32
                $SDATA &= "+"
            Case Else
                $SDATA &= "%" & Hex($NCHAR, 2)
        EndSwitch
    Next
    Return $SDATA
	#ce
    Local $UnicodeBinaryLength,$UnicodeBinary,$UnicodeBinary2
        $UnicodeBinary = StringToBinary ($UnicodeURL,4)
    $UnicodeBinary2 = StringReplace($UnicodeBinary, '0x', '', 1)
    $UnicodeBinaryLength = StringLen($UnicodeBinary2)
    Local $EncodedString,$UnicodeBinaryChar,$EncodedString
    For $i = 1 To $UnicodeBinaryLength Step 2
        $UnicodeBinaryChar = StringMid($UnicodeBinary2, $i, 2)
        If StringInStr("$-_.+!*'(),;/?:@=&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", BinaryToString ('0x' & $UnicodeBinaryChar,4)) Then
            $EncodedString &= BinaryToString ('0x' & $UnicodeBinaryChar)
        Else
            $EncodedString &= '%' & $UnicodeBinaryChar
        EndIf
    Next
    Return $EncodedString

EndFunc

Func Out($TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc