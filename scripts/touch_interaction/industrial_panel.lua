-- industrial_panel.lua

-- Detect monitor
local monitor
for _, side in ipairs({"top","bottom","left","right","front","back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end

if not monitor then error("No monitor found!") end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.lightGray)
monitor.setTextColor(colors.black)
monitor.clear()

-- Redstone output config
local buttons = {
    { label = "WATER PUMP", side = "left", state = false },
    { label = "FANS", side = "right", state = false },
    { label = "ALARM", side = "back", state = false },
}

-- Layout config
local buttonW, buttonH = 19, 3
local spacingY = 1

-- Draw background with border
local function drawFrame()
    monitor.setBackgroundColor(colors.gray)
    local w, h = monitor.getSize()
    for y = 1, h do
        monitor.setCursorPos(1, y)
        monitor.write((" "):rep(w))
    end

    monitor.setBackgroundColor(colors.lightGray)
    monitor.setTextColor(colors.black)

    -- Title bar
    monitor.setCursorPos(3, 1)
    monitor.write("<< INDUSTRIAL CONTROL PANEL >>")
end

-- Draw button with label and LED indicator
local function drawButton(btn, x, y)
    local active = btn.state
    local bg = active and colors.green or colors.red
    local ledColor = active and colors.lime or colors.red

    -- Button background
    for dy = 0, buttonH - 1 do
        monitor.setCursorPos(x, y + dy)
        monitor.setBackgroundColor(bg)
        monitor.write((" "):rep(buttonW))
    end

    -- Label
    local label = btn.label
    monitor.setCursorPos(x + math.floor((buttonW - #label)/2), y + 1)
    monitor.setTextColor(colors.white)
    monitor.write(label)

    -- LED dot (right side)
    monitor.setCursorPos(x + buttonW - 2, y)
    monitor.setTextColor(ledColor)
    monitor.write("●")
end

-- Draw all buttons
local function drawButtons()
    drawFrame()

    local w, h = monitor.getSize()
    local startY = 3

    for i, btn in ipairs(buttons) do
        local x = math.floor((w - buttonW) / 2)
        local y = startY + (i - 1) * (buttonH + spacingY)
        btn.bounds = {x1 = x, y1 = y, x2 = x + buttonW - 1, y2 = y + buttonH - 1}
        drawButton(btn, x, y)
    end
end

-- Check for button click
local function getButtonAt(x, y)
    for i, btn in ipairs(buttons) do
        local b = btn.bounds
        if x >= b.x1 and x <= b.x2 and y >= b.y1 and y <= b.y2 then
            return i
        end
    end
    return nil
end

-- Toggle redstone and update UI
local function toggleButton(i)
    local btn = buttons[i]
    btn.state = not btn.state
    redstone.setOutput(btn.side, btn.state)
    drawButtons()
end

-- Init UI
drawButtons()

-- Touch handling
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    local i = getButtonAt(x, y)
    if i then
        toggleButton(i)
    end
end
