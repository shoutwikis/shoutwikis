#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "../../激战接口.au3"
#

#cs
Changelog:

-New GUI
-New waypoints for ATC and COTNB
-Added Locationcheck for ATC
#ce


#region Model IDs and Settings
Global Enum $Hero_Norgu = 1, $Hero_Goren, $Hero_Tahlkora, $HERO_MasterOfWhispers, $Hero_AcolyteJin, $Hero_Koss, $Hero_Dunkoro, $Hero_AcolyteSousuke
Global Enum $Hero_Melonni = 9, $Hero_ZhedShadowhoof, $Hero_GeneralMorgahn, $Hero_MagridTheSly
Global Enum $Hero_Olias = 14, $Hero_Razah, $Hero_Mox, $Hero_Jora, $Hero_PyreFierceshot
Global Enum $Hero_Livia = 21, $Hero_Hayda, $Hero_Kahmu, $Hero_Gwen, $Hero_Xandra, $Hero_Vekk, $HERO_Ogden
Global Enum $Hero_Merc1 = 28, $Hero_Merc2, $Hero_Merc3, $Hero_Merc4
Global Enum $Hero_Merc5 = 32, $Hero_Merc6, $Hero_Merc7, $Hero_Merc8

Global $equipbag = 5 ;equip bag to store your armors
Global $bookbag[2] = [2, 1] ;which bag to put books in and the first avalible slot to store them (2=belt)

;Change these lines to use heroes of your choice at Against the Charr
Global $ATCHero1 = $Hero_Olias
Global $ATCHero2 = $Hero_Livia
Global $ATCHero3 = $Hero_Gwen
Global $ATCHero4 = $Hero_Norgu
Global $ATCHero5 = $HERO_MasterOfWhispers
Global $ATCHero6 = $Hero_Razah
Global $ATCHero7 = $Hero_Xandra

;Change these lines to use heroes of your choice at Nornbear quest
Global $NornHero1 = $Hero_Olias
Global $NornHero2 = $Hero_Livia
Global $NornHero3 = $Hero_Gwen
Global $NornHero4 = $Hero_Norgu
Global $NornHero5 = $HERO_MasterOfWhispers
Global $NornHero6 = $Hero_Razah
Global $NornHero7 = $Hero_Xandra

;Change these lines to your build
Global Const $templateNorn = "OwVCI8w0JgKwNlpDUwuIOVTA"
Global Const $templateATC = "OwVCI8w0JgKwNlpDUwuIOVTA"
Global Const $templateATFH = "OwBj0xf84QzkOMMMHM2k0kHQuMA" ;Does not work
Global Const $TahlkoraATFH = "OwQVQoW4yHCvYey7g6Ll3pkdCA"
Global Const $DunkoroATFH = "OwQS8WIH/jmHUfp8OlsT"
Global Const $OgdenATFH = "OwQUQwG+WYOikr/BRfkSuDlkOBA"
;change this to your skill energy, adrenal, casttime at Against the Charr and Nornbear
Global $intSkillEnergy[8] = [5, 5, 5, 5, 10, 50, 50, 50]
; Change the next lines to your skill casting times in milliseconds.
;425 = 1s signet
;500 = 1s enchantment
;350 = 1/4s signet
;250 = stance
;Change according to your build.
Global $intSkillCastTime[8] = [200, 2000, 2000, 2000, 2000, 1000, 2000, 2000]
; Change the next lines to your skill adrenaline count (1 to 8). leave as 0 for skills without adren
Global $intSkillAdrenaline[8] = [0, 0, 0, 0, 0, 0, 0, 0]
;change this to the secondary profession to be used in Nornbear and Against the Charr



Global $HardMode = 1 ;NM NOT IMPLEMENTED, DONT CHANGE THIS
Global $NumberOfRuns = 5 ;CHANGE IN GUI ONLY
Global $TurnBooks = True ;change in GUI ONLY
Global $ignorebooks = False ;CHANGE IN GUI ONLY
Global $secondaryprof = 7 ;dont change below this
Global $totalskills = 7
Global $Great_DestroyerID[2]
Global $Great_Destroyer[2] = [-14574, 14698]
Global $High_Priest_Alkar[2] = [-5, -911]
Global $Vanguard_Helmet[2] = [-9580, -2860]
Global $Sif_Shadowhunter[2] = [14380, 23968]

Global $CotNB = IniRead("SpeedSettings.ini", "Settings", "CotNB", "")
Global $ATC = IniRead("SpeedSettings.ini", "Settings", "ATC", "")
Global $ATFH = IniRead("SpeedSettings.ini", "Settings", "ATFH", "")
Global $fLog = FileOpen("SpeedBook.log", 1) ;Log file

Global $NornTitle
Global $VanguardTitle
Global $AsuraTitle
Global $DeldrimorTitle

Global $Asuran[3] = [17110, 19782, 640];asuran book keeper model ID and zone
Global $Vanguard[3] = [-2073, 2680, 642] ;vanguard book keeper model ID and zone
Global $Norn[3] = [18346, -13238, 644];norn book keeper model ID and zone
Global $Dwarven[3] = [17537, -4705, 644] ;dwarven book keeper model ID and zone

Global $selfx
Global $selfy
Global $MaxHp
Global $Agent

Global $Asuran[3] = [17110, 19782, 640];asuran book keeper model ID and zone
Global $Vanguard[3] = [-2073, 2680, 642] ;vanguard book keeper model ID and zone
Global $Norn[3] = [18346, -13238, 644];norn book keeper model ID and zone
Global $Dwarven[3] = [17537, -4705, 644] ;dwarven book keeper model ID and zone

