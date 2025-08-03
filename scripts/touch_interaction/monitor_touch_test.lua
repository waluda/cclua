-- monitor_buttons_modern.lua

-- Detect and wrap monitor
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end
if not monitor then error("No monitor found!") end

-- Define buttons
local buttons = {
    { label = "Lamp", side = "left", state = false },
    { label = "Door", side = "right", state = false },
    { label = "Alarm", side = "back", state = false },
}

-- Button rendering config
local buttonWidth = 13
local buttonHeight = 1
local paddingY = 1
local spacing = 1

-- Modern button drawing
local function drawButtons()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setTextColor(colors.white)
    monitor.setTextScale(1)

    local w, h = monitor.getSize()
    local totalHeight = (#buttons * (buttonHeight + spacing)) - spacing
    local startY = math.floor((h - totalHeight) / 2)

    for i, btn in ipairs(buttons) do
        local x = math.floor((w - buttonWidth) / 2)
        local y = startY + (i - 1) * (buttonHeight + spacing)

        btn.bounds = {x1 = x, y1 = y, x2 = x + buttonWidth - 1, y2 = y + buttonHeight - 1}

        -- Background (shaded style)
        local bg = btn.state and colors.green or colors.gray
        local shadow = colors.black
        local textColor = colors.white

        -- Main button
        monitor.setBackgroundColor(bg)
        monitor.setCursorPos(x, y)
        monitor.write((" "):rep(buttonWidth))

        -- Simulate bottom shadow
        if y + 1 <= h then
            monitor.setBackgroundColor(shadow)
            monitor.setCursorPos(x, y + 1)
            monitor.write((" "):rep(buttonWidth))
        end

        -- Text centered
        local label = btn.label .. (btn.state and " ON" or " OFF")
        local textX = x + math.floor((buttonWidth - #label) / 2)
        monitor.setCursorPos(textX, y)
        monitor.setTextColor(textColor)
        monitor.write(label)
    end
end

-- Toggle redstone and redraw
local function toggleButton(i)
    local btn = buttons[i]
    btn.state = not btn.state
    redstone.setOutput(btn.side, btn.state)
    drawButtons()
end

-- Get button at touched position
local function getButtonAt(x, y)
    for i, btn in ipairs(buttons) do
        local b = btn.bounds
        if x >= b.x1 and x <= b.x2 and y >= b.y1 and y <= b.y2 then
            return i
        end
    end
    return nil
end

-- Draw initial buttons
drawButtons()

-- Touch event loop
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    local i = getButtonAt(x, y)
    if i then
        toggleButton(i)
    end
end
