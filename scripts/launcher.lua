-- launcher.lua
print("Downloading download_files.lua...")
local success = shell.run("wget https://raw.githubusercontent.com/waluda/cclua/main/scripts/download_files.lua download_files.lua")
if success then
  print("Running download_files.lua...")
  shell.run("lua download_files.lua")
else
  print("Failed to download download_files.lua")
end
