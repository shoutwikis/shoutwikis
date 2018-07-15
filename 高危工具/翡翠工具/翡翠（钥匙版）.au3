#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


#Region
#include-once
#include <Date.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include "../../激战接口.au3"
#include "辅助功能.au3"
#include <file.au3>
#Include <WinAPI.au3>
#EndRegion

#Region - Vars
Global $iTotalRuns = 0
Global $iTotalImperial = 0
Global $iMaxTotalImperial = 0
Global $iTotalFaction = 0
Global $iMaxTotalFaction = 0
Global $iTotalBalthazar = 0
Global $iMaxTotalBalthazar = 0
Global $CharNameVal = ""
Global $GuildVal = "Luxon"
Global $ImperialForVal = "Balthazar"
Global $FactionForVal = "Alliance"
Global $BalthazarForVal = "Zaishen Keys"
Global $FirstPortal = True
Global $PlayingFor = "Kurzick"
Global $CapThisQuarry
Global $PurpleCapped
Global $YellowCapped
Global $GreenCapped
Global $MID_Zkey = 28517
Global $MyTotalZkeys = 0
Global $LastPortal = 10
Global $GWVersion = 0
Global $RenderCounter = 0
Global $IAmCaster
Global $ChatTimer = TimerInit()
Local $mKernelHandle
Local $mGWProcHandle
Local $mGWHwnd
Local $mMemory
Local $mLabels[1][2]
Local $mBase = 0x00DE0000
Local $mASMString, $mASMSize, $mASMCodeOffset
Local $lDistance

Local $mSkillLogStruct = DllStructCreate('dword;dword;dword;float')
Local $mSkillLogStruct = DllStructCreate('dword;dword;dword;float')
Local $mSkillLogStructPtr = DllStructGetPtr($mSkillLogStruct)
Local $mChatLogStruct = DllStructCreate('dword;wchar[256]')
Local $mChatLogStructPtr = DllStructGetPtr($mChatLogStruct)
GUIRegisterMsg(0x501, 'Event')

Local $mQueueCounter, $mQueueSize, $mQueueBase
Local $mTargetLogBase
Local $mStringLogBase
Local $mSkillBase
Local $mEnsureEnglish
Local $mMyID, $mCurrentTarget
Local $mAgentBase
Local $mBasePointer
Local $mRegion, $mLanguage
Local $mPing
Local $mCharname
Local $mMapID
Local $mMaxAgents
Local $mMapLoading
Local $mMapIsLoaded
Local $mLoggedIn
Local $mStringHandlerPtr
Local $mWriteChatSender
Local $mTraderQuoteID, $mTraderCostID, $mTraderCostValue
Local $mSkillTimer
Local $mBuildNumber
Local $mZoomStill, $mZoomMoving
Local $mDisableRendering
Local $mAgentCopyCount
Local $mAgentCopyBase
Global $AOEDangerXLocation
Global $AOEDangerYLocation
Local $mUseStringLog
Local $mUseEventSystem
#EndRegion Declarations
Local $lAgentArray = GetAgentArray(0xDB)
#Region Variables
Global $MyPlayerNumber
Global Enum $RARITY_White = 0xa3D, $RARITY_Blue = 0xa3F, $RARITY_Purple = 0xa42, $RARITY_Gold = 0xa40, $RARITY_Green = 0xa43
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH
Global Enum $BAG_Backpack = 1, $BAG_BeltPouch, $BAG_Bag1, $BAG_Bag2, $BAG_EquipmentPack, $BAG_UnclaimedItems = 7, $BAG_Storage1, $BAG_Storage2, _
		$BAG_Storage3, $BAG_Storage4, $BAG_Storage5, $BAG_Storage6, $BAG_Storage7, $BAG_Storage8, $BAG_StorageAnniversary
Global Enum $HERO_Norgu = 1, $HERO_Goren, $HERO_Tahlkora, $HERO_MasterOfWhispers, $HERO_AcolyteJin, $HERO_Koss, $HERO_Dunkoro, $HERO_AcolyteSousuke, $HERO_Melonni, _
		$HERO_ZhedShadowhoof, $HERO_GeneralMorgahn, $HERO_MargridTheSly, $HERO_Olias = 14, $HERO_Razah, $HERO_MOX, $HERO_Jora = 18, $HERO_PyreFierceshot, _
		$HERO_Livia = 21, $HERO_Hayda, $HERO_Kahmu, $HERO_Gwen, $HERO_Xandra, $HERO_Vekk, $HERO_Ogden
Global Enum $SKILLTYPE_Stance = 3, $SKILLTYPE_Hex, $SKILLTYPE_Spell, $SKILLTYPE_Enchantment, $SKILLTYPE_Signet, $SKILLTYPE_Condition, $SKILLTYPE_Well, _
		$SKILLTYPE_Skill, $SKILLTYPE_Ward, $SKILLTYPE_Glyph, $SKILLTYPE_Attack = 14, $SKILLTYPE_Shout, $SKILLTYPE_Preparation = 19, _
		$SKILLTYPE_Trap = 21, $SKILLTYPE_Ritual, $SKILLTYPE_ItemSpell = 24, $SKILLTYPE_WeaponSpell, $SKILLTYPE_Chant = 27, $SKILLTYPE_EchoRefrain
Global Enum $ComboReq_FollowsDual = 1, $ComboReq_FollowsLead, $ComboReq_FollowsOffhand = 4
Global Enum $ATTRIB_FastCasting, $ATTRIB_IllusionMagic, $ATTRIB_DominationMagic, $ATTRIB_InspirationMagic, _
		$ATTRIB_BloodMagic, $ATTRIB_DeathMagic, $ATTRIB_SoulReaping, $ATTRIB_Curses, _
		$ATTRIB_AirMagic, $ATTRIB_EarthMagic, $ATTRIB_FireMagic, $ATTRIB_WaterMagic, $ATTRIB_EnergyStorage, _
		$ATTRIB_HealingPrayers, $ATTRIB_SmitingPrayers, $ATTRIB_ProtectionPrayers, $ATTRIB_DivineFavor, _
		$ATTRIB_Strength, $ATTRIB_AxeMastery, $ATTRIB_HammerMastery, $ATTRIB_Swordsmanship, $ATTRIB_Tactics, _
		$ATTRIB_BeastMastery, $ATTRIB_Expertise, $ATTRIB_WildernessSurvival = 24, $ATTRIB_Marksmanship, _
		$ATTRIB_DaggerMastery = 29, $ATTRIB_DeadlyArts, $ATTRIB_ShadowArts, _
		$ATTRIB_Communing, $ATTRIB_RestorationMagic, $ATTRIB_ChannelingMagic, _
		$ATTRIB_CriticalStrikes, _
		$ATTRIB_SpawningPower, _
		$ATTRIB_SpearMastery, $ATTRIB_Command, $ATTRIB_Motivation, $ATTRIB_Leadership, _
		$ATTRIB_ScytheMastery, $ATTRIB_WindPrayers, $ATTRIB_EarthPrayers, $ATTRIB_Mysticism
Global $mSelf
Global $GoPlayer = 0
Global $MyMaxHP
Global Const $Null = 0
Global $AOEDanger = False
Global $AOEDangerRange = 0
Global $AOEDangerXLocation
Global $AOEDangerYLocation
Global $AOEDangerDuration
Global $AOEDangerTimer
Global $mSelfID
Global $mLowestAlly
Global $mLowestAllyHP
Global $mLowestAllyDist
Global $mHighestAlly
Global $mHighestAllyHP
Global $mLowestOtherAlly
Global $mLowestOtherAllyHP
Global $mLowestOtherAllyDist
Global $mHighestOtherAlly
Global $mHighestOtherAllyHP
Global $SpeedBoostTarget
Global $mLowestEnemy
Global $mLowestEnemyHP
Global $mClosestEnemy
Global $mClosestEnemyDist
Global $mBestShrineTarget
Global $mAlliesInRangeOfShrine
Global $mClosestAlly
Global $mClosestAllyDist
Global $mClosestOtherAlly
Global $mClosestOtherAllyDist
Global $mClosestFriendlyQuarry
Global $mClosestFriendlyQuarryDist
Global $mClosestCarrier
Global $mClosestCarrierDist
Global $mAverageTeamHP
Global $mAverageTeamLocationX
Global $mAverageTeamLocationY
Global $TotalAlliesOnMap
Global $NumberOfFoesInAttackRange = 0
Global $NumberOfDeadFoes = 0
Global $NumberOfFoesInSpellRange = 0
Global $NumPlayersInCloseRange = 0
Global $NumAlliesInCloseRange = 0
Global $NumPlayersOnMap = 0
Global $NearestShrineTarget = 0
Global $NearestShrineDist
Global $LeastAttackedShrine = 0
Global $LeastAttackedShrineDist
Global $NearestQuarryTarget = 0
Global $NearestQuarryDist
Global $BestAOETarget
Global $HexedAlly
Global $ConditionedAlly
Global $EnemyHexed
Global $EnemyNonHexed
Global $EnemyConditioned
Global $EnemyNonConditioned
Global $EnemyHealer
Global $EnemyAttacker = 0
Global $ClostestX[1]
Global $ClostestY[1]
Global $mTeam[1] ;Array of living members
Global $mTeamOthers[1] ;Array of living members other than self
Global $mTeamDead[1] ;Array of dead teammates
Global $mEnemies[1] ;Array of living enemy team
Global $mEnemiesRange[1] ;Array of living enemy team in range of waypoint
Global $mEnemiesSpellRange[1] ;Array of living enemy team in spell range
Global $mEnemyCorpesSpellRange[1] ;Array of dead enemy team in spell range
Global $mSpirits[1] ;Array of your spirits
Global $mPets[1] ;Array of your/your hero's pets
Global $mMinions[1] ;Array of your minions
Global Const $BoneHorrorID = 2198
Global $mDazed = False
Global $mBlind = False
Global $mSkillHardCounter = False
Global $mSkillSoftCounter = 0
Global $mAttackHardCounter = False
Global $mAttackSoftCounter = 0
Global $mAllySpellHardCounter = False
Global $mEnemySpellHardCounter = False
Global $mSpellSoftCounter = 0
Global $mBlocking = False
Global $mCastTime = -1
Global $mLastTarget = 0
Global $mMinipet = True
Global $boolRun = False
Global $Goldz = False
Global $boolIDSell = True
Global $boolPickAll = True
Global $intFaction = 0
Global $intTitle = 0
Global $intPrevious = -1
Global $intStarted = -1
Global $intCash = -1
Global $intGold = 0
Global $intRuns = 0
Global $Runs = 0
Global $grog = 30855
Global $golds = 2511
Global $gstones = 27047
Global $tots = 28434
Global $Resigned = False
Global $SavedLeader
Global $SavedLeaderID
Global $NumberInParty
Global $InOutpostCounter = 0
Global $GotBounty = False
Global $Defending = False
Global $CurrentMapID = 0
Global $UpdateText
Global $FirstRun = True
Global $RENDERING = True
Global $GWPID = -1
Global $UseEverlastingTonic = False
Global $HurtTimer = TimerInit()
Global $RestTimer
Global $CurrentHP = 1000
Global $NeedToChangeMap = False
Global $Resting = False
Global $Pink = 9
Global $InAttackRange = False
Global Const $Sunday = "Sunday"
Global Const $Monday = "Monday"
Global Const $Tuesday = "Tuesday"
Global Const $Wednesday = "Wednesday"
Global Const $Thursday = "Thursday"
Global Const $Friday = "Friday"
Global Const $Saturday = "Saturday"
Global $mTempStorage[1][2] = [[0, 0]]
Global $SlotFull[5][25]
Global $NewSlot
Global $mFoundMerch = False
Global $mFoundChest = False
Global $aMerchName = "Merchant"
Global Const $SaveGolds = False ;Save gold items.
Global Const $Bags = 4
Global Const $Ectoplasm = 930
Global Const $ObsidianShards = 945
Global Const $Ruby = 937
Global Const $Sapphire = 938
Global Const $DiessaChalice = 24353
Global Const $GoldenRinRelics = 24354
Global Const $Lockpicks = 22751
Global Const $SuperbCharrCarving = 27052
Global Const $DarkRemains = 522
Global Const $UmbralSkeletalLimbs = 525
Global Const $Scroll_Underworld = 3746
Global Const $Scroll_FOW = 22280
Global Const $MAT_Bone = 921
Global Const $MAT_Dust = 929
Global Const $MAT_Iron = 948
Global Const $MAT_TannedHides = 940
Global Const $MAT_Scales = 953
Global Const $MAT_Chitin = 954
Global Const $MAT_Cloth = 925
Global Const $MAT_Wood = 946
Global Const $MAT_Granite = 955
Global Const $MAT_Fiber = 934
Global Const $MAT_Feathers = 933
Global Const $CON_EssenceOfCelerity = 24859
Global Const $CON_GrailOfMight = 24861
Global Const $CON_ArmorOfSalvation = 24860

