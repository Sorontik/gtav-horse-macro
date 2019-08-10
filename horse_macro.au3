#cs
A little script to automatically play Inside-Track in the Diamond-Casino in GTAV

BASED ON tuokri's work <https://github.com/tuokri/gtav-horse-macro>
with improvements by me:

- Random click distribution inside the whole button-rectangle
	along with randomized click-times and delays, this should make the behaviour 'look' more natural/human and make the script harder to detect (NO GUARANTEES!)

- Random choice with adjustable probability between a glitch-using and a glitch-free variant
	you decide wheter you want to risk serious consequences from rockstar for higher revenue or play it safe and slower

- adjustable bid for the glitch-free variant

- Ini-File for persistent storage of settings and Button-positions
	Record the positions for your PC once and they will be loaded automatically the next time you start the script

- made the macro restartable as the first press of ALT+B only quits race-bidding loop but not the whole script (if and when the race-loop is runnning)
	When the script is racing, pressing ALT+B will end the current race, return to main menu and put the script in waiting state (just like after starting the execution, before starting the races with ALT+A)
	-> Pressing ALT+B again will quit the script immediately
	When the script is in waiting-state, pressing ALT-B will quit the script.
	When in recording-mode, pressing ALT-B will end the recording, discarding all changes and returning to waiting state

A glitchShare value of 1 means the glitch-variant is used always while a value of 0 means the glitch-variant is used never
	a value of 0.5 means the usage is distributed randomly with a 50:50 probability for each variant

bidIncNumber is the number of times the Increase-bet-button is clicked when using the glitch-free variant.
	a value of 0 means the button is clicked never and thus, the minimum bet is used
	a value of 27 increases the bid to the maximum of 10000

the rectangles should not be edited by hand. Instead, the record-function should be used, which can be triggered by pressing ALT-C
The Script then records the positions of the next 10 middle-mouse-clicks (Scroll-wheel).
	A pair of two of those positions defines the upper-left and lower-right corner of one button.
	The buttons are recorded in the same Order the appear ingame:
	Place-Bet #1 (the one in the main-menu, where you can access the rules)
	Horse #1 (or whatever horse you want to bet on)
	Increase bet button
	Place-Bet #2 (the one that starts the race)
	Bet-Again (which takes you back to the main menu after a race)
	
#ce





#include <Array.au3>
#include <AutoItConstants.au3>
#include <Misc.au3>

Global $handle_user32 = DllOpen("user32.dll")

Global $inidir = @ScriptDir&"\settings.ini"

Global Const $General = "general"
Global $f_glitchShare = Number(IniRead($inidir, $General, "glitchShare", "1")) ; 100 percent of all races will use Glitch
Global $i_bidIncNumber = Int(IniRead($inidir, $General, "bidIncNumber", "27"))	; 27 means maximum bid (10000)

; measured at 2560x1440
Global Const $Rectangles = "rectangles"
Global $r_place_bet_0[2][2]	; Place bet button location in main menu.
Global $r_horse[2][2]		; Horse #1 button location by default.
Global $r_inc_bet[2][2]		; Increase bet arrow button location.
Global $r_place_bet_1[2][2]	; Place bet button location in the betting menu.
Global $r_bet_again[2][2]	; Bet again button location.
$r_place_bet_0	= RectFromString(IniRead($inidir, $Rectangles, "place_bet_0", "0,0,0,0"))	; Place bet button location in main menu.
$r_horse		= RectFromString(IniRead($inidir, $Rectangles, "horse", "0,0,0,0"))			; Horse #1 button location by default.
$r_inc_bet		= RectFromString(IniRead($inidir, $Rectangles, "inc_bet", "0,0,0,0"))		; Increase bet arrow button location.
$r_place_bet_1	= RectFromString(IniRead($inidir, $Rectangles, "place_bet_1", "0,0,0,0"))	; Place bet button location in the betting menu.
$r_bet_again	= RectFromString(IniRead($inidir, $Rectangles, "bet_again", "0,0,0,0"))		; Bet again button location.


