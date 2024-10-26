local gfx <const> = playdate.graphics

class('Test').extends(gfx.sprite)

function Test:init()
	Test.super.init(self)
	self.x = 5
	print("init", self.x)
	self:addSprite()
end

function Test:update()
	print("update", self.x)
end