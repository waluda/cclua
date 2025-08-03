-- Ask user for text scale
print("Enter text scale (e.g. 0.5, 1, 2, 4). Press Enter for default (1):")
local textScaleInput = read()
local textScale = tonumber(textScaleInput) or 1

-- Ask user for text color (case sensitive, exactly as in colors API)
print("Enter text color (case sensitive, e.g. white, red, blue, lightBlue). Press Enter for default (white):")
local textColorInput = read()
local textColor = colors[textColorInput] or colors.white

-- Ask user for background color (case sensitive)
print("Enter background color (case sensitive, e.g. black, blue, red). Press Enter for default (blue):")
local backgroundColorInput = read()
local backgroundColor = colors[backgroundColorInput] or colors.blue

-- Detect monitor automatically
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end

if not monitor then error("No monitor found!") end

monitor.setTextScale(textScale)
monitor.setBackgroundColor(backgroundColor)
monitor.setTextColor(textColor)
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
    "Auto-Smeltery"
}

local startY = math.floor((h - #lines) / 2) + 1
if startY < 1 then startY = 1 end

for i, line in ipairs(lines) do
    local y = startY + i - 1
    if y >= 1 and y <= h then
        centerText(line, y)
    end
end
