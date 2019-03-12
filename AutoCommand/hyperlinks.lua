
local function stopTimer(timerID)
timerID = tonumber(timerID)
--print(ACtimers[timerID][1])
if table.getn(ACtimers) ~= 0 and timerID > 0 and timerID <= table.getn(ACtimers) then
ACtimers[timerID][2]:Cancel();
print("|cff00ccff[AutoCommand]|r Stopping timer: |cff00ccff"..timerID.."|r associated with command: |cff00ccff"..ACtimers[timerID][1].."|r")
--table.remove(ACtimers[timerID],2)
--table.remove(ACtimers[timerID],1)
table.remove(ACtimers,timerID)
end




end

local function removeCommand(commandID)
    commandID = tonumber(commandID);
    if table.getn(commands) ~= 0 and commandID > 0 and commandID <= table.getn(commands) then
    print("|cff00ccff[AutoCommand]|r |cffffffffRemoved command: "..commands[commandID].."|r")
    table.remove(commands, commandID)
    else
        -- do nothing cbfwriting error message 
    end

end


local	origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
ChatFrame_OnHyperlinkShow = function(...)
local chatFrame, link, text, button = ...;
    if type(text) == "string" and text:match("ACstop:") and not IsModifiedClick() then
        timerID = string.match(link, "ACstop:(%d*)");
        --print(link)
        if text:match("%[Stop%]") then
            --print(timerID)
            return stopTimer(timerID);
        end    
    end
    if type(text) == "string" and text:match("ACremovecommand:") and not IsModifiedClick() then
        commandListID = string.match(link, "ACremovecommand:(%d*)");
        --print(link)
        if text:match("%[Remove%]") then
            --print(timerID)
            return removeCommand(commandListID);
        end    
    end

return origChatFrame_OnHyperlinkShow(...); 
end

