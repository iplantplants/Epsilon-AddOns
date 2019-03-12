local f  = CreateFrame("Frame", "rossTest", UIParent)

local key = "space";
local timerElapsed = 0.2;
counter = 0;
toggleFly = toggleFly or "off"; --value from saved variable or refer to default: off

local function spaceFly(self, key)

    --print(key)

    if key:lower() == "space" then
        if counter > 0 and lastPress+1 < GetTime() then
            counter = 0;
            --print("space timer reset")
        end

        if counter == 0 then -- first press
        lastPress= GetTime();
        timer = GetTime();
        counter = counter + 1;

        --print(counter, key, timer);
        elseif counter == 1 and lastPress < timer+timerElapsed then -- second press only if pressed within 0.5 seconds of first timer starting
            counter = counter + 1; --advance counter by 1
            lastPress = GetTime(); --set lastpress

            --print(counter,key,lastPress)           
        elseif counter == 2 and lastPress < timer+(timerElapsed+timerElapsed) then -- third press only if pressed within (0.5+0.5) seconds
            counter = counter + 1;
            lastPress = GetTime();

            --print(counter,key,lastPress)

            if toggleFly == "off" then --light switch
                toggleFly = "on";
            else
                toggleFly = "off";
            end
            --print(toggleFly)
            SendChatMessage(".cheat fly "..toggleFly,GUILD)
            counter = 0; -- reset

        end
    end

end

f:SetScript("OnKeyDown", spaceFly)
f:SetPropagateKeyboardInput(true)

local function getFlyState(self,event,message,...)
    if message:match("Fly Mode has been set to |cff00CCFF") then --If cheat fly message, do this
        toggleFly = message:match("|cff00CCFF(%w*)|r") --match a word with 1 or more occurences between |cff00CCFF and |r
        --print(toggleFly)
    end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", getFlyState); --Filters system messages sent by the server