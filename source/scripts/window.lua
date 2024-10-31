-- ui
local gfx <const> = playdate.graphics

Window = {}

function Window:new(x, y, w, h, text)
	local self = gfx.sprite:new()
	
	self:setSize(200, 120)
	self:setCenter(0,0)
	self:addSprite()
	self:setZIndex(Z_INDEXES.Window)
	self:setIgnoresDrawOffset(true)
	
	--[[
	function self:update()
		self.offset_x, self.offset_y = gfx.getDrawOffset()
		self:(-self.offset_x, -self.offset_y)
	end
	]]--
	
	function self:closeWindow()
		self:remove()
	end
	
	function self:draw()
		-- rect
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect(x, y, w, h)
		-- border
		gfx.setColor(gfx.kColorWhite)
		gfx.drawRect(x+1, y+1, w-2, h-2)
		-- text
		wx = x+GRID
		wy = y+GRID
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		for i=1, #text do
			local _, height = gfx.getTextSize(text[i])
			gfx.drawText(text[i], wx, wy)
			wy+=height
		end
	end
	
	return self
end