Global $LastSlot
Global $herokey = "{F8}" ;hotkey to select the second party member
Global $Rep[3]
Global $boolRun = False
Global $wipednorn
;~ Description: Change the currently displayed title.
Global $DSpearmarshallTitle = 0x11
Global $DLightbringerTitle = 0x14
Global $DAsuranTitle = 0x26
Global $DDwarvenTitle = 0x27
Global $DEbonVanguardTitle = 0x28
Global $DNornTitle = 0x29

Global $RENDERING = True
#endregion
#

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
Global $slideold

$Form2 = GUICreate("Speedbooker", 466, 359, 192, 125)
$Group1 = GUICtrlCreateGroup("General Configuration", 8, 5, 190, 90)
$Runs = GUICtrlCreateInput("1", 150, 17, 41, 21, $SS_CENTER)
$Number = GUICtrlCreateLabel("Number of Books", 14, 21, 134, 17)
$getnew = GUICtrlCreateCheckbox("Get New Books", 14, 37, 129, 17)
$HM = GUICtrlCreateCheckbox("Hard Mode", 14, 54, 137, 17)
$Checkbox1 = GUICtrlCreateCheckbox("Turn Books after all Runs", 14, 71, 145, 17)
GUICtrlSetState($HM, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Reputation", 8, 97, 190, 97)
$Radio1 = GUICtrlCreateRadio("Norn: Norn Title", 13, 113, 137, 17)
$Radio2 = GUICtrlCreateRadio("Vanguard: Vanguard Title", 13, 131, 137, 17)
$Radio3 = GUICtrlCreateRadio("Asura: Asuran Title", 13, 149, 160, 17)
$Radio4 = GUICtrlCreateRadio("Deldrimor: Deldrimor Title", 13, 167, 160, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Missions", 8, 198, 190, 72)
$Checkbox6 = GUICtrlCreateCheckbox("Curse Of The Norn Bear", 14, 213, 140, 17)
$Checkbox5 = GUICtrlCreateCheckbox("Against The Charr", 14, 230, 140, 17)
$Checkbox4 = GUICtrlCreateCheckbox("A Time For Heroes", 14, 247, 140, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Character Name", 8, 274, 190, 79)
$charactername = GUICtrlCreateInput("", 14, 292, 179, 21, $SS_CENTER)
$Button1 = GUICtrlCreateButton("Start", 13, 319, 180, 26)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$gLogBox = GUICtrlCreateEdit("", 207, 12, 250, 340)
GUICtrlSetState($Checkbox1, $GUI_CHECKED)
GUICtrlSetState($Checkbox4, $GUI_CHECKED)
GUICtrlSetState($Checkbox5, $GUI_CHECKED)
GUICtrlSetState($Checkbox6, $GUI_CHECKED)
GUICtrlSetState($Radio1, $GUI_CHECKED)
GUICtrlSetState($getnew, $GUI_CHECKED)
GUICtrlSetState($HM, $GUI_DISABLE)

GUICtrlSetOnEvent($Button1, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUICtrlSetOnEvent($Checkbox1, "eventhandler")
GUICtrlSetOnEvent($getnew, "eventhandler")

GUISetState(@SW_SHOW)


Global $RenderMode = TrayCreateItem("Change Render")
TrayItemSetOnEvent(-1, "TrayHandler")


Func TrayHandler()
	Switch (@TRAY_ID)
		Case $RenderMode
			TOGGLERENDERING()
	    Case $tExit
			If Not $RENDERING Then TOGGLERENDERING()
			_exit()
	EndSwitch
EndFunc   ;==>TrayHandler

Func TOGGLERENDERING()
	If $RENDERING Then
		DisableRendering()
		$RENDERING = False
	Else
		EnableRendering()
		$RENDERING = True
	EndIf
EndFunc   ;==>TOGGLERENDERING

Func _exit()
	Exit
EndFunc   ;==>_exit
#EndRegion ### END Koda GUI section ###

#

while 1
	If GUICtrlRead($getnew) == $GUI_CHECKED Then
		$ignorebooks = True
	Else
		$ignorebooks = False
	EndIf
	If GUICtrlRead($checkbox1) == $GUI_CHECKED Then
		$TurnBooks = True
	Else
		$TurnBooks = False
	Endif
	sleep(100)
wend

#Region EventAndConfigs
Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $Checkbox1
			$TurnBooks = GUICtrlRead($checkbox1)
		Case $getnew
			$ignorebooks = GUICtrlRead($getnew)
		Case $Button1
			$boolRun = Not $boolRun
			If $boolRun Then
				GUICtrlSetData($Button1, "Started...")
				GUICtrlSetState($Button1, $GUI_DISABLE)
				GUICtrlSetState($charactername, $GUI_DISABLE)
				If GUICtrlRead($charactername) = "" Then
					If Initialize(ProcessExists("gw.exe")) = False Then
						MsgBox(0, "Error", "Guild Wars is not running.  Exiting Program.")
						Exit
					EndIf
					StartLoop()
				Else
					If Initialize(GUICtrlRead($charactername), True, True) = False Then
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
					StartLoop()
				EndIf
				GUICtrlSetState($Button1, $GUI_ENABLE)
				GUICtrlSetData($Button1, "Pause")

			Else
				GUICtrlSetData($Button1, "BOT WILL HALT AFTER THIS RUN")
				GUICtrlSetState($Button1, $GUI_DISABLE)
			EndIf
		;Case $cbxHideGW
			;If GUICtrlRead($cbxHideGW) = 1 Then ToggleRendering()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
EndFunc   ;==>EventHandler

Func DisableGUI()
	GUICtrlSetState($Group1, $GUI_DISABLE)
	GUICtrlSetState($Checkbox4, $GUI_DISABLE)
	GUICtrlSetState($Checkbox5, $GUI_DISABLE)
	GUICtrlSetState($Checkbox6, $GUI_DISABLE)
	GUICtrlSetState($Checkbox4, $GUI_DISABLE)
	GUICtrlSetState($charactername, $GUI_DISABLE)
	GuiCtrlSetState($Checkbox1, $GUI_DISABLE)
	GuiCtrlSetState($getnew, $GUI_DISABLE)
EndFunc

Func EnableGUI()
	GUICtrlSetState($Group1, $GUI_ENABLE)
	GUICtrlSetState($Checkbox4, $GUI_ENABLE)
	GUICtrlSetState($Checkbox5, $GUI_ENABLE)
	GUICtrlSetState($Checkbox6, $GUI_ENABLE)
	GUICtrlSetState($Checkbox4, $GUI_ENABLE)
	GUICtrlSetState($charactername, $GUI_ENABLE)
EndFunc

Func SaveINI()
	IniWrite("SpeedSettings.ini", "Settings", "CotNB", GUICtrlRead($Checkbox6))
	IniWrite("SpeedSettings.ini", "Settings", "ATC", GUICtrlRead($Checkbox5))
	IniWrite("SpeedSettings.ini", "Settings", "ATFH", GUICtrlRead($Checkbox4))
EndFunc

Func ReadINI()
	$CotNB = IniRead("SpeedSettings.ini", "Settings", "CotNB", "")
	$ATC = IniRead("SpeedSettings.ini", "Settings", "ATC", "")
	$ATFH = IniRead("SpeedSettings.ini", "Settings", "ATFH", "")
EndFunc

Func ReadTitles()
	$NornTitle = GetNornTitle()
	$VanguardTitle = GetVanguardTitle()
	$AsuraTitle = GetAsuraTitle()
	$DeldrimorTitle = GetDeldrimorTitle()
EndFunc

Func UpdateTitles()
	ReadTitles()
	GUICtrlSetData($Radio1, "Norn: " & $NornTitle)
	GUICtrlSetData($Radio2, "Vanguard: " & $VanguardTitle)
	GUICtrlSetData($Radio3, "Asura: " & $AsuraTitle)
	GUICtrlSetData($Radio4, "Deldrimor: " & $DeldrimorTitle)
EndFunc
#Endregion EventAndConfigs
#


#Region Bot
Func StartLoop()
	EnsureEnglish(True)
	out("StartLoop")
	ReadTitles()
	$NumberOfRuns = GUICtrlRead($Runs)
	DisableGui()
	For $R = 0 To $NumberOfRuns
		$Number_Of_Books = ($NumberOfRuns - $R)
		If $ignorebooks Then
			Out("Getting New Books")
			Select
				Case GUICtrlRead($Radio1) = $GUI_CHECKED
					$Rep = $Norn
				Case GUICtrlRead($Radio2) = $GUI_CHECKED
					$Rep = $Vanguard
				Case GUICtrlRead($Radio3) = $GUI_CHECKED
					$Rep = $Asuran
				Case GUICtrlRead($Radio4) = $GUI_CHECKED
					$Rep = $Dwarven
			EndSelect
			DoBooks($Rep, $Number_Of_Books, "GetNew")
		EndIf
		sleep(1000)
		If GUICtrlRead($Checkbox6) = $GUI_CHECKED Then
			MainLoopNorn()
			sleep(2000)
			UpdateTitles()
			sleep(2000)
			sleep(2000)
		EndIf
		If GUICtrlRead($Checkbox5) = $GUI_CHECKED Then
			MainLoopATC()
			sleep(2000)
			UpdateTitles()
			sleep(2000)
		EndIf
		If GUICtrlRead($Checkbox4) = $GUI_CHECKED Then
			MainLoopATFH()
			sleep(2000)
			UpdateTitles()
			sleep(2000)
		EndIf
		If $TurnBooks Then
			Out("Turning In Books")
			Select
				Case GUICtrlRead($Radio1) = $GUI_CHECKED
					$Rep = $Norn
				Case GUICtrlRead($Radio2) = $GUI_CHECKED
					$Rep = $Vanguard
				Case GUICtrlRead($Radio3) = $GUI_CHECKED
					$Rep = $Asuran
				Case GUICtrlRead($Radio4) = $GUI_CHECKED
					$Rep = $Dwarven
			EndSelect
			DoBooks($Rep, 1, "Done")
		EndIf
	Next
EndFunc
#endregion
#

#region Norn
Func MainLoopNorn()
	SetDisplayedTitle($DDwarvenTitle)
	Out("Norn: Location Check")
	LocationCheckNorn()
	sleep(1000)
	Out("Norn: Checking Armor")
	ArmorCheckSwitch("High Set") ;this will switch back to your last armor set
	SetDisplayedTitle($DNornTitle)
	sleep(1000)
	StartQuestNorn()
	sleep(1000)
	StartRunNorn()
	sleep(1000)
EndFunc

Func StartQuestNorn()
	Out("Norn: Starting Quest")
	LeaveGroup()
	Out("Norn: Adding Heroes")
	AddHero($NornHero1)
	sleep(Random(500,1000,1))
	AddHero($NornHero2)
	sleep(Random(500,1000,1))
	AddHero($NornHero3)
	sleep(Random(500,1000,1))
	AddHero($NornHero4)
	sleep(Random(500,1000,1))
	AddHero($NornHero5)
	sleep(Random(500,1000,1))
	AddHero($NornHero6)
	sleep(Random(500,1000,1))
	AddHero($NornHero7)
	sleep(Random(500,1000,1))
	Out("Norn: Heroes Added")
	SwitchMode($HardMode)
	Out("Norn: Hard Mode Set")
	sleep(200)
	ChangeWeaponSet(1)
	Out("Norn: Switching to Set #1")
	sleep(200)
	;ClearAttributes()
	;SetSkillsNorn()
	GoToNpc(GetNearestNPCToCoords(14380, 23968))  ; 0
	Dialog(0x81)
	sleep(1000)
	Dialog(0x86)
	sleep(2500 + Random(-150,150))
EndFunc

Func SetSkillsNorn()
	;LoadSkillTemplate($templateNorn)
	Out("Norn: Skill Template Loaded")
	sleep(500)
EndFunc

Func StartRunNorn()
	Out("Norn: Starting Run")
	AdlibRegister("PartyWipeNorn",5000)
	sleep(2000)
	AggroMoveToEx(7991, 22722)
	AggroMoveToEx(5970, 23060)
	AggroMoveToEx(3362, 22389);first set of jotuns
	sleep(2000)
	AggroMoveToEx(2080, 18139)
	AggroMoveToEx(2743, 16279)
	AggroMoveToEx(644, 15781);inside entrance to first nornbear
	AggroMoveToEx(-3086, 16189);mandragors near first nornbear
	AggroMoveToEx(-5103, 16196)
	sleep(500);first wait near nornbear 1
	AggroMoveToEx(-6797, 16209);far limits for nornbear 1
	out ("Norn: Waiting For Nornbear #1")
	WaitForEnemies(1200, 20000)
	Fight(1200)
	sleep(2000)
	Out ("Norn: Moving To Nornbear #2")
	AggroMoveToEx(3363, 16207)
	sleep(8000)
	AggroMoveToEx(5743, 12893);killing jotuns near base of nornbear 2
	sleep(1500)
	AggroMoveToEx(4043, 16044);bottom of hill for nornbear 2
	AggroMoveToEx(8233, 14028);nornbear 2
	sleep(3500)
	out("Norn: Waiting For NornBear #2")
    WaitForEnemies(1200, 20000)
    Fight(1200)
	sleep(2000)
	Out ("Norn: Moving To Nornbear #3")
	AggroMoveToEx(3807, 15768)
	AggroMoveToEx(5425, 13174)
	AggroMoveToEx(4310, 11606)
	AggroMoveToEx(1789, 11598)
	AggroMoveToEx(762, 10798)
	AggroMoveToEx(1208, 9356);bottom of hill for nornbear 3
	sleep(2000)
	AggroMoveToEx(2218, 8738)
	AggroMoveToEx(2134, 6449)
	AggroMoveToEx(4030, 5727)
	AggroMoveToEx(5070, 7027)
	out("Norn: Waiting For Nornbear #3")
	WaitForEnemies(1200, 20000)
    Fight(1200)
	AdlibUnRegister("PartyWipeNorn")
	sleep(2000)
	Do
		SkipCinematic()
		sleep(2000)
	Until GetMapId() = 643
	Out("Norn: Run Completed")
	sleep(2000 + Random(-150,150))
	$run = True
EndFunc

Func LocationCheckNorn()
	If GetMapID() <> 643 Then
		TravelTo(643)
		sleep(2000 + Random(-150,150))
	EndIf
EndFunc
#endregion Norn
#

#region ATFH
Func MainLoopATFH()
	SetDisplayedTitle($DDwarvenTitle)
	sleep(10000)
	out("ATFH: Checking location")
	LocationCheckATFH()
	sleep(2000)
	out("ATFH: Checking Armor")
	ArmorCheckSwitch("Low Set") ; this will switch to your 105hp armor set
	Out("ATFH: Armor Switched")
	sleep(2000)
	StartQuestATFH()
	sleep(2000)
	out("ATFH: Starting Run")
	StartRunATFH()
	sleep(2000)
EndFunc

Func StartQuestATFH()
	Out("ATFH: Starting Quest")
	;SetSkillsATFH()
	Rndsleep(1000)
	Out("ATFH: Adding Heroes")
	AddHero($Hero_Tahlkora)
	sleep(1000)
	AddHero($Hero_Dunkoro)
	sleep(1000)
	AddHero($HERO_Ogden)
	sleep(1000)
	Out("ATFH: Heroes Added")
	SwitchMode($HardMode)
	Out("ATFH: Hard Mode Set")
	Rndsleep(500)
	Out("ATFH: Switching To Set #2")
	ChangeWeaponSet(2)
	Out("ATFH: Loading Hero Skill Templates")
	LoadSkillTemplate($TahlkoraATFH, 1)
	sleep(500)
	LoadSkillTemplate($DunkoroATFH, 2)
	sleep(500)
	LoadSkillTemplate($OgdenATFH, 3)
	GoToNpc(GetNearestNPCToCoords(-5, -911))
	sleep(2000)
	Dialog(0x86)
	sleep(2000)
	Dialog(0x84)
	sleep(10000)
	Do
		sleep(500)
	Until GetMapLoading() = 1
	sleep(2500 + Random(-150,150))
EndFunc

Func StartRunATFH()
    Out("Indicate Vars")
	$whiped = False
	local $spam
	Sleep(1500)
	Out("Starting Bonds")
	Sleep(1500)
	HerosBond()
	Out("ATFH: Bonds Casted")
	sleep(5000)
	CommandAll(-15038, 18906)
	MoveTo(-15039, 18918)
	UseSkill(7, -2)
	sleep(1200)
	UseSkill(6, -2)
	;ConsoleWrite("Start Move Hard"&@CRLF)
	Out("ATFH: Moving To Boss")
	MoveTo(-14789, 14947)
	$Great_DestroyerID = GetAgentByLevel(31)
	ChangeTarget($Great_DestroyerID)
	sleep(100)
	AdlibRegister("LavaWave", 1000)
	UseSkill(1, -1);use skill on current target
	sleep(500)
	Attack(-1)
	sleep(100)
	UseSkill(2, -1)
	sleep(1350)
	Do
		If GetSkillbarSkillRecharge(1) = 0 And Not GetIsKnocked(-2) Then
			UseSkill (1, -2)
		EndIf
		sleep(1000)
		Attack (-1)
		$skill2 = GetSkillbarSkillRecharge(2)
		If $skill2 = 0 And Not GetIsKnocked(-2) Then
			UseSkill(2, -1)
			$spam = 1
		EndIf
		sleep(1000)
		$skill6 = GetSkillbarSkillRecharge(6)
		If $skill6 = 0 Then UseSkill(6, -2)

		$skill3 = GetSkillbarSkillRecharge(3)
		If $skill3 = 0 And $spam = 1 And Not GetIsKnocked(-2) Then
			UseSkill (3, -1)
			$spam = 2
		EndIf
		sleep(1000)

		$skill4 = GetSkillbarSkillRecharge(4)
		If $skill4 = 0 And $spam = 2 And Not GetIsKnocked(-2) Then
			UseSkill(4, -1)
			$spam = 0
		EndIf
		sleep(1000)

		$skill7 = GetSkillbarSkillRecharge(7)
		If $skill7 = 0 And Not GetIsKnocked(-2) Then
			UseSkill(7, -1)
			sleep(1500)
		EndIf

		$skill8 = GetSkillbarSkillRecharge(8)
		If $skill8 = 0 And Not GetIsKnocked(-2) Then
			UseSkill(8, -1)
		EndIf
		sleep(1500)

		If 	GetIsDead(-2) Then $whiped = True
		Me() ;Get my coords
	Until ($selfx = -15313 And $selfy = 15035) Or $whiped
	AdlibUnRegister("LavaWave")
	If $whiped Then
		;ConsoleWrite("Whiped Starting Over"&@CRLF)
		sleep(5000)
		Return MainLoopATFH()
	EndIf
	sleep(1000)
	SkipCinematic()
	sleep(1000)
	Do
		SkipCinematic()
		sleep(2000)
	Until GetMapId() = 710
	Out("ATFH: Run Completed")
	sleep(2000 + Random(-150,150))
	$run = True
EndFunc

Func LavaWave()
    $boss = GetAgentByLevel(31)
    $skill5 = GetSkillbarSkillRecharge(5)
    If GetIsCasting($boss) And DllStructGetData($boss, 'Skill') = 2347 And $skill5 = 0 Then
        UseSkill(5, $boss)
        sleep(1000)
    EndIf
EndFunc

Func HerosBond()
    Out("ATFH: Disable Bonds")
;	DisableHeroSkillSlot(1,1)
;	DisableHeroSkillSlot(2,1)
;	DisableHeroSkillSlot(3,1)
;	DisableHeroSkillSlot(1,2)
;	DisableHeroSkillSlot(2,2)
;	DisableHeroSkillSlot(3,2)
;	DisableHeroSkillSlot(1,3)
;	DisableHeroSkillSlot(2,3)
	;DisableHeroSkillSlot(3,3)
	;DisableHeroSkillSlot(1,4)
	;DisableHeroSkillSlot(2,4)
	;DisableHeroSkillSlot(3,4)
	;DisableHeroSkillSlot(1,4)
	Out("Disabled Bonds")
	Sleep(2000)
	Out("Selecting Me")
	ME()
	$Agent = GetAgentByID(-2)
	Sleep(2000)
	Out("ATFH: Using Bonds")

	Out("ATFH: Using HeroSkill 1")
	UseHeroSkill(1, 1, $Agent)
	Rndsleep(1000)
	Out("ATFH: Using HeroSkill 2")
	UseHeroSkill(2, 1, $Agent)
	Rndsleep(1000)
	UseHeroSkill(3, 1, $Agent)
	sleep(3000)
	UseHeroSkill(1, 2, $Agent)
	Rndsleep(1000)
	UseHeroSkill(2, 2, $Agent)
	Rndsleep(1000)
	UseHeroSkill(3, 2, $Agent)
	sleep(3000)
	UseHeroSkill(1, 6, $Agent)
	Rndsleep(1000)
	UseHeroSkill(2, 5, $Agent)
	Rndsleep(1000)
	UseHeroSkill(3, 5, $Agent)
	sleep(3000)
	UseHeroSkill(1, 3, $Agent)
	Rndsleep(1000)
	UseHeroSkill(2, 3, $Agent)
	Rndsleep(1000)
	UseHeroSkill(3, 3, $Agent)
	sleep(3000)
	UseHeroSkill(1, 4, $Agent)
	Rndsleep(1000)
	UseHeroSkill(2, 4, $Agent)
	Rndsleep(1000)
	UseHeroSkill(3, 4, $Agent)
	sleep(3000)
	UseHeroSkill(1, 5, $Agent)
	sleep(2500)
	return 1
EndFunc

Func LocationCheckATFH()
	If GetMapID() <> 652 Then
		TravelTo(652)
	EndIf
	sleep(2000)
	LeaveGroup()
EndFunc

Func SetSkillsATFH()
		ChangeSecondProfession(7)
		Out("ATFH: Secondary Changed")
		LoadSkillBar(2355, 782, 780, 775, 2358, 2356, 1031, 814)
		Out("ATFH: Skillbar Loaded")
		;ClearAttributes()
		Out("ATFH: Setting Attributes")
		sleep(1000)
		Out("ATFH: Setting Dagger Mastery")
		Do
			IncreaseAttribute(29)
			Rndsleep(1000)
	    Until GetAttributeByID(29) = 12
		Out("ATFH: Setting Shadow Arts")
		Do
			IncreaseAttribute(31)
			Rndsleep(1000)
	    Until GetAttributeByID(31) = 12
		Out("ATFH: All Attributes Set")
EndFunc
#endregion ATFH
#

#region ATC
Func MainLoopATC()
	SetDisplayedTitle($DEbonVanguardTitle)
	Out("ATC: Checking Location")
	LocationCheckATC()
	sleep(1000)
	Out("ATC: Checking Armor")
	ArmorCheckSwitch("High Set") ;this will switch back to your last armor set
	sleep(1000)
	StartQuestATC()
	sleep(1000)
	StartRunATC()
	sleep(5000)
EndFunc

Func StartQuestATC()
	Out("ATC: Starting Quest")
	sleep(500)
	Out("ATC: Adding Heroes")
	AddHero($ATCHero1)
	sleep(Random(500,1000,1))
	AddHero($atcHero2)
	sleep(Random(500,1000,1))
	AddHero($atcHero3)
	sleep(Random(500,1000,1))
	AddHero($atcHero4)
	sleep(Random(500,1000,1))
	AddHero($atcHero5)
	sleep(Random(500,1000,1))
	AddHero($atcHero6)
	sleep(Random(500,1000,1))
	AddHero($atcHero7)
	sleep(Random(500,1000,1))
	Out("ATC: Heroes Added")
	SwitchMode($HardMode)
	Out("ATC: Hard Mode Set")
	Rndsleep(200)
	Out("ATC: Switching to Set #1")
	ChangeWeaponSet(1)
	rndsleep(200)
	;LoadSkillTemplate($templateATC)
	sleep(500)
	Out("ATC: Moving Down Slope")
	MoveTo(-23065, 13699)
	MoveTo(-22159, 13058) ;Near Portal
	Out("ATC: Wait Near Portal")
	sleep(10000)
	Out("ATC: Entering Portal")
	Move(-21938, 12814) ;Exiting Portal
	Do
	   sleep(5000)
	Until GetMapLoading() = 1
	sleep(2000)
	AggroMoveToEx(-11477, 5042)
	sleep(500)
	AggroMoveToEx(-11155, 477)
	sleep(1500)
	Out("ATC: Moving To Helmet")
	AggroMoveToEx($Vanguard_Helmet[0], $Vanguard_Helmet[1])
	sleep(500)
	Out("ATC: Talking To Helmet")
	GoToNpc(GetNearestNPCToCoords(-9580, -2860))  ; 0
	sleep(1500)
	Dialog(0x84)
	sleep(1500)
	Do
		sleep(100)
		Me()
	Until ComputeDistance($selfx, $selfy, -9626, -3170) < 500
	sleep(5000)
	SkipCinematic()
	Do
		sleep(100)
		Me()
	Until ComputeDistance($selfx, $selfy, -9064, -3738) < 100
	sleep(4000)
EndFunc

Func StartRunATC()
	AdlibRegister("PartyWipeATC", 5000)
	Out("ATC: Starting Run")
	AggroMoveToEx(-4076, -9513)
	AggroMoveToEx(-3155, -11424);after bridge after 1st group of charr
	AggroMoveToEx(-2751, -11483)
	AggroMoveToEx(1843, -11891);brown tree near res point near ooze portal
	sleep(1000)
	AggroMoveToEx(2403, -11413)
	AggroMoveToEx(5079, -12524)
	AggroMoveToEx(8598, -12495);outside ooze portal
	Out("ATC: Waiting at Ooze Portal")
	sleep(8000)
	AggroMoveToEx(10316, -10897)
	AggroMoveToEx(12018, -10203);group after portal on path
	sleep(3000)
	AggroMoveToEx(14634, -8106)
	AggroMoveToEx(16805, -6060)
	sleep(10000)
	AggroMoveToEx(18726, -1738);wait for devourer
	sleep(1000)
	Out("ATC: Waiting for Devourer")
	sleep(5000)
	if WaitForEnemies(1200, 20000) then Fight(1200)
    AggroMoveToEx(19073, 57);just inside entrance, not too far inside
	Out("ATC: Waiting Inside Entrance")
	sleep(5000)
	AggroMoveToEx(18505, 997);right side
	sleep(4000)
	AggroMoveToEx(18102, 1601);firereign spawns
	sleep(5000)
	AggroMoveToEx(18343, 2625);dominators
	sleep(5000)
	Out("ATC: Moving to Bosses")
	AggroMoveToEx(19320, 3470)
	AdlibUnRegister("PartyWipeATC")
	sleep(10000)
    SkipCinematic()
	sleep(5000)
	AdLibRegister("PostATC", 2000)
	sleep(10000)
    AdLibUnRegister("PostATC")
	Out("ATC: Run Done")
EndFunc

Func LocationCheckATC()
    Out("Checking ATC Location")
	If GetMapId() <> 650 Then
		TravelTo(650)
		sleep(1000)
	EndIf
EndFunc

Func PostATC()
    SkipCinematic()
	Out("Checking Post-ATC Location")
	If GetMapId() = 649 Then
		TravelTo(650)
		sleep(1000)
    EndIf
EndFunc

#endregion ATC
#

#region books
Func Dobooks($reptype, $numberofbooks, $bookstate)
	$zoneID = $reptype[2]
	Local $book_keeper_Coords[2] = [$reptype[0], $reptype[1]]
	If GetMapID() <> $zoneID Then
		TravelTo($zoneID)
	EndIf
	sleep(2000)
	Select
		Case $book_keeper_Coords[0] = $Norn[0] And $book_keeper_Coords[1] = $Norn[1]
			Out("Talking to Norn NPC")
			moveto(16775, -9577)
		Case $book_keeper_Coords[0] = $Asuran[0] And $book_keeper_Coords[1] = $Asuran[1]
			Out("Talking to Asuran NPC")
			moveto(16800, 19658)
	EndSelect
	sleep(1000)
	MoveTo($book_keeper_Coords[0], $book_keeper_Coords[1])
	GoToNpc(GetNearestNPCToCoords($book_keeper_Coords[0], $book_keeper_Coords[1]))
	sleep(2000)
	Switch $bookstate
	Case "Done"
		turninbooks($numberofbooks, $book_keeper_Coords)
	Case "GetNew"
		getbooks($numberofbooks)
	EndSwitch
	sleep(2000)
EndFunc

Func turninbooks($numberofbooks, $book_keeper_coords_local) ;requires an open dialog with the book npc
		GrabBounty($book_keeper_Coords_local[0], $book_keeper_Coords_local[1], "0x84|0x1016913|0x1026913")
		sleep(1500)
		UpdateTitles()
		sleep(2000)
EndFunc

Func getbooks($numberofbooks) ;requires an open dialog with the book npc
	Dialog(0x85)
	sleep(1500)
	Dialog(16804115)
	;Dialog(0x16913)
	sleep(1500)
EndFunc
#endregion books
#

#Region OtherFunctions
Func GrabBounty($aX, $aY, $aDialogs = False, $aBounties = False)
	GoToNPC(GetNearestNPCToCoords($aX, $aY))
	If $aDialogs Then
		Local $lDialogs = StringSplit(String($aDialogs), "|")
		Local $lBounties = StringSplit(String($aBounties), "|")
		While 1
			For $i = 1 To $lDialogs[0]
				Dialog(Number($lDialogs[$i]))
				Tolsleep(1000, 250)
			Next
			If Not $aBounties Then ExitLoop
			For $i = 1 To $lBounties[0]
				If IsDllStruct(GetEffect(Number($lBounties[$i]))) Then ExitLoop 2
			Next
			GoToNPC(GetNearestNPCToCoords($aX, $aY))
		WEnd
	EndIf
EndFunc   ;==>GrabBounty


Func WaitForEnemies($aDist, $IIDeadLock)
	Local $lTarget, $lDistance
	Local $SSDeadLock = TimerInit()
    Do
		Tolsleep()
		$lTarget = GetNearestEnemyToAgent(-2)
        If Not IsDllStruct($lTarget) Then ContinueLoop
        $lDistance = GetDistance($lTarget, -2)
        If $lDistance < $aDist Then Return True
	Until TimerDiff($SSDeadLock) > $IIDeadLock
    Return False
EndFunc   ;==>WaitForEnemies


Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $aRange = 1250)
	Local $lAgent
	Local $lCount = 0
	For $i = 1 To GetMaxAgents()
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Allegiance') == 3 Then
			If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
			If Not GetIsLiving($lAgent) Then ContinueLoop
			If GetIsDead($lAgent) Then ContinueLoop
			If GetDistance($lAgent, $aAgent) > $aRange Then ContinueLoop
			$lCount += 1
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfFoesInRangeOfAgent

Func ArmorCheckSwitch($set)
	Local $switch
	Me()
	Switch $set
		Case "Low Set"
			If $MaxHp > 200 Then $switch = True
		Case "High Set"
			If $MaxHp < 200 Then $switch = True
		Case Else
			$switch = False
	EndSwitch
	If $switch Then
		Out("Switching Armor")
		GetItemBySlot($equipbag, 1)
		EquipItem(GetItemBySlot($equipbag, 1))
		sleep(Random(500,1000,1))
		EquipItem(GetItemBySlot($equipbag, 2))
		sleep(Random(500,1000,1))
		EquipItem(GetItemBySlot($equipbag, 3))
		sleep(Random(500,1000,1))
		EquipItem(GetItemBySlot($equipbag, 4))
		sleep(Random(500,1000,1))
		EquipItem(GetItemBySlot($equipbag, 5))
		sleep(Random(500,1000,1))
	EndIf
EndFunc

Func ME()
	$Agent = GetAgentByID(-2)
	$MaxHp = DllStructGetData($Agent, 'MaxHP')
	$selfx = DllStructGetData($Agent,'X')
	$selfy = DllStructGetData($Agent, 'Y')
EndFunc

Func AggroMoveToEx($x, $y, $s = "", $z = 1250)
	$Random = 50
	$iBlocked = 0

	Move($x, $y, $Random)


	$lMe = GetAgentByID(-2)
	$coordsX = DllStructGetData($lMe, "X")
	$coordsY = DllStructGetData($lMe, "Y")

	Do
		Rndsleep(250)
		$oldCoordsX = $coordsX
		$oldCoordsY = $coordsY
		$nearestenemy = GetNearestEnemyToAgent(-2)
		$lDistance = GetDistance($nearestenemy, -2)
		If $lDistance < $z And DllStructGetData($nearestenemy, 'ID') <> 0 Then
			FIGHT($z, $s)

		EndIf
		Rndsleep(250)
		$lMe = GetAgentByID(-2)
		$coordsX = DllStructGetData($lMe, "X")
		$coordsY = DllStructGetData($lMe, "Y")
		If $oldCoordsX = $coordsX And $oldCoordsY = $coordsY Then
			$iBlocked += 1
			Move($coordsX, $coordsY, 500)
			Rndsleep(350)
			Move($x, $y, $Random)
		EndIf
	Until ComputeDistance($coordsX, $coordsY, $x, $y) < 250 Or $iBlocked > 20
EndFunc   ;==>AggroMoveToEx


Func FIGHT($x, $s = "enemies")

	Do
		Rndsleep(250)
		$nearestenemy = GetNearestEnemyToAgent(-2)
	Until DllStructGetData($nearestenemy, 'ID') <> 0

	Do
		$useSkill = -1
		$target = GetNearestEnemyToAgent(-2)
		$distance = GetDistance($target, -2)
		If DllStructGetData($target, 'ID') <> 0 And $distance < $x Then
			ChangeTarget($target)
			Rndsleep(150)
			Attack($target, 1)
			Rndsleep(150)
		ElseIf DllStructGetData($target, 'ID') = 0 Or $distance > $x Then
			ExitLoop
		EndIf

		For $i = 0 To $totalskills

			$targetHP = DllStructGetData(GetCurrentTarget(), 'HP')
			If $targetHP = 0 Then ExitLoop

			$distance = GetDistance($target, -2)
			If $distance > $x Then ExitLoop

			$energy = GetEnergy(-2)
			$recharge = DllStructGetData(GetSkillBar(), "Recharge" & $i + 1)
			$adrenaline = DllStructGetData(GetSkillBar(), "Adrenaline" & $i + 1)

			If $recharge = 0 And $energy >= $intSkillEnergy[$i] And $adrenaline >= ($intSkillAdrenaline[$i] * 25 - 25) Then
				$useSkill = $i + 1
				Rndsleep(250)
				UseSkill($useSkill, $target)
				Rndsleep($intSkillCastTime[$i] + 400)
			EndIf
			If $i = $totalskills Then $i = 0
		Next

	Until DllStructGetData($target, 'ID') = 0 Or $distance > $x
	;PickupItems(-1, $x)
	sleep(500)
EndFunc   ;==>Fight

;=================================================================================================
; Function:			FindEmptySlot($bagIndex)
; Description:		This function also searches the storage
; Parameter(s):		Parameter = bagIndex to start searching from
;
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	Returns integer with item slot. If any of the returns = 0, then no empty slots were found
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func FindEmptySlot($bagIndex) ;Parameter = bag index to start searching from. Returns integer with item slot. This function also searches the storage. If any of the returns = 0, then no empty slots were found
	Local $lItemInfo, $aSlot

	For $aSlot = 0 To DllStructGetData(GetBag($bagIndex), 'Slots') - 1
		sleep(40)
		Out("Checking: " & $bagIndex & ", " & $aSlot & @CRLF)
		$lItemInfo = GetItemBySlot($bagIndex, $aSlot)
		If DllStructGetData($lItemInfo, 'ID') = 0 Then
			ConsoleWrite($bagIndex & ", " & $aSlot & "  <-Empty! " & @CRLF)
			$lReturn = $aSlot + 1
			$LastSlot = $aslot + 1
			ExitLoop
		Else
			$lReturn = 0
		EndIf
	Next

	Return $lReturn
EndFunc   ;==>FindEmptySlot
#Region Misc


;=================================================================================================
; Function:			GetNumberOfAlliesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
; Description:		Get number of allies around $aAgent ($aAgent = -2 ourself) within declared range ($fMaxDistance = 1012)
; Parameter(s):		$aAgent: ID of Agent, fMaxDistance: distance to check
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns count of allies
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNumberOfAlliesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
	Local $lDistance, $lCount = 0

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If GetIsDead($lAgentToCompare) <> 0 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'Allegiance') = 0x1 Then
			$lDistance = GetDistance($lAgentToCompare, $aAgent)
			If $lDistance < $fMaxDistance Then
				$lCount += 1
				;ConsoleWrite("Counts: " &$lCount & @CRLF)
			EndIf
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfAlliesInRangeOfAgent

Func GetAgentByLevel($level)
	For $i = 1 To GetMaxAgents()
		$llevel = DllStructGetData(GetAgentByID($i), 'Level')
		If $llevel = $level Then
			Return GetAgentByID($i)
		EndIf
	Next
EndFunc

Func PartyWipeATC()
	Local $Deads = 0
	For $i =1 to GetHeroCount(); wipe party loop
		sleep(100)
		If GetIsDead(GetHeroID($i)) = True Then
			Rndsleep(400)
			$Deads +=1
			Rndsleep(450)
		EndIf
	Next
	If $Deads > 4 Then
		Out("Number of alive heroes " & GetHeroCount() - $Deads)
		Out("Restarting")
		AdlibUnregister("PartyWipeATC") ;Exits PartyWipeATC register check
		MainLoopATC()
	EndIf
EndFunc

Func PartyWipeNorn()
	Local $Deads = 0
	For $i =1 to GetHeroCount(); wipe party loop
		sleep(100)
		If GetIsDead(GetHeroID($i)) = True Then
			Rndsleep(400)
			$Deads +=1
			Rndsleep(450)
		EndIf
	Next
	If $Deads > 4 Then
		Out("Number of alive heroes " & GetHeroCount() - $Deads)
		Out("Restarting")
		AdlibUnRegister("PartyWipeNorn")
		MainLoopNorn()
	EndIf
EndFunc

Func Out($aString)
	FileWriteLine($fLog, @HOUR & ":" & @MIN & ":" & @SEC & " - " & $aString)
	ConsoleWrite(@HOUR & ":" & @MIN & ":" & @SEC & " - " & $aString & @CRLF)
	GUICtrlSetData($gLogBox, GUICtrlRead($gLogBox) & @HOUR & ":" & @MIN & ":" & @SEC & " - " & $aString & @CRLF)
	_GUICtrlEdit_Scroll($gLogBox, 4)
EndFunc   ;==>Out
#endregion OtherFuctions