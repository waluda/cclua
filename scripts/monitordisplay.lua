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

-- Print size info on the computer screen so you can see it
local w, h = monitor.getSize()
print("Monitor size detected: width=" .. w .. ", height=" .. h)
print("Clearing monitor and drawing in 5 seconds...")
sleep(5)

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.clear()

-- Lines to display
local lines = {
    "REFINED STORAGE",
    "MEKANISM POWER",
    "ENDERIO",
    "MEKANISM MACHINERY"
}

-- Function to center text horizontally on the monitor
local function centerText(text, y)
    local x = math.floor((w - #text) / 2) + 1
    monitor.setCursorPos(x, y)
    monitor.write(text)
end

-- Calculate vertical starting row to center lines block vertically
local startY = math.floor((h - #lines) / 2) + 1
if startY < 1 then startY = 1 end

-- Write lines centered horizontally and vertically
for i, line in ipairs(lines) do
    local y = startY + i - 1
    if y >= 1 and y <= h then
        centerText(line, y)
    end
end
