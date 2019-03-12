--

--ADDED JUNE 23 2017
SLASH_CURL1, SLASH_CURL2 = '/cl', '/curl';
local function handler(message, editBox)


channel = GetCurrentKeyBoardFocus():GetAttribute("chatType");
url = string.match(message, "(.*)")


--print(url, channel);
--Creature-0-1-1116-0-145422-0000000120
SendChatMessage("\124cff00ffff\124Hgarrfollower:178:8:105:692:130:131:127:0:0:0:0:0\124h"..url.."\124h\124r \124cff00ccff\124Hunit:Creature-0-1-1116-0-145422-0000000120\124h[How to Copy]\124h\124r", string.upper(channel)) --\124cff00ccff\124Hunit:1003\124h[How Copy]\124r", string.upper(channel)) --\124cff00ff00\124Hitem:139620\124h[How to Copy]\124h\124r

end
SlashCmdList["CURL"] = handler;
