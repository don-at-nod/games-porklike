local gfx <const> = playdate.graphics

class('Stairs').extends(gfx.sprite)

function Stairs:init(x, y, type)
	local levelImageTable = gfx.imagetable.new("levels/tileset")
	
	self:setZIndex(Z_INDEXES.Stairs)
	
	if type == "entry" then
		self:setImage(levelImageTable:getImage(3))
	elseif type == "exit" then
		self:setImage(levelImageTable:getImage(4))
	end	
	
	self:setCenter(0,0)
	self:moveTo(x,y)
	self:add()
	
	self:setTag(TAGS.Stairs)
	self:setCollideRect(0,0,8,8)
end	