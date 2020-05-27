local GPN = GetPlayerName -- original GetPlayerName native
local Nicknames = {}

function GetPlayerName(player)
    player = tonumber(player)
    local source = GetPlayerServerId(player)
    source = tonumber(source)
    if Nicknames[source] and Nicknames[source].name then
        return Nicknames[source].name
    end
    return GPN(source)
end

function GetPlayerColor(source)
    source = tonumber(source)
    if Nicknames[source] and Nicknames[source].color then
        return Nicknames[source].color
    end
    return {255, 255, 255} -- white by default
end

RegisterNetEvent("nicknames:update")
AddEventHandler("nicknames:update", function(nicknames)
    for source, nickname in next, nicknames do
        Nicknames[source] = nickname
    end
end)

CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/nickname", "Set your chat nickname", {{name = "nickname", help = "The name to display in chat"}})
    TriggerEvent("chat:addSuggestion", "/nick", "Set your chat nickname", {{name = "nickname", help = "The name to display in chat"}})
    TriggerEvent("chat:addSuggestion", "/color_adv", "Manually set name color in chat", {
        {name = "r", help = "Red color value (0-255)"},
        {name = "g", help = "Green color value (0-255)"},
        {name = "b", help = "Blue color value (0-255)"},
    })

    local colorList = json.decode(LoadResourceFile(GetCurrentResourceName(), "colors.json"))
    local availableColors = {}
    for color, _ in next, colorList do
        availableColors[#availableColors + 1] = color
    end
    TriggerEvent("chat:addSuggestion", "/color", "Set your name color in chat", {{name = "color", help = "Available colors: " .. table.concat(availableColors, ", ")}})

    TriggerServerEvent("nicknames:init")
end)
