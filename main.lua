

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    --love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Wizard Forest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
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
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

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

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.update(dt)
    if not paused then
        Timer.update(dt)
        gStateMachine:update(dt)

        love.keyboard.keysPressed = {}
        love.mouse.keysPressed = {}
        love.mouse.keysReleased = {}
    end
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end

function loadhighscore()
    love.filesystem.setIdentity('wizard-forest1')
    local highscore=0
    if not love.filesystem.exists('wizard-forest1.lst') then
        local scores='1'
        love.filesystem.write('wizard-forest1.lst',scores)
    end

    for line in love.filesystem.lines('wizard-forest1.lst') do
        highscore=tonumber(line)
    end

    return highscore
end