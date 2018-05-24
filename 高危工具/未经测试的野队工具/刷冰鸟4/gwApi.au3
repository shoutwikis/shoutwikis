#cs
   GWBible, GWAddOns, GWA² functions revised.
   Pointer-based GWA².

   Author gwAPI 2.0: Testytest.
#ce

#include-once
;#RequireAdmin

#Region Declarations gwAPI_basics
Global $mKernelHandle
Global $mGWProcHandle
Global $mGWHwnd
Global $mGWTitleOld = 'Guild Wars'
Global $mMemory
Global $mLabelDict = 0
Global $mRestoreDict = 0
Global $mBase = 0x00DE0000
Global $mASMString, $mASMSize, $mASMCodeOffset
Global $mGUI = GUICreate('GWA²'), $mSkillActivate, $mSkillCancel, $mSkillComplete, $mChatReceive, $mLoadFinished
Global $mSkillLogStruct = DllStructCreate('dword;dword;dword;float')
Global $mSkillLogStructPtr = DllStructGetPtr($mSkillLogStruct)
Global $mChatLogStruct = DllStructCreate('dword;wchar[256]')
Global $mChatLogStructPtr = DllStructGetPtr($mChatLogStruct)
GUIRegisterMsg(0x501, 'Event')
Global $mQueueCounter, $mQueueSize, $mQueueBase
Global $mTargetLogBase
Global $mStringLogBase
Global $mSkillBase
Global $mEnsureEnglish
Global $mMyID, $mCurrentTarget
Global $mAgentBase
Global $mBasePointer
Global $mRegion, $mLanguage
Global $mPing
Global $mCharname
Global $mMapID
Global $mMaxAgents
Global $mMapLoading
Global $mMapIsLoaded
Global $mLoggedIn
Global $mStringHandlerPtr
Global $mWriteChatSender
Global $mTraderQuoteID, $mTraderCostID, $mTraderCostValue
Global $mSkillTimer
Global $mBuildNumber
Global $mZoomStill, $mZoomMoving
Global $mDisableRendering
Global $mAgentCopyCount
Global $mAgentCopyBase
Global $mChangeTitle = True
Global $mUseStringLog
Global $mUseEventSystem
Global $mLastDialogId
Global $mStorageSessionBase
Global $CurrentMapID = 0
Global $mRendering = True
Global $GWPID = -1
Global $mAgentMovement
Global $mFirstChar = ''
Global $mSleepAfterPort = 1000
#EndRegion Declarations

#Region UpdateWorld Variables
Global $MyID
Global $MyPtr
Global $Skillbar
Global $mSelf
Global $mSelfID
Global $mLowestAlly
Global $mLowestAllyHP
Global $mHighestAlly
Global $mHighestAllyHP
Global $mLowestOtherAlly
Global $mLowestOtherAllyHP
Global $mLowestEnemy
Global $mLowestEnemyHP
Global $mClosestEnemy
Global $mAverageTeamHP
Global $NumberOfFoesInAttackRange = 0
Global $NumberOfFoesInSpellRange = 0
Global $BestAOETarget
Global $HexedAlly
Global $ConditionedAlly
Global $EnemyHexed
Global $EnemyNonHexed
Global $EnemyConditioned
Global $EnemyNonConditioned
Global $EnemyNonEnchanted
Global $EnemyEnchanted
Global $EnemyHealer
Global $LowHPEnemy
Global $EnemyAttacker = 0
Global $mTeam[2] = [0, 0] ;Array of living members
Global $mTeamOthers[1] ;Array of living members other than self
Global $mTeamDead[1] ;Array of dead teammates
Global $mSpirits[1] ;Array of your spirits
Global $mMinions[1] ;Array of your minions
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
Global $mClosestEnemy
Global $mClosestEnemyDist
Global $mEffects
Global $mEnergy
Global $CurrentMapState = 0
Global $Resigned = False
Global $GotBounty = False
Global $GetSkillBar = False
Global $SavedLeader = 0
Global $SavedLeaderID = 0
Global $HurtTimer = TimerInit()
Global $CurrentHP = 1000
Global $AOEDanger = False
Global $AOEDangerRange = 0
Global $AOEDangerXLocation
Global $AOEDangerYLocation
Global $AOEDangerDuration
Global $AOEDangerTimer
#EndRegion

#Region SmartCast Variables
#Region MoveToSafeSpot
Global $ClostestX[1]
Global $ClostestY[1]
Global $SpiritAverageXLocation = 0
Global $SpiritAverageYLocation = 0
Global $EnemyAverageXLocation = 0
#EndRegion MoveToSafeSpot

