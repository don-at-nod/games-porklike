-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animator"

-- Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/LDtk"

-- Constants
local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Game
import "scripts/gameScene"
import "scripts/player"
import "scripts/interactable"
import "scripts/sounds"
import "scripts/window"

GameScene()

function pd.update()
	gfx.sprite.update()
	pd.timer.updateTimers()
end

function print_table(tbl)
	for k, v in pairs(tbl) do print(k, v) end
end