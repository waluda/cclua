-- monitor_server.lua

local modemSide = "top"
local modem = peripheral.wrap(modemSide)
if not modem then error("Modem not found on " .. modemSide) end

modem.open(1)

local function printHelp()
    print("Commands:")
    print("send - send text lines with options")
    print("clear - clear all remote monitors")
    print("exit - quit controller")
end

local function getInput(prompt)
    io.write(prompt)
    return read()
end

local function parseColorInput(input)
    input = input:gsub("%s+", "")
    if input == "" then return nil end
    return input
end

print("Monitor controller started. Type 'help' for commands.")

while true do
    io.write("> ")
    local cmd = read()
    if cmd == "exit" then
        print("Exiting controller.")
        break
    elseif cmd == "help" then
        printHelp()
    elseif cmd == "clear" then
        rednet.broadcast({command="clear"}, 1)
        print("Sent clear command to all monitors.")
    elseif cmd == "send" then
        local numLines = tonumber(getInput("Number of lines to send: ")) or 0
        if numLines < 1 then
            print("Invalid number of lines.")
        else
            local lines = {}
            for i = 1, numLines do
                lines[i] = getInput("Line " .. i .. ": ")
            end
            local textScale = tonumber(getInput("Text scale (e.g. 0.5, 1, 2). Default 1: ")) or 1
            local textColor = parseColorInput(getInput("Text color (e.g. white, red, blue). Default white: "))
            local bgColor = parseColorInput(getInput("Background color (e.g. black, blue, red). Default black: "))

            local message = {
                command = "display",
                lines = lines,
                textScale = textScale,
                textColor = textColor,
                bgColor = bgColor
            }
            rednet.broadcast(message, 1)
            print("Sent display command.")
        end
    else
        print("Unknown command. Type 'help' for available commands.")
    end
end
