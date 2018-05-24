#include-once
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#include <File.au3>
#include <WinAPI.au3>

;GetEffectsPtr vs GetEffects: no longer returns simply a struct, always an array

Local $fileNames=_FileListToArray(@ScriptDir, "*.au3")
for $i=1 to $fileNames[0]

	;==> 如需更新下行中的文件，擦掉以下与其对应的部分 <==

	if $fileNames[$i] = "gwa2.au3" or $fileNames[$i] = "gwApi.au3" or $fileNames[$i] = "Convert2Ptr.au3" or _
	   $fileNames[$i] = "底层.au3" or $fileNames[$i] = "接口.au3" or $fileNames[$i] = "换版.au3" then continueloop

	Local $hFileOpen = FileOpen($fileNames[$i], 128)

	Local $dFileOpen=FileOpen("底层-接口-新版/"&$fileNames[$i], 138)

	Local $readLine = FileReadLine($hFileOpen)

	while @error <> -1

		if $readLine = "" then
			FileWriteLine($dFileOpen, "")
		Else
			FileWriteLine($dFileOpen, Convert($readLine))
		EndIf

		$readLine = FileReadLine($hFileOpen)

	Wend

	FileClose($hFileOpen)
	FileClose($dFileOpen)
Next

msgbox(0,"提示", "换版完毕")