Global Const $ENEMY = 0x3
;===========Skills Stuff============;
Global $GetSkillBar = False
Global $mSkillTimer = TimerInit()
Global $mSkillbarCache[9] = [False]
Global $mSkillbarCacheStruct[9] = [False]
Global $mSkillbarCacheEnergyReq[9] = [False]
Global $mEffects
Global $mSkillbar
Global $mEnergy
Global $IsHealingSpell[9] = [False]
Global $IsCorpseSpell[9] = [False]
Global $IsHealingOtherAllySpell[9] = [False]
Global $IsSpeedBoostSkill[9] = [False]
Global $IsSpiritSpell[9] = [False]
Global $IsHexRemover[9] = [False]
Global $IsConditionRemover[9] = [False]
Global $IsAOESpell[9] = [False]
Global $IsGeneralAttackSpell[9] = [False]
Global $IsInterruptSpell[9] = [False]
Global $IsYMLAD[9] = [False]
Global $YMLADSlot = 0
Global $IsRezSpell[9] = [False]
Global $IsSummonSpell[9] = [False]
Global $IsSoulTwistingSpell[9] = [False]
Global $IsSelfCastingSpell[9] = [False]
Global $IsWeaponSpell[9] = [False]
Global $SkillDamageAmount[9] = [False]
Global $SkillAdrenalineReq[9] = [False]
Global $SkillComboFollowsDual[9] = [False]
Global $SkillComboFollowsLead[9] = [False]
Global $SkillComboFollowsOffhand[9] = [False]
Global $IsHealerPrimary = False
Global $Skill_FAILED = 0
Global $EnemyCaster = 0
Global $EnemyCasterTimer
Global $EnemyCasterSkillTime
Global $EnemyCasterActivationTime = 0
Global $lMyProfession
Global $lAttrPrimary
Global $SkillTYP
Global $YMLADTimer = 5000

Const $MK_LBUTTON = 0x0001
Const $MK_RBUTTON = 0x0002

Global $HoMID = 646
Global $EotNID = 642
Global $ArrowHeafExpID = 849
Global $RataSumID = 640
Global $RivenEarthID = 501
Global $DrazachThicketmID = 195
Global $TheEternalGroveID = 222
Global $LongeyesLedgeID = 650
Global $BjoraMarchesID = 482
Global $JagaMoraineID = 546
Global $DrazachThicketmID = 195
Global $TheEternalGroveID = 222
Global $JadeQuarryKurzickID = 296
Global $JadeQuarryLuxonID = 295
Global $JadeQuarryArenaID = 223
Global $GreatTempleOfBalthazarID = 248

Global $ScryingPoolPN = 5864
Global $WhiteMantleZealotPN = 8143
Global $Faction_Kurzick = 1
Global $Faction_Luxon = 2

;; ModelIDs
Global $LuxonLongbowMID = 3081
Global $LuxonStormCallerMID = 3079
Global $LuxonWizardMID = 3077
Global $KurzickFarShotMID = 3080
Global $KurzickThunderMID = 3078
Global $KurzickIllusionistMID = 3076
Global $LuxonBaseDefenderMID = 3083
Global $KurzickBaseDefenderMID = 3082
Global $GreenTurtleMID = 3575
Global $PurpleCarrierJuggernautMID = 3357
;~ Front of Luxon base, 851, 7019
;~ Lux base door 2, 3729, 4538
;~ front of kurzick base, -3850, 1922
;~ kurz door 2, -1272, -716
Global $MapCenter[2] = [-486, 2017]



#EndRegion Variables

#Region CommandStructs
Local $mUseSkill = DllStructCreate('ptr;dword;dword;dword')
Local $mUseSkillPtr = DllStructGetPtr($mUseSkill)

Local $mMove = DllStructCreate('ptr;float;float;float')
Local $mMovePtr = DllStructGetPtr($mMove)

Local $mChangeTarget = DllStructCreate('ptr;dword')
Local $mChangeTargetPtr = DllStructGetPtr($mChangeTarget)

Local $mMove = DllStructCreate('ptr;float;float;float')
Local $mMovePtr = DllStructGetPtr($mMove)

Local $mPacket = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Local $mPacketPtr = DllStructGetPtr($mPacket)

Local $mWriteChat = DllStructCreate('ptr')
Local $mWriteChatPtr = DllStructGetPtr($mWriteChat)

Local $mSellItem = DllStructCreate('ptr;dword;dword')
Local $mSellItemPtr = DllStructGetPtr($mSellItem)

Local $mAction = DllStructCreate('ptr;dword;dword')
Local $mActionPtr = DllStructGetPtr($mAction)

Local $mToggleLanguage = DllStructCreate('ptr;dword')
Local $mToggleLanguagePtr = DllStructGetPtr($mToggleLanguage)

Local $mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Local $mUseHeroSkillPtr = DllStructGetPtr($mUseHeroSkill)

Local $mBuyItem = DllStructCreate('ptr;dword;dword;dword')
Local $mBuyItemPtr = DllStructGetPtr($mBuyItem)

Local $mSendChat = DllStructCreate('ptr;dword')
Local $mSendChatPtr = DllStructGetPtr($mSendChat)

Local $mRequestQuote = DllStructCreate('ptr;dword')
Local $mRequestQuotePtr = DllStructGetPtr($mRequestQuote)

Local $mRequestQuoteSell = DllStructCreate('ptr;dword')
Local $mRequestQuoteSellPtr = DllStructGetPtr($mRequestQuoteSell)

Local $mTraderBuy = DllStructCreate('ptr')
Local $mTraderBuyPtr = DllStructGetPtr($mTraderBuy)

Local $mTraderSell = DllStructCreate('ptr')
Local $mTraderSellPtr = DllStructGetPtr($mTraderSell)

Local $mSalvage = DllStructCreate('ptr;dword;dword;dword')
Local $mSalvagePtr = DllStructGetPtr($mSalvage)

Local $mIncreaseAttribute = DllStructCreate('ptr;dword;dword')
Local $mIncreaseAttributePtr = DllStructGetPtr($mIncreaseAttribute)

Local $mDecreaseAttribute = DllStructCreate('ptr;dword;dword')
Local $mDecreaseAttributePtr = DllStructGetPtr($mDecreaseAttribute)

Local $mMaxAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Local $mMaxAttributesPtr = DllStructGetPtr($mMaxAttributes)

Local $mSetAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Local $mSetAttributesPtr = DllStructGetPtr($mSetAttributes)

Local $mMakeAgentArray = DllStructCreate('ptr;dword')
Local $mMakeAgentArrayPtr = DllStructGetPtr($mMakeAgentArray)
#EndRegion CommandStructs
Global $sMsg, $hProgress, $aRet[2]

Enum	$SKILL_Contagion = 1, _
		$SKILL_DarkAura, _
		$SKILL_DeathNova, _
		$SKILL_PutridBile, _
		$SKILL_ShadowWalk, _
		$SKILL_SignetOfAgony, _
		$SKILL_TouchOfAgony, _
		$SKILL_Dash

Enum	$SHRINE_PurpleQuarry = 1, _
		$SHRINE_YellowQuarry, _
		$SHRINE_GreenQuarry, _
		$SHRINE_PurpleGuard, _
		$SHRINE_YellowKurzGuard, _
		$SHRINE_MiddleKurzGuard, _
		$SHRINE_MiddleLuxGuard, _
		$SHRINE_YellowLuxGuard, _
		$SHRINE_GreenGuard, _
		$SHRINE_LuxBase, _
		$SHRINE_KurzBase

Dim $aShrines[11][2] = [[1579.7390, -2295.26], _      ;purplequarry
					    [-3034.230, 6240.510], _	  ;yellowquarry
					    [5249.4785, 1231.989], _ 	  ;greenquarry
					    [-542.4951, -2066.41], _	  ;purpleguard
					    [-4836.251, 4633.272], _	  ;yellowkurzguard
					    [-1044.872, 2163.458], _      ;middlekurzguard
					    [864.0032, 4244.3945], _	  ;middleluxguard
					    [-1182.46, 8126.49]  , _      ;yellowluxguard
						[5239.0000, 3847.000], _      ;greenguard
						[0.0, 0.0]               , _      ;luxbase
						[0.0, 0.0] ]                   ;kurzbase

Enum	$PORTAL_KurzLeft = 0, _
		$PORTAL_KurzMid, _
		$PORTAL_KurzRight, _
		$PORTAL_LuxLeft, _
		$PORTAL_LuxMid, _
		$PORTAL_LuxRight

Dim $aPortals[6][2] = [	[-4894, -1619], _; oku
						[-3680, -1760], _; -3680 -1761
						[-3244, -2430], _; -3244 -2429
						[5206, 6622], _;
						[4611, 6885], _;
						[4119, 8289]	];

