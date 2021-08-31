BeginGameState=Class{__includes=BaseState}

function BeginGameState:init()
    self.transitionAlpha=255
    self.levelLabelY=-64
    
end

function BeginGameState:enter(params)
    self.level=params.level
    self.background=Background(self.level)
    Timer.tween(1,{
        [self]={transitionAlpha=0}
    })
    :finish(function()
        Timer.tween(0.25,{
            [self]={levelLabelY=VIRTUAL_HEIGHT/2-16}
        })
        :finish(function()
            Timer.after(2,function()
                Timer.tween(0.25,{
                    [self]={levelLabelY=VIRTUAL_HEIGHT+16}
                })
                :finish(function()
                    gStateMachine:change('play',{
                        level=self.level
                    })
                end)
            end)
        end)
    end)
    
end

function BeginGameState:update(dt)
    
    Timer.update(dt)

end

function BeginGameState:render()
    self.background:render()
    for i=0,15 do
        love.graphics.draw(gTextures['mossy'], gFrames['mossy'][1],
        i*96,VIRTUAL_HEIGHT-96)
    end
    love.graphics.setColor(95,205,228,200)
    love.graphics.rectangle('fill',0,self.levelLabelY-8,VIRTUAL_WIDTH,80)
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level '..tostring(self.level),0,self.levelLabelY,VIRTUAL_WIDTH,'center')
    love.graphics.setColor(255,255,255,self.transitionAlpha)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
end