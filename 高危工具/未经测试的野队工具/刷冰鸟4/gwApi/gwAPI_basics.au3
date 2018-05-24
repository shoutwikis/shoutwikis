#include-once

#Region CommandStructs
; Commands
Local $mPacket = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Local $mPacketPtr = DllStructGetPtr($mPacket)

Local $mAction = DllStructCreate('ptr;dword;dword')
Local $mActionPtr = DllStructGetPtr($mAction)

Local $mUseSkill = DllStructCreate('ptr;dword;dword;dword')
Local $mUseSkillPtr = DllStructGetPtr($mUseSkill)

Local $mMove = DllStructCreate('ptr;float;float;float')
Local $mMovePtr = DllStructGetPtr($mMove)

Local $mChangeTarget = DllStructCreate('ptr;dword')
Local $mChangeTargetPtr = DllStructGetPtr($mChangeTarget)

Local $mToggleLanguage = DllStructCreate('ptr;dword')
Local $mToggleLanguagePtr = DllStructGetPtr($mToggleLanguage)

Local $mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Local $mUseHeroSkillPtr = DllStructGetPtr($mUseHeroSkill)

; Items
Local $mBuyItem = DllStructCreate('ptr;dword;dword;dword')
Local $mBuyItemPtr = DllStructGetPtr($mBuyItem)

Local $mSellItem = DllStructCreate('ptr;dword;dword')
Local $mSellItemPtr = DllStructGetPtr($mSellItem)

Local $mCraftItem = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword')
Local $mCraftItemPtr = DllStructGetPtr($mCraftItem)

Local $mCraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Local $mCraftItemExPtr = DllStructGetPtr($mCraftItemEx)

Local $mUpgrade = DllStructCreate('ptr;dword;dword;dword;dword')
Local $mUpgradePtr = DllStructGetPtr($mUpgrade)

Local $mSalvage = DllStructCreate('ptr;dword;dword;dword')
Local $mSalvagePtr = DllStructGetPtr($mSalvage)

Local $mOpenMerchant = DllStructCreate('ptr;dword;dword;dword;dword')
Local $mOpenMerchantPtr = DllStructGetPtr($mOpenMerchant)

Local $mOpenStorage = DllStructCreate('ptr;dword;dword;dword')
Local $mOpenStoragePtr = DllStructGetPtr($mOpenStorage)

; Trader
Local $mTraderBuy = DllStructCreate('ptr')
Local $mTraderBuyPtr = DllStructGetPtr($mTraderBuy)

Local $mTraderSell = DllStructCreate('ptr')
Local $mTraderSellPtr = DllStructGetPtr($mTraderSell)

Local $mRequestQuote = DllStructCreate('ptr;dword')
Local $mRequestQuotePtr = DllStructGetPtr($mRequestQuote)

Local $mRequestQuoteSell = DllStructCreate('ptr;dword')
Local $mRequestQuoteSellPtr = DllStructGetPtr($mRequestQuoteSell)

; Chat
Local $mSendChat = DllStructCreate('ptr;dword')
Local $mSendChatPtr = DllStructGetPtr($mSendChat)

Local $mWriteChat = DllStructCreate('ptr')
Local $mWriteChatPtr = DllStructGetPtr($mWriteChat)

; MakeAgentArray
Local $mMakeAgentArray = DllStructCreate('ptr;dword')
Local $mMakeAgentArrayPtr = DllStructGetPtr($mMakeAgentArray)

Local $mMakeAgentArrayEx = DllStructCreate('ptr;dword;dword')
Local $mMakeAgentArrayExPtr = DllStructGetPtr($mMakeAgentArrayEx)

; Attributes
Local $mMaxAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Local $mMaxAttributesPtr = DllStructGetPtr($mMaxAttributes)

Local $mSetAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Local $mSetAttributesPtr = DllStructGetPtr($mSetAttributes)

Local $mIncreaseAttribute = DllStructCreate('ptr;dword;dword')
Local $mIncreaseAttributePtr = DllStructGetPtr($mIncreaseAttribute)

Local $mDecreaseAttribute = DllStructCreate('ptr;dword;dword')
Local $mDecreaseAttributePtr = DllStructGetPtr($mDecreaseAttribute)
#EndRegion CommandStructs

#Region Memory
;~ Description: Open existing local process object.
Func MemoryOpen($aPID)
   $mKernelHandle = DllOpen('kernel32.dll')
   Local $lOpenProcess = DllCall($mKernelHandle, 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', 1, 'int', $aPID)
   $mGWProcHandle = $lOpenProcess[0]
EndFunc   ;==>MemoryOpen

;~ Description: Closes process handle opened with MemoryOpen.
Func MemoryClose()
   DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $mGWProcHandle)
   DllClose($mKernelHandle)
EndFunc   ;==>MemoryClose

;~ Description: Write a binarystring to an address inside opened process.
Func WriteBinary($aBinaryString, $aAddress, $aRestore = True)
   Local $lSize = 0.5 * StringLen($aBinaryString)
   Local $lData = DllStructCreate('byte[' & $lSize & ']')
   If $aRestore Then AddRestoreDict($aAddress, MemoryRead($aAddress, 'byte[' & $lSize & ']'))
   For $i = 1 To DllStructGetSize($lData)
	  DllStructSetData($lData, 1, Dec(StringMid($aBinaryString, 2 * $i - 1, 2)), $i)
   Next
   DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $aAddress, 'ptr', DllStructGetPtr($lData), 'int', DllStructGetSize($lData), 'int', 0)
EndFunc   ;==>WriteBinary

;~ Description: Writes data to specified address in opened process.
Func MemoryWrite($aAddress, $aData, $aType = 'dword')
   Local $lBuffer = DllStructCreate($aType)
   DllStructSetData($lBuffer, 1, $aData)
   AddRestoreDict($aAddress, MemoryReadStruct($aAddress, $aType))
   DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
EndFunc   ;==>MemoryWrite

;~ Description: Read process memory at specified address.
Func MemoryRead($aAddress, $aType = 'dword')
   Local $lBuffer = DllStructCreate($aType)
   DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
   Return DllStructGetData($lBuffer, 1)
EndFunc   ;==>MemoryRead

;~ Description: Read a chain of pointers.
Func MemoryReadPtr($aAddress, $aOffset, $aType = 'dword')
   Local $lPointerCount = UBound($aOffset) - 2
   Local $lBuffer = DllStructCreate($aType)
   For $i = 0 To $lPointerCount
	  $aAddress += $aOffset[$i]
	  DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	  $aAddress = DllStructGetData($lBuffer, 1)
	  If $aAddress = 0 Then
		 Local $lData[2] = [0, 0]
		 Return $lData
	  EndIf
   Next
   $aAddress += $aOffset[$lPointerCount + 1]
   $lBuffer = DllStructCreate($aType)
   DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
   Local $lData[2] = [$aAddress, DllStructGetData($lBuffer, 1)]
   Return $lData
EndFunc   ;==>MemoryReadPtr

;~ Description: Converts little endian to big endian and vice versa.
Func SwapEndian($aHex)
   Return StringMid($aHex, 7, 2) & StringMid($aHex, 5, 2) & StringMid($aHex, 3, 2) & StringMid($aHex, 1, 2)
EndFunc   ;==>SwapEndian

;~ Description: Enqueue a pointer to data to be written to process memory.
Func Enqueue($aPtr, $aSize)
   DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', 256 * $mQueueCounter + $mQueueBase, 'ptr', $aPtr, 'int', $aSize, 'int', '')
;~    ConsoleWrite("Queue: " & MemoryRead(GetValue('QueueCounter')) & @CRLF)
   If $mQueueCounter = $mQueueSize Then
	  $mQueueCounter = 0
   Else
	  $mQueueCounter = $mQueueCounter + 1
   EndIf
EndFunc   ;==>Enqueue

;~ Description: Reads consecutive values from memory to buffer struct.
;~ Author: 4D1.
Func MemoryReadStruct($aAddress, $aStruct = 'dword')
   Local $lBuffer = DllStructCreate($aStruct)
   DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
   Return $lBuffer
EndFunc   ;==>MemoryReadStruct

;~ Description: Reads consecutive values from memory into referenced struct.
;~ Returns array if successful: [0] -> boolean
;~    					  		[5] -> bytes read
;~ Author: 4D1.
Func MemoryReadToStruct($aAddress, ByRef $aStructbuffer)
   Return DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($aStructbuffer), 'int', DllStructGetSize($aStructbuffer), 'int', '')
EndFunc   ;==>MemoryReadStruct
#EndRegion Memory

#Region Initialisation
;~ Description: Searches in $aGW specified client and calls MemoryOpen() on that client.
;~ Injects asm functions, detours etc. into that game client.
Func Initialize($aGW = CharacterSelector(), $aChangeTitle = True, $aUseStringLog = False, $aUseEventSystem = True)
   Local $lWinList
   Local $lCharname = 0
   $mChangeTitle = $aChangeTitle
   $mUseStringLog = $aUseStringLog
   $mUseEventSystem = $aUseEventSystem
   If IsString($aGW) Then ; Charactername
	  $lWinList = WinList('Guild Wars')
	  For $i = 1 To $lWinList[0][0]
		 If StringInStr($lWinList[$i][0], 'Guild Wars Wiki') Then ContinueLoop
		 $mGWHwnd = $lWinList[$i][1]
		 MemoryOpen(WinGetProcess($mGWHwnd))
		 If $mGWProcHandle Then
			If StringRegExp(ScanForCharname(), $aGW) = 1 Then
			   $lCharname = $aGW
			   ExitLoop
			EndIf
		 EndIf
		 MemoryClose()
		 $mGWProcHandle = 0
	  Next
   Else ; Process ID
	  $lWinList = WinList()
	  For $i = 1 To $lWinList[0][0]
		 $mGWHwnd = $lWinList[$i][1]
		 If WinGetProcess($mGWHwnd) = $aGW Then
			MemoryOpen($aGW)
			$lCharname = ScanForCharname()
			ExitLoop
		 EndIf
	  Next
   EndIf
   Return InitClient($lCharname)
EndFunc