; TIMING options

Global $t_race = 35 * 1000 ; Race duration + safety margin.

; Time Range for normal click down times (note that due to the use of Sleep() the time effectively get rounded up to the next full 10ms)
Global $t_click_min = 20  ; ms
Global $t_click_max = 100 ; ms

; time Range for the delay between two actions (note that due to the use of Sleep() the time effectively get rounded up to the next full 10ms)
Global $t_delay_min = 50  ; ms
Global $t_delay_max = 150 ; ms

; Variable duration of holding left click after clicking the increase bet arrow.
Global $t_hold_click_min = Int($t_race / 4)
Global $t_hold_click_max = Int($t_race / 2)

Global $main = False



; Record button locations hotkey (alt + c).
HotKeySet("!c", "RecordButtonLocations")

; End script hotkey (alt + b).
HotKeySet("!b", "Quit")

; Wait for alt + a keystroke.
HotKeySet("!a", "Main")
While True
	Sleep(100)
WEnd

Func Main()
	If $r_place_bet_0[0][0] = 0 And $r_place_bet_0[0][1] = 0 And $r_place_bet_0[1][0] = 0 And $r_place_bet_0[1][1] = 0 Then
		MsgBox($MB_TOPMOST, "ERROR", "no valid coordinates found."&@CRLF& _
			"Please record the button-positions first."&@CRLF& _
			"To enter recording mode press ALT+C."&@CRLF& _
			"Then middle-Click the upper-left and lower right corner of each of the five buttons (in this specific order):"&@CRLF& _
			"first 'Place bet'"&@CRLF& _
			"First horse"&@CRLF& _
			"Increase bet"&@CRLF& _
			"second 'Place bet' (the one that starts the race)"&@CRLF& _
			"'Bet again'")
		Return
	EndIf
	; Disable hotkeys once in Main function.
	;HotKeySet("!a")
	$main = True
	HotKeySet("!c")

	; Loop until Quit() is called (alt + b).
	While $main
		; calculate random positions
		$m_pb_0 = RandomPointInRect($r_place_bet_0)
		$m_horse = RandomPointInRect($r_horse)
		
		$m_inc_bet = RandomPointInRect($r_inc_bet)
		$m_pb_1 = RandomPointInRect($r_place_bet_1)
		
		$m_bet_again = RandomPointInRect($r_bet_again)
		
		; Place bet button #1 to enter Race
		MouseMove($m_pb_0[0], $m_pb_0[1])
		Click()
		RandomDelay()

		; Choose horse button.
		MouseMove($m_horse[0], $m_horse[1])
		Click()
		RandomDelay()
		
		
		If Random(1) < $f_glitchShare Then
			Local $random_hold_click = Random($t_hold_click_min, $t_hold_click_max, 1)
			; Increase bet arrow button.
			MouseMove($m_inc_bet[0], $m_inc_bet[1])
			RandomDelay()
			MouseDown($MOUSE_CLICK_PRIMARY)

			; Place bet button #2.
			MouseMove($m_pb_1[0], $m_pb_1[1], 3)
			Sleep($random_hold_click)
			MouseUp($MOUSE_CLICK_PRIMARY)
			Sleep($t_race - $random_hold_click)
		Else
			; Increase bid the desired number of times
			MouseMove($m_inc_bet[0], $m_inc_bet[1])
			For $i = 1 To $i_bidIncNumber
				Click()
				RandomDelay()
			Next
			
			Sleep(Random(800, 2000, 1))
			
			; Place bet button #2.
			MouseMove($m_pb_1[0], $m_pb_1[1], 3)
			Click()
			Sleep($t_race)
		EndIf
		
		

		; Bet again button.
		MouseMove($m_bet_again[0], $m_bet_again[1])
		Click()
		RandomDelay()
	WEnd
EndFunc

; perform a single Click with a randomized duration
Func Click()
	MouseDown($MOUSE_CLICK_PRIMARY)
	Sleep(Random($t_click_min, $t_click_max, 1))
	MouseUp($MOUSE_CLICK_PRIMARY)
