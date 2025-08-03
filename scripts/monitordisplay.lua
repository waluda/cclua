local validSides = {left=true, right=true, top=true, bottom=true, front=true, back=true}

-- Try automatic detection first
local monitor
for _, side in ipairs({"top", "bottom", "left", "right", "front", "back"}) do
    if peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        print("Monitor found automatically on side: " .. side)
        break
    end
end

-- If automatic detection failed, ask user
if not monitor then
    while true do
        print("No monitor found automatically.")
        print("Please enter the side the monitor is connected to (left, right, top, bottom, front, back):")
        local side = read():lower()

        if validSides[side] then
            if peripheral.getType(side) == "monitor" then
                monitor = peripheral.wrap(side)
                print("Monitor found on side: " .. side)
                break
            else
                print("No monitor found on that side. Try again.")
            end
        else
            print("Invalid side. Please enter one of: left, right, top, bottom, front, back.")
        end
    end
end

-- Configure the monitor
monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.clear()

local w, h = monitor.getSize()

-- Function to center text
local function centerText(text, y)
    local x = math.floor((w - #text) / 2) + 1
    monitor.setCursorPos(x, y)
    monitor.write(text)
end

-- Write all lines centered
centerText("Refined Storage", 1)
centerText("Mekanism Power", 2)
centerText("Mekanism Machinery", 3)
centerText("Ender IO", 4)