;~ Description: Injects asm functions, detours etc. into the game client.
;~ Formerly part of Initialize(). MemoryOpen() has to be called before calling InitiClient(), to get $mGWProcHandle.
;~ Also needed: $mGWHwnd.
Func InitClient($aCharname = '')
   If $mGWProcHandle = 0 Then Return 0 ; MemoryOpen() not successfully called.
   If $mLabelDict = 0 Then CreateLabelDict()
   $mGWTitleOld = WinGetTitle($mGWHwnd)

   Scan()

   Local $lTemp
   $mBasePointer = MemoryRead(GetScannedAddress('ScanBasePointer', -3))
   SetValue('BasePointer', '0x' & Hex($mBasePointer, 8))
   $mAgentBase = MemoryRead(GetScannedAddress('ScanAgentBase', 13))
   SetValue('AgentBase', '0x' & Hex($mAgentBase, 8))
   $mMaxAgents = $mAgentBase + 8
   SetValue('MaxAgents', '0x' & Hex($mMaxAgents, 8))
   $mMyID = $mAgentBase - 84
   SetValue('MyID', '0x' & Hex($mMyID, 8))
   $mMapLoading = $mAgentBase - 240
   $mCurrentTarget = $mAgentBase - 1280
   SetValue('PacketLocation', '0x' & Hex(MemoryRead(GetScannedAddress('ScanBaseOffset', -3)), 8))
   $mStorageFunction = GetScannedAddress('ScanStorage', -7)
   SetValue('StorageFunction', '0x' & Hex($mStorageFunction, 8))
   $mMerchantWindow = GetScannedAddress('ScanMerchantWindow', 1)
   SetValue('MerchantWindow', '0x' & Hex($mMerchantWindow, 8))
   $mPing = MemoryRead(GetScannedAddress('ScanPing', -8))
   $mMapID = MemoryRead(GetScannedAddress('ScanMapID', 71))
   $mLoggedIn = MemoryRead(GetScannedAddress('ScanLoggedIn', -3)) + 4
   $mRegion = MemoryRead(GetScannedAddress('ScanRegion', 8))
   $mLanguage = MemoryRead(GetScannedAddress('ScanLanguage', 8)) + 12
   $mSkillBase = MemoryRead(GetScannedAddress('ScanSkillBase', 9))
   $mSkillTimer = MemoryRead(GetScannedAddress('ScanSkillTimer', -3))
   $mBuildNumber = MemoryRead(GetScannedAddress('ScanBuildNumber', 0x54))
   $mZoomStill = GetScannedAddress("ScanZoomStill", -1)
   $mZoomMoving = GetScannedAddress("ScanZoomMoving", 5)
   $lTemp = MemoryRead(GetScannedAddress("ScanStorageSessionIDBase", - 3))
   $mStorageSessionBase = MemoryRead($lTemp)

   Local $lTemp
   $lTemp = GetScannedAddress('ScanEngine', -16)
   SetValue('MainStart', '0x' & Hex($lTemp, 8))
   SetValue('MainReturn', '0x' & Hex($lTemp + 5, 8))
   ;; Rendering Mod ;;
   SetValue('RenderingMod', '0x' & Hex($lTemp + 116, 8))
   SetValue('RenderingModReturn', '0x' & Hex($lTemp + 132 + 6, 8))
   ;; TargetLog ;;
   $lTemp = GetScannedAddress('ScanTargetLog', 1)
   SetValue('TargetLogStart', '0x' & Hex($lTemp, 8))
   SetValue('TargetLogReturn', '0x' & Hex($lTemp + 5, 8))
   ;; SkillLog ;;
   $lTemp = GetScannedAddress('ScanSkillLog', 1)
   SetValue('SkillLogStart', '0x' & Hex($lTemp, 8))
   SetValue('SkillLogReturn', '0x' & Hex($lTemp + 5, 8))
   $lTemp = GetScannedAddress('ScanSkillCompleteLog', -4)
   SetValue('SkillCompleteLogStart', '0x' & Hex($lTemp, 8))
   SetValue('SkillCompleteLogReturn', '0x' & Hex($lTemp + 5, 8))
   $lTemp = GetScannedAddress('ScanSkillCancelLog', 5)
   SetValue('SkillCancelLogStart', '0x' & Hex($lTemp, 8))
   SetValue('SkillCancelLogReturn', '0x' & Hex($lTemp + 6, 8))
   ;; ChatLog ;;
   $lTemp = GetScannedAddress('ScanChatLog', 18)
   SetValue('ChatLogStart', '0x' & Hex($lTemp, 8))
   SetValue('ChatLogReturn', '0x' & Hex($lTemp + 6, 8))
   ;; TraderHook ;;
   $lTemp = GetScannedAddress('ScanTraderHook', -7)
   SetValue('TraderHookStart', '0x' & Hex($lTemp, 8))
   SetValue('TraderHookReturn', '0x' & Hex($lTemp + 5, 8))
   ;; StringLog ;;
   $lTemp = GetScannedAddress('ScanStringFilter1', -2)
   SetValue('StringFilter1Start', '0x' & Hex($lTemp, 8))
   SetValue('StringFilter1Return', '0x' & Hex($lTemp + 5, 8))
   $lTemp = GetScannedAddress('ScanStringFilter2', -2)
   SetValue('StringFilter2Start', '0x' & Hex($lTemp, 8))
   SetValue('StringFilter2Return', '0x' & Hex($lTemp + 5, 8))
   SetValue('StringLogStart', '0x' & Hex(GetScannedAddress('ScanStringLog', 35), 8))
   ;; DialogLog
   $lTemp = GetScannedAddress('ScanDialogLog', 15)
   SetValue('DialogLogStart', '0x' & Hex($lTemp, 8))
   SetValue('DialogLogReturn', '0x' & Hex($lTemp + 8, 8))
   ;; LoadFinished ;;
   SetValue('LoadFinishedStart', '0x' & Hex(GetScannedAddress('ScanLoadFinished', 1), 8))
   SetValue('LoadFinishedReturn', '0x' & Hex(GetScannedAddress('ScanLoadFinished', 6), 8))
   ;; Misc ;;
   SetValue('PostMessage', '0x' & Hex(MemoryRead(GetScannedAddress('ScanPostMessage', 11)), 8))
   SetValue('Sleep', MemoryRead(MemoryRead(GetValue('ScanSleep') + 8) + 3))
   SetValue('SalvageFunction', MemoryRead(GetValue('ScanSalvageFunction') + 8) - 18)
   SetValue('SalvageGlobal', MemoryRead(MemoryRead(GetValue('ScanSalvageGlobal') + 8) + 1))
   SetValue('IncreaseAttributeFunction', '0x' & Hex(GetScannedAddress('ScanIncreaseAttributeFunction', -96), 8))
   SetValue('DecreaseAttributeFunction', '0x' & Hex(GetScannedAddress('ScanDecreaseAttributeFunction', 46), 8))
   SetValue('MoveFunction', '0x' & Hex(GetScannedAddress('ScanMoveFunction', 1), 8))
   SetValue('UseSkillFunction', '0x' & Hex(GetScannedAddress('ScanUseSkillFunction', 1), 8))
   SetValue('ChangeTargetFunction', '0x' & Hex(GetScannedAddress('ScanChangeTargetFunction', -119), 8))
   SetValue('WriteChatFunction', '0x' & Hex(GetScannedAddress('ScanWriteChatFunction', 1), 8))
   SetValue('SellItemFunction', '0x' & Hex(GetScannedAddress('ScanSellItemFunction', -85), 8))
   SetValue('PacketSendFunction', '0x' & Hex(GetScannedAddress('ScanPacketSendFunction', 1), 8))
   SetValue('ActionBase', '0x' & Hex(MemoryRead(GetScannedAddress('ScanActionBase', -9)), 8))
   SetValue('ActionFunction', '0x' & Hex(GetScannedAddress('ScanActionFunction', -5), 8))
   SetValue('UseHeroSkillFunction', '0x' & Hex(GetScannedAddress('ScanUseHeroSkillFunction', -105), 8))
   SetValue('BuyItemFunction', '0x' & Hex(GetScannedAddress('ScanBuyItemFunction', 1), 8))
   SetValue('RequestQuoteFunction', '0x' & Hex(GetScannedAddress('ScanRequestQuoteFunction', -2), 8))
   SetValue('TraderFunction', '0x' & Hex(GetScannedAddress('ScanTraderFunction', -71), 8))
   SetValue('ClickToMoveFix', '0x' & Hex(GetScannedAddress("ScanClickToMoveFix", 1), 8))
   SetValue('UpgradeWindow', '0x' & Hex(GetScannedAddress('ScanUpgradeWindow', -2), 8))
   ;; Size ;;
   SetValue('QueueSize', '0x00000010')
   SetValue('SkillLogSize', '0x00000010')
   SetValue('ChatLogSize', '0x00000010')
   SetValue('TargetLogSize', '0x00000200')
   SetValue('StringLogSize', '0x00000200')
   SetValue('CallbackEvent', '0x00000501')

   ModifyMemory()

   ;; Set global variables ;;
   $mQueueCounter = MemoryRead(GetValue('QueueCounter'))
   $mQueueSize = GetValue('QueueSize') - 1
   $mQueueBase = GetValue('QueueBase')
   $mTargetLogBase = GetValue('TargetLogBase')
   $mStringLogBase = GetValue('StringLogBase')
   $mMapIsLoaded = GetValue('MapIsLoaded')
   $mEnsureEnglish = GetValue('EnsureEnglish')
   $mTraderQuoteID = GetValue('TraderQuoteID')
   $mTraderCostID = GetValue('TraderCostID')
   $mTraderCostValue = GetValue('TraderCostValue')
   $mDisableRendering = GetValue('DisableRendering')
   $mAgentCopyCount = GetValue('AgentCopyCount')
   $mAgentCopyBase = GetValue('AgentCopyBase')
   $mAgentMovement = GetAgentMovementPtr()
   $mLastDialogId = GetValue('LastDialogID')

   If $mUseEventSystem Then MemoryWrite(GetValue('CallbackHandle'), $mGUI)

   ;; commands ;;
   DllStructSetData($mPacket, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mUseSkill, 1, GetValue('CommandUseSkill'))
   DllStructSetData($mMove, 1, GetValue('CommandMove'))
   DllStructSetData($mChangeTarget, 1, GetValue('CommandChangeTarget'))
   DllStructSetData($mToggleLanguage, 1, GetValue('CommandToggleLanguage'))
   DllStructSetData($mUseHeroSkill, 1, GetValue('CommandUseHeroSkill'))
   ;; Items ;;
   DllStructSetData($mBuyItem, 1, GetValue('CommandBuyItem'))
   DllStructSetData($mSellItem, 1, GetValue('CommandSellItem'))
   DllStructSetData($mCraftItem , 1, GetValue('CommandCraftItem'))
   DllStructSetData($mCraftItemEx , 1, GetValue('CommandCraftItemEx'))
   DllStructSetData($mUpgrade, 1, GetValue('CommandUpgrade')) ; CommandUpgradeArmor
   DllStructSetData($mSalvage, 1, GetValue('CommandSalvage'))
   DllStructSetData($mAction, 1, GetValue('CommandAction'))
   DllStructSetData($mOpenStorage, 1, GetValue('CommandOpenStorage'))
   ;; Trader ;;
   DllStructSetData($mTraderBuy, 1, GetValue('CommandTraderBuy'))
   DllStructSetData($mTraderSell, 1, GetValue('CommandTraderSell'))
   DllStructSetData($mRequestQuote, 1, GetValue('CommandRequestQuote'))
   DllStructSetData($mRequestQuoteSell, 1, GetValue('CommandRequestQuoteSell'))
   ;; Chat ;;
   DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
   DllStructSetData($mSendChat, 2, 0x5E)
   DllStructSetData($mWriteChat, 1, GetValue('CommandWriteChat'))
   ;; MakeAgentArray ;;
   DllStructSetData($mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
   DllStructSetData($mMakeAgentArrayEx, 1, GetValue('CommandMakeAgentArrayEx'))
   ;; Attributes ;;
   DllStructSetData($mMaxAttributes, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mMaxAttributes, 2, 0x90)
   DllStructSetData($mMaxAttributes, 3, 9)
   DllStructSetData($mMaxAttributes, 5, 3) ;# of attributes
   DllStructSetData($mMaxAttributes, 22, 3) ;# of attributes
   DllStructSetData($mMaxAttributes, 23, 13) ;Attribute Levels
   DllStructSetData($mMaxAttributes, 24, 13) ;Attribute Levels
   DllStructSetData($mSetAttributes, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mSetAttributes, 2, 0x90)
   DllStructSetData($mSetAttributes, 3, 9)
   DllStructSetData($mIncreaseAttribute, 1, GetValue('CommandIncreaseAttribute'))
   DllStructSetData($mDecreaseAttribute, 1, GetValue('CommandDecreaseAttribute'))
   If $mChangeTitle Then
	  If $aCharname = '' Then
		 WinSetTitle($mGWHwnd, '', 'Guild Wars - ' & GetCharname())
	  Else
		 WinSetTitle($mGWHwnd, '', 'Guild Wars - ' & $aCharname)
	  EndIf
   EndIf
   $mASMString = ''
   $mASMSize = 0
   $mASMCodeOffset = 0
   Return $mGWHwnd
EndFunc   ;==>Initialize

;~ Description: Get Value to Key in $mLabelDict.
Func GetValue($aKey)
   If $mLabelDict.Exists($aKey) Then
	  Return Number($mLabelDict($aKey))
   Else
	  Return -1
   EndIf
EndFunc   ;==>GetValue

;~ Description: Add Key and Value to $mLabelDict.
Func SetValue($aKey, $aValue)
   $mLabelDict($aKey) = $aValue
EndFunc   ;==>SetValue

;~ Description: Creates dictionary object and sets keys to case insensitive.
Func CreateLabelDict()
   $mLabelDict = ObjCreate('Scripting.Dictionary')
   $mLabelDict.CompareMode = 1 ; keys -> case insensitive
EndFunc   ;==>CreateLabelDict

;~ Description: Returns Ptr to Agent Movement struct.
Func GetAgentMovementPtr()
   Local $Offset[4] = [0, 0x18, 0x8, 0xE8]
   Local $lPtr = MemoryReadPtr($mBasePointer, $Offset, 'ptr')
   Return $lPtr[1]
EndFunc   ;==>GetAgentMovementPtr

;~ Description: Scans memory for listed patterns.
Func Scan()
   $mASMSize = 0
   $mASMCodeOffset = 0
   $mASMString = ''
   ;; Scan patterns ;;
   _('MainModPtr/4')
   _('ScanBasePointer:')
   AddPattern('85C0750F8BCE')
   _('ScanAgentBase:')
   AddPattern('568BF13BF07204')
   _('ScanEngine:')
   AddPattern('5356DFE0F6C441')
   _('ScanLoadFinished:')
   AddPattern('8B561C8BCF52E8')
   _('ScanPostMessage:')
   AddPattern('6A00680080000051FF15')
   _('ScanTargetLog:')
   AddPattern('5356578BFA894DF4E8')
   _('ScanChangeTargetFunction:')
   AddPattern('33C03BDA0F95C033')
   _('ScanMoveFunction:')
   AddPattern('558BEC83EC2056578BF98D4DF0')
   _('ScanPing:')
   AddPattern('908D41248B49186A30')
   _('ScanMapID:')
   AddPattern('B07F8D55')
   _('ScanLoggedIn:')
   AddPattern('85C07411B807')
   _('ScanRegion:')
   AddPattern('83F9FD7406')
   _('ScanLanguage:')
   AddPattern('C38B75FC8B04B5')
   _('ScanUseSkillFunction:')
   AddPattern('558BEC83EC1053568BD9578BF2895DF0')
   _('ScanChangeTargetFunction:')
   AddPattern('33C03BDA0F95C033')
   _('ScanPacketSendFunction:')
   AddPattern('558BEC83EC2C5356578BF985')
   _('ScanBaseOffset:')
   AddPattern('5633F63BCE740E5633D2')
   _('ScanWriteChatFunction:')
   AddPattern('558BEC5153894DFC8B4D0856578B')
   _('ScanSkillLog:')
   AddPattern('408946105E5B5D')
   _('ScanSkillCompleteLog:')
   AddPattern('741D6A006A40')
   _('ScanSkillCancelLog:')
   AddPattern('85C0741D6A006A42')
   _('ScanChatLog:')
   AddPattern('8B45F48B138B4DEC50')
   _('ScanDialogLog:')
   AddPattern('8977045F5E5B5DC208')
   _('ScanSellItemFunction:')
   AddPattern('8B4D2085C90F858E')
   _('ScanStringLog:')
   AddPattern('893E8B7D10895E04397E08')
   _('ScanStringFilter1:')
   AddPattern('51568B7508578BF9833E00')
   _('ScanStringFilter2:')
   AddPattern('515356578BF933D28B4F2C')
   _('ScanActionFunction:')
   AddPattern('8B7D0883FF098BF175116876010000')
   _('ScanActionBase:')
   AddPattern('8B4208A80175418B4A08')
   _('ScanSkillBase:')
   AddPattern('8D04B65EC1E00505')
   _('ScanUseHeroSkillFunction:')
   AddPattern('8B782C8B333BB70805000073338D4601')
   _('ScanBuyItemFunction:')
   AddPattern('558BEC81ECC000000053568B75085783FE108BFA8BD97614')
   _('ScanRequestQuoteFunction:')
   AddPattern('81EC9C00000053568B')
   _('ScanTraderFunction:')
   AddPattern('8B45188B551085')
   _('ScanTraderHook:')
   AddPattern('8955FC6A008D55F8B9BA')
   _('ScanSleep:')
   AddPattern('5F5E5B741A6860EA0000')
   _('ScanSalvageFunction:')
   AddPattern('8BFA8BD9897DF0895DF4')
   _('ScanSalvageGlobal:')
   AddPattern('8B018B4904A3')
   _('ScanIncreaseAttributeFunction:')
   AddPattern('8B702C8B3B8B86')
   _('ScanDecreaseAttributeFunction:')
   AddPattern('8B4B0C6A00516A016A04')
   _('ScanSkillTimer:')
   AddPattern('85c974158bd62bd183fa64')
   _('ScanClickToMoveFix:')
   AddPattern('3DD301000074')
   _('ScanZoomStill:')
   AddPattern('3B448BCB')
   _('ScanZoomMoving:')
   AddPattern('50EB116800803B448BCE')
   _('ScanBuildNumber:')
   AddPattern('8D8500FCFFFF8D')
   _('ScanStorageSessionIDBase:')
   AddPattern('8D14768D14908B4208A80175418B4A0885C9')
   _('ScanStorage:')
   AddPattern('6A00BA12000000E87CCDFFFFBA120000008BCE')
   _('ScanMerchantWindow:')
   AddPattern('558BEC81ECF8000000535657')
   _('ScanUpgradeWindow:')
   AddPattern('568B71088B4904')
   ;; Scan engine ;;
   _('ScanProc:')
   _('pushad')
   _('mov ecx,401000')
   _('mov esi,ScanProc')
   _('ScanLoop:')
   _('inc ecx')
   _('mov al,byte[ecx]')
   _('mov edx,ScanBasePointer')
   ; Inner Loop ;
   _('ScanInnerLoop:')
   _('mov ebx,dword[edx]')
   _('cmp ebx,-1')
   _('jnz ScanContinue')
   _('add edx,50')
   _('cmp edx,esi')
   _('jnz ScanInnerLoop')
   _('cmp ecx,900000')
   _('jnz ScanLoop')
   _('jmp ScanExit')
   ; Continue ;
   _('ScanContinue:')
   _('lea edi,dword[edx+ebx]')
   _('add edi,C')
   _('mov ah,byte[edi]')
   _('cmp al,ah')
   _('jz ScanMatched')
   _('mov dword[edx],0')
   _('add edx,50')
   _('cmp edx,esi')
   _('jnz ScanInnerLoop')
   _('cmp ecx,900000')
   _('jnz ScanLoop')
   _('jmp ScanExit')
   ; Matched ;
   _('ScanMatched:')
   _('inc ebx')
   _('mov edi,dword[edx+4]')
   _('cmp ebx,edi')
   _('jz ScanFound')
   _('mov dword[edx],ebx')
   _('add edx,50')
   _('cmp edx,esi')
   _('jnz ScanInnerLoop')
   _('cmp ecx,900000')
   _('jnz ScanLoop')
   _('jmp ScanExit')
   ; Found ;
   _('ScanFound:')
   _('lea edi,dword[edx+8]')
   _('mov dword[edi],ecx')
   _('mov dword[edx],-1')
   _('add edx,50')
   _('cmp edx,esi')
   _('jnz ScanInnerLoop')
   _('cmp ecx,900000')
   _('jnz ScanLoop')
   ; Exit ;
   _('ScanExit:')
   _('popad')
   _('retn')
   Local $lScanMemory = MemoryRead($mBase, 'ptr')
   If $lScanMemory = 0 Then
	  $mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 0x40)
	  $mMemory = $mMemory[0]
	  AddRestoreDict($mBase, "0x00000000")
	  MemoryWrite($mBase, $mMemory)
   Else
	  $mMemory = $lScanMemory
   EndIf
   CompleteASMCode()
   If $lScanMemory = 0 Then
	  WriteBinary($mASMString, $mMemory + $mASMCodeOffset)
	  Local $lThread = DllCall($mKernelHandle, 'int', 'CreateRemoteThread', 'int', $mGWProcHandle, 'ptr', 0, 'int', 0, 'int', GetLabelInfo('ScanProc'), 'ptr', 0, 'int', 0, 'int', 0)
	  $lThread = $lThread[0]
	  Local $lResult
	  Do
		 $lResult = DllCall($mKernelHandle, 'int', 'WaitForSingleObject', 'int', $lThread, 'int', 50)
	  Until $lResult[0] <> 258
	  DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $lThread)
   EndIf
