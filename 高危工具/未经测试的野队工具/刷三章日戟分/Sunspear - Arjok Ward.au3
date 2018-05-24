;~ Arjok Ward Sunspear Point Farm

Global Const $ScriptName = "Sunspear Point Farm"
Global Const $HardMode = 0 ;Disable Hard Mode
Global Const $Chest[2][2] = [[True, 0],[-2024, -595]] ;Chest array. First element is whether to use chest and start gold, following elements are coordinates to reach chest.
Global Const $OutpostID = 381 ;Yohlon Haven
Global $mModelIDBlacklist[1] = [0] ;ModelIDs to ignore (spirits, etc)

;~ [Zone ID, X, Y, Range, Must Reach, "Description"] - Waypoints
;~ Only use mustreach on path off-shoot where you'll backtrack afterwards.
;~ ["UserFunction", "Param1", "Param2", "Param3", "Param4", "Description"] - User functions (grabbing bounties mid-vanq, etc.)
;~ Make sure userfunctions have 4 parameters (even if they aren't used for anything) to prevent issues.
Global $mWayPoints[4][6] = [ _
		[380, -18815, -11024, 1800, False, "First Spot"], _
		[380, -18559, -9664, 1800, False, "Second Spot"], _
		[380, -18798, -13275, 1800, False, "Third Spot"], _
		[380, -17085, -16491, 1800, False, "Fourth Spot"]]

;~ Function to run before starting. Bot will automatically warp to outpost, go to stash, deposit items in processing bags, and withdraw start gold.
;~ You'll be standing at the chest when this function is called.
Func BeforeRun()
	MoveTo(-3391, -3829, 80)
	MoveTo(-2016, -3648, 80)
	MoveTo(-1234, -3316, 80)
	MoveTo(-93, -3666, 80)
	MoveTo(1534, -3576, 80)
	MoveTo(2511, -2118, 80)
	MoveTo(3008, 554, 80)
	MoveTo(3767, 690, 80)
	MoveTo(4069, 743, 80)
	MoveTo(4223, 771, 80)
	MoveTo(4289, 783, 80)
	MoveTo(4331, 790, 80)
	Out("Waiting for Arjok Ward to load.")
	Do
		Move(4444, 836, 80) ;Go out into Arjok Ward
	Until WaitMapLoading(380)

	Out("Taking Blessing")
	GrabBounty(-18129, -13368, 0x84, "1793|1829|1830|1967|1968|") ;Which one is right? lol
EndFunc   ;==>BeforeRun

;~ Function to be called while just running around. Return false if nothing happens.
Func Maintenance()
	Return False
EndFunc   ;==>Maintenance

;~ Return True to prematurely exit the waypoints loop
Func ExitCheck()
	Return GetIsDead($mSelf)
EndFunc   ;==>ExitCheck

;~ Function to run after waypoints loop has completed/exited.
;~ Return True to exit main loop.
Func AfterWaypoints()
	Return True
EndFunc   ;==>AfterWaypoints

;~ Function to run after the run is over.
Func AfterRun()
	TravelGH()
	Inventory()
	LeaveGH()
EndFunc   ;==>AfterRun
