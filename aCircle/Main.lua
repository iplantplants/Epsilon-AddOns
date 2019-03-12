--

function doSteps(distance, angle)


	SendChatMessage(" gps f "..fwd, "GUILD");
	
	SendChatMessage(" gps u "..upw, "GUILD");

	return true;	
	end




SLASH_AC1, SLASH_AC2 = '/ac', '/AC';
local function handler(message, editBox)

distance, angle, option = message:match("(-?%d*\.?%d*) (-?%d*\.?%d*) (%d*)")



if tonumber(distance) < 0 then
print("negative "..distance);
end

i = 1;



C_Timer.NewTicker(1.5, function(self)

fwd = distance*cos(angle*i);
upw = distance*sin(angle*i);



if tonumber(option) == 0 then
print("negative")
fwdCCommand = ".gobj copy b ";
pitchCommand = i*angle;
else
fwdCCommand = ".gobj copy f ";
pitchCommand = "-"..i*angle;


end

upwMCommand = ".gobj move u ";

if i*angle > 90 then

if fwdCCommand:match("f") then
fwdCCommand = ".gobj copy b ";

print("back")
else
fwdCCommand = ".gobj copy f ";
end

end

if i*angle == 95 then
SendChatMessage(".gobj copy u "..upw)
--SendChatMessage(".gobj rotate 0 -".. 90-angle*i .. " 0")
--SendChatMessage(".gobj pitch "..angle)
else

if i*angle ~= 180 or i*angle ~= -180 or i*angle ~= 175 or i*angle ~= -175 then
SendChatMessage(fwdCCommand..fwd);
SendChatMessage(".gobj move u "..upw)
else
print(i*angle)
end


end
SendChatMessage(".gobj rotate 0 "..pitchCommand.." 0")


print(pitchCommand.." "..i.." f: "..fwd.." u:"..upw)


print(distance.."*cos("..i*angle..") = "..distance*cos(i*angle))
print(distance.."*sin("..i*angle..") = "..distance*cos(i*angle))
--print(i, fwd, upw)
i = i + 1;
end, 180/angle)


--local ticker = C_Timer.NewTicker(2.5, print(fwd, upw), 10)

--C_Timer.After(5, print(fwd, upw))


	--doSteps(fwd, upw)

--timer:Cancel()
--timer.cancel();
--print(url, channel);

end
SlashCmdList["AC"] = handler;