EndFunc   ;==>Scan

;~ Description: Formats and adds pattern-string to $mASMString.
Func AddPattern($aPattern)
   Local $lSize = Int(0.5 * StringLen($aPattern))
   $mASMString &= '00000000' & SwapEndian(Hex($lSize, 8)) & '00000000' & $aPattern
   $mASMSize += $lSize + 12
   For $i = 1 To 68 - $lSize
	  $mASMSize += 1
	  $mASMString &= '00'
   Next
EndFunc   ;==>AddPattern

;~ Description: Returns scanned address +/- offset.
Func GetScannedAddress($aLabel, $aOffset)
   Local $lLabelInfo = GetLabelInfo($aLabel)
   Return MemoryRead($lLabelInfo + 8) - MemoryRead($lLabelInfo + 4) + $aOffset
EndFunc   ;==>GetScannedAddress

;~ Description: Scans game client memory for charname.
Func ScanForCharname()
   Local $lCharNameCode = BinaryToString('0x90909066C705')
   Local $lCurrentSearchAddress = 0x00401000
   Local $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
   Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i
   While $lCurrentSearchAddress < 0x00900000
	  Local $lMBI[7]
	  DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
	  For $i = 0 To 6
		 $lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
	  Next
	  If $lMBI[4] = 4096 Then
		 Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
		 DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
		 $lTmpMemData = DllStructGetData($lBuffer, 1)
		 $lTmpMemData = BinaryToString($lTmpMemData)
		 $lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
		 If $lSearch > 0 Then
			$lTmpAddress = $lCurrentSearchAddress + $lSearch - 1
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lTmpAddress + 0x6, 'ptr', DllStructGetPtr($lTmpBuffer), 'int', DllStructGetSize($lTmpBuffer), 'int', '')
			$mCharname = DllStructGetData($lTmpBuffer, 1)
			Return GetCharname()
		 EndIf
		 $lCurrentSearchAddress += $lMBI[3]
	  EndIf
   WEnd
   Return ''
EndFunc   ;==>ScanForCharname

;~ Description: Gets Winlists of open game client windows.
;~ If there's more than one, a small GUI is opened with a ComboBox to select Charname from.
Func CharacterSelector()
   Local $lWinList = WinList("[CLASS:ArenaNet_Dx_Window_Class; REGEXPTITLE:^\D+$]")
   Switch $lWinList[0][0]
	  Case 0
		 Exit MsgBox(0, "Error", "No Guild Wars Clients were found.")
	  Case 1
		 Return WinGetProcess($lWinList[1][1])
	  Case Else
		 Local $lCharStr = "", $lFirstChar
		 For $winCount = 1 To $lWinList[0][0]
			MemoryOpen(WinGetProcess($lWinList[$winCount][1]))
			$lCharStr &= ScanForCharname()
			If $winCount = 1 Then $lFirstChar = GetCharname()
			If $winCount <> $lWinList[0][0] Then $lCharStr &= "|"
			MemoryClose()
		 Next
		 Local $GUICharSelector = GUICreate("Character Selector", 171, 64, 192, 124)
		 Local $ComboCharSelector = GUICtrlCreateCombo("", 8, 8, 153, 25)
		 Local $ButtonCharSelector = GUICtrlCreateButton("Use This Character", 8, 32, 153, 25)
		 GUICtrlSetData($ComboCharSelector, $lCharStr,$lFirstChar)
		 GUISetState(@SW_SHOW, $GUICharSelector)
		 While 1
			Switch GUIGetMsg()
			   Case $ButtonCharSelector
				  Local $tmp = GUICtrlRead($ComboCharSelector)
				  GUIDelete($GUICharSelector)
				  Return $tmp
			   Case -3
				  Exit
			EndSwitch
			Sleep(25)
		 WEnd
   EndSwitch
EndFunc   ;==>CharacterSelector

;~ Description: Returns a string of charnames, delimeter: '|'.
Func GetLoggedCharnames()
   Local $lWinList = WinList("[CLASS:ArenaNet_Dx_Window_Class; REGEXPTITLE:^\D+$]")
   Local $lCharStr = ''
   Switch $lWinList[0][0]
	  Case 0
		 Exit MsgBox(0, "Error", "No Guild Wars Clients were found.")
	  Case 1
		 MemoryOpen(WinGetProcess($lWinList[1][1]))
		 $lCharStr &= ScanForCharname()
		 $mFirstChar = $lCharStr
		 MemoryClose()
	  Case Else
		 For $winCount = 1 To $lWinList[0][0]
			MemoryOpen(WinGetProcess($lWinList[$winCount][1]))
			$lCharStr &= ScanForCharname()
			If $winCount = 1 Then $mFirstChar = $lCharStr
			If $winCount <> $lWinList[0][0] Then $lCharStr &= "|"
			MemoryClose()
		 Next
   EndSwitch
   Return $lCharStr
EndFunc   ;==>GetLoggedCharnames
#EndRegion Initialisation

#Region Callback
;~ Description: Controls Event System.
Func SetEvent($aSkillActivate = '', $aSkillCancel = '', $aSkillComplete = '', $aChatReceive = '', $aLoadFinished = '')
   If Not $mUseEventSystem Then Return
   If $aSkillActivate <> '' Then
	  WriteDetour('SkillLogStart', 'SkillLogProc')
   Else
	  $mASMString = ''
	  _('inc eax')
	  _('mov dword[esi+10],eax')
	  _('pop esi')
	  WriteBinary($mASMString, GetValue('SkillLogStart'))
   EndIf
   If $aSkillCancel <> '' Then
	  WriteDetour('SkillCancelLogStart', 'SkillCancelLogProc')
   Else
	  $mASMString = ''
	  _('push 0')
	  _('push 42')
	  _('mov ecx,esi')
	  WriteBinary($mASMString, GetValue('SkillCancelLogStart'))
   EndIf
   If $aSkillComplete <> '' Then
	  WriteDetour('SkillCompleteLogStart', 'SkillCompleteLogProc')
   Else
	  $mASMString = ''
	  _('mov eax,dword[edi+4]')
	  _('test eax,eax')
	  WriteBinary($mASMString, GetValue('SkillCompleteLogStart'))
   EndIf
   If $aChatReceive <> '' Then
	  WriteDetour('ChatLogStart', 'ChatLogProc')
   Else
	  $mASMString = ''
	  _('add edi,E')
	  _('cmp eax,B')
	  WriteBinary($mASMString, GetValue('ChatLogStart'))
   EndIf
   $mSkillActivate = $aSkillActivate
   $mSkillCancel = $aSkillCancel
   $mSkillComplete = $aSkillComplete
   $mChatReceive = $aChatReceive
   $mLoadFinished = $aLoadFinished
EndFunc   ;==>SetEvent

;~ Description: Internal use for event system. Calls different event functions.
;~ modified by gigi
Func Event($hwnd, $msg, $wparam, $lparam)
   Switch $lparam
	  Case 0x1
		 DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
		 Call($mSkillActivate, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3), DllStructGetData($mSkillLogStruct, 4))
	  Case 0x2
		 DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
		 Call($mSkillCancel, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3))
	  Case 0x3
		 DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
		 Call($mSkillComplete, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3))
	  Case 0x4
		 DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mChatLogStructPtr, 'int', 512, 'int', '')
		 Local $lMessage = DllStructGetData($mChatLogStruct, 2)
		 Local $lChannel
		 Local $lSender
		 Switch DllStructGetData($mChatLogStruct, 1)
			Case 0
			   $lChannel = "Alliance"
			   $lSender = StringMid($lMessage, 6, StringInStr($lMessage, "</a>") - 6)
			   $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			Case 3
			   $lChannel = "All"
			   $lSender = StringMid($lMessage, 6, StringInStr($lMessage, "</a>") - 6)
			   $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			Case 9
			   $lChannel = "Guild"
			   $lSender = StringMid($lMessage, 6, StringInStr($lMessage, "</a>") - 6)
			   $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			Case 11
			   $lChannel = "Team"
			   $lSender = StringMid($lMessage, 6, StringInStr($lMessage, "</a>") - 6)
			   $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			Case 12
			   $lChannel = "Trade"
			   $lSender = StringMid($lMessage, 6, StringInStr($lMessage, "</a>") - 6)
			   $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			Case 10
			   If StringLeft($lMessage, 3) == "-> " Then
				  $lChannel = "Sent"
				  $lSender = StringMid($lMessage, 10, StringInStr($lMessage, "</a>") - 10)
				  $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			   Else
				  $lChannel = "Global"
				  $lSender = "Guild Wars"
			   EndIf
			Case 13
			   $lChannel = "Advisory"
			   $lSender = "Guild Wars"
			   $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			Case 14
			   $lChannel = "Whisper"
			   $lSender = StringMid($lMessage, 7, StringInStr($lMessage, "</a>") - 7)
			   $lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, "<quote>") + 6)
			Case Else
			   $lChannel = "Other"
			   $lSender = "Other"
		 EndSwitch
		 Call($mChatReceive, $lChannel, $lSender, $lMessage)
	  Case 0x5
		 Call($mLoadFinished)
   EndSwitch
EndFunc   ;==>Event
#EndRegion Callback