Dim $aTeleports[6][2] = [	[-3290, 2400], _; -3290, 2399
							[-295, 1125], _; -295 1124
							[-650, -720], _; -654 -719
							[3806, 3731], _;
							[1777, 3312], _;
							[667, 6432]	];


#EndRegion


#Region - GUI

Global $boolRun = True
Global $NeedToChangeMap = False
Global $OldGuiText

Initialize("")

Opt("TrayMenuMode", 3)
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)
#NoTrayIcon ; no tray icon
TraySetIcon(@ScriptDir & "\Leader.ico")

Global $StartProgram = TrayCreateItem("暂停")
TrayItemSetOnEvent(-1, "TrayHandler")

Global $RenderMode = TrayCreateItem("成像")
TrayItemSetOnEvent(-1, "TrayHandler")

TrayCreateItem("")

Global $tExit = TrayCreateItem("关闭")
TrayItemSetOnEvent(-1, "TrayHandler")

Func _exit()
	Exit
EndFunc   ;==>_exit

Func TOGGLERENDERING()
	If $RENDERING Then
		DisableRendering()
		WinSetState($mGWHwnd,"",@SW_HIDE)
		$RENDERING = False
	Else
		EnableRendering()
		WinSetState($mGWHwnd,"",@SW_SHOW)
		$RENDERING = True
	EndIf
 EndFunc   ;==>TOGGLERENDERING


Func TrayHandler()
	Switch (@TRAY_ID)
		Case $StartProgram
			$boolRun = Not $boolRun
			If $boolRun Then
				TrayItemSetText($StartProgram, "暂停")
			Else
				TrayItemSetText($StartProgram, "开始")
			EndIf
		Case $RenderMode
			TOGGLERENDERING()
		Case $tExit
			If Not $RENDERING Then TOGGLERENDERING()
			_exit()
	EndSwitch
EndFunc   ;==>TrayHandler

Main()
Func GetAgentPrimaryProfession($aAgent = -2)
	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'Primary')
EndFunc   ;==>GetAgentPrimaryProfession

#Region - Main Funcs
Func GetIsCasterProfession($aAgent = -2)
	Switch GetAgentPrimaryProfession($aAgent)
		Case $PROF_NONE
			Return False
		Case $PROF_WARRIOR
			Return False
		Case $PROF_RANGER
			Return False
		Case $PROF_MONK
			Return True
		Case $PROF_NECROMANCER
			Return True
		Case $PROF_MESMER
			Return True
		Case $PROF_ELEMENTALIST
			Return True
		Case $PROF_ASSASSIN
			Return False
		Case $PROF_RITUALIST
			Return True
		Case $PROF_PARAGON
			Return False
		Case $PROF_DERVISH
			Return False
		Case Else
			Return False
	EndSwitch
 EndFunc   ;==>GetIsCasterProfession
 Func _PurgeHook()
	Update("Purging engine hook")
	EnableRendering()
	Sleep(Random(4000, 5000))
	DisableRendering()
 EndFunc   ;==>_PurgeHook
 Func UpdateStatus($text, $flag = 0)
	If $OldGuiText == $text Then Return
	$MyName = GetCharname()
	$ChatTimer = TimerInit()
	$OldGuiText = $text
	TraySetToolTip($MyName & @CRLF & $text & @CRLF & $MyTotalZkeys & " zkeys.")
;~ 	WriteChat($text, "JQ Bot")

