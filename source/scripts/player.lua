local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(AnimatedSprite)

function Player:init(x, y)
	local playerImageTable = gfx.imagetable.new("images/player-table-16-16")
	Player.super.init(self, playerImageTable)
	
	self.facing = 0
	self.grid_x = x
	self.grid_y = y
	self.offset_x = 0
	self.offset_y = 0
	self.original_x = 0
	self.original_y = 0
	self.speed = 2
	
	self.timer = 0
	
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
	
	local dirx = {-1, 1, 0, 0}
	local diry = {0, 0, -1, 1}
	local btns = {pd.kButtonLeft, pd.kButtonRight, pd.kButtonUp, pd.kButtonDown}
	
	for i=1, 4 do
		if pd.buttonJustPressed(btns[i]) then
			
			local dx, dy = dirx[i], diry[i]
			
			self.grid_x += dx
			self.grid_y += dy
			self.original_x, self.original_y = -dx*GRID,-dy*GRID
			self.offset_x, self.offset_x = self.original_x, self.original_y
			if i == 1 then
				self.facing = 1
			elseif i == 2 then
				self.facing = 0
			end
			self.timer = 0
		end
	end

	self:handleMovementAndCollisions()
end

function Player:handleMovementAndCollisions()
	-- local _, _, collisions, length = self:moveWithCollisions(self.x, self.y)
	
	self.globalFlip = self.facing
	
	self.timer = math.min(self.timer+0.125,1)
	
	self.offset_x = self.original_x*(1-self.timer)
	self.offset_y = self.original_y*(1-self.timer)
	
	if self.timer == 1 then
		self:changeState("idle")
	elseif self.timer > 0 and self.timer < 1 then
		self:changeState("move")
	end
	
	self:moveTo(self.grid_x*GRID+self.offset_x,self.grid_y*GRID+self.offset_y)
end

-- state transitions

function Player:changeToIdleState()
	self:changeState("idle")
end