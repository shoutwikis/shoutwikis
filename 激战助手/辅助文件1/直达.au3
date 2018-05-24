#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <../../激战接口.au3>
#include <../辅助文件2/激战常数.au3>
#include <../辅助文件1/界面框.au3>


Func fastTravelBuildUI()
	Local Const $travelX = 10
	Local Const $travelY = 10
	Local $x = $travelX
	Local $y = $travelY
	Local $buttonWidth = 80
	Global Const $travelDistrict = 	GUICtrlCreateCombo("本区", $travelX, 	$travelY, 175, 25, $CBS_DROPDOWNLIST)
	;GUICtrlSetData($travelDistrict, "International|American|American District 1|Europe English|Europe French|Europe German|Europe Italian|Europe Spanish|Europe Polish|Europe Russian|Asian Korean|Asia Chinese|Asia Japanese")
	GUICtrlSetData($travelDistrict, "亚洲-中|国际区|美洲-英|亚洲-朝|亚洲-日|欧洲-英|欧洲-法|欧洲-德|欧洲-意|欧洲-西|欧洲-波|欧洲-俄")
	GUICtrlSetBkColor($travelDistrict, $COLOR_BLACK)

	$x = $travelX
	$y += 45
	Global Const $travelToA = 		MyGuiCtrlCreateButton("世纪", 		$x+5, 	$y,  $buttonWidth, 25)
	Global Const $travelDoA = 		MyGuiCtrlCreateButton("四门", 		$x+90,	$y,  $buttonWidth, 25)
	$y += 30
	Global Const $travelKamadan = 	MyGuiCtrlCreateButton("卡玛丹", 	$x+5, 	$y,  $buttonWidth, 25)
	Global Const $travelEmbark = 	MyGuiCtrlCreateButton("登陆滩", 	$x+90,	$y,  $buttonWidth, 25)
	$y += 30
	Global Const $travelVlox = 		MyGuiCtrlCreateButton("瀑布", 	$x+5, $y,  $buttonWidth, 25)
	Global Const $travelEOTN = 		MyGuiCtrlCreateButton("北方之眼", 		$x+90, $y,  $buttonWidth, 25)
	$y += 30
	Global Const $travelUrgoz = 	MyGuiCtrlCreateButton("尔果", 		$x+5, $y, $buttonWidth, 25)
	Global Const $travelDeep = 		MyGuiCtrlCreateButton("深渊", 		$x+90, $y, $buttonWidth, 25)

	GUICtrlSetOnEvent($travelToA, "fastTravel")
	GUICtrlSetOnEvent($travelDoA, "fastTravel")
	GUICtrlSetOnEvent($travelEmbark, "fastTravel")
	GUICtrlSetOnEvent($travelKamadan, "fastTravel")
	GUICtrlSetOnEvent($travelVlox, "fastTravel")
	GUICtrlSetOnEvent($travelEOTN, "fasttravel")
	GUICtrlSetOnEvent($travelUrgoz, "fastTravel")
	GUICtrlSetOnEvent($travelDeep, "fastTravel")

	$y += 45
	Local $lDestnations = ""
	For $i=1 To $MAP_ID[0]
		If IsString($MAP_ID[$i]) And $MAP_ID[$i] <> "" Then
			$lDestnations = $lDestnations & "|"&$MAP_ID[$i]
		EndIf
	Next
	Global Const $travelDestination = GUICtrlCreateCombo("选择目的地", $travelX, $y, 175, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
	GUICtrlSetData(-1, $lDestnations)
	GUICtrlSetBkColor(-1, $COLOR_BLACK)
	$y += 29
	Global Const $travelButton = MyGuiCtrlCreateButton("前往", 75, $y, 110, 25)
	GUICtrlSetOnEvent($travelButton, "fastTravel")
EndFunc


Func fastTravel()
	Local $lMapId = 0
	Local $lDistrict
	Local $lDistrictNo = 0
	Local $lRegion[12] = 	[-2, 0, 2, 2, 2, 2, 2, 2,  2, 1, 3, 4]
	Local $lLanguage[12] = 	[0,  0, 0, 2, 3, 4, 5, 9, 10, 0, 0, 0]
	Local $lGuiDistrict = GUICtrlRead($travelDistrict)
	Switch @GUI_CtrlId
		Case $travelDoA
			$lMapId = $MAP_ID_DOA
		Case $travelEmbark
			$lMapId = $MAP_ID_EMBARK
		Case $travelKamadan
			$lMapId = $MAP_ID_KAMADAN
		Case $travelToA
			$lMapId = $MAP_ID_TOA
		Case $travelVlox
			$lMapId = $MAP_ID_VLOX
		Case $travelEOTN
			$lMapId = $MAP_ID_EOTN
		Case $travelUrgoz
			$lMapId = $MAP_ID_URGOZ
		Case $travelDeep
			$lMapId = $MAP_ID_DEEP
		Case $travelButton
			Local $lDestination = GUICtrlRead($travelDestination)
			For $i=1 To $MAP_ID[0]
				If $MAP_ID[$i] == $lDestination Then
					$lMapId = $i
					ExitLoop
				EndIf
			Next
	EndSwitch
	If $lGuiDistrict == "本区" Then
		If getMapID() == $lMapId Then Return
		MoveMap($lMapId, GetRegion(), 0, GetLanguage())
		Return
	Else
		Switch $lGuiDistrict
			Case "国际区"
				$lDistrict = 0
			Case "美洲-英"
				$lDistrict = 1
			;Case "American District 1"
			;	$lDistrict = 1
			;	$lDistrictNo = 1
			Case "欧洲-英"
				$lDistrict = 2
			Case "欧洲-法"
				$lDistrict = 3
			Case "欧洲-德"
				$lDistrict = 4
			Case "欧洲-意"
				$lDistrict = 5
			Case "欧洲-西"
				$lDistrict = 6
			Case "欧洲-波"
				$lDistrict = 7
			Case "欧洲-俄"
				$lDistrict = 8
			Case "亚洲-朝"
				$lDistrict = 9
			Case "亚洲-中"
				$lDistrict = 10
			Case "亚洲-日"
				$lDistrict = 11
		EndSwitch
		If (getMapID()==$lMapId) And (getRegion()==$lRegion[$lDistrict]) And (getLanguage()==$lLanguage[$lDistrict]) Then Return
		MoveMap($lMapId, $lRegion[$lDistrict], $lDistrictNo, $lLanguage[$lDistrict])
	EndIf
EndFunc