# GTA Online Inside Track Horse Race Glitch Abuser Macro

BASED ON tuokri's work <https://github.com/tuokri/gtav-horse-macro>

## Features
- Random click distribution inside the whole button-rectangle
	along with randomized click-times and delays, this should make the behaviour 'look' more natural/human and make the script harder to detect (NO GUARANTEES!)

- Random choice with adjustable probability between a glitch-using and a glitch-free variant
	you decide wheter you want to risk serious consequences from rockstar for higher revenue or play it safe and slower

- adjustable bid for the glitch-free variant

- restartable as the first press of ALT+B only quits race-bidding loop but not the whole script (when the script is racing)
	After starting the execution, the script is in waiting state.
	-> When the script is in waiting-state, pressing ALT-B will quit the script.
	When the script is racing, pressing ALT+B will end the current race, return to main menu and put the script in waiting state
	-> Pressing ALT+B again will quit the script immediately (without completing the current race-cycle)
	When in recording-mode, pressing ALT-B will end the recording, discarding all changes and returning to waiting state

- Ini-File for persistent storage of settings and Button-positions
	Record the positions for your PC once and they will be loaded automatically the next time you start the script
	

## Instructions:
1. Download the source-file or executable
2. Run the script
3. Enter the horse track main screen (the one with the 'rules' button).
4. ONLY DO THIS STEP DURING THE FIRST TIME OR IF THE SCRIPT IS MISSING THE BUTTONS:
	Press alt+c to enter button record mode. The Script will beep once to signal recording mode.
	MIDDLE-CLICK the upper-left and lower-right corner of each button in order to record their correct positions. The script will accept each click with a short beep.
	**The correct order is:
	- **Place-Bet #1** (the one in the main-menu, where you can access the rules)
	- **Horse #1** (or whatever horse you want to bet on)
	- **Increase bet**
	- **Place-Bet #2** (the one that starts the race)
	- **Bet-Again** (which takes you back to the main menu after a race)
	That's 10 MIDDLE-CLICKS in total!
	You can left-click, right-click, smash the keyboard between the middle-clicks, as long as the middle-clicks are done on the correct locations in the correct order.
	After the button locations are recorded, the script will again beep once, for one second.
	Return to the main screen with the 'rules' button to proceed to the next step.
	Aborting the recording will result in three fast and short beeps
5. Press alt+a to start the script while in the main screen with the 'rules' button. If you recorded button locations, the script will now click those locations in order.
6. To end the racing, press ALT+B.
7. You are now in waiting state again. You can now
	- restart the racing by pressing ALT-A
	- record new locations by following STEP 4. (starting with pressing ALT+C)
	- exit the script completely by pressing ALT+B again


If the script still does not work right, stop the script (press alt+b or shut it down from the task bar) and repeat the above steps and this time correctly record the button locations.
If this does not work, exit the script completely (press ALT+B twice), delete settings.ini and restart with step 2.


## Settings.ini
- ONLY EDIT THE INI WHEN THE SCRIPT IS NOT RUNNING
	whenever you record the button-positions, the script will overwrite the current Settings.ini, possibly also cancelling all the changes made after Script-execution-start

- A glitchShare value of 1 means the glitch-variant is used always while a value of 0 means the glitch-variant is used never
	a value of 0.5 means the usage is distributed randomly with a 50:50 probability for each variant

- bidIncNumber is the number of times the Increase-bet-button is clicked when using the glitch-free variant.
	a value of 0 means the button is clicked never and thus, the minimum bet is used
	a value of 27 increases the bid to the maximum of 10000
	(this obviously does not aplly to the glitch-variant)

- the rectangles should not be edited by hand. Instead, the record-function should be used, which can be triggered by pressing ALT-C
	The Script then records the positions of the next 10 middle-mouse-clicks (Scroll-wheel).
	A pair of two of those positions defines the upper-left and lower-right corner of one button.
	The buttons are recorded in the same Order the appear ingame:
	Place-Bet #1 (the one in the main-menu, where you can access the rules)
	Horse #1 (or whatever horse you want to bet on)
	Increase bet button
	Place-Bet #2 (the one that starts the race)
	Bet-Again (which takes you back to the main menu after a race)

- If you messed up your Ini, just delete it.
	The script will generate a new one when you record the button-positions again.
	You will then be able to view and edit it, if you still want to.