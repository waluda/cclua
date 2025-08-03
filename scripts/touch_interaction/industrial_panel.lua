-- industrial_panel.lua for 3x2 monitor (3 blocks wide, 2 blocks high)

-- Auto-detect monitor
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

-- Button config
local buttons = {
    { label = "WATER PUMP", side = "left", state = false },
    { label = "VENTILATION", side = "right", state = false },
    { label = "EMERGENCY", side = "back", state = false }
}

local buttonW, buttonH = 35, 5
local spacingY = 1

-- Draw full background
local w, h = monitor.getSize()
for y = 1, h do
    monitor.setCursorPos(1, y)
    monitor.write((" "):rep(w))
end

-- Draw header
local function drawHeader()
    monitor.setCursorPos(3, 1)
    monitor.setTextColor(colors.lightGray)
    monitor.write("<< INDUSTRIAL CONTROL PANEL >>")
end

-- Draw a single button
local function drawButton(btn, x, y)
    local bg = btn.state and colors.green or colors.red
    local ledColor = btn.state and colors.lime or colors.red

    -- Fill button area
    for dy = 0, buttonH - 1 do
        monitor.setCursorPos(x, y + dy)
        monitor.setBackgroundColor(bg)
        monitor.write((" "):rep(buttonW))
    end

    -- Write centered label
    local label = btn.label
    monitor.setCursorPos(x + math.floor((buttonW - #label) / 2), y + 2)
    monitor.setTextColor(colors.white)
    monitor.write(label)

    -- LED dot (top-right)
    monitor.setCursorPos(x + buttonW - 2, y)
    monitor.setTextColor(ledColor)
    monitor.write("●")
end

-- Draw all buttons
local function drawButtons()
    drawHeader()
    local startY = 3
    for i, btn in ipairs(buttons) do
        local x = 3
        local y = startY + (i - 1) * (buttonH + spacingY)
        btn.bounds = {x1 = x, y1 = y, x2 = x + buttonW - 1, y2 = y + buttonH - 1}
        drawButton(btn, x, y)
    end
end

-- Check which button was pressed
local function getButtonAt(x, y)
    for i, btn in ipairs(buttons) do
        local b = btn.bounds
        if x >= b.x1 and x <= b.x2 and y >= b.y1 and y <= b.y2 then
            return i
        end
    end
    return nil
end

-- Toggle redstone and refresh UI
local function toggleButton(i)
    local btn = buttons[i]
    btn.state = not btn.state
    redstone.setOutput(btn.side, btn.state)
    drawButtons()
end

-- Initialize UI
drawButtons()

-- Event loop
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    local i = getButtonAt(x, y)
    if i then toggleButton(i) end
end
