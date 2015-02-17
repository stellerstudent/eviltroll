on launchapps(applist, runtime)
	set start_value to do shell script "ruby -e 'print Time.now.to_f'"
	repeat
		repeat with x in applist
			tell application "System Events"
				set Proclst to name of every process
			end tell
			if x is not in Proclst then
				tell application x to activate
			end if
			
		end repeat
		set end_value to do shell script "ruby -e 'print Time.now.to_f'"
		if end_value - start_value ³ runtime then
			if runtime is not equal to "inf" then
				exit repeat
			end if
		end if
	end repeat
end launchapps

on quitall(whitelist)
	tell application "System Events"
		set Proclst to name of every process whose visible is true
	end tell
	repeat with x in Proclst
		if x is not in whitelist then
			tell application x to quit
		end if
	end repeat
end quitall


on screenshot()
	try
		do shell script "mkdir ~/.sc/sc"
	end try
	set volume 0
	delay 0.5
	do shell script "screencapture -f ~/.sc/sc"
	delay 0.5
end screenshot


on setbg()
	tell application "System Events"
		tell current desktop
			set picture to "~/.sc/sc"
		end tell
	end tell
end setbg

on toggledock()
	tell application "System Events"
		keystroke "d" using {command down, option down}
	end tell
end toggledock


on trollbg()
	quitall({"troll"})
	screenshot
	toggledock
	setbg
end trollbg


on hurr(runtime)
	tell application "Safari" to quit
	set start_value to do shell script "ruby -e 'print Time.now.to_f'"
	repeat
		tell application "System Events"
			set ProcessList to name of every process
			if "Safari" is not in ProcessList then
				tell application "Safari"
					activate
					open location "http://hurr-durr.com/"
				end tell
			end if
		end tell
		set end_value to do shell script "ruby -e 'print Time.now.to_f'"
		if end_value - start_value ³ runtime then
			if runtime is not equal to "inf" then
				exit repeat
			end if
		end if
	end repeat
end hurr

on pwrdown(delaytime)
	delay delaytime
	tell application "System Events"
		shut down
	end tell
end pwrdown





on run argv
	try
		set testvar to item 1 of argv
	on error
		error "



Usage: (modules are in chronological order)

-a NUM    Sets infinite app launch to true and sets the number of seconds to 
          repeat the app launch loop

-w        Sets screenshot to wallpaper to true, this will close all apps 
          and take a screenshot of the desktop, set it as the wallpaper, 
          and hide the dock
         
-h NUM    Sets hurr-durr to true, which will tell the script to 
          open hurr-durr.com in Safari
	     
-s NUM    Sets shutdown to true, this will shut down the computer

-n NUM    NUKE (Set all modules to true and all times to NUM seconds)
		
		
		
		"
	end try
	
	set applaunch to false
	set applaunchtime to 0
	set screenshotbg to false
	set hurrdurr to false
	set hurrdurrtime to 0
	set shutdown to false
	set shutdowntime to 0
	
	repeat with x from 1 to 8
		try
			if item x of argv is equal to "-a" then
				set applaunch to true
				set altime to x + 1
				set applaunchtime to item altime of argv
			else if item x of argv is equal to "-w" then
				set screenshotbg to true
			else if item x of argv is equal to "-h" then
				set hurrdurr to true
				set hdtime to x + 1
				set hurrdurrtime to item hdtime of argv
			else if item x of argv is equal to "-s" then
				set shutdown to true
				set sdtime to x + 1
				set shutdowntime to item sdtime of argv
			else if item x of argv is equal to "-n" then
				set ntime to x + 1
				set nuketime to item ntime of argv
				set applaunch to true
				set applaunchtime to nuketime
				set screenshotbg to true
				set hurrdurr to true
				set hurrdurrtime to nuketime
				set shutdown to true
				set shutdowntime to nuketime
			end if
			
		end try
	end repeat
	
	set applist to {"Calculator", "System Preferences", "Terminal", "Dictionary", "System Information", "Stickies", "TextEdit"}
	
	if applaunch then
		launchapps(applist, applaunchtime)
	end if
	
	if screenshotbg then
		trollbg()
	end if
	
	if hurrdurr then
		hurr(hurrdurrtime)
	end if
	
	if shutdown then
		pwrdown(shutdowntime)
	end if
end run
