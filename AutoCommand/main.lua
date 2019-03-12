commands = commands or {}
ACinterval = ACinterval or nil;
ACstate = ACstate or "ON";

--options["OPTION"][1] - for lowercase command
--options["OPTION"][2] - for help message
--settings 

options = {
	["Add"] = {"add", "|cff00ccffSyntax: /ac add $command|r\nAdds a command to the command list."},
	["Remove"] = {"remove", "|cff00ccffSyntax: /ac remove #index|r\nRemoves a command from the command list."},
	["Help"] = {"help", "|cff00ccffSyntax: /ac help command|r OR |cff00ccff/ac help|r\nDisplays this help menu."},
	["List"] = {"list", "|cff00ccffSyntax /ac list|r OR |cff00ccff/ac list timers|r\n Lists all saved commands or timers."},
	["Toggle"] = {"toggle", "|cff00ccffSyntax: /ac toggle|r\nToggles AutoCommand on or off."},
	["Settings"] = {
		["Time"] = {"time", "|cff00ccffSyntax: /ac settings time #SECONDS.|r\nSet time interval for automatic execution of commands. Both values must be numeric."},
		["State"] = {"state", "|cff00ccffSyntax: /ac set state $ON/OFF|r\nToggle state of AutoCommand on or off."}
	},
}

ACtimers = {};
ACTimerIndex = 0;



local function addCommand(command)
	print("|cff00ccff[AutoCommand]|r |cffffffffAdding Command: " .. command .. "|r")
	table.insert(commands,command)
	return true;
end

local function removeCommand(command)
	--ensure argument is a number.
	local index = tonumber(string.match(command, "(%d*)"))
	local tableLength = table.getn(commands)
	if index == "" or index == nil then
		print("|cff00ccff[AutoCommand]|r|cffffffff ERROR: You must enter a number.|r")
	else
		if index <= table.getn(commands) and index > 0 then
			print("|cff00ccff[AutoCommand]|r |cffffffffRemoving Command: "..commands[tonumber(index)].."|r")
			table.remove(commands,tonumber(index))
		return true

		else
			print("|cff00ccff[AutoCommand]|r|cffffffff ERROR: Argument must be within the bounds of the array.|r")

		end
	end
end

local function helpCommand(command)
	local helpMessage = "|cff00ccff";
	if command == "Settings" or command == "settings" then

		for k,v in pairs(options["Settings"]) do
			helpMessage = helpMessage..k.."|r, |cff00ccff"
		end
		print("|cff00ccff[AutoCommand]|r Available Subcommands for |cff00ccff"..command.."|r:")
		print(helpMessage)

	elseif command == "Help" or command == "help" then

		print("|cff00ccff[AutoCommand]|r Available Options:")
		for k,v in pairs(options) do
			if k == "Settings" then
				helpMessage = helpMessage..k.."...|r, |cff00ccff"
			else
				helpMessage = helpMessage..k.."|r, |cff00ccff"
			end
			if k:match("Settings") or k:match(string.lower("settings")) then
				for k1,v1 in pairs(options["Settings"]) do

						helpMessage = helpMessage..k1.."|r, |cff00ccff";
					
					--print("Match Arg",option,argument,message);
				end
				--print(argument)
			end
		end
		print(helpMessage)

	else --help with specific command
		print("|cff00ccff[AutoCommand]|r Available Help for command:")
		for k,v in pairs(options) do
			if command:match(k) or command:match(string.lower(k)) then
				helpMessage = options[k][2]
				if k:match("Settings") or k:match(string.lower("settings")) then
					for k1,v1 in pairs(options["Settings"]) do
						--print(options["Settings"][k1][2])
						if string.lower(command):match(string.lower(k1)) then
							helpMessage = options["Settings"][k1][2]
						end
					end
				end
			end
		end	

		print(helpMessage)

	end

	--old help menu. replaced with array
	-- print("|cff00ccff[AutoCommand]|r |cffffffffHelp Menu|r\n"
	-- 	.. "|cff00ccffAdd|r - |cffffffffAdd a command to be executed on login. SYNTAX: /ac add COMMAND|r\n"
	-- 	.. "|cff00ccffRemove|r - |cffffffffRemove a command using the index of the command from the saved list. SYNTAX: /ac remove #number|r \n"
	-- 	.. "|cff00ccffList|r - |cffffffffLists commands including their numbers required for removal.|r\n"
	-- 	.. "|cff00ccffHelp|r - |cffffffffDisplays this help menu.|r\n"
	-- 	.. "|cff00ccffSettings|r - Subcommands: \n"
	-- 	..	"|cff00ccffTimer|r - SYNTAX: /ac settings time #interval #commandID (interval is in seconds) (commandID can be obtained from /ac list)\n"
	-- 	..	"|cff00ccffState|r - SYNTAX: /ac settings state ON");
return
end

local function listCommands(command)

	if command:match("timers") or command:match("time") then
		print("|cff00ccff[AutoCommand]|r |cffffffff("..table.getn(ACtimers)..") Active Timers|r")
		for k,v in pairs(ACtimers) do
			--print(k,v[1],v[2]["_remainingIterations"])
			local index = k;
			local command = v[1];
			local duration = v[2]["_remainingIterations"];
			print("|cff00ccff"..index.."|r","Command: |cff00ccff"..command.."|r", "Iterations remaining: |cff00ccff"..duration.."|r - |cff00ccff|HACstop:"..index.."|h[Stop]|h|r")
		end
		print("|cff00ccff[AutoCommand]|r |cffffffffEnd of List|r")
	else
		print("|cff00ccff[AutoCommand]|r |cffffffff("..table.getn(commands)..") Stored Commands|r")
		for k,v in pairs(commands) do
			print("|cffffffff"..k.."|r","|cff00ccff"..v.."|r - |cff00ccff|HACremovecommand:"..k.."|h[Remove]|h|r")
		end
	print("|cff00ccff[AutoCommand]|r |cffffffffEnd of List|r")
	return
	end
end

local function toggleAutoCommand()
	if ACstate == "ON" then
		ACstate = "OFF";
	elseif ACstate == "OFF" then
		ACstate = "ON";
	end
	print("|cff00ccff[AutoCommand]|r is now |cff00ccff"..ACstate.."|r")
end

local function executeCommand(command)
	--print("executecommand")
	SendChatMessage(command, "GUILD");
end

local function setTime(argument)

	argument = argument:gsub("%s", ",")

	if argument:match("stop") then

		for i = 1,table.getn(ACtimers) do
			if table.getn(ACtimers) > 0 then
				ACtimers[1][2]:Cancel()
				table.remove(ACtimers,1)
			end
		end
		print("|cff00ccff[AutoCommand]|r Stopped all timers.")
	else

	local index = 0;
	--print(argument)
	local ACinterval, command = argument:match("(-?%d*\.?%d*),(%d*)");
	ACinterval = tonumber(ACinterval);
	command = tonumber(command);

	print(ACinterval,command)
	if ACinterval == nil or command == nil then
		print("|cff00ccff[AutoCommand]|r Error: input must be numeric.\n"..options["Settings"]["Time"][2])
		elseif ACinterval < 0 then
			print("|cff00ccff[AutoCommand]|r Error: Interval time must be greater than 0.")
		elseif command <= table.getn(commands) and command > 0 then
			if ACinterval > 0 then
				ACstate = "ON"
				ACTimerIndex = table.getn(ACtimers)+1;
				ACtimers[ACTimerIndex] = {commands[command], C_Timer.NewTicker(ACinterval, function(self)
				if ACstate == "ON" then
					executeCommand(commands[command]);
				end
				end, 1000) }

			print("|cff00ccff[AutoCommand]|r will execute the command: |cff00ccff"..commands[command].."|r every |cff00ccff"..ACinterval.. "|r second(s).")
			else
				print("Time must be greater than 0") 
			end
			else
			print("|cff00ccff[AutoCommand]|r Error: command index must be within the range of the commands array.")
		end
	end
end

local function setState(argument)
	if argument:match("On") or argument:match("on") then
		ACstate = "ON";
	elseif argument:match("Off") or argument:match("off") then
		ACstate = "OFF";
	end
	print("|cff00ccff[AutoCommand]|r is now: |cff00ccff"..ACstate.."|r")
end

--Fire commands from array
local EventFrame = CreateFrame("FRAME")
	EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	EventFrame:SetScript("OnEvent", function(...)

	if ACState == "ON" then
		for k,v in pairs(commands) do
			executeCommand(v);
		end
	else
		print("|cff00ccff[AutoCommand]|r is turned |cff00ccff"..ACstate.."|r, to execute commands automatically, it must be turned: |cff00ccffON|r")
	end
end)

SLASH_AUTOCOMMAND1, SLASH_AUTOCOMMAND2 = '/ac', '/autocommand';
local function handler(message, editBox)

	local option = "invalid";
	local argument = "invalid";
	for k,v in pairs(options) do
		if message:match(k) or message:match(string.lower(k)) then
			option = k;
		end

		if message:match("Help") or message:match("help") then
			option = "Help";
		end

		if k:match("Settings") or k:match(string.lower("settings")) then
			for k1,v1 in pairs(options["Settings"]) do
				if message:match(k1) or message:match(string.lower(k1)) then
					argument = k1;
					--print("Match Arg",option,argument,message);
				end
			end
		end

end

--case switch hack for doing things


if option == "invalid" then
	print("|cff00ccff[AutoCommand]|r Invalid option.");
	elseif option == "Help" then
		--print("help command")
		helpCommand(message:gsub("[H-h]elp ", ""));
	elseif option == "Add" then
		--print("add command")
		addCommand(message:gsub("add ", ""));	
	elseif option == "Remove" then
		--print("remove command")
		removeCommand(message:gsub("remove ", ""));		
	elseif option == "List" then
		--print("list command")
		listCommands(message:gsub("list ", ""));
	elseif option == "Toggle" then
		toggleAutoCommand();
	elseif option == "Settings" then
		--print("settings")
		if argument == "Time" then
			--print("settings time")
			setTime(message:gsub("settings time[r]?[s]?%s", ""))
		elseif argument == "State" then
			--print("settings state")
			setState(message:gsub("settings state ",""))
		elseif argument == "invalid" then
			print("|cff00ccff[AutoCommand]|r Invalid argument.")
		end
	end
end
SlashCmdList["AUTOCOMMAND"] = handler;



