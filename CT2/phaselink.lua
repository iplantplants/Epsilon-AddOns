--ADDED JUNE 23 2017
SLASH_PHASELINK1, SLASH_PHASELINK2 = '/pl', '/phaselink';
local function handler(message, editBox)
channel, phaseID = string.match(message, "(%a*) (%d*)")

if string.len(phaseID) < 10 then
	numberofZERO = 10 - string.len(phaseID)
	phaselink = math.random(1,20) .. string.format("%08d", phaseID, 1)
end

SendChatMessage("\124cff00ff00\124Hitem:"..phaselink.."\124h[Phase: "..phaseID.."]\124h\124r", string.upper(channel))

end
SlashCmdList["PHASELINK"] = handler;