;~ 	;Write new line at begining of file
	_FileWriteLog(@ScriptDir & "\" & $MyName & ".log", $text, 0)
	Sleep(10)
	If FileGetSize(@ScriptDir & "\" & $MyName & ".log") > 2048 Then
		$hFile = _WinAPI_CreateFile(@ScriptDir & "\" & $MyName & ".log", 2, 6, 6)
		_WinAPI_SetFilePointer($hFile, 2048) ; make the value a bit smaller than the max size if writing to log very frequently
		_WinAPI_SetEndOfFile($hFile)
		_WinAPI_CloseHandle($hFile)
	EndIf

EndFunc   ;==>UpdateStatus

Func TradeKurzickX($GuildVal)
	UpdateStatus("Trading Kurzick")
	If GetMapID() == $JadeQuarryLuxonID Then
		TravelTo($JadeQuarryKurzickID)
	EndIf
	If GetMapID() == $JadeQuarryKurzickID Then
		Sleep(Random(750, 3000, 1))
		$npc = GetAgentByName("Kurzick Bureaucrat [Faction Rewards]") ; GetNearestNPCToCoords(-2706, -6802)
		RndSleep(500)
		GoToNPC($npc)
		While GetKurzickFaction() >= 5000
			RndSleep(500)
			If $GuildVal = "Kurzick" Then
				Dialog(0x87) ; Donate Faction to Guild
				RndSleep(500)
				DonateFaction("k");
			Else
				Dialog(0x84) ; Purchase Amber Chunks using faction
				RndSleep(1500)
				Dialog(0x800101) ; Purchase 1 Amber Chunk
				RndSleep(1500)
				GoNPC($npc)
			EndIf
		WEnd
		Sleep(Random(500, 2500, 1))
		Switch Random(1, 5, 1)
			Case 1, 2
				Move(-3141, -6809, 300)
			Case 3
				MoveTo(-3141, -6809, 300)
				Move(-3141, -6809, 300)
			Case 4
				GoToNPCNearestCoords(-2805, -6366)
			Case 5
				GoToNPCNearestCoords(-3699, -7362)
		EndSwitch
	EndIf
 EndFunc   ;==>TradeBalthazarX
 Func TradeLuxonX($GuildVal)
	UpdateStatus("Trading Luxon")
	If GetMapID() == $JadeQuarryKurzickID Then
		TravelTo($JadeQuarryLuxonID)
	EndIf
	If GetMapID() == $JadeQuarryLuxonID Then
		Sleep(Random(750, 3000, 1))
		$npc = GetAgentByName("Luxon Scavenger [Faction Rewards]")
		RndSleep(500)
		GoToNPC($npc)
		While GetLuxonFaction() >= 5000
			RndSleep(500)
			If $GuildVal = "Luxon" Then
				Dialog(0x87) ; Donate Faction to Guild
				RndSleep(500)
				DonateFaction("l");
			Else
				Dialog(0x84) ; Purchase Jadeite Shards using faction
				RndSleep(1500)
				Dialog(0x800101) ; Purchase 1 Jadeite Shard
				RndSleep(1500)
				GoNPC($npc)
			EndIf
		WEnd
		Sleep(Random(500, 2500, 1))
	EndIf
 EndFunc   ;==>TradeBalthazarX
 Func CountItemInBagsByModelID($ItemModelID)
	$Count = 0
	For $i = $BAG_Backpack To $BAG_Bag2
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItemInfo = GetItemBySlot($i, $j)
			If DllStructGetData($lItemInfo, 'ModelID') = $ItemModelID Then $Count += DllStructGetData($lItemInfo, 'quantity')
		Next
	Next
	Return $Count
 EndFunc   ;==>CountItemInBagsByModelID
 Func GoToNPCNearestCoords($x, $y)
	Local $guy, $Me
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc   ;==>GoToNPCNearestCoords
 Func TradeBalthazarX($Balthazar)
	UpdateStatus("Trading Balthazar")
	$MyName = GetCharname()
	If GetMapID() == $JadeQuarryKurzickID Then
		Sleep(Random(750, 3000, 1))
		$npc = GetAgentByName("Tolkano [Tournament]") ; GetNearestNPCToCoords(-2706, -6802)
		RndSleep(500)
		If $Balthazar == "Zaishen Keys" Then
            GoToNPC($npc)
			While GetBalthazarFaction() >= 5000
				RndSleep(500)
				Dialog(0x87) ;; Purchase Zkeys using faction
				RndSleep(1500)
				Dialog(0x88) ;; Purchase 1 Zkey
				RndSleep(1500)
				$MyTotalZkeys = CountItemInBagsByModelID($MID_Zkey)
;~ 				$aRet = _Toast_Show(0, $MyName, "Has " & $MyTotalZkeys & " Zkeys!     " & @CRLF & "Completed " & $iTotalRuns & " runs." , 3, False)
				TraySetToolTip($MyName & @CRLF & "Has " & $MyTotalZkeys & " Zkeys!")
			WEnd
			Sleep(Random(500, 2500, 1))
			Switch Random(1, 5, 1)
				Case 1, 2
					Move(-3141, -6809, 300)
				Case 3
					MoveTo(-3141, -6809, 300)
					Move(-3141, -6809, 300)
				Case 4
					GoToNPCNearestCoords(-2805, -6366)
				Case 5
					GoToNPCNearestCoords(-3699, -7362)
			EndSwitch
		EndIf
	ElseIf GetMapID() == $JadeQuarryLuxonID Then
		$npc = GetAgentByName("Tolkano [Tournament]") ; GetNearestNPCToCoords(3585, 13641)
		Sleep(Random(750, 3000, 1))
		RndSleep(500)
		If $Balthazar == "Zaishen Keys" Then
            GoToNPC($npc)
			While GetBalthazarFaction() >= 5000
				RndSleep(500)
				Dialog(0x87) ;; Purchase Zkeys using faction
				RndSleep(1500)
				Dialog(0x88) ;; Purchase 1 Zkey
				RndSleep(1500)
				$MyTotalZkeys = CountItemInBagsByModelID($MID_Zkey)
;~ 				If $MyTotalZkeys / 10
;~ 				$aRet = _Toast_Show(0, $MyName, "Has " & $MyTotalZkeys & " Zkeys!     " & @CRLF & "Completed " & $iTotalRuns & " runs." , 3, False)
				TraySetToolTip($MyName & @CRLF & "Has " & $MyTotalZkeys & " Zkeys!")
			WEnd
			Sleep(Random(500, 2500, 1))
			Switch Random(1, 5, 1)
				Case 1, 2
					Move(3806, 13220, 250)
				Case 3
					MoveTo(3806, 13220, 250)
					Move(3806, 13220, 250)
				Case 4
					GoToNPCNearestCoords(3438, 13186)
				Case 5
					GoToNPCNearestCoords(4162, 13278)
			EndSwitch
		EndIf
	Else
		UpdateStatus("Wrong Map")
	EndIf
 EndFunc   ;==>TradeBalthazarX
 Func TradeImperialX($Imperial)
	UpdateStatus("Trading Imperial")
	If GetMapID() == $JadeQuarryKurzickID Then
		$npc = GetNearestNPCToCoords(-3298, -7560)
		GoToNPC($npc)
		Sleep(Random(750, 3000, 1))
		If $Imperial == "Balthazar" Then
			Dialog(0x97) ;Trade for Balthazar
			RndSleep(1500)
			Dialog(0xA3) ;Trade all Balthazar faction
			RndSleep(2000)
		EndIf
		If $Imperial == "Kurzick" Then
			Dialog(0x95) ;Trade for Kurzick
			RndSleep(1500)
			Dialog(0xA1) ;Trade all Kurzick faction
			RndSleep(2000)
		EndIf
		If $Imperial == "Luxon" Then
			Dialog(0x96) ;Trade for Luxon
			RndSleep(1500)
			Dialog(0xA2) ;Trade all Luxon faction
			RndSleep(2000)
		EndIf
	ElseIf GetMapID() == $JadeQuarryLuxonID Then
		$npc = GetNearestNPCToCoords(2472, 11757)
		GoToNPC($npc)
		Sleep(Random(750, 3000, 1))
		If $Imperial == "Balthazar" Then
			Dialog(0x97) ;Trade for Balthazar
			RndSleep(1500)
			Dialog(0xA3) ;Trade all Balthazar faction
			RndSleep(2000)
		EndIf
        If $Imperial == "Kurzick" Then
			Dialog(0x95) ;Trade for Kurzick
			RndSleep(1500)
			Dialog(0xA1) ;Trade all Kurzick faction
			RndSleep(2000)
		EndIf
		If $Imperial == "Luxon" Then
			Dialog(0x96) ;Trade for Luxon
			RndSleep(1500)
			Dialog(0xA2) ;Trade all Luxon faction
			RndSleep(2000)
		EndIf
	Else
		UpdateStatus("Wrong Map")
	EndIf
EndFunc   ;==>TradeImperialX
Func Main()
	Sleep(5000)

	While 1
		Sleep(100)
		If $boolRun Then
			If GetAgentExists(-2) == False And WinExists(GetWindowHandle()) Then
				Local $Sleeper = 1000
				Do
					Sleep(7000 + $Sleeper)
					$Sleeper += 1000
					ControlSend(GetWindowHandle(), "", "", "{Enter}")
				Until GetAgentExists(-2) == True Or $Sleeper > 10000
			EndIf
			Sleep(Random(1000, 2000, 1))
			$IAmCaster = GetIsCasterProfession()
			While $boolRun
				$aProcessList = ProcessList("Gw.exe") ; Closed Crashed GW
				Sleep(3000)


				If $ImperialForVal = "Kurzick" Then
					$iTotalImperial = GetImperialFaction()
					UpdateStatus("Imperial : " & $iTotalImperial)
					$iTotalKurzick = GetKurzickFaction()
					UpdateStatus("Kurzick : " & $iTotalKurzick)
					If $iTotalKurzick > 5001 Then
						TradeKurzickX($GuildVal)
                        If $PlayingFor == "Luxon" Then
                            TravelTo($JadeQuarryLuxonID) ; Travel back to Luxon territory
                        EndIf
					EndIf
					If $iTotalImperial >= 5001 Then
						TradeImperialX($ImperialForVal)
					EndIf
					If $BalthazarForVal = "Zaishen Keys" Then
						$iTotalBalthazar = GetBalthazarFaction()
						RndSleep(250)
						UpdateStatus("Balthazar : " & $iTotalBalthazar)
						If ($iTotalBalthazar >= 5001) Then
							TradeBalthazarX($BalthazarForVal)
						EndIf
					EndIf
				ElseIf $ImperialForVal = "Luxon" Then
					$iTotalImperial = GetImperialFaction()
					UpdateStatus("Imperial : " & $iTotalImperial)
					$iTotalLuxon = GetLuxonFaction()
					UpdateStatus("Luxon : " & $iTotalLuxon)
					If $iTotalLuxon > 5001 Then
						TradeLuxonX($GuildVal)
                        If $PlayingFor == "Kurzick" Then
                            TravelTo($JadeQuarryKurzickID) ; Travel back to Kurzick territory
                        EndIf
					EndIf
					If $iTotalImperial >= 5001 Then
						TradeImperialX($ImperialForVal)
					EndIf
					If $BalthazarForVal = "Zaishen Keys" Then
						$iTotalBalthazar = GetBalthazarFaction()
						RndSleep(250)
						UpdateStatus("Balthazar : " & $iTotalBalthazar)
						If ($iTotalBalthazar >= 5001) Then
							TradeBalthazarX($BalthazarForVal)
						EndIf
					EndIf
				ElseIf $ImperialForVal = "Balthazar" Then
					$iTotalImperial = GetImperialFaction()
					Local $ImperialValOfBalth = $iTotalImperial / 3
					UpdateStatus("Imperial : " & $iTotalImperial)
					$iTotalBalthazar = GetBalthazarFaction()
					If $ImperialValOfBalth + $iTotalBalthazar > 5001 Then
						TradeBalthazarX($BalthazarForVal)
					EndIf
					If ($iTotalImperial >= 5001) Then
						TradeImperialX($ImperialForVal)
					EndIf
				EndIf

				RndSleep(500)
				BotLoop()
			WEnd
		Else
			EnableRendering()
			UpdateStatus("Bot Closed.")
			Exit
		EndIf
	WEnd

EndFunc

Func _StopGame($Text)
	$boolRun = Not $boolRun
	If $boolRun Then
		TrayItemSetText($StartProgram, "Stop After Match")
	Else
		TrayItemSetText($StartProgram, "Start JQ Bot")
	EndIf
EndFunc
Func WaitAlive()
	UpdateStatus("Waiting to Res")
	Local $lMe
	Do
		Sleep(750)
	Until GetIsDead(-2) == False Or GameOver()
 EndFunc   ;==>WaitAlive
 Func GameOver()
	Local $ImperialNow = GetImperialFaction()
	Local $NewImperial = $ImperialNow - $iTotalImperial
	Local $WinLoose = False
	If $NewImperial > 1000 Then
		If $NewImperial > 3800 Then
			;$WinLoose = True
			UpdateStatus("We won and got " & $NewImperial & " faction!")
		Else
			;$WinLoose = True
			UpdateStatus("We lost and got " & $NewImperial & " faction!")
		EndIf
	Else
		$iTotalImperial = $ImperialNow
;~ 		UpdateStatus("We got " & $NewImperial & " faction!")
	EndIf

	If GetMapID() <> $JadeQuarryArenaID Or GetMapLoading() == $INSTANCETYPE_LOADING Or $WinLoose Then
		Sleep(Random(15000, 18000, 1))
		$iTotalRuns += 1
		UpdateStatus("Completed Run #" & $iTotalRuns & ".")
;~ 		$aRet = _Toast_Show(0, GetCharname(), "Completed Run #" & $iTotalRuns & ".", 3, False)
		RndSleep(1000)
		Main()
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>GameOver
Func BotLoop()
	Local $RandomPortal
	If GetMapID() == $JadeQuarryKurzickID Then
		$PlayingFor = "Kurzick"
	ElseIf GetMapID() == $JadeQuarryLuxonID Then
		$PlayingFor = "Luxon"
	;Else
	;	TravelTo($JadeQuarryLuxonID)
	;	$PlayingFor = "Luxon"
	EndIf
	OutpostCheck()
	ClearMemory()
	Sleep(400)

	UpdateStatus("Entering Battle.")
	If GetEffectTimeRemaining(2546) > 0 Then
		UpdateStatus("Wait for Dishonorable.")
		Sleep(GetEffectTimeRemaining(2546) + 2000) ; Dishonorable
	EndIf
	If GetMapLoading() == $INSTANCETYPE_OUTPOST Then EnterChallenge()
	Do
		Sleep(1000)
	Until GetMapID() == $JadeQuarryArenaID

	Sleep(Random(1000, 5000))
	If GetMapID() = $JadeQuarryArenaID Then
		$PurpleCapped = False
		$YellowCapped = False
		$GreenCapped = False
		Local $Me = GetAgentByID(-2)
		$MyPlayerNumber = DllStructGetData($Me, 'PlayerNumber')

		Do
			If $PlayingFor == "Kurzick" Then
			Do
				$RandomPortal = Random(0, 2, 1)
			Until $LastPortal <> $RandomPortal ; Don't go through same portal twice
			Else
				Do
					$RandomPortal = Random(3, 5, 1)
				Until $LastPortal <> $RandomPortal
			EndIf
			$LastPortal = $RandomPortal
			WaitAlive()
			;GameOver()
			GoPortal($RandomPortal)
			RndSleep(250)
			;GameOver()
			ShrineSearch()
		Until GameOver()
		UpdateStatus("Loading JQ Match.")
	EndIf
EndFunc
Func XLocation($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'X')
EndFunc   ;==>XLocation

;~ Description: Agents Y Location
Func YLocation($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'Y')
EndFunc   ;==>YLocation

;~ Description: Agents X and Y Location
Func XandYLocation($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Local $Location[2]
	$Location[0] = DllStructGetData($aAgent, 'X')
	$Location[1] = DllStructGetData($aAgent, 'Y')
	Return $Location
EndFunc   ;==>XandYLocation


Func GoPortal($iPortal)
	UpdateStatus("Moving to portal: #" & $iPortal)

	Local $lBlocked = 0
	Local $lMe
	Local $lAngle = 0
	Local $tEscape = TimerInit()
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $distance = 1000
	Local $MadeToPortal = False
	Local $DistanceToPortal
	$lMe = GetAgentByID(-2)
	$Random = Random(1, 1500)
	Sleep($Random)

	Move($aPortals[$iPortal][0], $aPortals[$iPortal][1], 30)

	Do
		Sleep(250)

		If GetIsDead($lMe) Then ExitLoop
		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		If GetIsMoving(-2) = False AND TimerDiff($tEscape) > 40000 Then
			Move($aPortals[$iPortal][0], $aPortals[$iPortal][1], 5)
			If TimerDiff($tEscape) > 60000 Then
				$lAngle += 40
				Move(XLocation() + 200 * Sin($lAngle), YLocation() + 200 * Cos($lAngle))
				Sleep(2000)
				Move($aPortals[$iPortal][0], $aPortals[$iPortal][1], 5)
				Sleep(500)
			EndIf
		EndIf
		$lMe = GetAgentByID(-2)
		$distance = ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $aTeleports[$iPortal][0], $aTeleports[$iPortal][1])
	Until  $distance < 400
	Return 1
 EndFunc
Func GetAgentID($aAgent)
	If IsDllStruct($aAgent) = 0 Then
		Local $lAgentID = ConvertID($aAgent)
		If $lAgentID = 0 Then Return ''
	Else
		Local $lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf
	Return $lAgentID
 EndFunc   ;==>GetAgentID
 Func GetIsQuarryNPC($ModelID)
	Switch $ModelID
		Case $KurzickThunderMID, $KurzickIllusionistMID, $LuxonStormCallerMID, $LuxonWizardMID, $LuxonLongbowMID, $KurzickFarShotMID
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>GetIsQuarryNPC
 Func GetNearestQuarryAgentToCoords($aX, $aY) ; FRIEND OR FOE!
	Local $lNearestAgent[2] = [0, 5000], $lNearestDistance = 2000
	Local $lDistance
	Local $lID = GetAgentID(-2)

	Local $lAgentArray = GetAgentArray(0xDB)

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop
		If GetIsQuarryNPC(DllStructGetData($lAgentArray[$i], 'PlayerNumber')) == False Then ContinueLoop
		$lDistance = ComputeDistance($aX, $aY, DllStructGetData($lAgentArray[$i], 'X'), DllStructGetData($lAgentArray[$i], 'Y'))
		If $lDistance < $lNearestDistance Then
			$lNearestAgent[0] = $lAgentArray[$i]
			$lNearestAgent[1] = $lDistance
			$lNearestDistance = $lDistance
		EndIf
	Next

	Return $lNearestAgent
EndFunc   ;==>GetNearestQuarryAgentToCoords

Func CheckQuarry() ; Return non captured quarries
	Local $target
	Local $distance
	Local $MyDistance
	For $iShrine = 0 To 2
		If $iShrine == 0 And $PurpleCapped == True Then ContinueLoop
		If $iShrine == 1 And $YellowCapped == True Then ContinueLoop
		If $iShrine == 2 And $GreenCapped == True Then ContinueLoop
		$distance = GetNearestQuarryAgentToCoords($aShrines[$iShrine][0], $aShrines[$iShrine][1])
		$MyDistance = ComputeDistance(XLocation(), YLocation(), $aShrines[$iShrine][0], $aShrines[$iShrine][1])
		If $distance[1] > 1420 And $MyDistance < 4500 And $MyDistance > 1000 Then
			If $iShrine + 1 == $SHRINE_PurpleQuarry Then $PurpleCapped = True
			If $iShrine + 1 == $SHRINE_YellowQuarry Then $YellowCapped = True
			If $iShrine + 1 == $SHRINE_GreenQuarry Then $GreenCapped = True
			Return $iShrine
		EndIf
	Next

	Return 50
EndFunc
Func GetIsKurzickNPC($ModelID)
	Switch $ModelID
		Case $KurzickFarShotMID, $KurzickThunderMID, $KurzickIllusionistMID
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>GetIsKurzickNPC
func GetIsShrineNPCEnemy($ModelID)
	If $PlayingFor == "Kurzick" Then
		Return GetIsLuxonNPC($ModelID)
	Else
		Return GetIsKurzickNPC($ModelID)
	EndIf
EndFunc   ;==>GetIsShrineNPCEnemy

Func CloseToQuarry() ; checks my distance to quarries
	Local $MyDistance
	For $iShrine = 0 To 2
		$MyDistance = ComputeDistance(XLocation(), YLocation(), $aShrines[$iShrine][0], $aShrines[$iShrine][1])
		If $MyDistance < 1500 Then
			Return True
		EndIf
	Next
	Return False
 EndFunc
 Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $fMaxDistance = 4500)
	Local $lDistance, $lCount = 0

	Local $lAgentArray = GetAgentArray(0xDB)

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop
		Switch DllStructGetData($lAgentArray[$i], 'PlayerNumber')
			Case $LuxonBaseDefenderMID, $KurzickBaseDefenderMID, $GreenTurtleMID, $PurpleCarrierJuggernautMID
				ContinueLoop
		EndSwitch
		$lDistance = ComputeDistance(DllStructGetData($aAgent, 'X'), DllStructGetData($aAgent, 'Y'), DllStructGetData($lAgentArray[$i], 'X'), DllStructGetData($lAgentArray[$i], 'Y'))
		If $lDistance < $fMaxDistance Then
			$lCount += 1
		EndIf
	Next
	Return $lCount
 EndFunc   ;==>GetNumberOfFoesInRangeOfAgent


Func GetIsShrineNPCAlly($ModelID)
	If $PlayingFor == "Kurzick" Then
		Return GetIsKurzickNPC($ModelID)
	Else
		Return GetIsLuxonNPC($ModelID)
	EndIf
EndFunc   ;==>GetIsShrineNPCAlly



Func GetIsLuxonNPC($ModelID)
	Switch $ModelID
		Case $LuxonLongbowMID, $LuxonStormCallerMID, $LuxonWizardMID
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>GetIsLuxonNPC

Func GetIsQuarryNPCEnemy($ModelID)
	If $PlayingFor == "Kurzick" Then
		Return GetIsLuxonQuarryNPC($ModelID)
	Else
		Return GetIsKurzickQuarryNPC($ModelID)
	EndIf
EndFunc   ;==>GetIsQuarryNPCEnemy

Func GetIsQuarryNPCAlly($ModelID)
	If $PlayingFor == "Kurzick" Then
		Return GetIsKurzickQuarryNPC($ModelID)
	Else
		Return GetIsLuxonQuarryNPC($ModelID)
	EndIf
EndFunc   ;==>GetIsQuarryNPCAlly

Func GetIsKurzickQuarryNPC($ModelID)
	Switch $ModelID
		Case $KurzickThunderMID, $KurzickIllusionistMID
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>GetIsKurzickQuarryNPC

Func GetIsLuxonQuarryNPC($ModelID)
	Switch $ModelID
		Case $LuxonStormCallerMID, $LuxonWizardMID
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>GetIsLuxonQuarryNPC

Func GetIsHealer($Agent)
	If DllStructGetData($Agent, 'Primary') == $Ritualist Or DllStructGetData($Agent, 'Secondary') == $Ritualist Then Return True
	If DllStructGetData($Agent, 'Primary') == $Monk Or DllStructGetData($Agent, 'Secondary') == $Monk Then Return True
	Return False
EndFunc   ;==>GetIsHealer
Func UpdateWorld($aRange = 1500)
	Local $LocationCount = 0
	$aRange = $aRange ^ 2
	$mSelfID = GetMyID()
	$mSelf = GetAgentByID($mSelfID)
	If GetIsDead($mSelf) Then Return False
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return True
	$mEnergy = DllStructGetData($mSelf, 'EnergyPercent') * DllStructGetData($mSelf, 'MaxEnergy')
	$mEffects = GetEffect()

	$mDazed = False
	$mBlind = False
	$mSkillHardCounter = False
	$mSkillSoftCounter = 0
	$mAttackHardCounter = False
	$mAttackSoftCounter = 0
	$mAllySpellHardCounter = False
	$mEnemySpellHardCounter = False
	$mSpellSoftCounter = 0
	$mBlocking = False

	For $i = 1 To $mEffects[0]
		Switch DllStructGetData($mEffects[$i], 'SkillID')
			Case $Dazed
				$mDazed = True
			Case $Blind
				$mBlind = True
			Case $Diversion, $Wail_of_Doom
				$mSkillHardCounter = True
			Case $Shame, $Mark_of_Subversion
				$mAllySpellHardCounter = True
			Case $Guilt, $Mistrust, 3191
				$mEnemySpellHardCounter = True
			Case $Visions_of_Regret, 3234
				$mSkillSoftCounter += 1
				$mSpellSoftCounter += 1
				$mAttackSoftCounter += 1
			Case $Backfire, $Soul_Leech
				$mSpellSoftCounter += 1
			Case $Ineptitude, $Clumsiness, $Yuletide, $Wandering_Eye, 3195
				$mAttackHardCounter = True
			Case $Insidious_Parasite, $Empathy, 3151, $Spiteful_Spirit, $Price_of_Failure, $Spirit_Shackles
				$mAttackSoftCounter += 1
			Case $Bonettis_Defense, $Protectors_Defense ;Not Finished
				$mBlocking = True
		EndSwitch
	Next

	Local $lAgent
	Local $lTeam = DllStructGetData($mSelf, 'Team')
	Local $lX = XLocation()
	Local $lY = YLocation()
	Local $lHP
	Local $lDistance
	Local $lModel
	Local $lCountAOE = 1

	Dim $mTeam[1] = [0]
	Dim $mTeamOthers[1] = [0]
	Dim $mTeamDead[1] = [0]
	Dim $mEnemies[1] = [0]
	Dim $mEnemiesRange[1] = [0]
	Dim $mEnemiesSpellRange[1] = [0]
	Dim $mEnemyCorpesSpellRange[1] = [0]
	Dim $mSpirits[1] = [0]
	Dim $mPets[1] = [0]
	Dim $mMinions[1] = [0]

	$mHighestAlly = $mSelf
	$mHighestAllyHP = 2
	$mLowestAlly = $mSelf
	$mLowestAllyHP = 2
	$mLowestAllyDist = 25000000
	$mLowestOtherAlly = 0
	$mLowestOtherAllyHP = 2
	$mLowestOtherAllyDist = 25000000
	$mHighestOtherAlly = 0
	$mHighestOtherAllyHP = 0
	$SpeedBoostTarget = 0
	$mLowestEnemy = 0
	$mLowestEnemyHP = 2
	$mBestShrineTarget = 0
	$mAlliesInRangeOfShrine = 100
	Local $mAlliesInRange = 1000
	$mClosestEnemy = 0
	$mClosestEnemyDist = 25000000
	$mClosestAlly = 0
	$mClosestAllyDist = 25000000
	$mClosestOtherAlly = 0
	$mClosestOtherAllyDist = 25000000
	$mClosestFriendlyQuarry = 0
	$mClosestFriendlyQuarryDist = 25000000
	$mClosestCarrier = 0
	$mClosestCarrierDist = 25000000
	$mAverageTeamHP = 0
	$BestAOETarget = 0
	$HexedAlly = 0
	$ConditionedAlly = 0
	$HexedEnemy = 0
	$EnemyNonHexed = 0
	$EnemyConditioned = 0
	$EnemyNonConditioned = 0
	$EnemyHealer = 0
	$NumberOfFoesInAttackRange = 0
	$NumberOfDeadFoes = 0
	$NumberOfFoesInSpellRange = 0
	$NumPlayersInCloseRange = 0
	$NumAlliesInCloseRange = 0
	$NumPlayersOnMap = -1
	$NearestShrineTarget = 0
	$NearestShrineDist = 25000000
	$LeastAttackedShrine = 0
	$LeastAttackedShrineDist = 25000000
	$NearestQuarryTarget = 0
	$NearestQuarryDist = 25000000
	$mAverageTeamLocationX = 0
	$mAverageTeamLocationY = 0
	$TotalAlliesOnMap = 0
	$EnemyAttacker = 0
	$EnemyCaster = 0

	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		$lAgent = $lAgentArray[$i]
		$lHP = DllStructGetData($lAgent, 'HP')
		$lDistance = ($lX - DllStructGetData($lAgent, 'X')) ^ 2 + ($lY - DllStructGetData($lAgent, 'Y')) ^ 2
		Switch DllStructGetData($lAgent, 'Allegiance')
			Case 1, 6 ;Allies
				If Not BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ; Not Dead
					$lModel = DllStructGetData($lAgent, 'PlayerNumber')
					If $lDistance <= 1562500 Then ; 1250, spell cast range
						If $lModel == $GreenTurtleMID Or $lModel == $PurpleCarrierJuggernautMID Then
							$SpeedBoostTarget = $lAgent
						EndIf
					EndIf
					If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop ;Not Team, minion, or pet.
					If $lDistance <= 90000 Then ; 300, Allies in close range
						$NumAlliesInCloseRange += 1
;~ 						Closest Ally
						If $lDistance < $mClosestAllyDist And $mSelfID <> DllStructGetData($lAgent, 'ID') Then
							$mClosestAllyDist = $lDistance
							$mClosestAlly = $lAgent
						EndIf
					EndIf

;~ 					Closest Other Ally
					If $lDistance < $mClosestOtherAllyDist And $mSelfID <> DllStructGetData($lAgent, 'ID') Then
						$mClosestOtherAllyDist = $lDistance
						$mClosestOtherAlly = $lAgent
					EndIf

;~ 					Closest Ally Quarry
					If $lDistance < $mClosestFriendlyQuarryDist And GetIsQuarryNPCAlly($lModel) Then
						$mClosestFriendlyQuarryDist = $lDistance
						$mClosestFriendlyQuarry = $lAgent
					EndIf

					If $lDistance <= 1960000 Then ; 1400
;~ 					Lowest Ally
						If $lHP < 0.75 Then
							$mLowestAlly = $lAgent
							$mLowestAllyHP = $lHP
							$mLowestAllyDist = $lDistance
						ElseIf $lHP = $mLowestAllyHP Then
							If $lDistance < ($lX - DllStructGetData($mLowestAlly, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestAlly, 'Y')) ^ 2 Then
								$mLowestAlly = $lAgent
								$mLowestAllyHP = $lHP
							EndIf
						ElseIf $lHP > $mHighestAllyHP Then ; Highest Ally
							$mHighestAlly = $lAgent
							$mHighestAllyHP = $lHP
						EndIf

						If GetHasHex($lAgent) == True Then $HexedAlly = $lAgent
						If GetHasCondition($lAgent) == True Then $ConditionedAlly = $lAgent

;~ 					Other Allies
						If $i <> $mSelfID Then
;~ 						Lowest Other Ally
							If $lHP < $mLowestOtherAllyHP Then
								$mLowestOtherAlly = $lAgent
								$mLowestOtherAllyHP = $lHP
								$mLowestOtherAllyDist = $lDistance
							ElseIf $lHP = $mLowestOtherAllyHP Then
								If $lDistance < ($lX - DllStructGetData($mLowestOtherAlly, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestOtherAlly, 'Y')) ^ 2 Then
									$mLowestOtherAlly = $lAgent
									$mLowestOtherAllyHP = $lHP
								EndIf
							ElseIf $lHP > $mHighestOtherAllyHP Then ; Highest Ally
								$mHighestOtherAlly = $lAgent
								$mHighestOtherAllyHP = $lHP
							EndIf
						EndIf
					EndIf
					$mAverageTeamLocationX += DllStructGetData($lAgent, 'X')
					$mAverageTeamLocationY += DllStructGetData($lAgent, 'Y')
					$TotalAlliesOnMap += 1
				Else
;~ 					Dead Allies
				EndIf
			Case 3 ;Enemies
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ; Dead Enemies
					If $lDistance <= 1537600 Then ;1240
						$NumberOfDeadFoes += 1
					EndIf
				Else
;~ 				Skip these guys
					$lModel = DllStructGetData($lAgent, 'PlayerNumber')
					Switch $lModel
						Case $LuxonBaseDefenderMID, $KurzickBaseDefenderMID
							ContinueLoop
						Case $GreenTurtleMID, $PurpleCarrierJuggernautMID
							If $IAmCaster == False Then
								If $lDistance <= 3240000 Then ; 1800
									$mClosestCarrier = $lAgent
									$mClosestCarrierDist = $lDistance
								Else
									ContinueLoop
								EndIf
							Else
								ContinueLoop
							EndIf
					EndSwitch

					If $lDistance <= $aRange Then
						$NumberOfFoesInAttackRange += 1

;~ 					Lowest Enemy
						If $lHP < $mLowestEnemyHP Then
							$mLowestEnemy = $lAgent
							$mLowestEnemyHP = $lHP
						ElseIf $lHP = $mLowestEnemyHP Then
							If $lDistance < ($lX - DllStructGetData($mLowestEnemy, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestEnemy, 'Y')) ^ 2 Then
								$mLowestEnemy = $lAgent
								$mLowestEnemyHP = $lHP
							EndIf
						EndIf

						If GetNumberOfFoesInRangeOfAgent($lAgent, 256) > $lCountAOE Then
							$BestAOETarget = $lAgent
							$lCountAOE += 1
						EndIf

						If GetHasHex($lAgent) == True Then
							$EnemyHexed = $lAgent
						Else
							$EnemyNonHexed = $lAgent
						EndIf

						If GetHasCondition($lAgent) == True Then
							$EnemyConditioned = $lAgent
						Else
							$EnemyNonConditioned = $lAgent
						EndIf

						If GetIsHealer($lAgent) Then $EnemyHealer = $lAgent
					EndIf

;~ 			Closest Enemy
					If $lDistance < $mClosestEnemyDist And $lHP > 0 Then
						$mClosestEnemyDist = $lDistance
						$mClosestEnemy = $lAgent
					EndIf

					If GetIsShrineNPCEnemy($lModel) Then
;~ 				Closest Enemy Shrine NPC
						If $lDistance < $NearestShrineDist Then
							$NearestShrineDist = $lDistance
							$NearestShrineTarget = $lAgent
						EndIf

;~				Enemy Shrine with fewest allies attacking it
						$ClosestAllyToShrine = GetNearestAllyToAgent($lAgent) ; array, agent [0], distance [1]
						If $ClosestAllyToShrine[1] > $LeastAttackedShrineDist Then
							$LeastAttackedShrine = $lAgent
							$LeastAttackedShrineDist = $ClosestAllyToShrine[1]
						EndIf
					EndIf

;~ 					Closest Enemy Quarry NPC
					If $lDistance < $NearestQuarryDist And GetIsQuarryNPCEnemy($lModel) Then
						$NearestQuarryDist = $lDistance
						$NearestQuarryTarget = $lAgent
					EndIf

					If $lDistance <= 1562500 Then ; 1250, Enemies in spell range
						$NumberOfFoesInSpellRange += 1
						If DllStructGetData($lAgent, 'Skill') <> 0 Then ; Is Casting
							$aSkill = GetSkillByID(DllStructGetData($lAgent, 'Skill'))
							If DllStructGetData($aSkill, 'Activation') > 0.15 And DllStructGetData($aSkill, 'Type') == $SKILLTYPE_Skill Then
								$EnemyCaster = $lAgent
							ElseIf DllStructGetData($aSkill, 'Type') == $SKILLTYPE_Attack Then
								$EnemyAttacker = $lAgent
							EndIf
						EndIf
					EndIf

					If $lDistance <= 202500 Then ; 450, close range
						$NumPlayersInCloseRange += 1
					EndIf

					$NumPlayersOnMap += 1 ; MAP size almost

				EndIf

			Case 4 ;Allied Pets/Spirits
				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Typemap'), 262144) Then
					$mSpirits[0] += 1
					ReDim $mSpirits[$mSpirits[0] + 1]
					$mSpirits[$mSpirits[0]] = $lAgent
;~ 				Else
;~ 					$mPets[0] += 1
;~ 					ReDim $mPets[$mPets[0] + 1]
;~ 					$mPets[$mPets[0]] = $lAgent
				EndIf
;~ 			Case 5 ;Allied Minions
;~ 				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop
;~ 				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ContinueLoop
;~ 				$mMinions[0] += 1
;~ 				ReDim $mMinions[$mMinions[0] + 1]
;~ 				$mMinions[$mMinions[0]] = $lAgent
			Case Else
		EndSwitch
	Next
	$LeastAttackedShrineDist = Sqrt($LeastAttackedShrineDist)
	$NearestQuarryDist = Sqrt($NearestQuarryDist)
	$mLowestOtherAllyDist = Sqrt($mLowestOtherAllyDist)
	$mLowestAllyDist = Sqrt($mLowestAllyDist)
	$mClosestOtherAllyDist = Sqrt($mClosestOtherAllyDist)
	$mClosestFriendlyQuarryDist = Sqrt($mClosestFriendlyQuarryDist)
	$mClosestEnemyDist = Sqrt($mClosestEnemyDist)
	$mClosestAllyDist = Sqrt($mClosestAllyDist)
	$NearestShrineDist = Sqrt($NearestShrineDist)
	$mAverageTeamHP /= $mTeam[0]
	$mAverageTeamLocationX = $mAverageTeamLocationX / $TotalAlliesOnMap
	$mAverageTeamLocationY = $mAverageTeamLocationY / $TotalAlliesOnMap
	If $NumberOfFoesInSpellRange <= 0 Then $EnemyAttacker = 0
	Return $lAgentArray
 EndFunc   ;==>UpdateWorld
 Func MoveToQuarry($QuarryNumber)
	Local $lBlocked = 0
	Local $lMe
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aShrines[$QuarryNumber][0]
	Local $lDestY = $aShrines[$QuarryNumber][1]

	GameOver()
	Move($lDestX, $lDestY, 0)

	Do
		Sleep(100)
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			GameOver()
			$lBlocked += 1
			Move($lDestX, $lDestY, 250)
		EndIf
		$ClosestNPC = GetNearestQuarryAgentToCoords($lDestX, $lDestY) ; Array, 0 is agent, 1 is distance
		If $ClosestNPC[1] < 2000 Then
			If $QuarryNumber == $SHRINE_PurpleQuarry Then $PurpleCapped = True
			If $QuarryNumber == $SHRINE_YellowQuarry Then $YellowCapped = True
			If $QuarryNumber == $SHRINE_GreenQuarry Then $GreenCapped = True
			UpdateStatus("Quarry already capped!")
			ExitLoop
		EndIf
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 200 Or $lBlocked > 3
 EndFunc   ;==>MoveToQuarry
 Func PingSleep($Time = 1000)
	Sleep(GetPing() + $Time)
 EndFunc   ;==>PingSleep
 Func UseSkillEx($aSkillSlot, $aTarget = -2, $aTimeout = 5200)
	If GetIsCasting() = False Then
		If $IsHealerPrimary == True Then $aTimeout = 2500
		Local $tDeadlock = TimerInit()
		Local $TargetID = GetAgentID($aTarget)
		If $TargetID <= 0 Then Return
		If GetIsDead($aTarget) Then Return
		If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
		ChangeTarget($aTarget)

		UseSkill($aSkillSlot, $aTarget)

		Do
			Sleep(50)
			If GetIsDead($aTarget) == 1 Then Return
			If getisdead(-2) == 1 Then Return
			If GetAgentID($aTarget) <= 0 Then Return
			If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
		Until GetSkillbarSkillRecharge($aSkillSlot) <> 0 Or TimerDiff($tDeadlock) > $aTimeout
		If TimerDiff($tDeadlock) > $aTimeout Then $Skill_FAILED = $aSkillSlot
		If $aSkillSlot > 1 Then RndSleep(50)
	EndIf
EndFunc   ;==>UseSkillEx

Func CanUseSkill($aSkillSlot, $aEnergy = 0, $aSoftCounter = 0)
	If $mSkillSoftCounter > $aSoftCounter Then Return False
	If $mEnergy < $aEnergy Then Return False
	Local $lSkill = $mSkillbarCacheStruct[$aSkillSlot]
	If DllStructGetData($mSkillbar, 'Recharge' & $aSkillSlot) == 0 Then
		If DllStructGetData($mSkillbar, 'AdrenalineA' & $aSkillSlot) < DllStructGetData($lSkill, 'Adrenaline') Then Return False
		Switch DllStructGetData($lSkill, 'Type')
			Case 15, 20, 3

			Case 7, 10, 12, 16, 19, 21, 22, 26, 27, 28

			Case 14
				If $mBlind Then Return False
				If $mAttackHardCounter Then Return False
				If $mAttackSoftCounter > $aSoftCounter Then Return False
			Case 4, 5, 6, 9, 11, 24, 25
				If $mSpellSoftCounter > $aSoftCounter Then Return False
				If $mDazed Then
					If DllStructGetData($lSkill, 'Activation') > .25 Then Return False
				EndIf
				Switch DllStructGetData($lSkill, 'Target')
					Case 3, 4
						If $mAllySpellHardCounter Then Return False
					Case 5, 16
						If $mEnemySpellHardCounter Then Return False
					Case Else
				EndSwitch
		EndSwitch
		Return True
	EndIf
	Return False
EndFunc   ;==>CanUseSkill



;~ Use rez with death check, longer timeout and checks if target is alive
Func UseRezSkillEx($aSkillSlot, $aTarget)
	$tDeadlock = TimerInit()
	ChangeTarget($aTarget)

	UseSkill($aSkillSlot, $aTarget)

	Do
		Sleep(50)
	Until GetSkillbarSkillRecharge($aSkillSlot) <> 0 Or GetIsDead(-1) == False Or TimerDiff($tDeadlock) > 7000
	If GetIsCasting() Then CancelAction()
EndFunc   ;==>UseRezSkillEx

;~ Remove hex with updated check
Func RemoveHexSkillEx($aSkillSlot, $aTarget)
	$tDeadlock = TimerInit()
	ChangeTarget($aTarget)

	UseSkill($aSkillSlot, $aTarget)

	Do
		Sleep(50)
	Until GetSkillbarSkillRecharge($aSkillSlot) <> 0 Or GetHasHex($aTarget) == False Or GetIsDead(-1) == True Or TimerDiff($tDeadlock) > 3500
	If GetIsCasting() Then CancelAction()
EndFunc   ;==>RemoveHexSkillEx

Func SleepSkillRecharge($recharge)
	Sleep($recharge)
EndFunc   ;==>SleepSkillRecharge

;~ Description: Kneel.
Func Kneel()
	Update("Kneel")
	SendChat('kneel', '/')
 EndFunc   ;==>Kneel
Func HasEffect($Effect)
	If IsDllStruct($Effect) = 0 Then $Effect = GetSkillByID($Effect)
	If DllStructGetData(GetEffect($Effect), 'SkillID') < 1 Then ; If you're not under effect
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>HasEffect
Func MoveIfHurt()
	Local $aX, $aY, $aRandom = 300
	Local $Me = GetAgentByID(-2), $Blocked = 0
	If $NumberOfFoesInAttackRange < 1 Then Return True

	If GetHealth() < $CurrentHP Then
		If TimerDiff($HurtTimer) > 1000 Then ;
			UpdateStatus("I'm Hurt!")
			$theta = Random(0, 360, 1)
			$HurtTimer = TimerInit()
			Move(200 * Cos($theta * 0.01745) + XLocation(), 200 * Sin($theta * 0.01745) + YLocation(), 0)
			Sleep(300)
		EndIf
	EndIf

	$CurrentHP = GetHealth()
EndFunc   ;==>MoveIfHurt

 Func SmartCast()
	#Region Variables
	Local $Me = GetAgentByID(-2)
	If GetIsDead($Me) Then Return False
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return False
	If Not $mSkillbarCache[0] Then
		$mSkillbar = GetSkillbar()
		Sleep(200)
		CacheSkillbar()
	EndIf

	Local $SkillIsRecharged[9] = [False]
	#EndRegion Variables

	; Skill usage
	For $i = 1 To 8
		If $Skill_FAILED == $i Then
			$Skill_FAILED = 0
			ContinueLoop
		EndIf

		;; Check Recharge and Energy
		If $SkillAdrenalineReq[$i] == 0 Then
			If GetSkillbarSkillRecharge($i) <> 0 Or Not CanUseSkill($i, $mSkillbarCacheEnergyReq[$i]) Then ContinueLoop
		EndIf
		;; Check Adrenaline
		If $SkillAdrenalineReq[$i] > GetSkillbarSkillAdrenaline($i) Then ContinueLoop

		If $IsInterruptSpell[$i] Then
			If $EnemyCaster <> 0 Then ; Interrupt
				UseSkillEx($i, $EnemyCaster)
				Return
			EndIf
		EndIf

		If $IsHealingSpell[0] Then
			If $IsHealingSpell[$i] And Not $IsHealingOtherAllySpell[$i] Then
				If $mLowestAllyHP < 0.75 And HasEffect($mSkillbarCacheStruct[$i]) == False Then
					If $IsWeaponSpell[$i] == True Then
						If $NumberOfFoesInAttackRange > 0 And GetHasWeaponSpell($mLowestAlly) == False Then
							UseSkillEx($i, $mLowestAlly)
							Return
						EndIf
					Else
						If TargetEnemySkill($mSkillbarCacheStruct[$i]) Then
							If $mLowestEnemy <> 0 Then
								UseSkillEx($i, $mLowestEnemy)
								Return
							EndIf
						Else
							UseSkillEx($i, $mLowestAlly)
							Return
						EndIf
					EndIf
				EndIf
			EndIf
			If $IsHealingSpell[$i] And $IsHealingOtherAllySpell[$i] Then
				If $mLowestOtherAllyHP < 0.75 Then
					If $IsWeaponSpell[$i] == True Then
						If $NumberOfFoesInAttackRange > 0 And GetHasWeaponSpell($mLowestOtherAlly) == False Then
							UseSkillEx($i, $mLowestOtherAlly)
							Return
						EndIf
					Else
						UseSkillEx($i, $mLowestOtherAlly)
						Return
					EndIf
				EndIf
			EndIf
			If $mSkillbarCache[$i] == $Protective_Was_Kaolai Then
				If HasEffect($Protective_Was_Kaolai) == False Then
					UseSkillEx($i, $Me)
					Return
				EndIf
			EndIf
		EndIf

		If $IsSpeedBoostSkill[0] Then
			If $IsSpeedBoostSkill[$i] Then
				If $SpeedBoostTarget <> 0 Then
					UseSkillEx($i, $SpeedBoostTarget)
					Return
				EndIf
			EndIf
		EndIf

		If $IsSoulTwistingSpell[$i] Then
			If HasEffect($Soul_Twisting) == False Then
				UseSkillEx($i, $Me)
				Return
			EndIf
		EndIf

		If $NumberOfFoesInAttackRange > 0 Then
			If $IsAOESpell[$i] Then
				If $mSkillbarCache[$i] == $Signet_of_Clumsiness Then
					If $EnemyAttacker <> 0 Then
						UseSkillEx($i, $EnemyAttacker)
						Return
					EndIf
				Else
					If $BestAOETarget <> 0 Then
						UseSkillEx($i, $BestAOETarget)
						Return
					EndIf
					If $EnemyHealer <> 0 Then
						UseSkillEx($i, $EnemyHealer)
						Return
					EndIf
					If $mLowestEnemy <> 0 And $NearestShrineDist >= 1400 And $NearestQuarryDist >= 1400 Then
						UseSkillEx($i, $mLowestEnemy)
						Return
					EndIf
					If $mLowestEnemy <> 0 And $NumberOfFoesInAttackRange == 1 Then
						UseSkillEx($i, $mLowestEnemy)
						Return
					EndIf
				EndIf
			EndIf
		EndIf

		If $IsCorpseSpell[0] Then
			If $IsCorpseSpell[$i] And $NumberOfDeadFoes > 0 Then
				UseSkillEx($i)
				Return
			Else
				ContinueLoop
			EndIf
		EndIf

		If $NumberOfFoesInAttackRange > 0 Then
			If $IsSpiritSpell[0] Then
				If $IsSoulTwistingSpell[0] And $IsSpiritSpell[$i] Then
					If HasEffect($Soul_Twisting) == True And HasEffect($mSkillbarCache[$i]) == False Then
						UseSkillEx($i, $Me)
						Return
					EndIf
				EndIf
				If Not $IsSoulTwistingSpell[0] And $IsSpiritSpell[$i] Then
					UseSkillEx($i, $Me)
					Return
				EndIf
			EndIf

			If $IsConditionRemover[$i] Then
				If $ConditionedAlly <> 0 Then
					UseSkillEx($i, $ConditionedAlly)
					Return
				EndIf
			EndIf

			If $IsHexRemover[$i] Then
				If $HexedAlly <> 0 Then
					UseSkillEx($i, $HexedAlly)
					Return
				EndIf
			EndIf

			If $IsGeneralAttackSpell[$i] Then
;~ 				If $EnemyHealer <> 0 Then
;~ 					UseSkillEx($i, $EnemyHealer)
;~ 					Return
;~ 				EndIf
;~ 				$IsAntiMeleeSkill = IsAntiMeleeSkill($mSkillbarCache[$i])
;~ 				$IsHexingSpell = IsHexSpell($mSkillbarCacheStruct[$i])
;~ 				$IsConditioningSpell = IsConditionSpell($mSkillbarCacheStruct[$i])
;~ 				If $IsAntiMeleeSkill And $EnemyAttacker <> 0 Then
;~ 					UseSkillEx($i, $EnemyAttacker)
;~ 					Return
;~ 				EndIf
;~ 				If $IsHexingSpell And Not $IsConditioningSpell And Not $IsAntiMeleeSkill And $EnemyNonHexed <> 0 Then
;~ 					UseSkillEx($i, $EnemyNonHexed)
;~ 					Return
;~ 				EndIf
;~ 				If $IsConditioningSpell And Not $IsHexingSpell And Not $IsAntiMeleeSkill And $EnemyConditioned <> 0 Then
;~ 					UseSkillEx($i, $EnemyConditioned)
;~ 					Return
;~ 				EndIf
;~ 				If $IsConditioningSpell And $EnemyNonConditioned <> 0 Then
;~ 					UseSkillEx($i, $EnemyNonConditioned)
;~ 					Return
;~ 				EndIf
;~ 				If $IsHexingSpell And $EnemyNonHexed <> 0 Then
;~ 					UseSkillEx($i, $EnemyNonHexed)
;~ 					Return
;~ 				EndIf
				If GetIsCasterProfession() Then
					If $NearestShrineTarget <> 0 Then
						UseSkillEx($i, $NearestShrineTarget)
						Return
					EndIf
					If $mLowestEnemy <> 0 Then
						UseSkillEx($i, $mLowestEnemy)
						Return
					EndIf
					If $mClosestEnemy <> 0 Then
						UseSkillEx($i, $mClosestEnemy)
						Return
					EndIf
				Else
					If $mClosestEnemy <> 0 Then
						UseSkillEx($i, $mClosestEnemy)
						Return
					EndIf
				EndIf
			EndIf

			If $IsSelfCastingSpell[$i] Then
				If HasEffect($mSkillbarCacheStruct[$i]) == False Then
					UseSkillEx($i)
					Return
				EndIf
			EndIf
		EndIf

	Next
	Return False

EndFunc   ;==>SmartCast
Func ShrineSearch()
	Local $lMe = GetAgentByID(-2)
	Local $BestTarget = 0
	Local $NewShrineTargets
	Local $IAmMoving
	Local $IAmMovingTimer = TimerInit()
	Local $theta
	Local $Blocked = 0
	Local $CurrentTarget = 0
	Local Const $Quarry = 4
	Local Const $SoloShrine = 3
	Local Const $Shrine = 2
	Local Const $EnemyPlayer = 1
	Local $RandomAttackPlayer = Random(30, 100, 1)
	Local $LoopAttackCounter = 0
	Local $RandomSleep = Random(30, 100, 1)
	Local $LoopSleepCounter = 0
	Local $lAgents

    Do
		$LoopSleepCounter += 1
		$LoopAttackCounter += 1
		If $LoopSleepCounter > $RandomSleep And $NearestShrineDist > 1700 Then ;; Random Sleeps every 30-100 loops
			UpdateStatus("Random Nap!")
			Sleep(Random(3000, 5000, 1))
			$RandomSleep = Random(30, 50, 1)
			$LoopSleepCounter = 0
		EndIf
		UpdateWorld()
		$CapThisQuarry = CheckQuarry()
		If getisdead(-2) Then Return False
		$IAmMoving = GetIsMoving(-2)
		If ($LoopAttackCounter > $RandomAttackPlayer And $mClosestEnemyDist < 1350 And $NearestShrineDist >= 1500) Or $mClosestCarrier <> 0 Then
			$RandomAttackPlayer = Random(20, 50, 1)
			$LoopAttackCounter = 0
			UpdateStatus("Random Attack Loop!")
			Do
				UpdateWorld()
				GameOver() ; Check
				If $mClosestAllyDist < 180 Then
					$theta = Random(0, 360, 1)
					UpdateStatus("Move, You're in my bubble.")
					Move(200 * Cos($theta * 0.01745) + XLocation($mClosestAlly), 200 * Sin($theta * 0.01745) + YLocation($mClosestAlly), 0)
					Sleep(250)
				Else
					MoveIfHurt()
				EndIf
				If $mClosestCarrier <> 0 Then
					UpdateStatus("Attack closest Closest Carrier.")
					Attack($mClosestCarrier)
				ElseIf $NearestQuarryDist < 1300 Then
					UpdateStatus("Attack closest Nearest Quarry Target.")
					Attack($NearestQuarryTarget)
				ElseIf $NearestShrineDist < 1300 Then
					UpdateStatus("Attack closest Nearest Shrine Target.")
					Attack($NearestShrineTarget)
				elseIf $mClosestEnemy <> 0 Then
					UpdateStatus("Attack closest Enemy.")
					Attack($mClosestEnemy)
				Else
					ExitLoop
				EndIf
				SmartCast()
				PingSleep(250)
				If getisdead(-2) Then Return False
			Until $NumberOfFoesInAttackRange <= 0
			UpdateStatus("Random Attack Loop Completed!")
		ElseIf $CapThisQuarry < 3 And $mClosestEnemyDist > 500 Then
			If $CapThisQuarry == 0 Then UpdateStatus("Capping Purple Quarry!")
			If $CapThisQuarry == 1 Then UpdateStatus("Capping Yellow Quarry!")
			If $CapThisQuarry == 2 Then UpdateStatus("Capping Green Quarry!")
			MoveToQuarry($CapThisQuarry)
		ElseIf $NearestShrineDist <= 1500 Or $NearestQuarryDist <= 1500 Then ;; Attack shrines/quarries
			UpdateStatus("Capping Loop.")
			Do
				UpdateWorld()
				GameOver() ; Check
					If $mClosestAllyDist < 180 Then
						$theta = Random(0, 360, 1)
						UpdateStatus("Move, You're in my bubble.")
						Move(200 * Cos($theta * 0.01745) + XLocation($mClosestAlly), 200 * Sin($theta * 0.01745) + YLocation($mClosestAlly), 0)
						Sleep(250)
					Else
						MoveIfHurt()
					EndIf
					If $NearestQuarryDist < 1300 Then
						UpdateStatus("Attack closest Nearest Quarry Target.")
						Attack($NearestQuarryTarget)
					ElseIf $NearestShrineDist < 1300 Then
						UpdateStatus("Attack closest Nearest Shrine Target.")
						Attack($NearestShrineTarget)
					ElseIf $mClosestEnemy <> 0 Then
						UpdateStatus("Attack closest Enemy.")
						Attack($mClosestEnemy)
					Else
						ExitLoop
					EndIf
				SmartCast()
				PingSleep(250)
				If getisdead(-2) Then Return False
			Until $NumberOfFoesInAttackRange <= 0
			UpdateStatus("Shrine Loopis clear.")
			;; I'm hurt
		ElseIf $IsSpeedBoostSkill[0] And $SpeedBoostTarget <> 0 Then
			UpdateStatus("Speed Boost!")
			GameOver() ; Check
			SmartCast()
			Sleep(250)
		ElseIf $MyMaxHP - GetHealth() > Random(50, 150, 1) Or $NumberOfFoesInAttackRange > 2 Then
			UpdateStatus("Health Check-up!")
			SmartCast()
			Sleep(250)
			GameOver() ; Check
			If $IAmCaster == False Then
				Attack($mClosestEnemy)
			Else
				MoveIfHurt()
			EndIf
		ElseIf CloseToQuarry() And $NumberOfFoesInAttackRange > 0 Then
			UpdateStatus("Defend Quarry!")
			SmartCast()
			GameOver() ; Check
			If $IAmCaster == False Then
				Attack($mClosestEnemy)
			EndIf
			Sleep(250)
		ElseIf $IAmMoving == True Then
			GameOver() ; Check
			$Blocked = 0
			;; Moving to enemy player or shrine but found quarry
			If $NearestQuarryDist <= 4500 And ($CurrentTarget < $Quarry OR TimerDiff($IAmMovingTimer) > 10000) Then
				UpdateStatus("Moving to Quarry.")
				$IAmMovingTimer = TimerInit()
				$CurrentTarget = $Quarry
				Move(XLocation($NearestQuarryTarget), YLocation($NearestQuarryTarget), 0)
				Sleep(500)
			;; Moving to enemy player but found shrine, or closer shrine
			ElseIf $LeastAttackedShrineDist <= 4000 And ($CurrentTarget < $SoloShrine OR TimerDiff($IAmMovingTimer) > 15000) Then
				UpdateStatus("Moving to Solo Shrine.")
				$IAmMovingTimer = TimerInit()
				$CurrentTarget = $Shrine
				Move(XLocation($LeastAttackedShrine), YLocation($LeastAttackedShrine), 0)
				Sleep(500)
			EndIf
			If $IsCorpseSpell[0] And $NumberOfDeadFoes > 1 Then
				SmartCast()
			EndIf
		Else
			GameOver() ; Check
			$IAmMovingTimer = 0
			;; No Enemies on map
			If $NumPlayersOnMap < 0 Or $Blocked > 6 Then
				UpdateStatus("No enemies found. Moving to center of map.")
				Move($MapCenter[0], $MapCenter[1], 300)
				$CurrentTarget = $EnemyPlayer
				Sleep(1000)
				$Blocked += 1
			;; Player blocking me
			ElseIf $NumPlayersInCloseRange > 0 And $Blocked > 2 Then ;; Attack enemy players that are close.
				UpdateStatus("Blocking me, attack.")
				$CurrentTarget = $EnemyPlayer
				SmartCast()
				If $IAmCaster == False Then
					Attack($mClosestEnemy)
				EndIf
				Sleep(250)
			;; Move to next Quarry
			ElseIf $NearestQuarryDist <= 4500 And $Blocked < 4 Then
				UpdateStatus("Moving to Quarry.")
				$CurrentTarget = $Quarry
				Sleep(Random(10,1500, 1))
				Move(XLocation($NearestQuarryTarget), YLocation($NearestQuarryTarget), 0)
				$Blocked += 1
				Sleep(500)
			ElseIf $LeastAttackedShrineDist	< 4000 And $Blocked < 3 Then
				UpdateStatus("Moving to Solo Shrine.")
				$CurrentTarget = $SoloShrine
				Sleep(Random(10,1500, 1))
				Move(XLocation($LeastAttackedShrine), YLocation($LeastAttackedShrine), 0)
				$Blocked += 1
				Sleep(500)
			;; Move to next shrine
			ElseIf $NearestShrineDist <= 4000 And $Blocked < 3 Then
				UpdateStatus("Moving to Shrine.")
				$CurrentTarget = $Shrine
				Sleep(Random(10,2000, 1))
				Move(XLocation($NearestShrineTarget), YLocation($NearestShrineTarget), 0)
				$Blocked += 1
				Sleep(500)
			;; Blocked and out of range of shrine
			ElseIf $mClosestEnemy <> 0 Then
				UpdateStatus("Moving to enemy player.")
				$CurrentTarget = $EnemyPlayer
				Move(XLocation($mClosestEnemy), YLocation($mClosestEnemy), 500)
				$Blocked += 1
				Sleep(500)
			EndIf
		EndIf
		PingSleep(300)

	Until getisdead(-2) Or GameOver()
EndFunc

#EndRegion
