#include-once
#include <String.au3>
#include <GuiComboBox.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>

#Region Guild Hall Globals
;~ Prophecies
Global $BurningIsle_GH_ID = 52 ;Key=Burning Isle
Global $Druid_GH_ID = 70 ;Key=Druid's Isle
Global $FrozenIsle_GH_ID = 68 ;Key=Frozen Isle
Global $Hunter_GH_ID = 8 ;Key=Hunter's Isle
Global $IsleOFDead_GH_ID = 179 ;Key=Isle Of Dead
Global $NomadIsle_GH_ID = 69 ;Key=Nomand's Isle
Global $WarriorsIsle_GH_ID = 7 ;Key=Warrior's Isle
Global $WizardsIsle_GH_ID = 9 ;Key=Wizard's Isle
;~ Factions
Global $Imperial_GH_ID = 363 ;Key=Imperial Isle
Global $IsleOfJade_GH_ID = 362 ;Key=Isle Of Jade
Global $Meditation_GH_ID = 360 ;Key=Isle Of Meditation
Global $IsleOfWeepingStone_GH_ID = 361 ;Key=Isle Of Weeping Stone
;~ Nightfall
Global $Corrupted_GH_ID = 539 ;Key=Corrupted Isle
Global $Solitude_GH_ID = 538 ;Key=Isle of Solitude
Global $IsleOfWurm_GH_ID = 532 ;Key=Isle Of Wurm
Global $Ucharted_GH_ID = 531 ;Key=Ucharted Isle

Global $BURNINGISLE = False
Global $DRUIDISLE = False
Global $FROZENISLE = False
Global $HUNTERISLE = False
Global $ISLEOFDEAD = False
Global $NOMADISLE = False
Global $WARRIORISLE = False
Global $WIZARDISLE = False
Global $IMPERIALISLE = False
Global $ISLEOFJADE = False
Global $ISLEOFMEDITATION = False
Global $ISLEOFWEEPING = False
Global $CORRUPTEDISLE = False
Global $ISLEOFSOLITUDE = False
Global $ISLEOFWURMS = False
Global $UNCHARTEDISLE = False
#endregion Guild Hall Globals

; 激战成像标记
Global $RenderingEnabled = True

; 自动工具开关标记
Global $BotRunning = False
Global $BotInitialized = False

; 记录被困时间/包载物量
Global $ChatStuckTimer = TimerInit()
Global $BAG_SLOTS[18] = [0, 20, 5, 10, 10, 20, 41, 12, 20, 20, 20, 20, 20, 20, 20, 20, 20, 9]

Global $RunCount=0
Global $FailCount
Global $SuccessCount=0
Global $BossKills, $reZone

; 各种范围
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING