-- the code sucks, feel free to optimize it however you like.
-- Ranu, 8/23/2024, 8:49 PM West Java, Indonesia

-- parser

local file = io.open("skrip.jawa", "r")
if not file then
    print("Could not open file.")
    return
end

local keys = {
    ['jenenge']="local",
    ['iku']="=",
    ['matur']="print",
    [';']='\n',
    ['nek']="if",
    ['nggo']="for",
    ['dalem']="in",
    ['naliko']="while",
    ['nindak']="do",
    ['terus']="then",
    ['mburi']="end",
    ['bener']="true",
    ['palsu']="false",
    ['bisik']="--",
    ['mlebu']="io.read",
    ['omong']="io.write",
    ['balik']="return",
    ['liyane']="else",
    ['liyanenek']="elseif",
    ['jadine']="==",
    ['orakoyo']="~=",
    ['ora']="not"
}

local content = file:read("*all")
file:close()

local tokens = {}
for word in string.gmatch(content, "%S+") do
    table.insert(tokens, word)
end

for i, w in pairs(tokens) do
    if keys[w] then
        tokens[i] = keys[w]
    end
end
--[[
for i, w in pairs(tokens) do
    print(i, w)
end]]

-- interpreter

file = io.open('out-file.lua','w')
if not file then
    print("Could not open file.")
    return
end

local comma_banned = {
    "\n", '+', '-', '*', '/'
}
local already_commaed = false
local currently_printing = false
for i in pairs(tokens) do
    already_commaed = false
    file:write(tokens[i])
    if tokens[i] ~= "\n" and currently_printing == false then
        file:write(" ")
    end
    if tokens[i+1] == "\n" and currently_printing == true then
        file:write(")")
        currently_printing = false
    end
    if currently_printing == true then
        local valid = true
        for _, x in pairs(comma_banned) do
            if tokens[i+1] == x or tokens[i-1] == x or tokens[i] ~= x or already_commaed == false or currently_printing == true then
                valid = false
            end
        end
        if valid == true then
            already_commaed = true
            file:write(",")
        end
    end
    if tokens[i] == "print" or tokens[i] == "io.read" or tokens[i] == "io.write" then
        file:write("(")
        currently_printing = true
    end
    if tokens[i+1] == "\n" and currently_printing == true then
        file:write(")")
        currently_printing = false
    end
end
file:close()
dofile('out-file.lua')