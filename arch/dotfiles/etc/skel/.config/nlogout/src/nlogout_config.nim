import std/[os, sequtils, strutils, tables]
import parsetoml

type
  ButtonConfig* = object
    text*, shortcut*, backgroundColor*, textColor*: string

  WindowConfig* = object
    width*, height*: int
    title*, backgroundColor*: string

  Config* = object
    buttons*: Table[string, ButtonConfig]
    buttonOrder*: seq[string]
    window*: WindowConfig
    programsToTerminate*: seq[string]
    fontFamily*: string
    fontSize*: int
    fontBold*: bool
    showText*: bool
    showshortcuttext*: bool
    buttonWidth*: int
    buttonHeight*: int
    buttonPadding*: int
    buttonTopPadding*: int
    cornerRadius*: int
    iconSize*: int
    iconTheme*: string
    lockScreenApp*: string

const
  CONFIG_PATH* = getHomeDir() / ".config/nlogout/config.toml"
  ICON_THEME_PATH* = getHomeDir() / ".config/nlogout/themes"
  DEFAULT_BUTTON_ORDER = @["cancel", "logout", "reboot", "shutdown", "suspend", "hibernate", "lock"]
  DEFAULT_CONFIG = Config(
    buttons: {
      "cancel": ButtonConfig(text: "Cancel", shortcut: "Escape", backgroundColor: "#f5e0dc", textColor: "#363a4f"),
      "logout": ButtonConfig(text: "Logout", shortcut: "L", backgroundColor: "#cba6f7", textColor: "#363a4f"),
      "reboot": ButtonConfig(text: "Reboot", shortcut: "R", backgroundColor: "#f5c2e7", textColor: "#363a4f"),
      "shutdown": ButtonConfig(text: "Shutdown", shortcut: "S", backgroundColor: "#f5a97f", textColor: "#363a4f"),
      "suspend": ButtonConfig(text: "Suspend", shortcut: "U", backgroundColor: "#7dc4e4", textColor: "#363a4f"),
      "hibernate": ButtonConfig(text: "Hibernate", shortcut: "H", backgroundColor: "#a6da95", textColor: "#363a4f"),
      "lock": ButtonConfig(text: "Lock", shortcut: "K", backgroundColor: "#8aadf4", textColor: "#363a4f")
    }.toTable,
    buttonOrder: DEFAULT_BUTTON_ORDER,
    window: WindowConfig(width: 642, height: 98, title: "nlogout", backgroundColor: "#313244"),
    programsToTerminate: @[""],
    fontFamily: "Noto Sans Mono",
    fontSize: 14,
    fontBold: true,
    showText: true,
    showshortcuttext: true,
    buttonWidth: 80,
    buttonHeight: 80,
    buttonPadding: 3,
    buttonTopPadding: 3,
    cornerRadius: 0,
    iconSize: 32,
    iconTheme: "default",
    lockScreenApp: "loginctl lock-session"
  )

proc standardizeKeyName*(key: string): string =
  result = key.toLower()
  if result.startsWith("key_"):
    result = result[4..^1]
  if result == "esc": result = "escape"
  elif result == "return": result = "enter"

proc loadConfig*(): Config =
  result = DEFAULT_CONFIG
  if fileExists(CONFIG_PATH):
    let toml = parsetoml.parseFile(CONFIG_PATH)
    if toml.hasKey("window"):
      let windowConfig = toml["window"]
      result.window.width = windowConfig.getOrDefault("width").getInt(result.window.width)
      result.window.height = windowConfig.getOrDefault("height").getInt(result.window.height)
      result.window.title = windowConfig.getOrDefault("title").getStr(result.window.title)
      result.window.backgroundColor = windowConfig.getOrDefault("background_color").getStr(result.window.backgroundColor)

    if toml.hasKey("font"):
      let fontConfig = toml["font"]
      result.fontFamily = fontConfig.getOrDefault("family").getStr(result.fontFamily)
      result.fontSize = fontConfig.getOrDefault("size").getInt(result.fontSize)
      result.fontBold = fontConfig.getOrDefault("bold").getBool(result.fontBold)

    if toml.hasKey("button"):
      let buttonConfig = toml["button"]
      result.showText = buttonConfig.getOrDefault("show_text").getBool(result.showText)
      result.showshortcuttext = buttonConfig.getOrDefault("keybind_text").getBool(result.showshortcuttext)
      result.buttonWidth = buttonConfig.getOrDefault("width").getInt(result.buttonWidth)
      result.buttonHeight = buttonConfig.getOrDefault("height").getInt(result.buttonHeight)
      result.buttonPadding = buttonConfig.getOrDefault("padding").getInt(result.buttonPadding)
      result.buttonTopPadding = buttonConfig.getOrDefault("top_padding").getInt(result.buttonTopPadding)
      result.iconSize = buttonConfig.getOrDefault("icon_size").getInt(result.iconSize)
      result.iconTheme = buttonConfig.getOrDefault("icon_theme").getStr(result.iconTheme)
      result.cornerRadius = buttonConfig.getOrDefault("corner_radius").getInt(result.cornerRadius)

    var configuredButtons: Table[string, ButtonConfig]
    if toml.hasKey("buttons"):
      let buttonConfigs = toml["buttons"]
      if buttonConfigs.kind == TomlValueKind.Table:
        for key, value in buttonConfigs.getTable():
          if value.kind == TomlValueKind.Table:
            let btnConfig = value.getTable()
            configuredButtons[key] = ButtonConfig(
              text: btnConfig.getOrDefault("text").getStr(DEFAULT_CONFIG.buttons.getOrDefault(key).text),
              shortcut: standardizeKeyName(btnConfig.getOrDefault("shortcut").getStr(DEFAULT_CONFIG.buttons.getOrDefault(key).shortcut)),
              backgroundColor: btnConfig.getOrDefault("background_color").getStr(DEFAULT_CONFIG.buttons.getOrDefault(key).backgroundColor),
              textColor: btnConfig.getOrDefault("text_color").getStr(DEFAULT_CONFIG.buttons.getOrDefault(key).textColor)
            )

    result.buttons = configuredButtons

    if toml.hasKey("button_order"):
      let orderArray = toml["button_order"]
      if orderArray.kind == TomlValueKind.Array:
        result.buttonOrder = @[]
        for item in orderArray.getElems():
          if item.kind == TomlValueKind.String:
            let key = item.getStr()
            if key in configuredButtons:
              result.buttonOrder.add(key)
    elif configuredButtons.len > 0:
      # If no button_order is specified, use all configured buttons
      result.buttonOrder = toSeq(configuredButtons.keys)
    else:
      # If no buttons are configured, use the default order
      result.buttonOrder = DEFAULT_BUTTON_ORDER

    if toml.hasKey("programs_to_terminate"):
      result.programsToTerminate = toml["programs_to_terminate"].getElems().mapIt(it.getStr())

    if toml.hasKey("lock_screen_app"):
      result.lockScreenApp = toml["lock_screen_app"].getStr(result.lockScreenApp)
