-- ui
local gfx <const> = playdate.graphics

Window = {}

function Window:new(x, y, w, h, text, dur)
	local self = gfx.sprite:new()
	
	self.duration = dur
	
	self:setSize(200, 120)
	self:setCenter(0,0)
	self:addSprite()
	self:setZIndex(Z_INDEXES.Window)
	self:setIgnoresDrawOffset(true)
	
	--[[
	
	attempt until I discovered setIgnoreDrawOffset
	
	function self:update()
		self.offset_x, self.offset_y = gfx.getDrawOffset()
		self:(-self.offset_x, -self.offset_y)
	end
	]]--
	
	function self:closeWindow()
		self.duration = 0
		talkWind = nil
	end
	
	function self:update()
		if self.duration ~= nil then
			self.duration -= 1
			if self.duration <= 0 then
				self:markDirty()
				local dif = h/4
				y += dif/2
				h -= dif
				if h < 3 then
					self:remove()
				end
			end
		else
			self:markDirty()
		end
	end
	
	function self:draw()
		-- rect
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect(x-6, y-6, w+12, h+12)
		-- border
		gfx.setColor(gfx.kColorWhite)
		gfx.drawRect(x-5, y-5, w+10, h+10)

		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		-- hide text if window is closing
		if  self.duration == nil or self.duration ~= nil and self.duration >= 0 then
			gfx.drawText(text, x, y)
			if self.butt then
				local window_bx, window_by = x+w, y+h
				local button_x, button_y = window_bx - GRID/2 - 10, window_by + GRID/2 + math.sin(playdate.getCurrentTimeMilliseconds() / 100) - 4
				
				button_y = math.min(button_y, 120 - GRID + math.sin(playdate.getCurrentTimeMilliseconds() / 100) - 4)
				
				gfx.fillCircleInRect(button_x - 3, button_y - 3,GRID + 6, GRID + 6)
				gfx.setColor(gfx.kColorBlack)
				gfx.drawCircleInRect(button_x - 2, button_y - 2, GRID + 4, GRID + 4)
				gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
				gfx.drawText("A", button_x, button_y-1, GRID, GRID, gfx.kAlignCenter)
			end
		end
	end
	
	return self
end

function Window:showTimedMessage(txt, dur)
	local width, height = gfx.getTextSize(txt)
	local w = Window:new((w - width) / 2, (h - height) / 2, width, height, txt, dur)
end

function Window:showMessage(txt)
	local width, height = gfx.getTextSize(txt)
	talkWind = Window:new((w - width) / 2, (h - height) / 2, width, height, txt)
	talkWind.butt = true
end