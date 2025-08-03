-- Detect monitor automatically
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        print("Monitor found on side: " .. side)
        break
    end
end

if not monitor then error("No monitor found!") end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.clear()

local w, h = monitor.getSize()
print("Monitor size detected: width=" .. w .. ", height=" .. h)

local function centerText(text, y)
    local x = math.floor((w - #text) / 2) + 1
    monitor.setCursorPos(x, y)
    monitor.write(text)
end

local lines = {
    "REFINED STORAGE",
    "MEKANISM POWER",
    "ENDERIO",
    "MEKANISM MACHINERY"
}

local startY = math.floor((h - #lines) / 2) + 1
if startY < 1 then startY = 1 end  -- Make sure startY is at least 1

print("Starting Y position for vertical centering: " .. startY)

for i, line in ipairs(lines) do
    local y = startY + i - 1
    if y >= 1 and y <= h then
        centerText(line, y)
    end
end
