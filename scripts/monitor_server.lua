-- monitor_server.lua

-- Open rednet on any available side
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
print("Rednet opened on side: " .. modemSide)

while true do
    print("Enter text to send to monitors (or 'exit' to quit):")
    local input = read()
    if input == "exit" then break end

    local message = {
        command = "display",
        lines = {input}
        -- you can add other keys if your client supports them
    }

    -- Broadcast the message with string protocol "monitor"
    rednet.broadcast(message, "monitor")

    print("Message sent!")
end

rednet.close(modemSide)
print("Server stopped.")
