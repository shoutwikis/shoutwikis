#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.0
 GWA2 Version: 3.6.8
 Author:         4D1

 Script Function:
	Leeches Raptors and shit.

#ce ----------------------------------------------------------------------------

#include "GWA2.au3"

Initialize2()

While 1
	If GetMapID() = 501 = True Then
		WaitMapLoading()
		UseSkill(3,-2)
		GoToNPC(GetNearestNPCToCoords(-24246, -5615))
		Dialog(0x83)
		MoveTo(-25000, -3996)
		SendChat("resign",'/')
		Do
		Sleep(100)
		Until GetMapID() <> 501
	EndIf
WEnd