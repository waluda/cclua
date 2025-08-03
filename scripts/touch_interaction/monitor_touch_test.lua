-- monitor_touch_test.lua

-- Detect monitor
local monitor
for _, side in ipairs({"top","bottom","left","right","front","back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end

if not monitor then error("No monitor found!") end

-- Redstone setup
local lampSide = "back"  -- Change this to the side the lamp is on
local lampState = false  -- Starts OFF

-- Draw button
local function drawButton()
    monitor.setTextScale(1)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.clear()

    local w, h = monitor.getSize()
    local label = lampState and "Lamp ON" or "Lamp OFF"
    local x = math.floor((w - #label) / 2) + 1
    local y = math.floor(h / 2)

    monitor.setCursorPos(x, y)
    monitor.write(label)
end

-- Toggle logic
local function toggleLamp()
    lampState = not lampState
    redstone.setOutput(lampSide, lampState)
    drawButton()
end

-- Initial draw
drawButton()

-- Wait for monitor touches
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    toggleLamp()
end
