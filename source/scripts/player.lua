local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(AnimatedSprite)

function Player:init(x, y)
	local playerImageTable = gfx.imagetable.new("images/player-table-16-16")
	Player.super.init(self, playerImageTable)
	
	self:addState("idle", 1, 1)
	self:playAnimation()
	
	self:setCenter(0,0)
	self:moveTo(x, y)
	self:setZIndex(Z_INDEXES.Player)
	self:setTag(TAGS.Player)
end

function Player:update()
	if playdate.buttonJustPressed(pd.kButtonUp ) then
		self.y -= 16
	end
	if playdate.buttonJustPressed(pd.kButtonDown ) then
		self.y += 16
	end
	if playdate.buttonJustPressed(pd.kButtonRight ) then
		self.x += 16
	end
	if playdate.buttonJustPressed(pd.kButtonLeft ) then
		self.x -= 16
	end
	
	self:moveTo(self.x,self.y)
end