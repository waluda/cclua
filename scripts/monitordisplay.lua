-- Find the monitor automatically
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end

if not monitor then
    error("No monitor found!")
end

-- Configure the monitor
monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.clear()

local w, h = monitor.getSize()

-- Line 1: "REFINED STORAGE"
local line1 = "REFINED STORAGE"
local x1 = math.floor((w - #line1) / 2) + 1
local y1 = 1

-- Line 2: "MEKANISM POWER"
local line2 = "MEKANISM POWER"
local x2 = math.floor((w - #line2) / 2) + 1
local y2 = 2

-- Line 3: "ENDERIO"
local line3 = "ENDERIO"
local x3 = math.floor((w - #line3) / 2) + 1
local y3 = 3

-- Line 4: "MEKANISM MACHINERY"
local line4 = "MEKANISM MACHINERY"
local x4 = math.floor((w - #line4) / 2) + 1
local y4 = 4

-- Write all lines
monitor.setCursorPos(x1, y1)
monitor.write(line1)
monitor.setCursorPos(x2, y2)
monitor.write(line2)
monitor.setCursorPos(x3, y3)
monitor.write(line3)
monitor.setCursorPos(x4, y4)
monitor.write(line4)
