local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(AnimatedSprite)

function Player:init(x, y)
	local playerImageTable = gfx.imagetable.new("images/player-table-16-16")
	Player.super.init(self, playerImageTable)
	
	self.grid_x = x
	self.grid_y = y
	self.offset_x = 0
	self.offset_y = 0
	self.original_x = 0
	self.original_y = 0
	self.speed = 2
	
	self.timer = 1
	
	self:addState("idle", 1, 1)
	self:addState("move", 1, 4, {tickStep = 2}) -- p_ani
	self:addState("bump", 1, 4, {tickStep = 2}) -- p_ani
	self:playAnimation()
	
	self:setCenter(0,0)
	self:moveTo(self.grid_x * GRID, self.grid_y * GRID)
	self:setZIndex(Z_INDEXES.Player)
	self:setTag(TAGS.Player)
	self:setCollideRect(0,0,16,16)
	self:changeState("idle")
end

function Player:collisionResponse(other)
	local tag = other:getTag()
	if tag == TAGS.Stairs then
		return gfx.sprite.kCollisionTypeOverlap
	end
	return gfx.sprite.kCollisionTypeFreeze
end

function Player:update()
	self:updateAnimation()
	self:handleInput()
	--self:handleMovementAndCollisions()
	self:updatePlayer()
end

function Player:handleInput()
	local dirx = {-1, 1, 0, 0}
	local diry = {0, 0, -1, 1}
	local btns = {pd.kButtonLeft, pd.kButtonRight, pd.kButtonUp, pd.kButtonDown}
	
	for i=1, 4 do
		if pd.buttonJustPressed(btns[i]) and self.currentState == "idle" then
			self:movePlayer(dirx[i], diry[i])
		end
	end
end

-- Gameplay (tab from Video 5)

function Player:updatePlayer()
	self.timer = math.min(self.timer+0.125,1)
	self:moveTo(self.grid_x*GRID+self.offset_x, self.grid_y*GRID+self.offset_y)
	
	if self.currentState == "move" then
		self.offset_x = self.original_x*(1-self.timer)
		self.offset_y = self.original_y*(1-self.timer)
	elseif self.currentState == "bump" then
		local tme = self.timer
		if self.timer > 0.5 then
			tme=1-self.timer
		end
		self.offset_x = self.original_x*tme
		self.offset_y = self.original_y*tme
	end
	
	if self.timer == 1 then
		self:changeState("idle")
	end
end

function Player:movePlayer(dx, dy)
	local dest_x, dest_y = self.grid_x + dx, self.grid_y + dy
	local allow_move = true
	
	if dx < 0 then
		self.globalFlip = 1
	elseif dx > 0 then
		self.globalFlip = 0
	end
	
	local _, _, collisions, length = self:checkCollisions(dest_x*GRID, dest_y*GRID)
	
	if length > 0 then
		for i=1, length do
			local collision = collisions[i]
			local collisionType = collision.type
			local collisionObject = collision.other
			local collisionTag = collisionObject:getTag()
			
			if collisionType == gfx.sprite.kCollisionTypeFreeze then
				-- wall
				allow_move = false
			end
			
			if collisionTag == TAGS.Stairs then
				collisionObject:use(self)
			end
		end
	end
	
	if allow_move ~= true then
		self.original_x, self.original_y = dx * GRID, dy * GRID
		self.offset_x, self.offset_y = 0, 0
		self.timer = 0
		self:changeState("bump")
	else
		self.grid_x += dx
		self.grid_y += dy
			
		self.original_x, self.original_y = -dx * GRID, -dy * GRID
		self.offset_x, self.offset_y = self.original_x, self.original_y
		self.timer = 0
		self:changeState("move")
	end
end