#Region CacheSkill
Global $mSkillPriorityRating[9][3]
Global $mSkillbarCache[9] = [False]
Global $mSkillbarCacheStruct[9] = [False]
Global $mSkillbarCacheEnergyReq[9] = [False]
Global $mSkillbar
Global $mSkillbarPtr
Global $mSkillbarCacheArray[9][11]
Global $mSkillbarCachePtr[9] = [False]
Global $IsHealingSpell[9] = [False]
Global $IsYMLAD[9] = [False]
Global $IsInterrupt[9] = [False]
Global $YMLADSlot = 0
Global $IsSummonSpell[9] = [False]
Global $IsSoulTwistingSpell[9] = [False]
Global $IsSelfCastingSpell[9] = [False]
Global $IsWeaponSpell[9] = [False]
Global $SkillDamageAmount[9] = [False]
Global $SkillAdrenalineReq[9] = [False]
Global $lMyProfession
Global $lAttrPrimary
#EndRegion
#EndRegion

#Region GUI
Global $boolRun = False
Global $Resigned = False
Global $UpdateText
Global $FirstRun = True
Global $OldGuiText = ''
#EndRegion

#Region Misc Variables
Global $mMaxPartySize = 12
Global $mPartyArray[13]

#Region PickUp
Global $mBattlePlans = False ; excluded from $mPickUpAll, set to true if you want to pick them up
Global $mMapPieces = False ; excluded from $mPickUpAll, set to true if you want to pick them up
Global $mTomes = True
Global $mEliteTomes = True
Global $mMesmerTomes = True
Global $mElementalistTomes = False
Global $mQuestItems = False
Global $mDyes = True
Global $mSalvageTrophies = True
Global $mRarityGold = True
Global $mRarityGreen = False
Global $mEventModelID = 0
Global $mEventCount = 0
Global $mPickUpAll = True
Global $mLeecher = False
Global $mPickUpBundles = True
#EndRegion

#Region Inventory
Global $mEmptyBag = 8
Global $mEmptySlot = 0
Global $mStoreGold = False
Global $mStoreMaterials = False
Global $mBlackWhite = True
Global $mMatExchangeGold = 930 ; ModelID of mat that should be bought in case gold storage is full
Global $mSalvageStacks = True
Global $mDustFeatherFiber = 1 ; change to 1 to sell this group of materials
Global $mGraniteIronBone = 1 ; change to 1 to sell this group of materials
Global $mWhiteMantleEmblem = False ; change to false to sell them
Global $mWhiteMantleBadge = False ; change to false to sell them
#EndRegion

#Region TempStorage
Global $mBags = 16
Global $mTempStorage[1][2] = [[0, 0]]
Global $mFoundMerch = False
Global $mFoundChest = False
#EndRegion TempStorage
#EndRegion

;~ Description: Data arrays, remove commentation if you need them.
;~ #include "gwAPI\array_questnames.au3"
;~ #include "gwAPI\array_skill_small.au3"
;~ #include "gwAPI\array_skillnames.au3"
;~ #include "gwAPI\array_skills_big.au3"
;~ #include "gwAPI\array_skills_pvp.au3"

;~ Description: Global constants.
#include "gwAPI\constants.au3"

;~ Description: Mainfile, Initialisation etc.
#include "gwAPI\gwAPI_basics.au3"

;~ Description: Easier handling of memreads.
;~ #include "gwAPI\memreads.au3"

;~ Description: GetMapID, GetMapLoading etc.
#include "gwAPI\map.au3"

;~ Description: Move, MoveTo, MoveAggroing, GoToAgent and its variations, as well as travelto etc.
#include "gwAPI\movement.au3"

;~ Description: All functions that mainly involve agents.
#include "gwAPI\agents.au3"

;~ Description: Functions needed to process inventory between runs.
#include "gwAPI\inventory.au3"

;~ Description: All functions that mainly involve items.
#include "gwAPI\items.au3"

;~ Description: Party formation etc functions.
#include "gwAPI\party.au3"

;~ Description: Smartcast function.
#include "gwAPI\smartcast.au3"

;~ Description: Updateworld()
#include "gwAPI\UpdateWorld.au3"

;~ Description: All functions involving heroes and henchmen.
#include "gwAPI\h_h.au3"

;~ Description: Functions involving kurzick, luxon, balth and imperial faction.
#include "gwAPI\faction.au3"

;~ Description: Write, send etc chat functions, including functions like kneel.
#include "gwAPI\chat.au3"

;~ Description: All functions needed to access character information, doesnt include faction.
#include "gwAPI\characterinfo.au3"

;~ Description: Functions for manipulation client interface, includes disable/enable rendering.
#include "gwAPI\client_interface.au3"

;~ Description: Functions involving skills, skilltemplates, attributes or professions.
#include "gwAPI\skills.au3"

;~ Description: Quest functions.
#include "gwAPI\quest.au3"

;~ Description: Trade functions.
#include "gwAPI\trade.au3"

;~ Description: Some emote functions.
#include "gwAPI\emoting.au3"

;~ Description: Custom GUI functions.
#include "gwAPI\GUI.au3"
