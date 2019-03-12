local f  = CreateFrame("Frame", "rossTest", UIParent)

local x = 1
toggleFly = toggleFly or "off"; --value from saved variable or refer to default: off

local function spceFly(self, key)

    if key:lower() ~= "space" then 
        -- Do nothing
    else
        --print(self.lastPress)
        if self.lastPress and key:lower() == "space" and x == 0 then --No other key will start counter/timer
            local timer = time()
            print(x, self.lastPress)
            x = x+1 -- first space press
            --print("lastPress: "..self.lastPress)

            if self.lastPress+0.5 > timer and key:lower() == "space" and x == 1 then --Make sure
                x = x+1 -- second space press
                print(x,self.lastPress,timer)

                if x == 2 and self.lastPress+(0.5+0.5) > timer and key:lower() == "space" then
                    print(x,self.lastPress,timer)
                    x = x + 1 -- third space press
                    if toggleFly == "off" then --light switch
                        toggleFly = "on";
                    else
                        toggleFly = "off";
                    end
                    --print(toggleFly)
                    SendChatMessage(".cheat fly "..toggleFly,GUILD)
                    print(x)
                end                
                self.lastPress = nil --end the 'timer' (it will start again when they press space next time)
            else
                self.lastPress = time() --they didnt tap the second time fast enough so we reset the 'timer'
            end
        else
            self.lastPress = time() --start the tap 'timer'
        end
        x = 0
    end -- IF key is not equal to 'space' then don't go any further
end
 
f:SetScript("OnKeyDown", spceFly)
f:SetPropagateKeyboardInput(true)


local function getFlyState(self,event,message,...)
    if message:match("Fly Mode has been set to |cff00CCFF") then --If cheat fly message, do this
        toggleFly = message:match("|cff00CCFF(%w*)|r") --match a word with 1 or more occurences between |cff00CCFF and |r
        print(toggleFly)
    end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", getFlyState); --Filters system messages sent by the server