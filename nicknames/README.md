# Nicknames

![](https://i.imgur.com/esjKaWO.png)

#### A nickname and chat color handler

Lets you set a nickname and a chat color

## Disclaimer
Nicknames are not automatically applied to all instances of a players name, FiveM does not supply such a feature.
Built-in chat override does **not** support frameworks, such as ExtendedMode, ESX or vRP.
Nicknames and colors are **not** stored between sessions!

## Commands
### Player commands
| Command | Description | Aliases |
| ------- | ----------- | ------- |
| `/color [color]` | Changes your color (for chat etc.) | _None_ |
| `/color_adv [r] [g] [b]` | Changes your color by rgb input (for chat etc.) | _None_ |
| `/nickname [nickname]` | Changes your nickname | `/nick` |

### Admin commands
| Command | Description | Aliases |
| ------- | ----------- | ------- |
| `/setnick [id] [nickname]` | Sets the target players nickname | _None_ |
| `/setcolor [id] [color]` | Sets the target players color | _None_ |
| `/setcoloradv [id] [r] [g] [b]` | Sets the target players color | _None_ |

## Configuration
The resource contains two files:
`blacklist.json`: Contains blacklisted phrases that can not be used in nicknames. (Only used server side)
`colors.json`: Contains colors with names, for the `/color` command. (Shared with the client to generate chat suggestions)
Other elements of the resource can be configured using convars

## Convars
**Pro tip:** This resource supports the [Webadmin Settings](https://forum.cfx.re/t/release-webadmin-settings-menu/869717) panel and automatically adds options there
| Variable | Description | Default value |
| -------- | ----------- | ------------- |
| `nick_chat` | Replace default chat behavior with this resource's own chat, showing nicknames and custom color in chat | true |
| `nick_chat_id` | Show the player's server id in the chat (requires `nick_chat` to be true) | true |
| `nick_nick_everyone` | Anyone can use `/nickname` (on themselves) | true |
| `nick_color_everyone` | Anyone can use `/color` (on themselves) | true |
| `nick_unique` | Require unique nicknames and prevent using existing names | true |
| `nick_blacklist` | Scan nicknames using the blacklist file before applying | true |
| `nick_notify` | Send notifications in chat | true |

## Developers
### Exports
These exports allow your own resources to set or get names and colors
#### Client
##### GetPlayerName
Returns the set nickname for the player (or their original name is none is set)
| Parameters | Description |
| ---------- | ----------- |
| `playerId` | The player to get the name of |
##### GetPlayerColor
Returns the set color for the player (or white if none is set)
| Parameters | Description |
| ---------- | ----------- |
| `playerId` | The player to get the color of |
#### Server
##### GetPlayerName
Returns the set nickname for the player (or their original name is none is set)
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player to get the name of |
##### GetPlayerColor
Returns the set color for the player (or white if none is set)
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player to get the color of |
##### SetPlayerName
Sets the target players override name
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player to set the name of |
| `nickname` | The name to give them |
Alias: `SetPlayerNickname`
##### SetPlayerColor
Sets the target players color
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player to set the color of |
| `red` | The red component (0-255) |
| `green` | The green component (0-255) |
| `blue` | The blue component (0-255) |
| `name` | The color name (optional) |
### Events (set)
These events can be triggered on the server to set names and colors
#### Server
##### setPlayerName
Sets the target players override name
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player to set the name of |
| `nickname` | The name to give them |
Alias: `setPlayerNickname`
##### setPlayerColor
Sets the target players color
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player to set the color of |
| `red` | The red component (0-255) |
| `green` | The green component (0-255) |
| `blue` | The blue component (0-255) |
| `name` | The color name (optional) |
### Events (listeners)
These events can be listened for in your own resources to do stuff when changes are made
#### Server
##### onPlayerNameChange
Triggered when a player's name changes
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player whose name changed |
| `nickname` | Their new name |
Alias: `onPlayerNicknameChange`
##### onPlayerColorChange
Triggered when a player's color changes
| Parameters | Description |
| ---------- | ----------- |
| `serverId` | The player whose color changed |
| `red` | Their new red value |
| `green` | Their new green value |
| `blue` | Their new blue value |
| `name` | The name of their new color (not guaranteed to be present) |

## Credits
Script by @glitchdetector
