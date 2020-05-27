name 'Nicknames'
description 'Allows players to set nicknames and custom chat colors'
version '1.0'

author 'glitchdetector'
contact 'glitchdetector@gmail.com'

fx_version 'adamant'
game 'common'

file 'colors.json'

server_script 'sv_nicknames.lua'
client_script 'cl_nicknames.lua'
export 'GetPlayerName'
export 'GetPlayerColor'
server_export 'GetPlayerName'
server_export 'GetPlayerColor'
server_export 'SetPlayerName'
server_export 'SetPlayerNickname'
server_export 'SetPlayerColor'

-- Convar setup for https://forum.cfx.re/t/release-webadmin-settings-menu/869717
convar_category 'Nicknames' {
    'Control nickname access and properties',
    {
        {"Replace normal chat behavior", "nick_chat", "CV_BOOL", true},
        {"Show server ID in chat", "nick_chat_id", "CV_BOOL", true},
        {"Anyone can use /nickname", "nick_nick_everyone", "CV_BOOL", true},
        {"Anyone can use /color", "nick_color_everyone", "CV_BOOL", true},
        {"Require unique nicknames", "nick_unique", "CV_BOOL", true},
        {"Scan nicknames before applying", "nick_blacklist", "CV_BOOL", true},
        {"Send notifications in chat", "nick_notify", "CV_BOOL", true},
    }
}
