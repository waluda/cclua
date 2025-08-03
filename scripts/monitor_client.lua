-- monitor_client.lua

local monitorSide = "back"
local modemSide = "top"

local monitor = peripheral.wrap(monitorSide)
local modem = peripheral.wrap(modemSide)

if not monitor then error("Monitor not found on " .. monitorSide) end
if not modem then error("Modem not found on " .. modemSide) end

modem.open(1)

print("Monitor client running, waiting for commands...")

local function getColor(colorName)
    if not colorName then return colors.white end
    return colors[colorName] or colors.white
end

while true do
    local event, side, senderId, message, distance = os.pullEvent("rednet_message")
    if side == modemSide then
        if type(message) == "table" then
            if message.command == "clear" then
                monitor.clear()
            elseif message.command == "display" then
                local lines = message.lines or {"No lines provided."}
                local textScale = tonumber(message.textScale) or 1
                local textColor = getColor(message.textColor)
                local bgColor = getColor(message.bgColor)

                monitor.setTextScale(textScale)
                monitor.setBackgroundColor(bgColor)
                monitor.setTextColor(textColor)
                monitor.clear()

                local w, h = monitor.getSize()
                local function centerText(text, y)
                    local x = math.floor((w - #text) / 2) + 1
                    monitor.setCursorPos(x, y)
                    monitor.write(text)
                end

                local startY = math.floor((h - #lines) / 2) + 1
                if startY < 1 then startY = 1 end

                for i, line in ipairs(lines) do
                    local y = startY + i - 1
                    if y >= 1 and y <= h then
                        centerText(line, y)
                    end
                end
            else
                print("Unknown command received.")
            end
        elseif type(message) == "string" then
            monitor.setTextScale(1)
            monitor.setBackgroundColor(colors.black)
            monitor.setTextColor(colors.white)
            monitor.clear()
            monitor.setCursorPos(1,1)
            monitor.write(message)
        end
    end
end
