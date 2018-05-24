#include <../辅助文件1/界面框.au3>
#include <../辅助文件2/激战常数.au3>
#include <../../激战接口.au3>
#include <../辅助文件2/Queue.au3>


; Gui Variables
Local $matsInput, $matsCombo, $matsBuyButton
Local $consInput, $consLabel, $consBuyButton
Local $scrollsInput, $scrollsLabel, $scrollsBuyButton
Local $pstonesInput, $pstonesLabel, $pstonesBuyButton
Local $logLabel, $priceCheckButton, $helpButton, $cancelButton

; Price check variables
Local $matsTimer = TimerInit(), $matsRequested = False
Local $lLastTraderCostID = 0

Local Enum $MAT_IRON = 0, $MAT_DUST, $MAT_BONES, $MAT_FEATHERS, $MAT_FIBERS, $MAT_GRANITE
Global $matCost[6]
For $i = 0 To 5
	$matCost[$i] = 0
Next
Global $matModelID[6]
$matModelID[$MAT_IRON] = $MODELID_IRON
$matModelID[$MAT_DUST] = $MODELID_DUST
$matModelID[$MAT_BONES] = $MODELID_BONES
$matModelID[$MAT_FEATHERS] = $MODELID_FEATHERS
$matModelID[$MAT_FIBERS] = $MODELID_FIBERS
$matModelID[$MAT_GRANITE] = $MODELID_GRANITE

; Action queue variables
Local Enum $ACTION_BUY, $ACTION_BUY_ID, $ACTION_PRICECHECK
Local $queue = Queue()

