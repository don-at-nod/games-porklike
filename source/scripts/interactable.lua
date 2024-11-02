local gfx <const> = playdate.graphics

class('Interactable').extends(gfx.sprite)

levelImageTable = gfx.imagetable.new("levels/tileset")

function Interactable:init(x, y, entity)
	self.fields = entity.fields
	self.name = entity.name

	if(self.name == "Door") then
		self:setImage(levelImageTable:getImage(5))
	elseif(self.name == "Sign") then
		self:setImage(levelImageTable:getImage(12))
	elseif self.fields.Vases == "Fat" then
		self:setImage(levelImageTable:getImage(4))
	elseif self.fields.Vases == "Skinny" then
		self:setImage(levelImageTable:getImage(11))
	elseif self.fields.Chests == "Large" then
		self:setImage(levelImageTable:getImage(7))
	elseif self.fields.Chests == "Small" then
		self:setImage(levelImageTable:getImage(6))
	elseif self.fields.Stairs == "Entry" then
		self:setImage(levelImageTable:getImage(3))
	elseif self.fields.Stairs == "Exit" then
		self:setImage(levelImageTable:getImage(10))
	end

	self:setZIndex(Z_INDEXES.Interactable)
	self:setCenter(0,0)
	self:moveTo(x,y)
	self:add()
	
	self:setTag(TAGS.Interactable)
	self:setCollideRect(0,0,self:getSize())
end

function Interactable:use(player, normal)
	-- vase (remove)
	if self.name == "Vase" or self.name == "Door" then
		self:remove()
		if self.name == "Vase" then
			Sound:play('badvase')
		elseif self.name == "Door" then
			Sound:play('door')
		end
	elseif self.name == "Chest" and normal.y == 1 then
		-- chest (open)
		if self.fields.Chests == "Large" then
			self:setImage(levelImageTable:getImage(14))
		elseif self.fields.Chests == "Small" then
			self:setImage(levelImageTable:getImage(13))
		end
		Sound:play('chest')
		Window:showTimedMessage("You got something", 120)
	elseif self.name == "Sign" and normal.y == 1 then
		-- stone tablet (read)
		--window = Window:new(w/2 - GRID*11/2, h/2 - GRID*6/2, 11*GRID, GRID*6, {"Welcome to the", "world of Porklike"})
		Window:showMessage(self.fields.Message)
	end
end