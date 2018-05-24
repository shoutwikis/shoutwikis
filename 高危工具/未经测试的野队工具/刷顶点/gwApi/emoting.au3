#include-once

;~ Description: Randomly emotes 6 different emotes (dance, clap, excited, drum, flute and violin)
Func Emoting()
   Switch (Random(1, 6, 1))
	  Case 1
		 Dance()
	  Case 2
		 Clap()
	  Case 3
		 Excited()
	  Case 4
		 Drum()
	  Case 5
		 Flute()
	  Case 6
		 Violin()
	EndSwitch
EndFunc   ;==>Emoting

;~ Description: Dance emote.
Func Dance()
   SendChat('dance', '/')
EndFunc   ;==>Dance

;~ Description: Clap emote.
Func Clap()
   SendChat('clap', '/')
EndFunc   ;==>Clap

;~ Description: Excited emote.
Func Excited()
   SendChat('excited', '/')
EndFunc   ;==>Excited

;~ Description: Drum emote.
Func Drum()
   SendChat('drum', '/')
EndFunc   ;==>Drum

;~ Description: Flute emote.
Func Flute()
   SendChat('flute', '/')
EndFunc   ;==>Flute

;~ Description: Violin emote.
Func Violin()
   SendChat('violin', '/')
EndFunc   ;==>Violin

;~ Description: Jump emote.
Func Jump()
   SendChat('jump', '/')
EndFunc   ;==>Jump