Func materialsBuildUI()
	Local $y = 5
	Local $labelX = 25
	Local $inputX = 35
	Local $comboX = 70
	Local $buttonX = 230
	GUICtrlCreateGroup("自购", 10, $y, 280, 50)
	GUICtrlSetFont(-1, 9)
	GUICtrlCreateLabel("#", $labelX, $y+23)
	$matsInput = GUICtrlCreateInput("1", $inputX, $y+20, 30, 20, BitOR($ES_NUMBER, $ES_RIGHT))
	GUICtrlSetColor(-1, $COLOR_BLACK)
	$matsCombo = GUICtrlCreateCombo("", $comboX, $y+19, 150, 24, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
	GUICtrlSetBkColor(-1, $COLOR_BLACK)
	Local $lMatsString = ""
	For $i=1 To $MATS_NAME[0]
		$lMatsString = $lMatsString & "|" & $MATS_NAME[$i]
	Next
	GUICtrlSetData(-1, $lMatsString)
	$matsBuyButton = MyGuiCtrlCreateButton("买", $buttonX, $y+20, 50, 20)
	GUICtrlSetOnEvent(-1, "matsEventHandler")

	$y+=52
	GUICtrlCreateGroup("药", 10, $y, 280, 50)
	GUICtrlSetFont(-1, 9)
	GUICtrlCreateLabel("#", $labelX, $y+23)
	$consInput = GUICtrlCreateInput("1", $inputX, $y+20, 30, 20, BitOR($ES_NUMBER, $ES_RIGHT))
	GUICtrlSetColor(-1, $COLOR_BLACK)
	$consLabel = GUICtrlCreateLabel("-", $comboX, $y+23, 150, 20, $SS_CENTER)
	$consBuyButton = MyGuiCtrlCreateButton("买材料", $buttonX, $y+20, 50, 20)
	GUICtrlSetOnEvent(-1, "matsEventHandler")

	$y+=52
	GUICtrlCreateGroup("复活卷", 10, $y, 280, 50)
	GUICtrlSetFont(-1, 9)
	GUICtrlCreateLabel("#", $labelX, $y+23)
	$scrollsInput = GUICtrlCreateInput("1", $inputX, $y+20, 30, 20, BitOR($ES_NUMBER, $ES_RIGHT))
	GUICtrlSetColor(-1, $COLOR_BLACK)
	$scrollsLabel = GUICtrlCreateLabel("-", $comboX, $y+23, 150, 20, $SS_CENTER)
	$scrollsBuyButton = MyGuiCtrlCreateButton("买材料", $buttonX, $y+20, 50, 20)
	GUICtrlSetOnEvent(-1, "matsEventHandler")

	$y+=52
	GUICtrlCreateGroup("粉石", 10, $y, 280, 50)
	GUICtrlSetFont(-1, 9)
	GUICtrlCreateLabel("#", $labelX, $y+23)
	$pstonesInput = GUICtrlCreateInput("1", $inputX, $y+20, 30, 20, BitOR($ES_NUMBER, $ES_RIGHT))
	GUICtrlSetColor(-1, $COLOR_BLACK)
	$pstonesLabel = GUICtrlCreateLabel("-", $comboX, $y+23, 150, 20, $SS_CENTER)
	$pstonesBuyButton = MyGuiCtrlCreateButton("买材料", $buttonX, $y+20, 50, 20)
	GUICtrlSetOnEvent(-1, "matsEventHandler")

	$y+=52
	$logLabel = GUICtrlCreateLabel("准备就绪", $labelX, $y+5, 160, 20)
	$y += 30
	$helpButton = MyGuiCtrlCreateButton("说明", 10, $y, 90, 25)
	GUICtrlSetOnEvent($helpButton, "helpMaterialsBuyer")
	GUICtrlSetTip($helpButton, "击此展开说明")

	$priceCheckButton = MyGuiCtrlCreateButton("估价", 105, $y, 90, 25)
	GUICtrlSetOnEvent(-1, "matsEventHandler")

	$cancelButton = MyGuiCtrlCreateButton("取消", 200, $y, 90, 25)
	GUICtrlSetOnEvent(-1, "matsEventHandler")
EndFunc


Func helpMaterialsBuyer()
	Local $lTitle = "材料购买器说明"
	Local $lText = 	@CRLF & "使用材料购买器前需先点击材料商人， 此后可关闭买卖窗口" _
	& @CRLF & @CRLF & @CRLF &"购买器工作时若与他人交易，将导致工具暂停，换图后才可重新启动" _
	& @CRLF & @CRLF & @CRLF &"避免在购买器估价时移动， 否则无法估价" _
	& @CRLF & @CRLF & @CRLF &"不需等待估价结束就可开始购买， 但这将中断未完成的估价" _
	& @CRLF & @CRLF & @CRLF &"单位: 购买次数. 例: 如需50羽毛，则应输入5; 如需1组药，则应输入1"
	MyGuiMsgBox(0, $lTitle, $lText, $mainGui, 500, 360, True)
EndFunc

Func materialsMainLoop()
	If (Not Queue_IsEmpty($queue)) And TimerDiff($matsTimer) > 500 Then
		Local $error = False
		Local $data = Queue_Peek($queue)
		Local $lAction = $data[0]
		Local $lMatID = $data[1]
		Local $lMatModelID = $lAction == $ACTION_BUY_ID ? $data[1] : $matModelID[$data[1]]

		GUICtrlSetData($logLabel, "正在计算... " & (Queue_Count($queue) * 2 + ($matsRequested ? -1 : 0)))

		If Not $matsRequested Then
			Local $lRet = TraderRequest($lMatModelID)
			If Not $lRet Then ; if error notify user and clear queue
				GUICtrlSetData($logLabel, "估价失败")
				$error = True
			Else ; everything is fine, mats were requested
				$matsRequested = True
			EndIf
		Else
			If $lAction == $ACTION_PRICECHECK Then
				Local $lTraderCostValue = GetTraderCostValue()
				Local $lTraderCostID = GetTraderCostID()
				If $lTraderCostID == 0 Or $lTraderCostValue == 0 Or $lTraderCostID == $lLastTraderCostID Then
					GUICtrlSetData($logLabel, "费用计算失败")
					$error = True
				Else
					$lLastTraderCostID = $lTraderCostID

					$matCost[$lMatID] = $lTraderCostValue

					If $matCost[$MAT_DUST] > 0 And $matCost[$MAT_IRON] > 0 And $matCost[$MAT_BONES] > 0 And $matCost[$MAT_FEATHERS] > 0 Then
						GUICtrlSetData($consLabel, "费用: " & ($matCost[$MAT_DUST]*10 + $matCost[$MAT_IRON]*10 + $matCost[$MAT_BONES]*5 + $matCost[$MAT_FEATHERS]*5 + 750) / 1000 & " k")
					Else
						GUICtrlSetData($consLabel, "-")
					EndIf

					If $matCost[$MAT_FIBERS] > 0 And $matCost[$MAT_BONES] > 0 Then
						GUICtrlSetData($scrollsLabel, "费用: " & ($matCost[$MAT_FIBERS] * 2.5 + $matCost[$MAT_BONES] * 2.5 + 250) / 1000 & " k")
					Else
						GUICtrlSetData($scrollsLabel, "-")
					EndIf

					If $matCost[$MAT_GRANITE] > 0 And $matCost[$MAT_DUST] > 0 Then
						GUICtrlSetData($pstonesLabel, "费用: " & ($matCost[$MAT_GRANITE] * 10 + $matCost[$MAT_DUST] * 10 + 1000) / 1000 & " k")
					Else
						GUICtrlSetData($pstonesLabel, "-")
					EndIf

					Queue_Dequeue($queue)
				EndIf

			ElseIf $lAction == $ACTION_BUY Or $lAction == $ACTION_BUY_ID Then
				If GetGoldCharacter() < GetTraderCostValue() Then ; check if we have enough money
					GUICtrlSetData($logLabel, "购买失败: 资金不足")
					$error = True
				Else ; go buy
					If Not TraderBuy() Then
						GUICtrlSetData($logLabel, "购买失败")
						$error = True
					Else
						Queue_Dequeue($queue)
					EndIf
				EndIf
			EndIf

			$matsRequested = False
		EndIf

		$matsTimer = TimerInit()
		If $error Then
			$matsRequested = False
			Queue_Clear($queue)
		Else
			If Queue_IsEmpty($queue) Then
				GUICtrlSetData($logLabel, "操作完毕")
				$matsRequested = False
			EndIf
		EndIf
	EndIf
EndFunc


Func matsEventHandler()
	Switch @GUI_CtrlId
		Case $matsBuyButton
			Local $lMatID = getMatIDByName(GUICtrlRead($matsCombo))
			Local $lMatQuantity = Int(GUICtrlRead($matsInput))
			If $lMatQuantity <= 0 Then Return GUICtrlSetData($logLabel, "输入正数!")
			If $lMatID == -1 Then Return GUICtrlSetData($logLabel, "选材料!")
			Local $data[2] = [$ACTION_BUY_ID, $lMatID]
			For $j = 1 To $lMatQuantity
				Queue_Enqueue($queue, $data)
			Next

		Case $consBuyButton
			Local $lMatQuantity = Int(GUICtrlRead($consInput))
			If $lMatQuantity <= 0 Then Return GUICtrlSetData($logLabel, "输入正数!")
			Local $data1[2] = [$ACTION_BUY, $MAT_IRON]
			Local $data2[2] = [$ACTION_BUY, $MAT_DUST]
			Local $data3[2] = [$ACTION_BUY, $MAT_BONES]
			Local $data4[2] = [$ACTION_BUY, $MAT_FEATHERS]
			For $i=1 To $lMatQuantity ; for each cons
				For $j = 1 To 10
					Queue_Enqueue($queue, $data1)
					Queue_Enqueue($queue, $data2)
				Next
				For $j = 1 To 5
					Queue_Enqueue($queue, $data3)
					Queue_Enqueue($queue, $data4)
				Next
			Next

		Case $scrollsBuyButton
			Local $lMatQuantity = Int(GUICtrlRead($scrollsInput))
			If $lMatQuantity <= 0 Then Return GUICtrlSetData($logLabel, "输入正数!")
			Local $data1[2] = [$ACTION_BUY, $MAT_FIBERS]
			Local $data2[2] = [$ACTION_BUY, $MAT_BONES]
			Local $data3[2] = [$ACTION_BUY, $MAT_FIBERS]
			Local $data4[2] = [$ACTION_BUY, $MAT_BONES]
			For $i=1 To $lMatQuantity ; for each scroll
				If Mod($i, 2) == 1 Then
					For $j = 1 To 3
						Queue_Enqueue($queue, $data1)
						Queue_Enqueue($queue, $data2)
					Next
				Else
					For $j = 1 To 2
						Queue_Enqueue($queue, $data3)
						Queue_Enqueue($queue, $data4)
					Next
				EndIf
			Next

		Case $pstonesBuyButton
			Local $lMatQuantity = Int(GUICtrlRead($pstonesInput))
			If $lMatQuantity <= 0 Then Return GUICtrlSetData($logLabel, "输入正数!")
			Local $data1[2] = [$ACTION_BUY, $MAT_GRANITE]
			Local $data2[2] = [$ACTION_BUY, $MAT_DUST]
			For $i=1 To $lMatQuantity ; for each pstone
				For $j = 1 To 10
					Queue_Enqueue($queue, $data1)
					Queue_Enqueue($queue, $data2)
				Next
			Next

		Case $priceCheckButton
			GUICtrlSetData($logLabel, "查价...")
			Local $data[2] = [$ACTION_PRICECHECK, 0]
			For $i = 0 To 5
				$data[1] = $i
				Queue_Enqueue($queue, $data)
			Next

		Case $cancelButton
			If Not Queue_IsEmpty($queue) Then GUICtrlSetData($logLabel, "已取消操作")
			Queue_Clear($queue)
	EndSwitch
EndFunc

Func getMatIDByName($lMatName)
	For $i=1 To $MATS_NAME[0]
		If $lMatName == $MATS_NAME[$i] Then
			Return $MATS_ID[$i]
		EndIf
	Next
	Return -1
EndFunc
