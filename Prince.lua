local ANCHOR = CreateFrame("Frame", nil, UIParent)
local Interval = 10
local EventTime = time()

ANCHOR:SetScript("OnEvent", function () Event() end)
ANCHOR:RegisterEvent("PLAYER_LOGIN")

local function Start(option)
	if option == "on" then
		ANCHOR:RegisterEvent("CHAT_MSG_CHANNEL")
		DEFAULT_CHAT_FRAME:AddMessage("|CFFB700B7Prince Nazjak|CFFFFFFFF's search is |cff58ff00ON")
	elseif option == "off" then
		ANCHOR:UnregisterEvent("CHAT_MSG_CHANNEL")
		DEFAULT_CHAT_FRAME:AddMessage("|CFFB700B7Prince Nazjak|CFFFFFFFF's search is |cff58ff00OFF")
	elseif option == "interval" then
		DEFAULT_CHAT_FRAME:AddMessage("|CFFB700B7Prince Nazjak|CFFFFFFFF's interval is |cff58ff00" .. Interval)
	elseif strfind(option, '^interval%s') then
		for interval in string.gfind(option, "interval%s*(%S*)") do
			if tonumber(interval) then
				if (tonumber(interval) > 0) then
					Interval = tonumber(interval)
					DEFAULT_CHAT_FRAME:AddMessage("|CFFB700B7Prince Nazjak|CFFFFFFFF's interval set to |cff58ff00" .. Interval)
				end
			end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("Prince Nazjak's usage:")
		DEFAULT_CHAT_FRAME:AddMessage("/Prince on")
		DEFAULT_CHAT_FRAME:AddMessage("/Prince off")
		DEFAULT_CHAT_FRAME:AddMessage("/Prince interval x")
	end
end

function Event()
	if event == "PLAYER_LOGIN" then
		Setup()
	elseif event == "CHAT_MSG_CHANNEL" then
		if (GetSubZoneText() == "The Drowned Reef" or GetSubZoneText() == "Faldir's Cove") then
			if time() - EventTime > Interval then
				print("Searching for Prince Nazjak...")
				TargetPrince()
				EventTime = time()
			end
		end
	end
end

function TargetPrince()
	local name = "Prince Nazjak"

	TargetByName(name, true)
	if UnitName("target") == name then
		if UnitHealth("target") == 0 then
			PlaySoundFile("Interface\\AddOns\\Prince\\Sounds\\dead.mp3");
			print("Prince Nazjak is dead!")
		else
			PlaySoundFile("Interface\\AddOns\\Prince\\Sounds\\alive.mp3")
			print("Prince Nazjak RESPAWNED!")
		end
	end
end

function Setup()
	EventTime = time() - 1 - Interval
	DEFAULT_CHAT_FRAME:AddMessage("|CFFB700B7Prince Nazjak |cff58ff00v0.0.1|CFFFFFFFF lodaded.")
	DEFAULT_CHAT_FRAME:AddMessage("|CFFB700B7/Prince on|CFFFFFFFF to activate |CFFB700B7Prince Nazjak |CFFFFFFFFsearch.")
end

SLASH_PRINCE1 = "/Prince"

SlashCmdList["PRINCE"] = Start