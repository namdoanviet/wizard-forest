VictoryState=Class{__includes=BaseState}

function VictoryState:enter(params)
    self.background=params.background
    self.level=params.level
    self.highscore=params.highscore
    self.isStarted=false
    Timer.after(0.5,function()
        self.isStarted=true
    end)
end

function VictoryState:update(dt)
    local touchNumbers=howManyTouches()
    Timer.update(dt)
    if self.isStarted then
        if  love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or touchNumbers~=0 then 
            gStateMachine:change('begin-game',{
                level=self.level+1,
                highscore=self.highscore
            })
        end
    end
    
end

function VictoryState:render()
    self.background:render()
    
    love.graphics.setColor(64/255, 64/255, 64/255, 200/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 2-40 ,
        400, 140, 3)

    love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('!!! Victory !!!', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')

    
    
    love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Click to next level!', 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')
    for i=0,15 do
        love.graphics.draw(gTextures['mossy'], gFrames['mossy'][1],
        i*96,VIRTUAL_HEIGHT-96)
    end
end