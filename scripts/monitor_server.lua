local monitorSide = "back"   -- your monitor side here
local modemSide = "top"      -- your wireless modem side here

local monitor = peripheral.wrap(monitorSide)
local modem = peripheral.wrap(modemSide)

if not monitor then error("Monitor not found on " .. monitorSide) end
if not modem then error("Modem not found on " .. modemSide) end

monitor.clear()
monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

modem.open(1)

print("Monitor server started, waiting for messages...")

while true do
    local event, side, senderId, message, distance = os.pullEvent("rednet_message")
    if side == modemSide then
        if type(message) == "string" then
            monitor.clear()
            monitor.setCursorPos(1,1)
            monitor.write(message)
        elseif type(message) == "table" then
            -- e.g. {command="clear"} or {command="write", text="Hello"}
            if message.command == "clear" then
                monitor.clear()
            elseif message.command == "write" and message.text then
                monitor.clear()
                monitor.setCursorPos(1,1)
                monitor.write(message.text)
            end
        end
    end
end
