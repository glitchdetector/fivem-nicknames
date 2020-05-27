local GPN = GetPlayerName -- original GetPlayerName native
local Nicknames = {}

-- External data, configurable in their own files
local Blacklist = {}
local Colors = {}
CreateThread(function()
    Blacklist = json.decode(LoadResourceFile(GetCurrentResourceName(), "blacklist.json"))
    Colors = json.decode(LoadResourceFile(GetCurrentResourceName(), "colors.json"))
end)

function Notify(source, text)
    if GetConvar("nick_notify", "true") == "true" then
        TriggerClientEvent("chat:addMessage", source, {
            args = {"Error", text},
            color = {255, 0, 0},
        })
    end
end
function Success(source, text, col)
    if GetConvar("nick_notify", "true") == "true" then
        TriggerClientEvent("chat:addMessage", source, {
            args = (col and {text} or {"Success", text}),
            color = (col or {0, 255, 0}),
        })
    end
end

-- Override a players name with a nickname
function SetNickname(source, nickname)
    -- Setup data table if not already present
    source = tonumber(source)
    if not Nicknames[source] then Nicknames[source] = {} end

    -- Check name blacklist
    if GetConvar("nick_blacklist", "true") == "true" then
        local nickLower = nickname:lower()
        for _, phrase in next, Blacklist do
            if nickLower:find(phrase) ~= nil then
                -- illegal phrase, return to prevent further execution
                Notify(source, "Blacklisted phrase in nickname")
                return false
            end
        end
    end
    -- Check unique name
    if GetConvar("nick_unique", "true") == "true" then
        local nickLower = nickname:lower()
        -- check nicknames
        for serverId, nick in next, Nicknames do
            if nick.name and nick.name:lower() == nickLower then
                -- make sure we're not impersonating ourselves
                if tonumber(serverId) ~= source then
                    Notify(source, "Not a unique nickname")
                    return false
                end
            end
        end
        -- check base names
        for serverId, player in next, GetPlayers() do
            if GPN(player):lower() == nickLower then
                -- make sure we're not impersonating ourselves
                if tonumber(serverId) ~= source then
                    Notify(source, "Not a unique nickname")
                    return false
                end
            end
        end
    end
    -- Store new nickname
    Nicknames[source].name = nickname
    -- Send nickname update to clients and other resources
    Success(source, "Nickname changed to " .. nickname, GetPlayerColor(source))
    TriggerEvent("onPlayerNicknameChange", source, nickname)
    TriggerEvent("onPlayerNameChange", source, nickname)
    TriggerClientEvent("nicknames:update", -1, {[source] = Nicknames[source]})
end

-- Override a players color (for chat etc.)
function SetColor(source, r, g, b, name)
    -- Setup data table if not already present
    source = tonumber(source)
    if not Nicknames[source] then Nicknames[source] = {} end

    -- Store new color
    Nicknames[source].color = {r, g, b}
    -- Send color update to clients and other resources
    Success(source, "Color changed to " .. (name or "custom"), Nicknames[source].color)
    TriggerEvent("onPlayerColorChange", source, r, g, b, name)
    TriggerClientEvent("nicknames:update", -1, {[source] = Nicknames[source]})
end

-- Command handler for /nickname
function nicknameHandler(source, args)
    if #args < 1 then
        Notify(source, "No nickname specified")
        return false
    end
    local nickname = table.concat(args, " ")
    SetNickname(source, nickname)
end
-- Proxy function to check for permissions when required
function nicknameHandlerProxy(source, args)
    local function notify(text)
        Notify(source, text)
    end
    if GetConvar("nick_nick_everyone", "true") ~= "true" then
        if not IsPlayerAceAllowed(source, "command.nickname") then
            -- Player does not have permission to use the command
            Notify(source, "Not allowed to use this command")
            return false
        end
    end
    nicknameHandler(source, args)
end
RegisterCommand("nickname", nicknameHandlerProxy) -- /nickname [nickname]
RegisterCommand("nick", nicknameHandlerProxy) -- /nick [nickname]