#Region Modification
;~ Description: Calls ASM functions.
Func ModifyMemory()
   $mASMSize = 0
   $mASMCodeOffset = 0
   $mASMString = ''
   CreateData()
   CreateMain()
   CreateTargetLog()
   CreateSkillLog()
   CreateSkillCancelLog()
   CreateSkillCompleteLog()
   CreateChatLog()
   CreateTraderHook()
   CreateLoadFinished()
   CreateStringLog()
   CreateStringFilter1()
   CreateStringFilter2()
   CreateRenderingMod()
   CreateDialogLog()
   CreateCommands()
   Local $lModMemory = MemoryRead(MemoryRead($mBase), 'ptr')
   If $lModMemory = 0 Then
	  $mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 0x40)
	  $mMemory = $mMemory[0]
	  MemoryWrite(MemoryRead($mBase), $mMemory)
   Else
	  $mMemory = $lModMemory
   EndIf
   CompleteASMCode()
   If $lModMemory = 0 Then
	  WriteBinary($mASMString, $mMemory + $mASMCodeOffset)
	  WriteBinary("83F8009090", GetValue('ClickToMoveFix'))
	  MemoryWrite(GetValue('QueuePtr'), GetValue('QueueBase'))
	  MemoryWrite(GetValue('SkillLogPtr'), GetValue('SkillLogBase'))
	  MemoryWrite(GetValue('ChatLogPtr'), GetValue('ChatLogBase'))
	  MemoryWrite(GetValue('StringLogPtr'), GetValue('StringLogBase'))
   EndIf
   WriteDetour('MainStart', 'MainProc')
   WriteDetour('TargetLogStart', 'TargetLogProc')
   WriteDetour('TraderHookStart', 'TraderHookProc')
   WriteDetour('LoadFinishedStart', 'LoadFinishedProc')
   WriteDetour('RenderingMod', 'RenderingModProc')
   WriteDetour('DialogLogStart', 'DialogLogProc')
   If $mUseStringLog Then
	  WriteDetour('StringLogStart', 'StringLogProc')
	  WriteDetour('StringFilter1Start', 'StringFilter1Proc')
	  WriteDetour('StringFilter2Start', 'StringFilter2Proc')
   EndIf
EndFunc   ;==>ModifyMemory

;~ Description: Writes a jump 'from'-'to' to process memory.
Func WriteDetour($aFrom, $aTo)
   Local $lFrom = GetLabelInfo($aFrom)
   WriteBinary('E9' & SwapEndian(Hex(GetLabelInfo($aTo) - $lFrom - 5)), $lFrom)
EndFunc   ;==>WriteDetour

;~ Description: Add Key and Value to $mRestoreDict.
Func AddRestoreDict($aKey, $aItem)
   If $aItem == '' Then Return
   If $mRestoreDict = 0 Then CreateRestoreDict()
   $mRestoreDict($aKey) = $aItem
EndFunc

;~ Description: Restore data saved in $mRestoreDict.
Func RestoreDetour()
   While GetMapLoading() = 2
	  Sleep(1000)
   WEnd
   If $mRestoreDict.Item($mBase) = "0x00000000" Then
	  $lStr = "Restoring data: " & @CRLF
	  For $i In $mRestoreDict.Keys
		 $lItem = $mRestoreDict.Item($i)
		 If StringLeft($lItem, 2) == '0x' Then $lItem = StringTrimLeft($lItem, 2)
		 $lSize = 0.5 * StringLen($lItem)
		 $lTemp = MemoryRead(Ptr($i), 'byte[' & $lSize & ']')
		 WriteBinary($lItem, $i, False)
		 $lStr &= Ptr($i) & ': ' & $lItem & ' | ' & $lTemp & ' -> ' & MemoryRead(Ptr($i), 'byte[' & $lSize & ']') & @CRLF
	  Next
	  WinSetTitle($mGWHwnd, '', $mGWTitleOld)
	  DllCall($mKernelHandle, 'int', 'VirtualFreeEx', 'handle', $mGWProcHandle, 'ptr', $mMemory, 'int', 0, 'dword', 0x8000)
   Else
	  $lStr = "Client was already injected. Only restoring Dialoghook."
	  WinSetTitle($mGWHwnd, '', $mGWTitleOld)
	  WriteBinary('558BEC8B41', GetLabelInfo('DialogLogStart'))
   EndIf
   Consolewrite($lStr & @CRLF)
EndFunc

;~ Description: Creates dictionary object and sets keys to case insensitive. Internal use RestoreDetour.
Func CreateRestoreDict()
   $mRestoreDict = ObjCreate('Scripting.Dictionary')
   $mRestoreDict.CompareMode = 1 ; keys -> case insensitive
EndFunc   ;==>CreateLabelDict

;~ Description: ASM variables.
Func CreateData()
   _('CallbackHandle/4')
   _('QueueCounter/4')
   _('SkillLogCounter/4')
   _('ChatLogCounter/4')
   _('ChatLogLastMsg/4')
   _('MapIsLoaded/4')
   _('NextStringType/4')
   _('EnsureEnglish/4')
   _('TraderQuoteID/4')
   _('TraderCostID/4')
   _('TraderCostValue/4')
   _('DisableRendering/4')
   _('QueueBase/' & 256 * GetValue('QueueSize'))
   _('TargetLogBase/' & 4 * GetValue('TargetLogSize'))
   _('SkillLogBase/' & 16 * GetValue('SkillLogSize'))
   _('StringLogBase/' & 256 * GetValue('StringLogSize'))
   _('ChatLogBase/' & 512 * GetValue('ChatLogSize'))
   _('LastDialogID/4')
   _('AgentCopyCount/4')
   _('AgentCopyBase/' & 0x1C0 * 256)
EndFunc   ;==>CreateData

;~ Description: ASM function. Internal use only.
Func CreateMain()
   _('MainProc:')
   _('pushad')
   _('mov eax,dword[EnsureEnglish]')
   _('test eax,eax')
   _('jz MainMain')

   _('mov ecx,dword[BasePointer]')
   _('mov ecx,dword[ecx+18]')
   _('mov ecx,dword[ecx+18]')
   _('mov ecx,dword[ecx+194]')
   _('mov al,byte[ecx+4f]')
   _('cmp al,f')
   _('ja MainMain')
   _('mov ecx,dword[ecx+4c]')
   _('mov al,byte[ecx+3f]')
   _('cmp al,f')
   _('ja MainMain')
   _('mov eax,dword[ecx+40]')
   _('test eax,eax')
   _('jz MainMain')

   _('mov ecx,dword[ActionBase]')
   _('mov ecx,dword[ecx+170]')
   _('mov ecx,dword[ecx+20]')
   _('mov ecx,dword[ecx]')
   _('push 0')
   _('push 0')
   _('push bb')
   _('mov edx,esp')
   _('push 0')
   _('push edx')
   _('push 18')
   _('call ActionFunction')
   _('pop eax')
   _('pop ebx')
   _('pop ecx')

   _('MainMain:')
   _('mov eax,dword[QueueCounter]')
   _('mov ecx,eax')
   _('shl eax,8')
   _('add eax,QueueBase')
   _('mov ebx,dword[eax]')
   _('test ebx,ebx')
   _('jz MainExit')

   _('push ecx')
   _('mov dword[eax],0')
   _('jmp ebx')

   _('CommandReturn:')
   _('pop eax')
   _('inc eax')
   _('cmp eax,QueueSize')
   _('jnz MainSkipReset')
   _('xor eax,eax')
   _('MainSkipReset:')
   _('mov dword[QueueCounter],eax')

   _('MainExit:')
   _('popad')
   _('mov ebp,esp')
   _('sub esp,14')
   _('ljmp MainReturn')
EndFunc   ;==>CreateMain

;~ Description: ASM function. Internal use only.
Func CreateTargetLog()
   _('TargetLogProc:')
   _('cmp ecx,4')
   _('jz TargetLogMain')
   _('cmp ecx,32')
   _('jz TargetLogMain')
   _('cmp ecx,3C')
   _('jz TargetLogMain')
   _('jmp TargetLogExit')

   _('TargetLogMain:')
   _('pushad')
   _('mov ecx,dword[ebp+8]')
   _('test ecx,ecx')
   _('jnz TargetLogStore')
   _('mov ecx,edx')

   _('TargetLogStore:')
   _('lea eax,dword[edx*4+TargetLogBase]')
   _('mov dword[eax],ecx')
   _('popad')

   _('TargetLogExit:')
   _('push ebx')
   _('push esi')
   _('push edi')
   _('mov edi,edx')
   _('ljmp TargetLogReturn')
EndFunc   ;==>CreateTargetLog

;~ Description: ASM function. Internal use only.
Func CreateSkillLog()
   _('SkillLogProc:')
   _('pushad')
   _('mov eax,dword[SkillLogCounter]')
   _('push eax')
   _('shl eax,4')
   _('add eax,SkillLogBase')
   _('mov ecx,dword[edi]')
   _('mov dword[eax],ecx')
   _('mov ecx,dword[ecx*4+TargetLogBase]')
   _('mov dword[eax+4],ecx')
   _('mov ecx,dword[edi+4]')
   _('mov dword[eax+8],ecx')
   _('mov ecx,dword[edi+8]')
   _('mov dword[eax+c],ecx')
   _('push 1')
   _('push eax')
   _('push CallbackEvent')
   _('push dword[CallbackHandle]')
   _('call dword[PostMessage]')
   _('pop eax')
   _('inc eax')
   _('cmp eax,SkillLogSize')
   _('jnz SkillLogSkipReset')
   _('xor eax,eax')

   _('SkillLogSkipReset:')
   _('mov dword[SkillLogCounter],eax')
   _('popad')
   _('inc eax')
   _('mov dword[esi+10],eax')
   _('pop esi')
   _('ljmp SkillLogReturn')
EndFunc   ;==>CreateSkillLog

;~ Description: ASM function. Internal use only.
Func CreateSkillCancelLog()
   _('SkillCancelLogProc:')
   _('pushad')
   _('mov eax,dword[SkillLogCounter]')
   _('push eax')
   _('shl eax,4')
   _('add eax,SkillLogBase')
   _('mov ecx,dword[edi]')
   _('mov dword[eax],ecx')
   _('mov ecx,dword[ecx*4+TargetLogBase]')
   _('mov dword[eax+4],ecx')
   _('mov ecx,dword[edi+4]')
   _('mov dword[eax+8],ecx')
   _('push 2')
   _('push eax')
   _('push CallbackEvent')
   _('push dword[CallbackHandle]')
   _('call dword[PostMessage]')
   _('pop eax')
   _('inc eax')
   _('cmp eax,SkillLogSize')
   _('jnz SkillCancelLogSkipReset')
   _('xor eax,eax')

   _('SkillCancelLogSkipReset:')
   _('mov dword[SkillLogCounter],eax')
   _('popad')
   _('push 0')
   _('push 42')
   _('mov ecx,esi')
   _('ljmp SkillCancelLogReturn')
EndFunc   ;==>CreateSkillCancelLog

;~ Description: ASM function. Internal use only.
Func CreateSkillCompleteLog()
   _('SkillCompleteLogProc:')
   _('pushad')
   _('mov eax,dword[SkillLogCounter]')
   _('push eax')
   _('shl eax,4')
   _('add eax,SkillLogBase')
   _('mov ecx,dword[edi]')
   _('mov dword[eax],ecx')
   _('mov ecx,dword[ecx*4+TargetLogBase]')
   _('mov dword[eax+4],ecx')
   _('mov ecx,dword[edi+4]')
   _('mov dword[eax+8],ecx')
   _('push 3')
   _('push eax')
   _('push CallbackEvent')
   _('push dword[CallbackHandle]')
   _('call dword[PostMessage]')
   _('pop eax')
   _('inc eax')
   _('cmp eax,SkillLogSize')
   _('jnz SkillCompleteLogSkipReset')
   _('xor eax,eax')

   _('SkillCompleteLogSkipReset:')
   _('mov dword[SkillLogCounter],eax')
   _('popad')
   _('mov eax,dword[edi+4]')
   _('test eax,eax')
   _('ljmp SkillCompleteLogReturn')
EndFunc   ;==>CreateSkillCompleteLog

;~ Description: ASM function. Internal use only.
Func CreateChatLog()
   _('ChatLogProc:')
   _('pushad')
   _('mov ecx,dword[esp+1F4]')
   _('mov ebx,eax')
   _('mov eax,dword[ChatLogCounter]')
   _('push eax')
   _('shl eax,9')
   _('add eax,ChatLogBase')
   _('mov dword[eax],ebx')
   _('mov edi,eax')
   _('add eax,4')
   _('xor ebx,ebx')

   _('ChatLogCopyLoop:')
   _('mov dx,word[ecx]')
   _('mov word[eax],dx')
   _('add ecx,2')
   _('add eax,2')
   _('inc ebx')
   _('cmp ebx,FF')
   _('jz ChatLogCopyExit')
   _('test dx,dx')
   _('jnz ChatLogCopyLoop')

   _('ChatLogCopyExit:')
   _('push 4')
   _('push edi')
   _('push CallbackEvent')
   _('push dword[CallbackHandle]')
   _('call dword[PostMessage]')
   _('pop eax')
   _('inc eax')
   _('cmp eax,ChatLogSize')
   _('jnz ChatLogSkipReset')
   _('xor eax,eax')
   _('ChatLogSkipReset:')
   _('mov dword[ChatLogCounter],eax')
   _('popad')

   _('ChatLogExit:')
   _('add edi,E')
   _('cmp eax,B')
   _('ljmp ChatLogReturn')
EndFunc   ;==>CreateChatLog

;~ Description: ASM function. Internal use only.
Func CreateTraderHook()
   _('TraderHookProc:')
   _('mov dword[TraderCostID],ecx')
   _('mov dword[TraderCostValue],edx')
   _('push eax')
   _('mov eax,dword[TraderQuoteID]')
   _('inc eax')
   _('cmp eax,200')
   _('jnz TraderSkipReset')
   _('xor eax,eax')
   _('TraderSkipReset:')
   _('mov dword[TraderQuoteID],eax')
   _('pop eax')
   _('mov ebp,esp')
   _('sub esp,8')
   _('ljmp TraderHookReturn')
EndFunc   ;==>CreateTraderHook

