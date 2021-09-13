

require 'src/Dependencies'

local platform = love.system.getOS()
local mobileBuild = (platform == 'Android' or platform == 'iOS')
function love.load()
    math.randomseed(os.time())
    --love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Wizard Forest')

    local a,b,flags = love.window.getMode()
    local w,h =love.window.getDesktopDimensions(flags.display)
    -- push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     fullscreen = false,
    --     vsync = true,
    --     resizable = true
    -- })
    local dpi_scale = love.window.getDPIScale()
    w=w/dpi_scale
    h=h/dpi_scale
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, w, h, {
        fullscreen = mobileBuild,
        resizable = not mobileBuild,
        highdpi=flags.highdpi,
        canvas=true,
        stretched = true,
        pixelperfect = false
    })
    

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play']=function() return PlayState() end,
        ['game-over']=function() return GameOver() end,
        ['victory']=function() return VictoryState() end,
        ['begin-game']=function() return BeginGameState() end
    }
    gStateMachine:change('start',{
        highscore=loadhighscore()
    })

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
    -- love.mouse.keysPressed = {}
    -- love.mouse.keysReleased = {}
    love.touch.touches={}
    --love.touch.keysReleased={}
    paused = false
end

function push.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'p' then
        paused = not paused
    end

    love.keyboard.keysPressed[key] = true
end

-- function love.mousepressed(x, y, key)
--     love.mouse.keysPressed[key] = true
-- end

-- function love.mousereleased(x, y, key)
--     love.mouse.keysReleased[key] = true 
-- end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- function love.mouse.wasPressed(key)
--     return love.mouse.keysPressed[key]
-- end

-- function love.mouse.wasReleased(key)
--     return love.mouse.keysReleased[key]
-- end

function love.touchpressed(id,x,y,dx,dy,pressure)
    x,y=push:toGame(x,y)
    key=tostring(id)
    love.touch.touches[key]={xx=x,yy=y}
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    x,y=push:toGame(x,y)
    key=tostring(id)
    if x and y and love.touch.touches[key]~=nil then
        love.touch.touches[key].xx = x
        love.touch.touches[key].yy = y
    else
        love.touchreleased(id, 0, 0, 0, 0,1)
    end
    
end

function love.touchreleased(id,x,y,dx,dy,pressure)
    x,y=push:toGame(x,y)
    key=tostring(id)
    love.touch.touches[key]=nil
end

function howManyTouches()
    local howMany = 0
    for k,v in pairs(love.touch.touches) do
      howMany = howMany + 1
    end
    return howMany
end

-- function love.touch.wasPressed(key)
--     return love.touch.keysPressed[key]
-- end

-- function love.touch.wasReleased(key)
--     return love.touch.keysReleased[key]
-- end



function love.update(dt)
    if not paused then
        
        gStateMachine:update(dt)

        love.keyboard.keysPressed = {}
        -- love.mouse.keysPressed = {}
        -- love.mouse.keysReleased = {}
        --love.touch.touches={}
        -- love.touch.keysPressed={}
        -- love.touch.keysReleased={}
    end
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end

function loadhighscore()
    love.filesystem.setIdentity('wizard-forest3')
    local highscore=0
    if not love.filesystem.getInfo('wizard-forest3.txt') then
        local scores='0\n'
        love.filesystem.write('wizard-forest3.txt',scores)
    end

    for line in love.filesystem.lines('wizard-forest3.txt') do
        highscore=tonumber(line)
    end

    return highscore
end