-- Command handler for /color
function colorHandler(source, args)
    if #args < 1 then
        Notify(source, "No color specified")
        return false
    end
    local selectedColor = args[1]:lower()
    if Colors[selectedColor] then
        local color = Colors[selectedColor]
        SetColor(source, color[1], color[2], color[3], selectedColor)
    else
        Notify(source, "Invalid color specified")
        return false
    end
end
-- Proxy function to check for permissions when required
function colorHandlerProxy(source, args)
    if GetConvar("nick_color_everyone", "true") ~= "true" then
        if not IsPlayerAceAllowed(source, "command.color") then
            -- Player does not have permission to use the command
            Notify(source, "Not allowed to use this command")
            return false
        end
    end
    colorHandler(source, args)
end
RegisterCommand("color", colorHandlerProxy) -- /color [color]

-- Command handler for /color_adv
function colorAdvHandler(source, args)
    if #args < 3 then
        Notify(source, "No color specified")
        return false
    end
    local r = math.min(255, math.max(0, math.floor(tonumber(args[1]))))
    local g = math.min(255, math.max(0, math.floor(tonumber(args[2]))))
    local b = math.min(255, math.max(0, math.floor(tonumber(args[3]))))
    SetColor(source, r, g, b, "custom")
end
-- Proxy function to check for permissions when required
function colorAdvHandlerProxy(source, args)
    if GetConvar("nick_color_everyone", "true") ~= "true" then
        if not IsPlayerAceAllowed(source, "command.color") then
            -- Player does not have permission to use the command
            Notify(source, "Not allowed to use this command")
            return false
        end
    end
    colorAdvHandler(source, args)
end
RegisterCommand("color_adv", colorAdvHandlerProxy) -- /color_adv [r] [g] [b]

-- Admin commands /command [id] [...]
RegisterCommand("setnick", function(source, args)
    nicknameHandler(table.remove(args, 1), args) -- /setnick [id] [nickname]
end, true)
RegisterCommand("setcolor", function(source, args)
    colorHandler(table.remove(args, 1), args) -- /setcolor [id] [color]
end, true)
RegisterCommand("setcoloradv", function(source, args)
    colorAdvHandler(table.remove(args, 1), args) -- /setcoloradv [id] [r] [g] [b]
end, true)

-- Get a players nickname, if no nickname is set it uses default playername
-- Exported, can be used to replace GetPlayerName (via exports.nickname:GetPlayerName instead)
function GetPlayerName(source)
    source = tonumber(source)
    if Nicknames[source] and Nicknames[source].name then
        return Nicknames[source].name
    end
    return GPN(source)
end

-- Get a players color, if no color is set it uses white
-- Exported, no existing equivelent
function GetPlayerColor(source)
    source = tonumber(source)
    if Nicknames[source] and Nicknames[source].color then
        return Nicknames[source].color
    end
    return {255, 255, 255} -- white by default
end

-- Override a players nickname
-- Exported for other resources to use
function SetPlayerName(player, name)
    SetNickname(player, name)
end
AddEventHandler("setPlayerName", function(player, name)
    SetNickname(player, name)
end)

-- Override a players nickname
-- Exported for other resources to use
function SetPlayerNickname(player, nickname)
    SetNickname(player, nickname)
end
AddEventHandler("setPlayerNickname", function(player, nickname)
    SetNickname(player, nickname)
end)

-- Override a players color
-- Exported for other resources to use
function SetPlayerColor(player, r, g, b, name)
    SetColor(player, r, g, b, name)
end
AddEventHandler("setPlayerColor", function(player, r, g, b, name)
    SetColor(player, r, g, b, name)
end)

-- Client requests to receive all set nicknames
RegisterServerEvent("nicknames:init")
AddEventHandler("nicknames:init", function()
    TriggerClientEvent("nicknames:update", source, Nicknames)
end)

-- Chat handler
AddEventHandler("chatMessage", function(source, _, message)
    if GetConvar("nick_chat", "true") == "true" then
        -- Override default chat with new custom chat
        CancelEvent()
        local name = GetPlayerName(source)
        -- Add server id if required
        if GetConvar("nick_chat_id", "true") == "true" then
            name = ("[%s] %s"):format(source, name)
        end
        local color = GetPlayerColor(source)
        TriggerClientEvent("chat:addMessage", -1, {
            args = {name, message},
            color = color,
        })
    end
end)
