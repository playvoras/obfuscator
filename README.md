```
local code = [[
  print("Hello World!")
]]
local obfuscator = loadstring(game:HttpGet("https://raw.githubusercontent.com/playvoras/obfuscator/main/source.lua"))()

obfuscator(
  code,   -- source code
  "Moonsec_V3", -- Random var lol
  "Protected"   -- WaterMark
)
```
