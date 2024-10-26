local gfx <const> = playdate.graphics

class('Stairs').extends(gfx.sprite)

function Stairs:init(x, y, entity)
	local levelImageTable = gfx.imagetable.new("levels/tileset")

	self.fields = entity.fields	
	self.type = self.fields.Stairs
	
	if self.type == "Entry" then
		self:setImage(levelImageTable:getImage(3))
	elseif self.type == "Exit" then
		self:setImage(levelImageTable:getImage(10))
	end	

	self:setZIndex(Z_INDEXES.Stairs)	
	self:setCenter(0,0)
	self:moveTo(x,y)
	self:add()
	
	self:setTag(TAGS.Stairs)
	self:setCollideRect(0,0,self:getSize())
end

function Stairs:use(player)
	if self.type == "Entry" then
		print("Enter")
	elseif self.type == "Exit" then
		print("Exit")
	end
	self:remove() -- temp fun
end