import std/[os, osproc, tables, strutils]
import nlogout_config
import nigui


proc getDesktopEnvironment(): string =
  let xdgCurrentDesktop = getEnv("XDG_CURRENT_DESKTOP").toLower()
  if xdgCurrentDesktop != "":
    return xdgCurrentDesktop

  let desktopSession = getEnv("DESKTOP_SESSION").toLower()
  if desktopSession != "":
    return desktopSession

  return "unknown"

proc terminate(sApp: string) =
  discard execCmd("pkill " & sApp)

proc getIconPath(config: Config, buttonKey: string): string =
  result = ICON_THEME_PATH / config.iconTheme / (buttonKey & ".svg")
  if not fileExists(result):
    result = ICON_THEME_PATH / "default" / (buttonKey & ".svg")

proc hexToRgb(hex: string): Color =
  var hexColor = hex.strip()
  if hexColor.startsWith("#"):
    hexColor = hexColor[1..^1]
  if hexColor.len == 6:
    let
      r = byte(parseHexInt(hexColor[0..1]))
      g = byte(parseHexInt(hexColor[2..3]))
      b = byte(parseHexInt(hexColor[4..5]))
    result = rgb(r, g, b)
  else:
    result = rgb(0.byte, 0.byte, 0.byte)

###############################################################################
proc drawRoundedRect(canvas: Canvas, x, y, width, height, radius: float, color: Color) =
  # Set the fill and line color
  canvas.areaColor = color
  canvas.lineColor = color

  let radiusInt = radius.int

  # Draw the main rectangle
  canvas.drawRectArea(x.int + radiusInt, y.int, (width - radius * 2).int, height.int)
  canvas.drawRectArea(x.int, y.int + radiusInt, width.int, (height - radius * 2).int)


  # Draw the rounded corners using arcs
  canvas.drawArcOutline(x.int + radiusInt, y.int + radiusInt, radius, 180, 90)  # Top-left
  canvas.drawArcOutline((x + width).int - radiusInt, y.int + radiusInt, radius, 270, 90)  # Top-right
  canvas.drawArcOutline(x.int + radiusInt, (y + height).int - radiusInt, radius, 90, 90)  # Bottom-left
  canvas.drawArcOutline((x + width).int - radiusInt, (y + height).int - radiusInt, radius, 0, 90)  # Bottom-right


  # Fill the corners
  canvas.drawEllipseArea(x.int, y.int, radiusInt * 2, radiusInt * 2)  # Top-left
  canvas.drawEllipseArea((x + width).int - radiusInt * 2, y.int, radiusInt * 2, radiusInt * 2)  # Top-right
  canvas.drawEllipseArea(x.int, (y + height).int - radiusInt * 2, radiusInt * 2, radiusInt * 2)  # Bottom-left
  canvas.drawEllipseArea((x + width).int - radiusInt * 2, (y + height).int - radiusInt * 2, radiusInt * 2, radiusInt * 2)  # Bottom-right




proc createButton(cfg: ButtonConfig, config: Config, buttonKey: string, action: proc()): Control =
  var button = newControl()
  button.width = config.buttonWidth
  button.height = config.buttonHeight

  button.onDraw = proc(event: DrawEvent) =
    let canvas = event.control.canvas
    let buttonWidth = button.width.float
    let buttonHeight = button.height.float

    if config.cornerRadius > 0:
      drawRoundedRect(canvas, 0, 0, buttonWidth, buttonHeight, config.cornerRadius.float, hexToRgb(cfg.backgroundColor))
    else:
      canvas.areaColor = hexToRgb(cfg.backgroundColor)
      canvas.drawRectArea(0, 0, buttonWidth.int, buttonHeight.int)

    canvas.fontFamily = config.fontFamily
    canvas.fontSize = config.fontSize.float
    canvas.fontBold = config.fontBold
    canvas.textColor = hexToRgb(cfg.textColor)

    var y = config.buttonTopPadding.float

    # Draw icon
    let iconPath = getIconPath(config, buttonKey)
    if fileExists(iconPath):
      var icon = newImage()
      icon.loadFromFile(iconPath)
      let iconX = (buttonWidth - config.iconSize.float) / 2
      let iconY = y
      canvas.drawImage(icon, iconX.int, iconY.int, config.iconSize, config.iconSize)
      y += config.iconSize.float + 5  # Add some padding after the icon

    # Draw text
    if config.showText:
      let textWidth = canvas.getTextWidth(cfg.text).float
      let textX = (buttonWidth - textWidth) / 2
      canvas.drawText(cfg.text, textX.int, y.int)
      y += config.fontSize.float + 5  # Add some padding after the text

      # Draw shortcut
      if config.showshortcuttext:
        let shortcutText = "(" & cfg.shortcut & ")"
        let shortcutWidth = canvas.getTextWidth(shortcutText).float
        let shortcutX = (buttonWidth - shortcutWidth) / 2
        canvas.drawText(shortcutText, shortcutX.int, y.int)

  button.onClick = proc(event: ClickEvent) =
    action()

  return button


