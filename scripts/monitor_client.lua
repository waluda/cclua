local modemSide = "top"
local modem = peripheral.wrap(modemSide)
if not modem then error("Modem not found on " .. modemSide) end

modem.open(1)

print("Controller ready. Type messages to send. 'clear' to clear monitor. 'exit' to quit.")

while true do
    io.write("> ")
    local input = read()
    if input == "exit" then
        print("Exiting.")
        break
    elseif input == "clear" then
        rednet.broadcast({command="clear"}, 1)
        print("Sent clear command.")
    elseif input ~= "" then
        rednet.broadcast(input, 1)
        print("Sent message: " .. input)
    end
end
