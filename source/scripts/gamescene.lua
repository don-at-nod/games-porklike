local gfx <const> = playdate.graphics
local ldtk <const> = LDtk

local abs, floor, ceil, min, max = math.abs, math.floor, math.ceil, math.min, math.max

TAGS = {
	Player = 1,
	Interactable = 2
}

Z_INDEXES = {
	Player = 100,
	Interactable = 20,
	Window = 200
}

GRID = 16

ldtk.load("levels/world.ldtk", false)

playdate.display.setScale(2) -- 2 = 200 x 120, 4 = 100 x 60
w, h = playdate.display.getSize()

local cameraX = 0
local cameraY = 0

class('GameScene').extends(gfx.sprite)

function GameScene:init()
	gfx.setBackgroundColor(gfx.kColorBlack)
	gfx.clear() -- prevents light bg from showing after camera moved
	
	self:goToLevel("Level_0")
	self.spawnX = 2
	self.spawnY = 1
	self.player = Player(self.spawnX, self.spawnY)
	
	self:addSprite()
end

function GameScene:goToLevel(levelName)
	gfx.sprite.removeAll()
	
	self.levelName = levelName
	self.bounds = ldtk.get_rect(self.levelName)
	
	for layerName, layer in pairs(ldtk.get_layers(levelName)) do
		if layer.tiles then
			local tilemap = ldtk.create_tilemap(levelName, layerName)
			
			local layerSprite = gfx.sprite.new()
			layerSprite:setTilemap(tilemap)
			layerSprite:moveTo(0,0)
			layerSprite:setCenter(0,0)
			layerSprite:setZIndex(layer.zIndex)
			layerSprite:add()
			
			local emptyTiles = ldtk.get_empty_tileIDs(levelName, "Solid", layerName)
			if emptyTiles then
				gfx.sprite.addWallSprites(tilemap, emptyTiles)
			end
		end
	end
	
	for _, entity in ipairs(ldtk.get_entities(levelName)) do
		local entityX, entityY = entity.position.x, entity.position.y
		local entityName = entity.name
		
		if entityName == "Vase" or
			entityName == "Door" or
			entityName == "Sign" or
			entityName == "Stairs" or
			entityName == "Chest" then
			Interactable(entityX, entityY, entity)
		end
	end
end

function GameScene:update()
	self:updateCamera()
end

-- camera testing

function GameScene:updateCamera()	
	-- allows to not move every time player does
	local newX = floor(max(min(self.player.x - w/2 + GRID, self.bounds.width - w), 0))
	local newY = floor(max(min(self.player.y - h/2 + GRID, self.bounds.height - h), 0))
	
	if newX ~= -cameraX or newY ~= -cameraY then
		cameraX = -newX
		cameraY = -newY
		gfx.setDrawOffset(cameraX, cameraY)
	end
end