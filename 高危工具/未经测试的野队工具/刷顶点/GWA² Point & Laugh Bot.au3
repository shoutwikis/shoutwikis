#cs

AutoIt Version: 3.3.8.1 (best version)
GWA2 Version: 3.6.9
Compiler:		Phrost A.K.A. P-wizzy, P-money, Big P, P to the E, Frozen Pizza, The Grusome Twosome Experience, Peezy
Author:			Phrost

Greetings Comrads, I am writing this bot to help you handle any rough customers you may encounter in Tyria. Are you of the jackass who leeches trim? Is Ghostly Hero all over the place
like a single, pgegnant, white female? Are you tired of the elitism? Would you say in the average day you smile less than 17 times? Is is your money and you also want it now?

Fear not. I bring to you the ultimate script. This will guarentee your chances with the hunnies go up 110% czech that 169% This is a work in progress or a WIP (said like coolwhip).
I will be working diligently on this boat to get it running as quick as possible but to make something ABAP [As Ballin' As Possible] requires a lot of time and drinks.
Good thing I have both, for now...

The idea is simple yet complex. You character will /point and /laugh at your target or just if you want to if you are positined right and will do it for as long as the bot runs
or Guild Wars servers remain active. I will be adding a feature to follow the person you are targeting via an input box. I will also make both /point and /laugh toggleable in GUI so
if you only ant one or the other. Other features will include the option to constantly open trade, set to 'do not disturb' (also known as hentai tentacle mode). After many revisions
I may add the option to send ".                                           Glob of Ectoplasm" to all chat tabs to make sure everyone knows you mean business. You may want to join a guild
and stay in it for at least 24 hours or a few days then make another character and don't login to either without checking log in as offline before using this part of the bot. This step will
make sure that you are not kicked for awhile and emphasize your business.

I am always thinking of new features. I do not have a e-mail, phone #, or address as I'm a pizza, but you may reach me on Game Revision @ Phrost (kind of like a gay sub-zero). I work
very hard on my material and others may use it, but please include me in your credits. The only way to get street cred is by aquiring street credits. You can also PM Rask asking
about his wares.

I truly hope all enjoy this bot when it is finished. As stated before I'm a pizza so I'm very busy with my family. Also remember this is a WIP so it may not work right away, but you can guarentee
that future versions will be magnificent when they're finished and released.

NOTE: Going to buy a flag that states "Chillin' The Most" and rock that bitch up and down the coast.
#ce

#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <GuiComboBox.au3>
#include <Array.au3>
#include <GWA2.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Global $BoolRun = False
Global $BoolInitialized = False
Global $SendReady = False
Global $Send = False
Global $CurrentTab = 0

_Initialize2(True, True, False, False)