Func Convert($lData)

	Local $original = $lData

	Local $tempRegex = "^(?i)\h*?#include\h*?('|"&'"'&")(底层.au3|\.\.\\底层.au3)('|"&'")'
	$lData = StringRegExpReplace($lData, $tempRegex,'#include "..\\接口.au3"')

	;If there's no need to update SendPacket, comment out the region below
	#Region Updates individual SendPacket calls while leaving its function definition alone

		$tempRegex = "(?i)SendPacket\(.*?,(.*?)(,|\))"

		Local $nResult = StringRegExp($original, $tempRegex, 2)

		if $nResult <> 1 and StringInStr($nResult[1], "$") = 0 then
			$tempRegex = "(?i)(SendPacket\(.*?,.*?)(,|\))"
			$lData = StringRegExpReplace($lData, $tempRegex, "$1+1$2")
		endif

	#EndRegion

	$lData = StringReplace($lData,"GetBag(", "GetBagPtr(")


	$lData = StringReplace($lData,"GetItemByItemID(", "GetItemPtr(")

	$lData = StringReplace($lData,"GetItemBySlot(", "GetItemPtrBySlot(")
	$lData = StringReplace($lData,"GetItemByAgentID(", "GetItemPtrByAgentID(")
	$lData = StringReplace($lData,"GetItemByModelID(", "GetItemPtrByModelID(") ;ptr version has a bagsOnly parameter



	$lData = StringReplace($lData,"GetSkillByID(", "GetSkillPtr(")

	$lData = StringReplace($lData,"GetSkillbar(","GetSkillbarPtr(")
	$lData = StringReplace($lData,"GetBuffByIndex(","GetBuffPtr(")
	$lData = StringReplace($lData,"GetEffect(","GetEffectsPtr(")
	;$lData = StringReplace($lData,"GetHasEffects(","HasEffect(") ;ptr version now has heroNumber as parameter ;NO need to change


	$lData = StringReplace($lData,"GetAgentByID(", "GetAgentPtr(")

	$lData = StringReplace($lData,"GetAgentArray(", "GetAgentPtrArray(")

	$lData = StringReplace($lData,"GetNearestAgentToAgent(", "GetNearestAgentPtrToAgent(")
	$lData = StringReplace($lData,"GetNearestEnemyToAgent(", "GetNearestEnemyPtrToAgent(")
	$lData = StringReplace($lData,"GetNearestAgentToCoords(", "GetNearestAgentPtrToCoords(")
	$lData = StringReplace($lData,"GetNearestSignpostToAgent(", "GetNearestSignpostPtrToAgent(")
	$lData = StringReplace($lData,"GetNearestSignpostToCoords(", "GetNearestSignpostPtrToCoords(")
	$lData = StringReplace($lData,"GetNearestNPCToAgent(", "GetNearestNPCPtrToAgent(")
	$lData = StringReplace($lData,"GetNearestNPCToCoords(", "GetNearestNPCPtrToCoords(")
	$lData = StringReplace($lData,"GetNearestItemToAgent(", "GetNearestItemPtrToAgent(")


	$lData = StringReplace($lData,"GetCurrentTarget(","GetCurrentTargetPtr(")

	$lData = StringReplace($lData,"GetQuestByID(","GetQuestPtrByID(")

	$lData = StringReplace($lData,"Fn0554(", "IsPartyLoaded(")

	Local $regexTemplate

	;agent
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")vtable('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Timer1('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+20,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")NearestAgentPtr('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+28,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")NextAgent('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+32,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Id('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+44,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Z('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+48,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")BoxHoverWidth('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+60,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")BoxHoverHeight('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+64,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Rotation('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+76,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")NameProperties('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+88,'byte[4]')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")X('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+116,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Y('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+120,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Ground('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+124,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")NameTagX('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+132,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")NameTagY('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+136,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")NameTagZ('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+140,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Type('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+156,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")MoveX('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+160,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")MoveY('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+164,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Owner('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+196,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")ItemID('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+200,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")ExtraType('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+208,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Animation('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+220,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")AttackSpeed('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+236,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")AttackSpeedModifier('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+240,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")PlayerNumber('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+244,'word')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")PlayerNumberArray('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+244,'byte[4]')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Equip('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+252,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Primary('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+266,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Secondary('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+267,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Level('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+268,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Team('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+269,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")EnergyPips('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+276,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")EnergyPercent('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+284,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")MaxEnergy('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+288,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")HPPips('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+296,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")HP('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+304,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")MaxHP('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+308,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Effects('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+312,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")ModelState('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+340,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")TypeMap('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+344,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")InSpiritRange('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+364,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")LoginNumber('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+384,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")ModelMode('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+388,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")ModelAnimation('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+396,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")LastStrike('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+432,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Allegiance('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+433,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")WeaponType('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+434,'word')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")Skill('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+436,'word')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")WeaponItemId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+442,'word')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?agent.*?),.*?('|"& '"' & ")OffhandItemId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+444,'word')")

	;bag

	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")BagType('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")index('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+4,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")id('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+8,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")containerItem('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+12,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")ItemsCount('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+16,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")bagArray('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+20,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")itemArray('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+24,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")fakeSlots('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+28,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?bag.*?),.*?('|"& '"' & ")slots('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+32,'long')")

	;buff

	$regexTemplate = "(?i)DllStructGetData\((\$.*?buff.*?),.*?('|"& '"' & ")SkillId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?buff.*?),.*?('|"& '"' & ")BuffId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+8,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?buff.*?),.*?('|"& '"' & ")TargetId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+12,'long')")

	;item

	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")id('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")agentId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+4,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")bag('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+12,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")modstruct('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+16,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")modstructsize('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+20,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")customized('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+24,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")type('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+32,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")extraId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+34,'short')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")value('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+36,'short')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")interaction('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+40,'byte[4]')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")modelId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+44,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")modString('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+48,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")NameString('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+56,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")quantity('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+75,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")equipped('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+76,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")profession('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+77,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?item.*?),.*?('|"& '"' & ")slot('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+78,'byte')")


	;quest

	$regexTemplate = "(?i)DllStructGetData\((\$.*?quest.*?),.*?('|"& '"' & ")id('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?quest.*?),.*?('|"& '"' & ")LogState('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+4,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?quest.*?),.*?('|"& '"' & ")MapFrom('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+20,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?quest.*?),.*?('|"& '"' & ")X('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+24,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?quest.*?),.*?('|"& '"' & ")Y('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+28,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?quest.*?),.*?('|"& '"' & ")MapTo('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+40,'long')")


	;skillbar

	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AgentId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA1('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+4,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB1('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+8,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge1('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+12,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id1('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+16,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event1('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+20,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA2('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+24,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB2('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+28,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge2('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+32,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id2('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+36,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event2('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+40,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA3('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+44,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB3('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+48,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge3('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+52,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id3('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+56,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event3('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+60,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA4('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+64,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB4('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+68,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge4('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+72,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id4('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+76,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event4('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+80,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA5('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+84,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB5('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+88,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge5('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+92,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id5('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+96,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event5('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+100,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA6('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+104,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB6('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+108,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge6('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+112,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id6('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+116,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event6('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+120,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA7('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+124,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB7('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+128,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge7('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+132,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id7('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+136,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event7('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+140,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineA8('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+144,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")AdrenalineB8('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+148,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Recharge8('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+152,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Id8('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+156,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Event8('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+160,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")disabled('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+164,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")QueuePtr('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+168,'ptr')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skillbar.*?),.*?('|"& '"' & ")Casting('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+176,'dword')")


	;skilleffect

	$regexTemplate = "(?i)DllStructGetData\((\$.*?skilleffect.*?),.*?('|"& '"' & ")SkillId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skilleffect.*?),.*?('|"& '"' & ")EffectType('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+4,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skilleffect.*?),.*?('|"& '"' & ")EffectId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+8,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skilleffect.*?),.*?('|"& '"' & ")AgentId('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+12,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skilleffect.*?),.*?('|"& '"' & ")Duration('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+16,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skilleffect.*?),.*?('|"& '"' & ")TimeStamp('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+20,'long')")

	;skill

	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")ID('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+0,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")campaign('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+8,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Type('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+12,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Special('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+16,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")ComboReq('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+20,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Effect1('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+24,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Condition('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+28,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Effect2('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+32,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")WeaponReq('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+36,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Profession('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+40,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Attribute('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+41,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")PvESkill('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+42,'short')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")PvPID('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+44,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Combo('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+48,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Target('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+49,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")EquipType('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+51,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")EnergyCost('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+53,'byte')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")HealthCost('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+54,'short')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Adrenaline('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+56,'dword')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Activation('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+60,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Aftercast('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+64,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Duration0('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+68,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Duration15('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+72,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Recharge('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+76,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Scale0('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+92,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")Scale15('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+96,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")BonusScale0('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+100,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")BonusScale15('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+104,'long')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")AoERange('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+108,'float')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")ConstEffect('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+112,'byte[4]')")
	$regexTemplate = "(?i)DllStructGetData\((\$.*?skill.*?),.*?('|"& '"' & ")tooltip('|" & '"' & ')\)'
	$lData=StringRegExpReplace($lData, $regexTemplate,"MemoryRead($1+148,'byte[8]')")

	Local $nTabs = StringRegExp($original, "^(\h*)[^\h]+?", 2)

	if $original <> $lData then
		if StringInStr($lData,"IsDllStruct(")<>0 or StringInStr($lData,"DllStructGetData(")<>0 Then
			return $nTabs[1]&";注: 以下[=或需 IsPtr 或 MemoryRead=] <===CCC==="&@CRLF&$nTabs[1]&";注: 原文: "&StringTrimLeft($original,StringLen($nTabs[1]))&" <===CCC==="&@CRLF&$lData&@CRLF&@CRLF
		Else
			return $nTabs[1]&";注: 原文: "&StringTrimLeft($original,StringLen($nTabs[1]))&" <===CCC==="&@CRLF&$lData&@CRLF&@CRLF
		endif
	ElseIf StringInStr($original,"IsDllStruct(")<>0 or StringInStr($original,"DllStructGetData(")<>0 Then
		return $nTabs[1]&";注: 以下[=或需 IsPtr 或 MemoryRead=] <===CCC==="&@CRLF&$nTabs[1]&";注: 原文: "&StringTrimLeft($original,StringLen($nTabs[1]))&" <===CCC==="&@CRLF&$original&@CRLF&@CRLF
	Else
		return $original
	EndIf

EndFunc   ;==>Convert