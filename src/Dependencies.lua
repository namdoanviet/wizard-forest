--[[
    GD50
    Angry Birds
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/Entity'
require 'src/Player'
require 'src/Mossy'
require 'src/Background'
require 'src/constants'
require 'src/Level'
require 'src/StateMachine'
require 'src/Util'

require 'src/states/BaseState'
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkingState'
require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/GameOver'
require 'src/states/VictoryState'
require 'src/states/BeginGameState'
-- gTextures = {
--     -- backgrounds
--     ['bgr']=love.graphics.newImage('graphics/gameBackground.png'),
--     ['blue-desert'] = love.graphics.newImage('graphics/blue_desert.png'),
--     ['blue-grass'] = love.graphics.newImage('graphics/blue_grass.png'),
--     ['blue-land'] = love.graphics.newImage('graphics/blue_land.png'),
--     ['blue-shroom'] = love.graphics.newImage('graphics/blue_shroom.png'),
--     ['colored-land'] = love.graphics.newImage('graphics/colored_land.png'),
--     ['colored-desert'] = love.graphics.newImage('graphics/colored_desert.png'),
--     ['colored-grass'] = love.graphics.newImage('graphics/colored_grass.png'),
--     ['colored-shroom'] = love.graphics.newImage('graphics/colored_shroom.png'),

--     -- aliens
--     ['aliens'] = love.graphics.newImage('graphics/aliens.png'),

--     -- tiles
--     ['tiles'] = love.graphics.newImage('graphics/tiles.png'),

--     -- wooden obstacles
--     ['wood'] = love.graphics.newImage('graphics/wood.png'),

--     -- arrow for trajectory
--     ['arrow'] = love.graphics.newImage('graphics/arrow.png')
-- }

gTextures={
    ['mossy']=love.graphics.newImage('graphics/mossy-tilesets.png'),
    ['bg1']=love.graphics.newImage('graphics/forestBackground.png'),
    ['bg2']=love.graphics.newImage('graphics/background2.png'),
    ['bg3']=love.graphics.newImage('graphics/background3.png'),
    ['bg4']=love.graphics.newImage('graphics/background4.png'),
    ['bg5']=love.graphics.newImage('graphics/background5.png'),
    ['bg6']=love.graphics.newImage('graphics/background6.png'),
    ['bg7']=love.graphics.newImage('graphics/background7.png'),
    ['bg8']=love.graphics.newImage('graphics/background8.png'),
    ['bg9']=love.graphics.newImage('graphics/background9.png'),
    ['blue-wizard']=love.graphics.newImage('graphics/bluewizard.png'),
    ['main-control']=love.graphics.newImage('graphics/move-control.png'),
    ['menu-control']=love.graphics.newImage('graphics/move-control-menu5.png'),
    ['flag']=love.graphics.newImage('graphics/flag.png')
}

gFrames = {
    ['mossy'] = {
        love.graphics.newQuad(96, 0, 128, 128, gTextures['mossy']:getDimensions()),
        love.graphics.newQuad(64, 384, 256, 128, gTextures['mossy']:getDimensions()),
        love.graphics.newQuad(384, 384, 128, 128, gTextures['mossy']:getDimensions())
    },
    ['blue-wizard']=GenerateQuads(gTextures['blue-wizard'],128,128),
    ['main-control']=GenerateQuads(gTextures['main-control'],30,30),
    ['menu-control']=GenerateQuads(gTextures['menu-control'],112,112),
    ['flag']=GenerateQuads(gTextures['flag'],60,60)
}

gSounds = {
    ['break1'] = love.audio.newSource('sounds/break1.wav', 'static'),
    ['break2'] = love.audio.newSource('sounds/break2.wav', 'static'),
    ['break3'] = love.audio.newSource('sounds/break3.mp3', 'static'),
    ['break4'] = love.audio.newSource('sounds/break4.wav', 'static'),
    ['break5'] = love.audio.newSource('sounds/break5.wav', 'static'),
    ['bounce'] = love.audio.newSource('sounds/bounce.wav', 'static'),
    ['kill'] = love.audio.newSource('sounds/kill.wav', 'static'),
    ['death']=love.audio.newSource('sounds/death.wav', 'static'),
    ['jump']=love.audio.newSource('sounds/jump.wav', 'static'),

    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    ['collision']= love.audio.newSource('sounds/collision.wav', 'static'),
    ['victory']=love.audio.newSource('sounds/victory.wav', 'static')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/newFont.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/newFont.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/newFont.ttf', 32),
    ['huge'] = love.graphics.newFont('fonts/newFont.ttf', 64)
}

-- tweak circular alien quad
-- gFrames['aliens'][9]:setViewport(105.5, 35.5, 35, 34.2)