;~ Description: ASM function. Internal use only.
Func CreateLoadFinished()
   _('LoadFinishedProc:')
   _('pushad')
   _('mov eax,1')
   _('mov dword[MapIsLoaded],eax')
   _('xor ebx,ebx')
   _('mov eax,StringLogBase')

   _('LoadClearStringsLoop:')
   _('mov dword[eax],0')
   _('inc ebx')
   _('add eax,100')
   _('cmp ebx,StringLogSize')
   _('jnz LoadClearStringsLoop')

   _('xor ebx,ebx')
   _('mov eax,TargetLogBase')
   _('LoadClearTargetsLoop:')
   _('mov dword[eax],0')
   _('inc ebx')
   _('add eax,4')
   _('cmp ebx,TargetLogSize')
   _('jnz LoadClearTargetsLoop')

   _('push 5')
   _('push 0')
   _('push CallbackEvent')
   _('push dword[CallbackHandle]')
   _('call dword[PostMessage]')
   _('popad')
   _('mov edx,dword[esi+1C]')
   _('mov ecx,edi')
   _('ljmp LoadFinishedReturn')
EndFunc   ;==>CreateLoadFinished

;~ Description: ASM function. Internal use only.
Func CreateStringLog()
   _('StringLogProc:')
   _('pushad')
   _('mov eax,dword[NextStringType]')
   _('test eax,eax')
   _('jz StringLogExit')

   _('cmp eax,1')
   _('jnz StringLogFilter2')
   _('mov eax,dword[ebp+37c]')
   _('jmp StringLogRangeCheck')

   _('StringLogFilter2:')
   _('cmp eax,2')
   _('jnz StringLogExit')
   _('mov eax,dword[ebp+338]')

   _('StringLogRangeCheck:')
   _('mov dword[NextStringType],0')
   _('cmp eax,0')
   _('jbe StringLogExit')
   _('cmp eax,StringLogSize')
   _('jae StringLogExit')

   _('shl eax,8')
   _('add eax,StringLogBase')
   _('xor ebx,ebx')

   _('StringLogCopyLoop:')
   _('mov dx,word[ecx]')
   _('mov word[eax],dx')
   _('add ecx,2')
   _('add eax,2')
   _('inc ebx')
   _('cmp ebx,80')
   _('jz StringLogExit')
   _('test dx,dx')
   _('jnz StringLogCopyLoop')

   _('StringLogExit:')
   _('popad')
   _('mov esp,ebp')
   _('pop ebp')
   _('retn 10')
EndFunc   ;==>CreateStringLog

;~ Description: ASM function. Internal use only.
Func CreateStringFilter1()
   _('StringFilter1Proc:')
   _('mov dword[NextStringType],1')
   _('push ebp')
   _('mov ebp,esp')
   _('push ecx')
   _('push esi')
   _('ljmp StringFilter1Return')
EndFunc   ;==>CreateStringFilter1

;~ Description: ASM function. Internal use only.
Func CreateStringFilter2()
   _('StringFilter2Proc:')
   _('mov dword[NextStringType],2')
   _('push ebp')
   _('mov ebp,esp')
   _('push ecx')
   _('push esi')
   _('ljmp StringFilter2Return')
EndFunc   ;==>CreateStringFilter2

;~ Description: ASM function. Internal use only.
Func CreateDialogLog()
   _('DialogLogProc:')
   _('push ebp')
   _('mov ebp,esp')
   _('mov eax,dword[ebp+8]')
   _('mov dword[LastDialogID],eax')
   _('mov eax,dword[ecx+8]')
   _('test al,1')
   _('ljmp DialogLogReturn')
EndFunc   ;==>CreateDialogLog

;~ Description: ASM function. Internal use only.
Func CreateRenderingMod()
   _('RenderingModProc:')
   _('cmp dword[DisableRendering],1')
   _('jz RenderingModSkipCompare')
   _('cmp eax,ebx')
   _('ljne RenderingModReturn')

   _('RenderingModSkipCompare:')
   $mASMSize += 17
   $mASMString &= StringTrimLeft(MemoryRead(GetValue("RenderingMod") + 4, "byte[17]"), 2)
   _('cmp dword[DisableRendering],1')
   _('jz DisableRenderingProc')
   _('retn')

   _('DisableRenderingProc:')
   _('push 1')
   _('call dword[Sleep]')
   _('retn')
EndFunc   ;==>CreateRenderingMod

;~ Description: ASM functions as strings, each line calls conversion function _(). Internal use only.
Func CreateCommands()
   #Region Commands
   ; PacketSend ;
   _('CommandPacketSend:')
   _('mov ecx,dword[PacketLocation]')
   _('lea edx,dword[eax+8]')
   _('push edx')
   _('mov edx,dword[eax+4]')
   _('mov eax,ecx')
   _('call PacketSendFunction')
   _('ljmp CommandReturn')
   ; Action ;
   _('CommandAction:')
   _('mov ecx,dword[ActionBase]')
   _('mov ecx,dword[ecx+250]')
   _('mov ecx,dword[ecx+10]')
   _('mov ecx,dword[ecx]')
   _('push 0')
   _('push 0')
   _('push dword[eax+4]')
   _('mov edx,esp')
   _('push 0')
   _('push edx')
   _('push dword[eax+8]')
   _('call ActionFunction')
   _('pop eax')
   _('pop ebx')
   _('pop ecx')
   _('ljmp CommandReturn')
   ; UseSkill ;
   _('CommandUseSkill:')
   _('mov ecx,dword[MyID]')
   _('mov edx,dword[eax+C]')
   _('push edx')
   _('mov edx,dword[eax+4]')
   _('dec edx')
   _('push dword[eax+8]')
   _('call UseSkillFunction')
   _('ljmp CommandReturn')
   ; Move ;
   _('CommandMove:')
   _('lea ecx,dword[eax+4]')
   _('call MoveFunction')
   _('ljmp CommandReturn')
   ; ChangeTarget ;
   _('CommandChangeTarget:')
   _('mov ecx,dword[eax+4]')
   _('xor edx,edx')
   _('call ChangeTargetFunction')
   _('ljmp CommandReturn')
   ; ToggleLanguage ;
   _('CommandToggleLanguage:')
   _('mov ecx,dword[ActionBase]')
   _('mov ecx,dword[ecx+170]')
   _('mov ecx,dword[ecx+20]')
   _('mov ecx,dword[ecx]')
   _('push 0')
   _('push 0')
   _('push bb')
   _('mov edx,esp')
   _('push 0')
   _('push edx')
   _('push dword[eax+4]')
   _('call ActionFunction')
   _('pop eax')
   _('pop ebx')
   _('pop ecx')
   _('ljmp CommandReturn')
   ; UseHeroSkill ;
   _('CommandUseHeroSkill:')
   _('mov ecx,dword[eax+4]')
   _('mov edx,dword[eax+c]')
   _('mov eax,dword[eax+8]')
   _('push eax')
   _('call UseHeroSkillFunction')
   _('ljmp CommandReturn')
   #EndRegion Commands

   #Region Items
   ; Buy ;
   _('CommandBuyItem:')
   _('add eax,4')
   _('push eax')
   _('add eax,4')
   _('push eax')
   _('push 1')
   _('push 0')
   _('push 0')
   _('push 0')
   _('push 0')
   _('mov ecx,1')
   _('mov edx,dword[eax+4]')
   _('call BuyItemFunction')
   _('ljmp CommandReturn')
   ; Sell ;
   _('CommandSellItem:')
   _('push 0')
   _('push 0')
   _('push 0')
   _('push dword[eax+4]')
   _('push 0')
   _('add eax,8')
   _('push eax')
   _('push 1')
   _('mov ecx,b')
   _('xor edx,edx')
   _('call SellItemFunction')
   _('ljmp CommandReturn')
   ; CraftItem ;
   _('CommandCraftItem:')
   _('add eax,4')
   _('push eax')
   _('add eax,4')
   _('push eax')
   _('push 1')
   _('push 0')
   _('push 0')
   _('add eax,4')
   _('push eax')
   _('add eax,C')
   _('push dword[eax+4]')
   _('add eax,4')
   _('mov edx,esp')
   _('mov ecx,dword[E1D684]')
   _('mov dword[edx-0x70],ecx')
   _('mov ecx,dword[edx+0x1C]')
   _('mov dword[edx+0x54],ecx')
   _('mov ecx,dword[edx+4]')
   _('mov dword[edx-0x14],ecx')
   _('mov ecx,3')
   _('mov ebx,dword[eax]')
   _('mov edx,dword[eax+4]')
   _('call BuyItemFunction')
   _('ljmp CommandReturn')
   ; CraftItemEx ;
   _('CommandCraftItemEx:')
   _('add eax,4')
   _('push eax')
   _('add eax,4')
   _('push eax')
   _('push 1')
   _('push 0')
   _('push 0')
   _('push dword[eax+4]')
   _('add eax,4')
   _('push dword[eax+4]')
   _('add eax,4')
   _('mov edx,esp')
   _('mov ecx,dword[E1D684]')
   _('mov dword[edx-0x70],ecx')
   _('mov ecx,dword[edx+0x1C]')
   _('mov dword[edx+0x54],ecx')
   _('mov ecx,dword[edx+4]')
   _('mov dword[edx-0x14],ecx')
   _('mov ecx,3')
   _('mov ebx,dword[eax]')
   _('mov edx,dword[eax+4]')
   _('call BuyItemFunction')
   _('ljmp CommandReturn')
   ; Upgrade ;
   _('CommandUpgrade:')
   _('add eax,4')
   _('mov ecx,eax')
   _('call UpgradeWindow')
   _('ljmp CommandReturn')
   ; Salvage ;
   _('CommandSalvage:')
   _('mov ebx,SalvageGlobal')
   _('mov ecx,dword[eax+4]')
   _('mov dword[ebx],ecx')
   _('push ecx')
   _('mov ecx,dword[eax+8]')
   _('add ebx,4')
   _('mov dword[ebx],ecx')
   _('mov edx,dword[eax+c]')
   _('mov dword[ebx],ecx')
   _('call SalvageFunction')
   _('ljmp CommandReturn')
   ; OpenStorage ;
   _('CommandOpenStorage:')
   _('pushad')
   _('add eax,4')
   _('mov ecx,dword[eax]')
   _('add eax,4')
   _('mov edx,eax')
   _('call StorageFunction')
   _('popad')
   ; OpenMerchant ;
   _('CommandOpenMerchant:')
   _('pushad')
   _('add eax,4')
   _('mov ecx,dword[eax]')
   _('add eax,4')
   _('mov edx,eax')
   _('mov ebx,eax')
   _('mov eax,14')
   _('call MerchantWindow')
   _('popad')
   #EndRegion Items

   #Region Trader
   ; Buy ;
   _('CommandTraderBuy:')
   _('push 0')
   _('push TraderCostID')
   _('push 1')
   _('push 0')
   _('push 0')
   _('push 0')
   _('push 0')
   _('mov ecx,c')
   _('mov edx,dword[TraderCostValue]')
   _('call TraderFunction')
   _('mov dword[TraderCostID],0')
   _('mov dword[TraderCostValue],0')
   _('ljmp CommandReturn')
   ; Sell ;
   _('CommandTraderSell:')
   _('push 0')
   _('push 0')
   _('push 0')
   _('push dword[TraderCostValue]')
   _('push 0')
   _('push TraderCostID')
   _('push 1')
   _('mov ecx,d')
   _('xor edx,edx')
   _('call TraderFunction')
   _('mov dword[TraderCostID],0')
   _('mov dword[TraderCostValue],0')
   _('ljmp CommandReturn')
   ; QuoteBuy ;
   _('CommandRequestQuote:')
   _('mov dword[TraderCostID],0')
   _('mov dword[TraderCostValue],0')
   _('add eax,4')
   _('push eax')
   _('push 1')
   _('push 0')
   _('push 0')
   _('push 0')
   _('push 0')
   _('mov ecx,c')
   _('xor edx,edx')
   _('call RequestQuoteFunction')
   _('ljmp CommandReturn')
   ; QuoteSell ;
   _('CommandRequestQuoteSell:')
   _('mov dword[TraderCostID],0')
   _('mov dword[TraderCostValue],0')
   _('push 0')
   _('push 0')
   _('push 0')
   _('add eax,4')
   _('push eax')
   _('push 1')
   _('push 0')
   _('mov ecx,d')
   _('xor edx,edx')
   _('call RequestQuoteFunction')
   _('ljmp CommandReturn')
   #EndRegion Trader

   #Region Chat
   ; Send ;
   _('CommandSendChat:')
   _('mov ecx,dword[PacketLocation]')
   _('add eax,4')
   _('push eax')
   _('mov edx,11c')
   _('mov eax,ecx')
   _('call PacketSendFunction')
   _('ljmp CommandReturn')
   ; Write ;
   _('CommandWriteChat:')
   _('add eax,4')
   _('mov edx,eax')
   _('xor ecx,ecx')
   _('add eax,28')
   _('push eax')
   _('call WriteChatFunction')
   _('ljmp CommandReturn')
   #EndRegion Chat

   #Region AgentArray
   ; MakeAgentArray ;
   _('CommandMakeAgentArray:')
   _('mov eax,dword[eax+4]')
   _('xor ebx,ebx')
   _('xor edx,edx')
   _('mov edi,AgentCopyBase')

   _('AgentCopyLoopStart:')
   _('inc ebx')
   _('cmp ebx,dword[MaxAgents]')
   _('jge AgentCopyLoopExit')

   _('mov esi,dword[AgentBase]')
   _('lea esi,dword[esi+ebx*4]')
   _('mov esi,dword[esi]')
   _('test esi,esi')
   _('jz AgentCopyLoopStart')

   _('cmp eax,0')
   _('jz CopyAgent')
   _('cmp eax,dword[esi+9C]')
   _('jnz AgentCopyLoopStart')

   _('CopyAgent:')
   _('mov ecx,1C0')
   _('clc')
   _('repe movsb')
   _('inc edx')
   _('jmp AgentCopyLoopStart')

   _('AgentCopyLoopExit:')
   _('mov dword[AgentCopyCount],edx')
   _('ljmp CommandReturn')
   ; MakeAgentArrayEx ;
   _('CommandMakeAgentArrayEx:')
   _('mov ecx,dword[eax+8]') ; move content of eax+8 to ecx (allegiance to be copied)
   _('mov eax,dword[eax+4]') ; move content of eax+4 to eax (agent type to be copied)
   _('xor ebx,ebx') ; set ebx to 0
   _('xor edx,edx') ; set edx to 0
   _('mov edi,AgentCopyBase') ; set edi to pointer to AgentCopyBase

   _('AgentCopyLoopStartEx:')
   _('inc ebx') ; ebx + 1
   _('cmp ebx,dword[MaxAgents]') ; compare ebx (internal counter) with amount of MaxAgents
   _('jge AgentCopyLoopExitEx') ; jump to exit if greater or equal

   _('mov esi,dword[AgentBase]') ; set esi to pointer read from AgentBase
   _('lea esi,dword[esi+ebx*4]') ; set esi to address of esi+ebx*4 -> First Agent + Number of Agent * 4
   _('mov esi,dword[esi]') ; set esi to content of address in esi
   _('test esi,esi') ; BitAnd(esi,esi) => ZF = 1 if esi = 0 -> check for empty agent
   _('jz AgentCopyLoopStartEx') ; jump to AgentCopyLoopStart if ZF = 1

   _('cmp eax,0') ; eax - 0 => ZF = 1 if eax = 0
   _('jz CopyAgentEx') ; jump to CopyAgentEx if eax ZF = 1 -> if eax = 0
   _('cmp eax,dword[esi+9C]') ; eax - agent type => ZF = 1 if eax = agent type
   _('jnz AgentCopyLoopStartEx') ; jump to AgentCopyLoopStartEx if ZF = 0
   _('cmp ecx,0') ; ecx - 0 => ZF = 1 if ecx = 0
   _('jz CopyAgentEx') ; jump to CopyAgentEx
   _('cmp cl,byte[esi+1B1]') ; cl - agent allegiance
   _('jnz AgentCopyLoopStartEx') ; jump to AgentCopyLoopStartEx if ZF = 0

   _('CopyAgentEx:')
   _('mov dword[edi],esi') ; move esi (agent ptr) to address in edi
   _('add edi,4') ; add 4 to edi (prepare next segment in struct)
   _('inc edx') ; add 1 to copied agents counter
   _('jmp AgentCopyLoopStartEx') ; jump to AgentCopyLoopStartEx

   _('AgentCopyLoopExitEx:')
   _('mov dword[AgentCopyCount],edx') ; move edx (counter of copied agent ptrs) to AgentCopyCount
   _('ljmp CommandReturn') ; jump to CommandReturn
   #EndRegion AgentArray

   #Region Attributes
   ; Increase ;
   _('CommandIncreaseAttribute:')
   _('mov edx,dword[eax+4]')
   _('mov ecx,dword[eax+8]')
   _('call IncreaseAttributeFunction')
   _('ljmp CommandReturn')
   ; Decrease ;
   _('CommandDecreaseAttribute:')
   _('mov edx,dword[eax+4]')
   _('mov ecx,dword[eax+8]')
   _('call DecreaseAttributeFunction')
   _('ljmp CommandReturn')
   #EndRegion Attributes
