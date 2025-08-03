-- monitor_client.lua

-- Detect modem
local modemSide
for _, side in ipairs({"top","bottom","left","right","front","back"}) do
    if peripheral.getType(side) == "modem" then
        modemSide = side
        break
    end
end

if not modemSide then
    error("No modem found!")
end

rednet.open(modemSide)

-- Detect monitor
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end

if not monitor then error("No monitor found!") end

-- Function to center and display text
local function centerText(text, y)
    local w, _ = monitor.getSize()
    local x = math.floor((w - #text) / 2) + 1
    monitor.setCursorPos(x, y)
    monitor.write(text)
end

-- Color conversion from string to colors table
local function getColorByName(name)
    if not name then return nil end
    return colors[name] or nil
end

print("Client running. Waiting for messages...")

while true do
    local id, message, protocol = rednet.receive("monitor")

    if type(message) == "table" and message.command == "display" then
        local lines = message.lines or {}
        local textScale = tonumber(message.textScale) or 1
        local textColor = getColorByName(message.textColor) or colors.white
        local bgColor = getColorByName(message.bgColor) or colors.black

        monitor.setTextScale(textScale)
        monitor.setBackgroundColor(bgColor)
        monitor.setTextColor(textColor)
        monitor.clear()

        local _, h = monitor.getSize()
        local startY = math.floor((h - #lines) / 2) + 1
        if startY < 1 then startY = 1 end

        for i, line in ipairs(lines) do
            local y = startY + i - 1
            if y >= 1 and y <= h then
                centerText(line, y)
            end
        end

    elseif type(message) == "table" and message.command == "clear" then
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
    end
end
