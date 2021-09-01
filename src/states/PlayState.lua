
PlayState = Class{__includes = BaseState}

function PlayState:init()
    
end

function PlayState:enter(params)
    self.currentLevel=params.level
    self.highscore=params.highscore
    self.level = Level(self.currentLevel,self.highscore)
    
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- update camera

    self.level:update(dt)
end

function PlayState:render()
    -- render background separate from level rendering
    

    love.graphics.translate(0, 0)
    self.level:render()
    
end