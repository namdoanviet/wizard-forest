--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- BACKGROUND_TYPES = {
--     'colored-land', 'blue-desert', 'blue-grass', 'blue-land', 
--     'blue-shroom', 'colored-desert', 'colored-grass', 'colored-shroom'
-- }
BACKGROUND_TYPES = {
    'bg1','bg2','bg3','bg4','bg5','bg6','bg7','bg8','bg9'
}
Background = Class{}

function Background:init(level)
    self.level=(level % 9)+1
    self.background = BACKGROUND_TYPES[self.level]
    self.width = gTextures[self.background]:getWidth()
    self.xOffset = 0
end



function Background:update(dt)
    
end

function Background:render()
    love.graphics.draw(gTextures[self.background], 0, -128)
    
end