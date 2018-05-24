#include-once

#Region ChatControl
;~ Description: Write a message in chat (can only be seen by botter).
Func WriteChat($aMessage, $aSender = 'GWA²')
   Local $lMessage, $lSender
   Local $lAddress = 256 * $mQueueCounter + $mQueueBase
   If $mQueueCounter = $mQueueSize Then
	  $mQueueCounter = 0
   Else
	  $mQueueCounter = $mQueueCounter + 1
   EndIf

   If StringLen($aSender) > 19 Then
	  $lSender = StringLeft($aSender, 19)
   Else
	  $lSender = $aSender
   EndIf
   MemoryWrite($lAddress + 4, $lSender, 'wchar[20]')
   If StringLen($aMessage) > 100 Then
	  $lMessage = StringLeft($aMessage, 100)
   Else
	  $lMessage = $aMessage
   EndIf
   MemoryWrite($lAddress + 44, $lMessage, 'wchar[101]')
   DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mWriteChatPtr, 'int', 4, 'int', '')
   If StringLen($aMessage) > 100 Then WriteChat(StringTrimLeft($aMessage, 100), $aSender)
EndFunc   ;==>WriteChat

;~ Description: Send a whisper to another player.
Func SendWhisper($aReceiver, $aMessage)
   Local $lTotal = 'whisper ' & $aReceiver & ',' & $aMessage
   Local $lMessage
   If StringLen($lTotal) > 120 Then
	  $lMessage = StringLeft($lTotal, 120)
   Else
	  $lMessage = $lTotal
   EndIf
   SendChat($lMessage, '/')
   If StringLen($lTotal) > 120 Then SendWhisper($aReceiver, StringTrimLeft($lTotal, 120))
EndFunc   ;==>SendWhisper

;~ Description: Send a message to chat.
Func SendChat($aMessage, $aChannel = '!')
   Local $lMessage
   Local $lAddress = 256 * $mQueueCounter + $mQueueBase
   If $mQueueCounter = $mQueueSize Then
	  $mQueueCounter = 0
   Else
	  $mQueueCounter = $mQueueCounter + 1
   EndIf
   If StringLen($aMessage) > 120 Then
	  $lMessage = StringLeft($aMessage, 120)
   Else
	  $lMessage = $aMessage
   EndIf
   MemoryWrite($lAddress + 8, $aChannel & $lMessage, 'wchar[122]')
   DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mSendChatPtr, 'int', 8, 'int', '')
   If StringLen($aMessage) > 120 Then SendChat(StringTrimLeft($aMessage, 120), $aChannel)
EndFunc   ;==>SendChat

;~ Description: Writes text to chat.
Func Update($aText, $aFlag = 0)
;~    Out($text)
   If $OldGuiText == $aText Then Return
   TraySetToolTip(GetCharname() & @CRLF & $aText)
   $OldGuiText = $aText
   WriteChat($aText, $aFlag)
   ConsoleWrite($aText & @CRLF)
   $RestTimer = TimerInit()
EndFunc   ;==>Update
#EndRegion Chat

#Region ChatSends
;~ Description: Resign.
Func Resign()
   SendChat('resign', '/')
EndFunc   ;==>Resign

;~ Description: Resigns and returns to main function.
Func ResignAndReturn()
   Sleep(3000)
   Update("Resigning")
   Resign()
   Sleep(4000)
   ReturnToOutpost()
   Update("Returning To Outpost")
   WaitMapLoading()
   RndSleep(2000)
   Main()
EndFunc   ;==>ResignAndReturn

;~ Description: Kneel.
Func Kneel()
   Update("Kneel")
   SendChat('kneel', '/')
EndFunc   ;==>Kneel

;~ Description: Stuck.
Func Stuck()
   SendChat('stuck', '/')
EndFunc   ;==>Stuck
#EndRegion