local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(AnimatedSprite)

function Player:init(x, y)
	local playerImageTable = gfx.imagetable.new("images/player-table-16-16")
	Player.super.init(self, playerImageTable)
	
	self.facing = 0
	self.moving = false
	self.grid_x = x
	self.grid_y = y
	self.offset_x = 0
	self.offset_y = 0
	self.speed = 2
	
	self:addState("idle", 1, 1)
	self:addState("move", 1, 4, {tickStep = 2}) -- p_ani
	self:playAnimation()
	
	self:setCenter(0,0)
	self:moveTo(self.grid_x * 16, self.grid_y * 16)
	self:setZIndex(Z_INDEXES.Player)
	self:setTag(TAGS.Player)
	self:setCollideRect(0,0,16,16)
end

function Player:update()
	self:updateAnimation()
	self:handleState()
	--self:handleMovementAndCollisions()
end

function Player:handleState()
	if self.currentState == "idle" then
		self:handleInput()
	elseif self.currentState == "move" then
		self:handleInput()
	end
end

function Player:handleInput()
	if pd.buttonJustPressed( pd.kButtonRight ) and self.currentState ~= "move" then
		self.facing = 0
		self.grid_x += 1
		self.offset_x = GRID
	elseif pd.buttonJustPressed( pd.kButtonDown ) and self.currentState ~= "move" then
		self.grid_y += 1
		self.offset_y = GRID
	elseif pd.buttonJustPressed( pd.kButtonLeft ) and self.currentState ~= "move" then
		self.facing = 1
		self.grid_x -= 1
		self.offset_x = -GRID
	elseif pd.buttonJustPressed( pd.kButtonUp ) and self.currentState ~= "move" then
		self.grid_y -= 1
		self.offset_y = -GRID
	end
	
	self.globalFlip = self.facing
	
	self:changeState("move")
	if self.offset_x > 0 then
		self.offset_x -= self.speed
	elseif self.offset_x < 0 then
		self.offset_x += self.speed
	elseif self.offset_y > 0 then
		self.offset_y -= self.speed
	elseif self.offset_y < 0 then
		self.offset_y += self.speed
	elseif self.offset_x == 0 and self.offset_y == 0 then
		self.moving = false
		self:changeState("idle")
	end
	
	self:moveTo(self.grid_x*GRID-self.offset_x,self.grid_y*GRID-self.offset_y)
end

function Player:handleMovementAndCollisions()
	-- local _, _, collisions, length = self:moveWithCollisions(self.x, self.y)
end

-- state transitions

function Player:changeToIdleState()
	self:changeState("idle")
end