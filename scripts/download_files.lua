-- download_files.lua
print("Downloading startup.lua...")
local success1 = shell.run("wget https://raw.githubusercontent.com/waluda/cclua/refs/heads/main/scripts/startup.lua startup.lua")
print("Downloading monitordisplay.lua...")
local success2 = shell.run("wget https://raw.githubusercontent.com/waluda/cclua/refs/heads/main/scripts/monitordisplay.lua monitordisplay.lua")

if success1 and success2 then
  print("Downloads complete! Rebooting...")
  os.reboot()
else
  print("Failed to download one or more files. Not rebooting.")
end
