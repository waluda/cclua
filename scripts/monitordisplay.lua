-- Detect monitor automatically
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end

if not monitor then error("No monitor found!") end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.clear()

local w, h = monitor.getSize()

local function centerText(text, y)
    local x = math.floor((w - #text) / 2) + 1
    monitor.setCursorPos(x, y)
    monitor.write(text)
end

local lines = {
    "Refined Storage",
    "Mekanism Power",
    "Mekanism Machinery",
    "Ender IO",
    "Auto-Smeltery",
}

local startY = math.floor((h - #lines) / 2) + 1
if startY < 1 then startY = 1 end

for i, line in ipairs(lines) do
    local y = startY + i - 1
    if y >= 1 and y <= h then
        centerText(line, y)
    end
end
