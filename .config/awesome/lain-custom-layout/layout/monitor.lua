
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2014,      projektile                 
      * (c) 2013,      Luke Bonham                
      * (c) 2010-2012, Peter Hofmann              
                                                  
--]]

local awful     = require("awful")
local beautiful = require("beautiful")
local tonumber  = tonumber
local math      = { floor = math.floor, ceil = math.ceil }

local monitor =
{
    name         = "monitor",
    top_right    = 0,
    bottom_right = 1,
    bottom_left  = 2,
    top_left     = 3
}

function monitor.arrange(p)
    -- A useless gap (like the dwm patch) can be defined with
    -- beautiful.useless_gap_width .
    local useless_gap = tonumber(beautiful.useless_gap_width) or 0

    -- A global border can be defined with
    -- beautiful.global_border_width
    local global_border = tonumber(beautiful.global_border_width) or 0
    if global_border < 0 then global_border = 0 end

    -- Screen.
    local wa = p.workarea
    local cls = p.clients

    -- Borders are factored in.
    wa.x = wa.x + global_border
    wa.y = wa.y + global_border

    -- Width of main column?
    local t = awful.tag.selected(p.screen)
    local mwfact = awful.tag.getmwfact(t)

    if #cls > 0
    then
       for i = 1,#cls,1
       do
	  -- Main column, fixed width and height.
	  local c = cls[i]
	  local g = {}

	  g.x = math.floor(wa.x + p.workarea.width*0.243)
	  g.y = math.ceil(0.042 * (p.workarea.height + 19)) -- awesome bar is 19 px
	  -- g.x = p.geometry.width*0.243
	  -- g.y = p.geometry.height*0.0238
	  g.height = math.ceil(0.6875 * (p.workarea.height + 19)) - 4 -- awesome bar is 19 px, frame border is 4 px
	  g.width = math.ceil(p.workarea.width*0.502 - 2*c.border_width)
	  
	  if g.width < 1 then g.width = 1 end
	  if g.height < 1 then g.height = 1 end
	  c:geometry(g)
       end
    end
end

return monitor
