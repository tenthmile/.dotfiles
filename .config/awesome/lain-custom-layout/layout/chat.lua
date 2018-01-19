
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2017,      tenthmile
      * (c) 2016,      Henrik Antonsson           
      * (c) 2015,      Joerg Jaspert              
      * (c) 2014,      projektile                 
      * (c) 2013,      Luke Bonham                
      * (c) 2010-2012, Peter Hofmann              
                                                  
--]]

local floor  = math.floor
local min  = math.min
local screen = screen

local chat = {
   name         = "chat",
   horizontal   = { name = "chath" }
}

local function do_chat(p, orientation)
    local t = p.tag or screen[p.screen].selected_tag
    local wa = p.workarea
    local cls = p.clients

    if #cls == 0 then return end

    local rows = min(#cls, 3)
    local minorHeight = floor(wa.height * 0.3333)
    local mainChatHeight = wa.height
    if #cls == 2 then
       mainChatHeight = floor(wa.height / 2.0)
    elseif #cls >= 3 then
       mainChatHeight = minorHeight
    end
    local mainChatWidth = wa.width
    local minorWidth = wa.width
    if #cls > 3 then
       minorWidth = floor(wa.width / (#cls - 2))
    end

    -- Main chat, upper third (if 3 or more windows exist)
    local c = cls[1]
    local g1 = {}
    g1.height = mainChatHeight
    g1.width  = mainChatWidth

    g1.x = wa.x
    g1.y = wa.y
    if g1.width  < 1 then g1.width  = 1 end
    if g1.height < 1 then g1.height = 1 end
    p.geometries[c] = g1
    
    if #cls <= 1 then return end
    c = cls[2]
    local g2 = {}
    g2.height = mainChatHeight
    g2.width  = mainChatWidth

    g2.x = wa.x
    g2.y = wa.y + mainChatHeight
    if g2.width  < 1 then g2.width  = 1 end
    if g2.height < 1 then g2.height = 1 end
    p.geometries[c] = g2
    
    -- Auxiliary windows.
    if #cls <= 2 then return end
    for i = 3,#cls do
        local c = cls[i]
        local g = {}

        g.x = wa.x + minorWidth * (i-3)
        g.y = wa.y + mainChatHeight*2

        g.width = minorWidth
        g.height = minorHeight

        if g.width  < 1 then g.width  = 1 end
        if g.height < 1 then g.height = 1 end

        p.geometries[c] = g
    end
end


function chat.horizontal.arrange(p)
    return do_chat(p, "horizontal")
end

function chat.arrange(p)
    return do_chat(p, "vertical")
end

return chat