proc main() =
  let config = loadConfig()
  app.init()

  var window = newWindow()
  window.width = config.window.width
  window.height = config.window.height
  window.title = config.window.title

  var container = newLayoutContainer(Layout_Vertical)
  container.widthMode = WidthMode_Fill
  container.heightMode = HeightMode_Fill

  container.onDraw = proc (event: DrawEvent) =
    let canvas = event.control.canvas
    canvas.areaColor = hexToRgb(config.window.backgroundColor)
    canvas.drawRectArea(0, 0, window.width, window.height)

  window.add(container)

  # Top spacer
  var spacerTop = newControl()
  spacerTop.widthMode = WidthMode_Fill
  spacerTop.heightMode = HeightMode_Expand
  container.add(spacerTop)

  # Button container
  var buttonContainer = newLayoutContainer(Layout_Horizontal)
  buttonContainer.widthMode = WidthMode_Fill
  buttonContainer.height = config.buttonHeight + (2 * config.buttonPadding)

  buttonContainer.onDraw = proc (event: DrawEvent) =
    let canvas = event.control.canvas
    canvas.areaColor = hexToRgb(config.window.backgroundColor)
    canvas.drawRectArea(0, 0, buttonContainer.width, buttonContainer.height)

  container.add(buttonContainer)

  # Left spacer in button container
  var spacerLeft = newControl()
  spacerLeft.widthMode = WidthMode_Expand
  spacerLeft.heightMode = HeightMode_Fill
  buttonContainer.add(spacerLeft)

  proc logout() {.closure.} =
    for program in config.programsToTerminate:
      terminate(program)
    let desktop = getDesktopEnvironment()
    
    if desktop == "hyprland":
      discard execCmd("hyprctl dispatch exit")
    else:
      terminate(desktop)
    quit(0)

  let actions = {
    "cancel": proc() {.closure.} = app.quit(),
    "logout": logout,
    "reboot": proc() {.closure.} = discard execCmd("systemctl reboot"),
    "shutdown": proc() {.closure.} = discard execCmd("systemctl poweroff"),
    "suspend": proc() {.closure.} = discard execCmd("systemctl suspend"),
    "hibernate": proc() {.closure.} = discard execCmd("systemctl hibernate"),
    "lock": proc() {.closure.} =
      if config.lockScreenApp != "":
        discard execCmd(config.lockScreenApp)
      else:
        discard execCmd("loginctl lock-session")
  }.toTable

  for i, key in config.buttonOrder:
    if key in config.buttons and key in actions:
      if i > 0:  # Add spacing between buttons, but not before the first button
        var spacing = newControl()
        spacing.width = config.buttonPadding
        buttonContainer.add(spacing)

      var button = createButton(config.buttons[key], config, key, actions[key])
      buttonContainer.add(button)

  # Right spacer in button container
  var spacerRight = newControl()
  spacerRight.widthMode = WidthMode_Expand
  spacerRight.heightMode = HeightMode_Fill
  buttonContainer.add(spacerRight)

  # Bottom spacer
  var spacerBottom = newControl()
  spacerBottom.widthMode = WidthMode_Fill
  spacerBottom.heightMode = HeightMode_Expand
  container.add(spacerBottom)

  window.onKeyDown = proc(event: KeyboardEvent) =
    let keyString = standardizeKeyName($event.key)
    for key, cfg in config.buttons:
      let standardizedShortcut = standardizeKeyName(cfg.shortcut)
      if standardizedShortcut == keyString:
        if key in actions:
          actions[key]()
          return

  window.show()
  app.run()

main()
