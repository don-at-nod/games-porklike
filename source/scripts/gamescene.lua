local gfx <const> = playdate.graphics
local ldtk <const> = LDtk

TAGS = {
	Player = 1,
	Stairs = 2
}

Z_INDEXES = {
	Player = 100,
	Stairs = 20
}

GRID = 16

ldtk.load("levels/world.ldtk", false)

class('GameScene').extends()

function GameScene:init()
	playdate.display.setScale(2) -- 2 = 200 x 120, 4 = 100 x 60
	gfx.setBackgroundColor(gfx.kColorBlack)
	
	self:goToLevel("Level_0")
	self.spawnX = 3
	self.spawnY = 5
	self.player = Player(self.spawnX, self.spawnY)
end

function GameScene:goToLevel(levelName)
	gfx.sprite.removeAll()
	
	self.levelName = levelName
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
		if entityName == "Stairs" then
			Stairs(entityX, entityY, entity)
		end
	end
end