EndFunc

Func RandomPointInRect($r_rect)
	Local $ret[2]
	$ret[0] = Random($r_rect[0][0], $r_rect[1][0], 1)
	$ret[1] = Random($r_rect[0][1], $r_rect[1][1], 1)
	return $ret
EndFunc

Func RandomDelay()
	Sleep(Random($t_delay_min, $t_delay_max, 1))
EndFunc

; Record button locations.
Func RecordButtonLocations()
	; Disable hotkeys while recording.
	HotKeySet("!a")
	HotKeySet("!c")
	
	$main = True
	Beep(1500, 250)
	
	; store the values in temp variables, so we can easily discard them if the user aborts at any time
	Local $rt_place_bet_0 = RecordRectangle()
	Local $rt_horse = RecordRectangle()
	Local $rt_inc_bet = RecordRectangle()
	Local $rt_place_bet_1 = RecordRectangle()
	Local $rt_bet_again = RecordRectangle()
	
	if Not $main Then ; aborted by user
		Beep(1500, 150)
		Sleep(100)
		Beep(1500, 150)
		Sleep(100)
		Beep(1500, 150)
		Return
	EndIf
	
	$r_place_bet_0 = $rt_place_bet_0
	$r_horse = $rt_horse
	$r_inc_bet = $rt_inc_bet
	$r_place_bet_1 = $rt_place_bet_1
	$r_bet_again = $rt_bet_again
	
	
	IniWrite($inidir, $General, "glitchShare", String($f_glitchShare))
	IniWrite($inidir, $General, "bidIncNumber", String($i_bidIncNumber))
	
	IniWrite($inidir, $Rectangles, "place_bet_0", StringFromRect($r_place_bet_0))
	IniWrite($inidir, $Rectangles, "horse", StringFromRect($r_horse))
	IniWrite($inidir, $Rectangles, "inc_bet", StringFromRect($r_inc_bet))
	IniWrite($inidir, $Rectangles, "place_bet_1", StringFromRect($r_place_bet_1))
	IniWrite($inidir, $Rectangles, "bet_again", StringFromRect($r_bet_again))
	
	Beep(1500, 1000)
	$main = False
	; Re-enable hotkeys.
	HotKeySet("!a", "Main")
	HotKeySet("!c", "RecordButtonLocations")
EndFunc

Func AppendRectangleToString($str, $arr)
	Return $str&StringFormat("[[%d, %d], [%d, %d]]", $arr[0][0], $arr[0][1], $arr[1][0], $arr[1][1])
EndFunc

; Wait for MMB to be pressed and record location.
Func RecordButtonLocation()
	Local $mpos = [0, 0]
	While $main
		If _IsPressed(04, $handle_user32) Then
			$mpos = MouseGetPos()
			Beep(1500, 250)
			; Wait until key is no longer pressed.
			While _IsPressed(04, $handle_user32) <> 0 And $main
				Sleep(50)
			WEnd
			ExitLoop
		Endif
		Sleep(50);
	WEnd
	Return $mpos
EndFunc

Func RecordRectangle()
	Local $p1 = RecordButtonLocation()
	Local $p2 = RecordButtonLocation()
	Local $ret = [[$p1[0], $p1[1]], [$p2[0], $p2[1]]]
	Return $ret
EndFunc

Func RectFromString($str)
	$parts = StringSplit(StringStripWS($str, $STR_STRIPALL), ",", $STR_NOCOUNT)
	Local $ret = [[Int($parts[0]), Int($parts[1])], [Int($parts[2]), Int($parts[3])]]
	Return $ret
EndFunc

Func StringFromRect($rect)
	Local $ret = String($rect[0][0])&","&String($rect[0][1])&","&String($rect[1][0])&","&String($rect[1][1])
	Return $ret
EndFunc

Func Quit()
	If $main Then
		$main = False
	Else
		DllClose($handle_user32)
		Exit 0
	EndIf
EndFunc