EndFunc   ;==>CreateCommands
#EndRegion Modification

#Region Assembler
;~ Description: Converts ASM commands to opcodes and updates global variables.
Func _($aASM)
   ;quick and dirty x86assembler unit:
   ;relative values stringregexp
   ;static values hardcoded
   Local $lBuffer
   Local $lOpCode = ''
   Local $lMnemonic = StringLeft($aASM, StringInStr($aASM, ' ') - 1)
   Select
	  Case $lMnemonic = "" ; variables and single word opcodes
		 Select
			Case StringRight($aASM, 1) = ':'
			   SetValue('Label_' & StringLeft($aASM, StringLen($aASM) - 1), $mASMSize)
			Case StringInStr($aASM, '/') > 0
			   SetValue('Label_' & StringLeft($aASM, StringInStr($aASM, '/') - 1), $mASMSize)
			   Local $lOffset = StringRight($aASM, StringLen($aASM) - StringInStr($aASM, '/'))
			   $mASMSize += $lOffset
			   $mASMCodeOffset += $lOffset
			Case $aASM = 'pushad' ; push all
			   $lOpCode = '60'
			Case $aASM = 'popad' ; pop all
			   $lOpCode = '61'
			Case $aASM = 'nop'
			   $lOpCode = '90'
			Case $aASM = 'retn'
			   $lOpCode = 'C3'
			Case $aASM = 'clc'
			   $lOpCode = 'F8'
		 EndSelect
	  Case $lMnemonic = "nop" ; nop
		 If StringLeft($aASM, 5) = 'nop x' Then
			$lBuffer = Int(Number(StringTrimLeft($aASM, 5)))
			$mASMSize += $lBuffer
			For $i = 1 To $lBuffer
			   $mASMString &= '90'
			Next
		 EndIf
	  Case StringLeft($lMnemonic, 2) = "lj" Or StringLeft($lMnemonic, 1) = "j" ; jump
		 $lStringLeft5 = StringLeft($aASM, 5)
		 $lStringLeft4 = StringLeft($aASM, 4)
		 $lStringLeft3 = StringLeft($aASM, 3)
		 Select
			Case $lStringLeft5 = 'ljmp '
			   $mASMSize += 5
			   $mASMString &= 'E9{' & StringRight($aASM, StringLen($aASM) - 5) & '}'
			Case $lStringLeft5 = 'ljne '
			   $mASMSize += 6
			   $mASMString &= '0F85{' & StringRight($aASM, StringLen($aASM) - 5) & '}'
			Case $lStringLeft4 = 'jmp ' And StringLen($aASM) > 7
			   $mASMSize += 2
			   $mASMString &= 'EB(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
			Case $lStringLeft4 = 'jae '
			   $mASMSize += 2
			   $mASMString &= '73(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
			Case $lStringLeft4 = 'jnz '
			   $mASMSize += 2
			   $mASMString &= '75(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
			Case $lStringLeft4 = 'jbe '
			   $mASMSize += 2
			   $mASMString &= '76(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
			Case $lStringLeft4 = 'jge '
			   $mASMSize += 2
			   $mASMString &= '7D(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
			Case $lStringLeft4 = 'jle '
			   $mASMSize += 2
			   $mASMString &= '7E(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
			Case $lStringLeft3 = 'ja '
			   $mASMSize += 2
			   $mASMString &= '77(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
			Case $lStringLeft3 = 'jl '
			   $mASMSize += 2
			   $mASMString &= '7C(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
			Case $lStringLeft3 = 'jz '
			   $mASMSize += 2
			   $mASMString &= '74(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
			; hardcoded
			Case $aASM = 'jmp ebx'
			   $lOpCode = 'FFE3'
		 EndSelect
	  Case $lMnemonic = "mov" ; mov
		 Select
			; mov eax,dword[EnsureEnglish]
			Case StringRegExp($aASM, 'mov eax,dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 5
			   $mASMString &= 'A1[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
			Case StringRegExp($aASM, 'mov ecx,dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 6
			   $mASMString &= '8B0D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
			Case StringRegExp($aASM, 'mov edx,dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 6
			   $mASMString &= '8B15[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
			Case StringRegExp($aASM, 'mov ebx,dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 6
			   $mASMString &= '8B1D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
			Case StringRegExp($aASM, 'mov esi,dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 6
			   $mASMString &= '8B35[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
			Case StringRegExp($aASM, 'mov edi,dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 6
			   $mASMString &= '8B3D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
			; mov eax,TargetLogBase
			Case StringRegExp($aASM, 'mov eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 5
			   $mASMString &= 'B8[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			Case StringRegExp($aASM, 'mov edx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 5
			   $mASMString &= 'BA[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			Case StringRegExp($aASM, 'mov ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 5
			   $mASMString &= 'BB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			Case StringRegExp($aASM, 'mov esi,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 5
			   $mASMString &= 'BE[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			Case StringRegExp($aASM, 'mov edi,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 5
			   $mASMString &= 'BF[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			; mov ecx,dword[ecx*4+TargetLogBase]
			Case StringRegExp($aASM, 'mov eax,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			   $mASMSize += 7
			   $mASMString &= '8B048D[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
			Case StringRegExp($aASM, 'mov ecx,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			   $mASMSize += 7
			   $mASMString &= '8B0C8D[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
			; mov eax,14
			Case StringRegExp($aASM, 'mov eax,[-[:xdigit:]]{1,8}\z')
			   $mASMSize += 5
			   $mASMString &= 'B8' & ASMNumber(StringMid($aASM, 9))
			Case StringRegExp($aASM, 'mov ebx,[-[:xdigit:]]{1,8}\z')
			   $mASMSize += 5
			   $mASMString &= 'BB' & ASMNumber(StringMid($aASM, 9))
			Case StringRegExp($aASM, 'mov ecx,[-[:xdigit:]]{1,8}\z')
			   $mASMSize += 5
			   $mASMString &= 'B9' & ASMNumber(StringMid($aASM, 9))
			Case StringRegExp($aASM, 'mov edx,[-[:xdigit:]]{1,8}\z')
			   $mASMSize += 5
			   $mASMString &= 'BA' & ASMNumber(StringMid($aASM, 9))
			; mov dword[TraderCostID],ecx
			Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],ecx')
			   $mASMSize += 6
			   $mASMString &= '890D[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
			Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],edx')
			   $mASMSize += 6
			   $mASMString &= '8915[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
			Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],eax')
			   $mASMSize += 5
			   $mASMString &= 'A3[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
			; mov dword[NextStringType],2
			Case StringRegExp($aASM, 'mov dword\[[a-z,A-Z]{4,}\],[-[:xdigit:]]{1,8}\z')
			   $lBuffer = StringInStr($aASM, ",")
			   $mASMSize += 10
			   $mASMString &= 'C705[' & StringMid($aASM, 11, $lBuffer - 12) & ']' & ASMNumber(StringMid($aASM, $lBuffer + 1))
			; hardcoded
			Case $aASM = 'mov eax,ecx'
			   $lOpCode = '8BC1'
			Case $aASM = 'mov eax,edi'
			   $lOpCode = '8BC7'
			Case $aASM = 'mov eax,dword[ebp+8]'
			   $lOpCode = '3E8B4508'
			Case $aASM = 'mov eax,dword[ecx+8]'
			   $lOpCode = '8B4108'
			Case $aASM = 'mov ecx,eax'
			   $lOpCode = '8BC8'
			Case $aASM = 'mov ecx,edx'
			   $lOpCode = '8BCA'
			Case $aASM = 'mov ecx,esi'
			   $lOpCode = '8BCE'
			Case $aASM = 'mov ecx,edi'
			   $lOpCode = '8BCF'
			Case $aASM = 'mov edx,eax'
			   $lOpCode = '8BD0'
			Case $aASM = 'mov edx,esp'
			   $lOpCode = '8BD4'
			Case $aASM = 'mov ebx,edi'
			   $lOpCode = '8BDF'
			Case $aASM = 'mov ebx,eax'
			   $lOpCode = '8BD8'
			Case $aASM = 'mov esp,ebp'
			   $lOpCode = '8BE5'
			Case $aASM = 'mov ebp,esp'
			   $lOpCode = '8BEC'
			Case $aASM = 'mov edi,eax'
			   $lOpCode = '8BF8'
			Case $aASM = 'mov edi,edx'
			   $lOpCode = '8BFA'
			Case $aASM = 'mov eax,dword[eax+4]'
			   $lOpCode = '8B4004'
			Case $aASM = 'mov eax,dword[eax+8]'
			   $lOpCode = '8B4008'
			Case $aASM = 'mov eax,dword[ecx]'
			   $lOpCode = '8B01'
			Case $aASM = 'mov eax,dword[ecx+40]'
			   $lOpCode = '8B4140'
			Case $aASM = 'mov eax,dword[ebx+c]'
			   $lOpCode = '8B430C'
			Case $aASM = 'mov eax,dword[ebp+37c]'
			   $lOpCode = '8B857C030000'
			Case $aASM = 'mov eax,dword[ebp+338]'
			   $lOpCode = '8B8538030000'
			Case $aASM = 'mov eax,dword[esi+8]'
			   $lOpCode = '8B4608'
			Case $aASM = 'mov eax,dword[edi+4]'
			   $lOpCode = '8B4704'
			Case $aASM = 'mov ecx,dword[eax]'
			   $lOpCode = '8B08'
			Case $aASM = 'mov ecx,dword[eax+4]'
			   $lOpCode = '8B4804'
			Case $aASM = 'mov ecx,dword[eax+8]'
			   $lOpCode = '8B4808'
			Case $aASM = 'mov ecx,dword[eax+20]'
			   $lOpCode = '8B4814'
			Case $aASM = 'mov ecx,dword[ecx]'
			   $lOpCode = '8B09'
			Case $aASM = 'mov ecx,dword[ecx+10]'
			   $lOpCode = '8B4910'
			Case $aASM = 'mov ecx,dword[ecx+18]'
			   $lOpCode = '8B4918'
			Case $aASM = 'mov ecx,dword[ecx+20]'
			   $lOpCode = '8B4920'
			Case $aASM = 'mov ecx,dword[ecx+4c]'
			   $lOpCode = '8B494C'
			Case $aASM = 'mov ecx,dword[ecx+170]'
			   $lOpCode = '8B8970010000'
			Case $aASM = 'mov ecx,dword[ecx+194]'
			   $lOpCode = '8B8994010000'
			Case $aASM = 'mov ecx,dword[ecx+250]'
			   $lOpCode = '8B8950020000'
			Case $aASM = 'mov ecx,dword[edx+4]'
			   $lOpCode = '8B4A04'
			Case $aASM = 'mov ecx,dword[edx+0x1C]'
			   $lOpCode = '8B4A1C'
			Case $aASM = 'mov ecx,dword[ebx]'
			   $lOpCode = '8B0B'
			Case $aASM = 'mov ecx,dword[ebx+18]'
			   $lOpCode = '8B5918'
			Case $aASM = 'mov ecx,dword[ebx+40]'
			   $lOpCode = '8B5940'
			Case $aASM = 'mov ecx,dword[ebx+170]'
			   $lOpCode = '8B8B70010000'
			Case $aASM = 'mov ecx,dword[ebx+194]'
			   $lOpCode = '8B8B94010000'
			Case $aASM = 'mov ecx,dword[ebx+250]'
			   $lOpCode = '8B8B50020000'
			Case $aASM = 'mov ecx,dword[ebp+8]'
			   $lOpCode = '8B4D08'
			Case $aASM = 'mov ecx,dword[esp+1F4]'
			   $lOpCode = '8B8C24F4010000'
			Case $aASM = 'mov ecx,dword[edi]'
			   $lOpCode = '8B0F'
			Case $aASM = 'mov ecx,dword[edi+4]'
			   $lOpCode = '8B4F04'
			Case $aASM = 'mov ecx,dword[edi+8]'
			   $lOpCode = '8B4F08'
			Case $aASM = 'mov edx,dword[eax+4]'
			   $lOpCode = '8B5004'
			Case $aASM = 'mov edx,dword[eax+c]'
			   $lOpCode = '8B500C'
			Case $aASM = 'mov edx,dword[esi+1c]'
			   $lOpCode = '8B561C'
			Case $aASM = 'mov edx,dword[eax+8]'
			   $lOpCode = '8B5008'
			Case $aASM = 'mov edx,dword[eax+12]'
			   $lOpCode = '8B500C'
			Case $aASM = 'mov edx,0x57C'
			   $lOpCode = 'BA7C050000'
			Case $aASM = 'mov ebx,dword[eax]'
			   $lOpCode = '8B18'
			Case $aASM = 'mov ebx,dword[ecx+20]'
			   $lOpCode = '8B5920'
			Case $aASM = 'mov ebx,dword[ecx+14]'
			   $lOpCode = '8B5914'
			Case $aASM = 'mov ebx,dword[edx]'
			   $lOpCode = '8B1A'
			Case $aASM = 'mov ebx,dword[ecx+10]'
			   $lOpCode = '8B5910'
			Case $aASM = 'mov ebx,dword[ecx+18]'
			   $lOpCode = '8B5918'
			Case $aASM = 'mov ebx,dword[ecx+4c]'
			   $lOpCode = '8B594C'
			Case $aASM = 'mov esi,dword[esi]'
			   $lOpCode = '8B36'
			Case $aASM = 'mov edi,dword[edx+4]'
			   $lOpCode = '8B7A04'
			Case $aASM = 'mov ecx,dword[E1D684]'
			   $lOpCode = '8B0D84D6E100'
			Case $aASM = 'mov dword[eax],0'
			   $lOpCode = 'C70000000000'
			Case $aASM = 'mov dword[eax],ecx'
			   $lOpCode = '8908'
			Case $aASM = 'mov dword[eax+4],ecx'
			   $lOpCode = '894804'
			Case $aASM = 'mov dword[eax+8],ecx'
			   $lOpCode = '894808'
			Case $aASM = 'mov dword[eax+C],ecx'
			   $lOpCode = '89480C'
			Case $aASM = 'mov dword[eax],ebx'
			   $lOpCode = '8918'
			Case $aASM = 'mov dword[edx],0'
			   $lOpCode = 'C70200000000'
			Case $aASM = 'mov dword[edx],-1'
			   $lOpCode = 'C702FFFFFFFF'
			Case $aASM = 'mov dword[edx-0x70],ecx'
			   $lOpCode = '894A90'
			Case $aASM = 'mov dword[edx-0x14],ecx'
			   $lOpCode = '894AEC'
			Case $aASM = 'mov dword[edx+0x54],ecx'
			   $lOpCode = '894A54'
			Case $aASM = 'mov dword[edx],ebx'
			   $lOpCode = '891A'
			Case $aASM = 'mov dword[ebx],ecx'
			   $lOpCode = '890B'
			Case $aASM = 'mov dword[esp+108],ecx'
			   $lOpCode = '898C2408010000'
			Case $aASM = 'mov dword[esi+10],eax'
			   $lOpCode = '894610'
			Case $aASM = 'mov dword[edi],ecx'
			   $lOpCode = '890F'
			Case $aASM = 'mov dword[edi],esi'
			   $lOpCode = '897700'
			Case $aASM = 'mov dword[A30ADC],edx'
			   $lOpCode = '8915DC0AA300'
			Case $aASM = 'mov dword[A30AD0],edx'
			   $lOpCode = '8915D00AA300'
			Case $aASM = 'mov dword[A30AD8],edx'
			   $lOpCode = '8915D80AA300'
			Case $aASM = 'mov dword[A30AD4],edx'
			   $lOpCode = '8915D40AA300'
			Case $aASM = 'mov al,byte[ecx+4f]'
			   $lOpCode = '8A414F'
			Case $aASM = 'mov al,byte[ecx+3f]'
			   $lOpCode = '8A413F'
			Case $aASM = 'mov al,byte[ebx]'
			   $lOpCode = '8A03'
			Case $aASM = 'mov al,byte[ecx]'
			   $lOpCode = '8A01'
			Case $aASM = 'mov ah,byte[edi]'
			   $lOpCode = '8A27'
			Case $aASM = 'mov dx,word[ecx]'
			   $lOpCode = '668B11'
			Case $aASM = 'mov dx,word[edx]'
			   $lOpCode = '668B12'
			Case $aASM = 'mov word[eax],dx'
			   $lOpCode = '668910'
		 EndSelect
	  Case $lMnemonic = "cmp" ; cmp
		 Select
			; cmp ebx,dword[MaxAgents]
			Case StringRegExp($aASM, 'cmp ebx,dword\[[a-z,A-Z]{4,}\]')
			   $mASMSize += 6
			   $mASMString &= '3B1D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
			; cmp dword[DisableRendering],1
			Case StringRegExp($aASM, 'cmp dword[[][a-z,A-Z]{4,}[]],[-[:xdigit:]]')
			   $lBuffer = StringInStr($aASM, ",")
			   $lBuffer = ASMNumber(StringMid($aASM, $lBuffer + 1), True)
			   If @extended Then
				  $mASMSize += 7
				  $mASMString &= '833D[' & StringMid($aASM, 11, StringInStr($aASM, ",") - 12) & ']' & $lBuffer
			   Else
				  $mASMSize += 10
				  $mASMString &= '813D[' & StringMid($aASM, 11, StringInStr($aASM, ",") - 12) & ']' & $lBuffer
			   EndIf
			; cmp eax, TargetLogBase
			Case StringRegExp($aASM, 'cmp eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 5
			   $mASMString &= '3D[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			Case StringRegExp($aASM, 'cmp ecx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 6
			   $mASMString &= '81F9[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			Case StringRegExp($aASM, 'cmp ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 6
			   $mASMString &= '81FB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			; cmp ebx,14
			Case StringRegExp($aASM, 'cmp ebx,[-[:xdigit:]]{1,8}\z')
			   $lBuffer = ASMNumber(StringMid($aASM, 9), True)
			   If @extended Then
				  $mASMSize += 3
				  $mASMString &= '83FB' & $lBuffer
			   Else
				  $mASMSize += 6
				  $mASMString &= '81FB' & $lBuffer
			   EndIf
			; hardcoded
			Case $aASM = 'cmp eax,ecx'
			   $lOpCode = '3BC1'
			Case $aASM = 'cmp eax,ebx'
			   $lOpCode = '3BC3'
			Case $aASM = 'cmp eax,0'
			   $lOpCode = '83F800'
			Case $aASM = 'cmp eax,1'
			   $lOpCode = '83F801'
			Case $aASM = 'cmp eax,2'
			   $lOpCode = '83F802'
			Case $aASM = 'cmp eax,B'
			   $lOpCode = '83F80B'
			Case $aASM = 'cmp eax,-1'
			   $lOpCode = '83F8FF'
			Case $aASM = 'cmp eax,dword[esi+9C]'
			   $lOpCode = '3B869C000000'
			Case $aASM = 'cmp eax,200'
			   $lOpCode = '3D00020000'
			Case $aASM = 'cmp ecx,0'
			   $lOpCode = '83F900'
			Case $aASM = 'cmp ecx,4'
			   $lOpCode = '83F904'
			Case $aASM = 'cmp ecx,32'
			   $lOpCode = '83F932'
			Case $aASM = 'cmp ecx,3C'
			   $lOpCode = '83F93C'
			Case $aASM = 'cmp ecx,900000'
			   $lOpCode = '81F900009000'
			Case $aASM = 'cmp word[edx],0'
			   $lOpCode = '66833A00'
			Case $aASM = 'cmp al,ah'
			   $lOpCode = '3AC4'
			Case $aASM = 'cmp edx,esi'
			   $lOpCode = '3BD6'
			Case $aASM = 'cmp ebx,edi'
			   $lOpCode = '3BDF'
			Case $aASM = 'cmp al,f'
			   $lOpCode = '3C0F'
			Case $aASM = 'cmp cl,byte[esi+1B1]'
			   $lOpCode = '3A8EB1010000'
		 EndSelect
	  Case $lMnemonic = "lea" ; lea
		 Select
			; lea eax,dword[ecx*8+TargetLogBase]
			Case StringRegExp($aASM, 'lea eax,dword[[]ecx[*]8[+][a-z,A-Z]{4,}[]]')
			   $mASMSize += 7
			   $mASMString &= '8D04CD[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
			; lea eax,dword[ecx*4+TargetLogBase]
			Case StringRegExp($aASM, 'lea eax,dword[[]edx[*]4[+][a-z,A-Z]{4,}[]]')
			   $mASMSize += 7
			   $mASMString &= '8D0495[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
			; hardcoded
			Case $aASM = 'lea eax,dword[eax+18]'
			   $lOpCode = '8D4018'
			Case $aASM = 'lea ecx,dword[eax+4]'
			   $lOpCode = '8D4804'
			Case $aASM = 'lea ecx,dword[eax+180]'
			   $lOpCode = '8D8880010000'
			Case $aASM = 'lea edx,dword[eax+4]'
			   $lOpCode = '8D5004'
			Case $aASM = 'lea edx,dword[eax+8]'
			   $lOpCode = '8D5008'
			Case $aASM = 'lea esi,dword[esi+ebx*4]'
			   $lOpCode = '8D349E'
			Case $aASM = 'lea edi,dword[edx+ebx]'
			   $lOpCode = '8D3C1A'
			Case $aASM = 'lea edi,dword[edx+8]'
			   $lOpCode = '8D7A08'
		 EndSelect
	  Case $lMnemonic = "add" ; add
		 Select
			; add eax, TargetLogBase
			Case StringRegExp($aASM, 'add eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			   $mASMSize += 5
			   $mASMString &= '05[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
			; add eax,14
			Case StringRegExp($aASM, 'add eax,[-[:xdigit:]]{1,8}\z')
			   $lBuffer = ASMNumber(StringMid($aASM, 9), True)
			   If @extended Then
				  $mASMSize += 3
				  $mASMString &= '83C0' & $lBuffer
			   Else
				  $mASMSize += 5
				  $mASMString &= '05' & $lBuffer
			   EndIf
			Case StringRegExp($aASM, 'add ecx,[-[:xdigit:]]{1,8}\z')
			   $lBuffer = ASMNumber(StringMid($aASM, 9), True)
			   If @extended Then
				  $mASMSize += 3
				  $mASMString &= '83C1' & $lBuffer
			   Else
				  $mASMSize += 6
				  $mASMString &= '81C1' & $lBuffer
			   EndIf
			Case StringRegExp($aASM, 'add edx,[-[:xdigit:]]{1,8}\z')
			   $lBuffer = ASMNumber(StringMid($aASM, 9), True)
			   If @extended Then
				  $mASMSize += 3
				  $mASMString &= '83C2' & $lBuffer
			   Else
				  $mASMSize += 6
				  $mASMString &= '81C2' & $lBuffer
			   EndIf
			Case StringRegExp($aASM, 'add ebx,[-[:xdigit:]]{1,8}\z')
			   $lBuffer = ASMNumber(StringMid($aASM, 9), True)
			   If @extended Then
				  $mASMSize += 3
				  $mASMString &= '83C3' & $lBuffer
			   Else
				  $mASMSize += 6
				  $mASMString &= '81C3' & $lBuffer
			   EndIf
			Case StringRegExp($aASM, 'add edi,[-[:xdigit:]]{1,8}\z')
			   $lBuffer = ASMNumber(StringMid($aASM, 9), True)
			   If @extended Then
				  $mASMSize += 3
				  $mASMString &= '83C7' & $lBuffer
			   Else
				  $mASMSize += 6
				  $mASMString &= '81C7' & $lBuffer
			   EndIf
		 EndSelect
	  Case $lMnemonic = "fstp" ; fstp
		 ; fstp dword[EnsureEnglish]
		 If StringRegExp($aASM, 'fstp dword[[][a-z,A-Z]{4,}[]]') Then
			$mASMSize += 6
			$mASMString &= 'D91D[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
		 EndIf
	  Case $lMnemonic = "push" ; push
		 Select
			; push  dword[EnsureEnglish]
			Case StringRegExp($aASM, 'push dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 6
			   $mASMString &= 'FF35[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
			; push CallbackEvent
			Case StringRegExp($aASM, 'push [a-z,A-Z]{4,}\z')
			   $mASMSize += 5
			   $mASMString &= '68[' & StringMid($aASM, 6, StringLen($aASM) - 5) & ']'
			; push 14
			Case StringRegExp($aASM, 'push [-[:xdigit:]]{1,8}\z')
			   $lBuffer = ASMNumber(StringMid($aASM, 6), True)
			   If @extended Then
				  $mASMSize += 2
				  $mASMString &= '6A' & $lBuffer
			   Else
				  $mASMSize += 5
				  $mASMString &= '68' & $lBuffer
			   EndIf
			; hardcoded
			Case $aASM = 'push eax'
			   $lOpCode = '50'
			Case $aASM = 'push ecx'
			   $lOpCode = '51'
			Case $aASM = 'push edx'
			   $lOpCode = '52'
			Case $aASM = 'push ebx'
			   $lOpCode = '53'
			Case $aASM = 'push ebp'
			   $lOpCode = '55'
			Case $aASM = 'push esi'
			   $lOpCode = '56'
			Case $aASM = 'push edi'
			   $lOpCode = '57'
			Case $aASM = 'push dword[eax+4]'
			   $lOpCode = 'FF7004'
			Case $aASM = 'push dword[eax+8]'
				  $lOpCode = 'FF7008'
			Case $aASM = 'push dword[eax+c]'
			   $lOpCode = 'FF700C'
		 EndSelect
	  Case $lMnemonic = "pop" ; pop
		 ; hardcoded
		 Select
			Case $aASM = 'pop eax'
			   $lOpCode = '58'
			Case $aASM = 'pop ebx'
			   $lOpCode = '5B'
			Case $aASM = 'pop edx'
			   $lOpCode = '5A'
			Case $aASM = 'pop ecx'
			   $lOpCode = '59'
			Case $aASM = 'pop esi'
			   $lOpCode = '5E'
			Case $aASM = 'pop edi'
			   $lOpCode = '5F'
			Case $aASM = 'pop ebp'
			   $lOpCode = '5D'
		 EndSelect
	  Case $lMnemonic = "call" ; call
		 Select
			; call dword[EnsureEnglish]
			Case StringRegExp($aASM, 'call dword[[][a-z,A-Z]{4,}[]]')
			   $mASMSize += 6
			   $mASMString &= 'FF15[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
			; call ActionFunction
			Case StringLeft($aASM, 5) = 'call ' And StringLen($aASM) > 8
			   $mASMSize += 5
			   $mASMString &= 'E8{' & StringMid($aASM, 6, StringLen($aASM) - 5) & '}'
		 EndSelect
	  Case $lMnemonic = "test"
		 Switch $aAsm
			Case $aASM = 'test eax,eax'
			   $lOpCode = '85C0'
			Case $aASM = 'test ecx,ecx'
			   $lOpCode = '85C9'
			Case $aASM = 'test ebx,ebx'
			   $lOpCode = '85DB'
			Case $aASM = 'test esi,esi'
			   $lOpCode = '85F6'
			Case $aASM = 'test dx,dx'
			   $lOpCode = '6685D2'
			Case $aASM = 'test al,al'
			   $lOpCode = '84C0'
			Case $aASM = 'test al,1'
			   $lOpCode = 'A801'
		 EndSwitch
	  Case $lMnemonic = "inc"
		 Switch $aAsm
			Case $aASM = 'inc eax'
			   $lOpCode = '40'
			Case $aASM = 'inc ecx'
			   $lOpCode = '41'
			Case $aASM = 'inc edx'
			   $lOpCode = '42'
			Case $aASM = 'inc ebx'
			   $lOpCode = '43'
		 EndSwitch
	  Case $lMnemonic = "dec"
		 Switch $aAsm
			Case $aASM = 'dec edx'
			   $lOpCode = '4A'
		 EndSwitch
	  Case $lMnemonic = "xor"
		 Switch $aAsm
			Case $aASM = 'xor eax,eax'
			   $lOpCode = '33C0'
			Case $aASM = 'xor ecx,ecx'
			   $lOpCode = '33C9'
			Case $aASM = 'xor edx,edx'
			   $lOpCode = '33D2'
			Case $aASM = 'xor ebx,ebx'
			   $lOpCode = '33DB'
		 EndSwitch
	  Case $lMnemonic = "sub"
		 Switch $aAsm
			Case $aASM = 'sub esp,8'
			   $lOpCode = '83EC08'
			Case $aASM = 'sub esp,14'
			   $lOpCode = '83EC14'
		 EndSwitch
	  Case $lMnemonic = "shl"
		 Switch $aAsm
			Case $aASM = 'shl eax,4'
			   $lOpCode = 'C1E004'
			Case $aASM = 'shl eax,6'
			   $lOpCode = 'C1E006'
			Case $aASM = 'shl eax,7'
			   $lOpCode = 'C1E007'
			Case $aASM = 'shl eax,8'
			   $lOpCode = 'C1E008'
			Case $aASM = 'shl eax,8'
			   $lOpCode = 'C1E008'
			Case $aASM = 'shl eax,9'
			   $lOpCode = 'C1E009'
		 EndSwitch
	  Case $lMnemonic = "retn"
		 If $aASM = 'retn 10' Then $lOpCode = 'C21000'
	  Case $aASM = 'repe movsb'
		 $lOpCode = 'F3A4'
	  Case Else
		 MsgBox(0, 'ASM', 'Could not assemble: ' & $aASM)
		 Exit
   EndSelect
   If $lOpCode <> '' Then
	  $mASMSize += 0.5 * StringLen($lOpCode)
	  $mASMString &= $lOpCode
   EndIf
EndFunc   ;==>_

;~ Description: Completes formatting of ASM code. Internal use only.
Func CompleteASMCode()
   Local $lInExpression = False
   Local $lExpression
   Local $lTempASM = $mASMString
   Local $lCurrentOffset = Dec(Hex($mMemory)) + $mASMCodeOffset
   Local $lToken
   For $i In $mLabelDict.Keys
	  If StringLeft($i, 6) = 'Label_' Then
		 $mLabelDict.Item($i) = "0x" & Hex(Int($mMemory + $mLabelDict.Item($i)),8)
		 $mLabelDict.Key($i) = StringTrimLeft($i, 6)
	  EndIf
   Next
   $mASMString = ''
   For $i = 1 To StringLen($lTempASM)
	  $lToken = StringMid($lTempASM, $i, 1)
	  Switch $lToken
		 Case '(', '[', '{'
			$lInExpression = True
		 Case ')'
			$mASMString &= Hex(GetLabelInfo($lExpression) - Int($lCurrentOffset) - 1, 2)
			$lCurrentOffset += 1
			$lInExpression = False
			$lExpression = ''
		 Case ']'
			$mASMString &= SwapEndian(Hex(GetLabelInfo($lExpression), 8))
			$lCurrentOffset += 4
			$lInExpression = False
			$lExpression = ''
		 Case '}'
			$mASMString &= SwapEndian(Hex(GetLabelInfo($lExpression) - Int($lCurrentOffset) - 4, 8))
			$lCurrentOffset += 4
			$lInExpression = False
			$lExpression = ''
		 Case Else
			If $lInExpression Then
			   $lExpression &= $lToken
			Else
			   $mASMString &= $lToken
			   $lCurrentOffset += 0.5
			EndIf
	  EndSwitch
   Next
EndFunc   ;==>CompleteASMCode

;~ Description: Returns GetValue($aLabel) and exits, if label cant be found.
Func GetLabelInfo($aLabel)
   Local $lValue = GetValue($aLabel)
   If $lValue = -1 Then Exit MsgBox(0, 'Label', 'Label: ' & $aLabel & ' not provided')
   Return $lValue
EndFunc   ;==>GetLabelInfo

;~ Description: Converts hexadecimal ASM to decimal.
Func ASMNumber($aNumber, $aSmall = False)
   If $aNumber >= 0 Then
	  $aNumber = Dec($aNumber)
   EndIf
   If $aSmall And $aNumber <= 127 And $aNumber >= -128 Then
	  Return SetExtended(1, Hex($aNumber, 2))
   Else
	  Return SetExtended(0, SwapEndian(Hex($aNumber, 8)))
   EndIf
EndFunc   ;==>ASMNumber
#EndRegion Assembler

#Region Conversion
;~ Description: Converts float to integer.
Func FloatToInt($nFloat)
   Local $tFloat = DllStructCreate("float")
   Local $tInt = DllStructCreate("int", DllStructGetPtr($tFloat))
   DllStructSetData($tFloat, 1, $nFloat)
   Return DllStructGetData($tInt, 1)
EndFunc   ;==>FloatToInt
#EndRegion

#Region Misc
;~ Description: Prepares data to be used to call Guild War's packet send function.
Func SendPacket($aSize, $aHeader, $aParam1 = 0, $aParam2 = 0, $aParam3 = 0, $aParam4 = 0, $aParam5 = 0, $aParam6 = 0, $aParam7 = 0, $aParam8 = 0, $aParam9 = 0, $aParam10 = 0)
   If GetAgentExists(-2) Then
	  DllStructSetData($mPacket, 2, $aSize)
	  DllStructSetData($mPacket, 3, $aHeader)
	  DllStructSetData($mPacket, 4, $aParam1)
	  DllStructSetData($mPacket, 5, $aParam2)
	  DllStructSetData($mPacket, 6, $aParam3)
	  DllStructSetData($mPacket, 7, $aParam4)
	  DllStructSetData($mPacket, 8, $aParam5)
	  DllStructSetData($mPacket, 9, $aParam6)
	  DllStructSetData($mPacket, 10, $aParam7)
	  DllStructSetData($mPacket, 11, $aParam8)
	  DllStructSetData($mPacket, 12, $aParam9)
	  DllStructSetData($mPacket, 13, $aParam10)
	  Enqueue($mPacketPtr, 52)
	  Return True
   Else
	  Return False
   EndIf
EndFunc   ;==>SendPacket

;~ Description: Call CommandAction.
Func PerformAction($aAction, $aFlag)
   If GetAgentExists(-2) Then
	  DllStructSetData($mAction, 2, $aAction)
	  DllStructSetData($mAction, 3, $aFlag)
	  Enqueue($mActionPtr, 12)
	  Return True
   Else
	  Return False
   EndIf
EndFunc   ;==>PerformAction

;~ Description: Returns current ping.
Func GetPing()
   Return MemoryRead($mPing)
EndFunc   ;==>GetPing

;~ Description: Internal use for travel functions. Returns Language.
Func GetLanguage()
   Return MemoryRead($mLanguage)
EndFunc   ;==>GetLanguage

;~ Description: Get name of currently logged in character.
Func GetCharname()
   Return MemoryRead($mCharname, 'wchar[30]')
EndFunc   ;==>GetCharname

;~ Description: Returns logged in or not.
Func GetLoggedIn()
   Return MemoryRead($mLoggedIn)
EndFunc   ;==>GetLoggedIn

;~ Description: Returns currently used language as number, same as GetLanguage().
Func GetDisplayLanguage()
   Local $lOffset[6] = [0, 0x18, 0x18, 0x194, 0x4C, 0x40]
   Local $lResult = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lResult[1]
EndFunc   ;==>GetDisplayLanguage

;~ Description: Amount of time the current instance has been active.
Func GetInstanceUpTime()
   Local $lOffset[4] = [0, 0x18, 0x8, 0x1AC]
   Local $lTimer = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lTimer[1]
EndFunc   ;==>GetInstanceUpTime

;~ Description: Returns the game client's build number.
Func GetBuildNumber()
   Return $mBuildNumber
EndFunc   ;==>GetBuildNumber

;~ Description: Sleep a random amount of time.
Func RndSleep($aAmount, $aRandom = 0.05)
   Local $lRandom = $aAmount * $aRandom
   Sleep(Random($aAmount - $lRandom, $aAmount + $lRandom))
EndFunc   ;==>RndSleep

;~ Description: Sleep a period of time, plus or minus a tolerance
Func TolSleep($aAmount = 150, $aTolerance = 50)
   Sleep(Random($aAmount - $aTolerance, $aAmount + $aTolerance))
EndFunc   ;==>TolSleep

;~ Description: Sleeps time plus your ping.
Func PingSleep($Time = 1000)
   Sleep(GetPing() + $Time)
EndFunc   ;==>PingSleep

;~ Description: Window Handle to game client, variable set during initialize.
Func GetWindowHandle()
   Return $mGWHwnd
EndFunc   ;==>GetWindowHandle

;~ Description: Computes distance between two sets of coordinates.
Func ComputeDistance($aX1, $aY1, $aX2, $aY2)
   Return Sqrt(($aX1 - $aX2) ^ 2 + ($aY1 - $aY2) ^ 2)
EndFunc   ;==>ComputeDistance

;~ Description: Opens merchant window, merchant has to be in target.
Func OpenMerchantWindow()
   Local $ID = StorageSessionID()
   DllStructSetData($mOpenMerchant, 2, $ID)
   DllStructSetData($mOpenMerchant, 3, 128)
   DllStructSetData($mOpenMerchant, 4, 0)
   DllStructSetData($mOpenMerchant, 5, 0)
   Enqueue($mOpenMerchantPtr, 20)
EndFunc   ;==>OpenMerchantWindow

;~ Description: Opens storage window, only in outpost its possible to change content of chest.
Func OpenStorageWindow()
   Local $ID = StorageSessionID()
   DllStructSetData($mOpenStorage, 2, $ID)
   DllStructSetData($mOpenStorage, 3, 0)
   DllStructSetData($mOpenStorage, 4, 1)
   Enqueue($mOpenStoragePtr, 16)
EndFunc   ;==>OpenStorageWindow

;~ Description: Gets current storage session ID.
Func StorageSessionID()
   Local $lOffset[3] = [0x118, 0x10, 0]
   $lReturn = MemoryReadPtr($mStorageSessionBase, $lOffset)
   Return MemoryRead($lReturn[1] + 0x14)
EndFunc   ;==>StorageSessionID

;~ Description: Checks if game client got disconnected and attempts to reconnect.
Func Disconnected()
   ControlSend(GetWindowHandle(), "", "", "{Enter}")
   Local $lCheck = False
   Local $lDeadlock = TimerInit()
   Do
	  Sleep(20)
	  $lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
   Until $lCheck Or TimerDiff($lDeadlock) > 60000
   If $lCheck = False Then
	  ControlSend(GetWindowHandle(), "", "", "{Enter}")
	  $lDeadlock = TimerInit()
	  Do
		 Sleep(20)
		 $lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
	  Until $lCheck Or TimerDiff($lDeadlock) > 60000
	  If $lCheck = False Then
		 Exit 1
	  EndIf
   EndIf
   Sleep(5000)
EndFunc   ;==>Disconnected
#EndRegion