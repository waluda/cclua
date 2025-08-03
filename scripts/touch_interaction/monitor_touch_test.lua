-- monitor_buttons.lua

-- Monitor + Redstone Setup
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
    { label = "Lamp (Left)", side = "left", state = false },
    { label = "Door (Right)", side = "right", state = false },
    { label = "Alarm (Back)", side = "back", state = false },
}

-- Button drawing constants
local buttonWidth = 16
local buttonHeight = 3
local padding = 1

-- Draw buttons
local function drawButtons()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setTextColor(colors.white)
    monitor.setTextScale(1)

    local w, h = monitor.getSize()
    for i, btn in ipairs(buttons) do
        local x1 = math.floor((w - buttonWidth) / 2)
        local y1 = (i - 1) * (buttonHeight + padding) + 2
        local x2 = x1 + buttonWidth - 1
        local y2 = y1 + buttonHeight - 1

        btn.bounds = {x1=x1, y1=y1, x2=x2, y2=y2}
        local bg = btn.state and colors.green or colors.red
        monitor.setBackgroundColor(bg)
        for y = y1, y2 do
            monitor.setCursorPos(x1, y)
            monitor.write((" "):rep(buttonWidth))
        end
        monitor.setCursorPos(x1 + 1, y1 + 1)
        monitor.setTextColor(colors.white)
        monitor.write(btn.label .. (btn.state and " ON" or " OFF"))
    end
end

-- Toggle redstone and redraw
local function toggleButton(i)
    local btn = buttons[i]
    btn.state = not btn.state
    redstone.setOutput(btn.side, btn.state)
    drawButtons()
end

-- Detect which button was touched
local function getButtonAt(x, y)
    for i, btn in ipairs(buttons) do
        local b = btn.bounds
        if x >= b.x1 and x <= b.x2 and y >= b.y1 and y <= b.y2 then
            return i
        end
    end
    return nil
end

-- Initial draw
drawButtons()

-- Event loop
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    local index = getButtonAt(x, y)
    if index then
        toggleButton(index)
    end
end
