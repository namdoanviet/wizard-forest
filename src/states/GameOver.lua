GameOver=Class{__includes=BaseState}

function GameOver:enter(params)
    self.background=params.background
    self.highscore=params.highscore
    self.currentLevel=params.currentLevel
    if self.currentLevel>self.highscore then
        self.highscore=self.currentLevel
        love.filesystem.write('wizard-forest2.lst',tostring(self.highscore)..'\n')
    end
end
function GameOver:update(dt)
    if love.mouse.wasPressed(1) or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then 
        gStateMachine:change('start',{
            highscore=self.highscore
        })
    end
end

function GameOver:render()
    self.background:render()
    
    love.graphics.setColor(64, 64, 64, 200)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 2-40 ,
        400, 140, 3)

    love.graphics.setColor(200, 200, 200, 255)
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')

    
    
    love.graphics.setColor(200, 200, 200, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Click to continue!', 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')
    for i=0,15 do
        love.graphics.draw(gTextures['mossy'], gFrames['mossy'][1],
        i*96,VIRTUAL_HEIGHT-96)
    end
end