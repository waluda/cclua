-- industrial_panel_compact.lua for 3x2 monitor

-- Detect and wrap monitor
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end
if not monitor then error("No monitor found!") end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.gray)
monitor.setTextColor(colors.white)
monitor.clear()

-- Get monitor size
local w, h = monitor.getSize()

-- Button config
local buttons = {
    { label = "WATER PUMP", side = "left", state = false },
    { label = "VENTILATION", side = "right", state = false }
}

-- Visual layout parameters
local buttonH = 5
local buttonW = w - 4
local spacing = 2

-- Draw header
local function drawHeader()
    monitor.setCursorPos(math.floor((w - 30) / 2), 1)
    monitor.setTextColor(colors.lightGray)
    monitor.write("<< INDUSTRIAL CONTROL PANEL >>")
end

-- Draw a button
local function drawButton(btn, x, y)
    local bg = btn.state and colors.green or colors.red
    local ledColor = btn.state and colors.lime or colors.red

    -- Button box
    for dy = 0, buttonH - 1 do
        monitor.setCursorPos(x, y + dy)
        monitor.setBackgroundColor(bg)
        monitor.write((" "):rep(buttonW))
    end

    -- Button label (centered)
    monitor.setCursorPos(x + math.floor((buttonW - #btn.label) / 2), y + 2)
    monitor.setTextColor(colors.white)
    monitor.write(btn.label)

    -- LED dot (top-right)
    monitor.setCursorPos(x + buttonW - 2, y)
    monitor.setTextColor(ledColor)
    monitor.write("●")

    -- Save bounds
    btn.bounds = { x1 = x, y1 = y, x2 = x + buttonW - 1, y2 = y + buttonH - 1 }
end

-- Draw all buttons
local function drawButtons()
    monitor.clear()
    drawHeader()
    local startY = 3
    for i, btn in ipairs(buttons) do
        local y = startY + (i - 1) * (buttonH + spacing)
        drawButton(btn, 3, y)
    end
end

-- Detect button click
local function getButtonAt(x, y)
    for i, btn in ipairs(buttons) do
        local b = btn.bounds
        if x >= b.x1 and x <= b.x2 and y >= b.y1 and y <= b.y2 then
            return i
        end
    end
    return nil
end

-- Toggle button + redstone
local function toggleButton(i)
    local btn = buttons[i]
    btn.state = not btn.state
    redstone.setOutput(btn.side, btn.state)
    drawButtons()
end

-- Init
drawButtons()

-- Event loop
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    local i = getButtonAt(x, y)
    if i then toggleButton(i) end
end
