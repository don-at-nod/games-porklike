local gfx <const> = playdate.graphics

local entryImage <const> = gfx.image.new("images/entrystairs")
local exitImage <const> = gfx.image.new("images/exitstairs")

class('Stairs').extends(gfx.sprite)

function Stairs:init(x, y, type)
	self:setZIndex(Z_INDEXES.Stairs)
	
	if type == "exit" then
		self:setImage(exitImage)
	elseif type == "entry" then
		self:setImage(entryImage)
	end	
	
	self:setCenter(0,0)
	self:moveTo(x,y)
	self:add()
	
	self:setTag(TAGS.Stairs)
	self:setCollideRect(0,0,8,8)
end	