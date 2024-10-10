require "utils.saveUtils"

local Colors = require "enums.Colors"
local GameStates = require "enums.GameStates"

local constants, variables
local font, fontSize
local screenWidth, screenHeight
local player, entities, gameMap, messageLog, gameState
local showMainMenu = true
local showLoadErrorMessage = false
local mainMenuBackgroundImage

function love.load()
    setFont()
    loadConstants()
    loadVariables()
    loadBackgroundImage()
    testSave()
end

function testSave()
    saveGame(player, entities, gameMap, messageLog, gameState)
end

function loadConstants()
    constants = require "config.constants"
    screenWidth = constants.screen.width * fontSize
    screenHeight = constants.screen.height * fontSize
end

function setFont()
    font = love.graphics.newImageFont("img/love-font.png",
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
        "123456789.,!?-+/():;%&`'*#=[]\"")
    fontSize = 17
    love.graphics.setFont(font)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
end

function loadVariables()
    variables = require "config.variables"
    player = variables.player
    entities = variables.entities
    gameMap = variables.gameMap
    messageLog = variables.messageLog
    messageLog.font = font
    messageLog.fontSize = fontSize
    gameState = variables.gameState
end

function loadBackgroundImage()
    mainMenuBackgroundImage = love.graphics.newImage("img/menu_background.png")
end

function love.update(dt)
end

function love.keypressed(key, scancode)
    if showMainMenu then
        handleMainMenu(key)
    else
        print(string.format("%s %s", key, scancode))
    end
end

function handleMainMenu(key)
    if showLoadErrorMessage then
        showLoadErrorMessage = false
    elseif key == "a" then
        newGame()
    elseif key == "b" then
        continue()
    elseif key == "c" then
        quit()
    end
end

function newGame()
    loadVariables()
    gameState = GameStates.PLAYERS_TURN
    showMainMenu = false
end

function continue()
    local success, loadedPlayer, loadedEntities, loadedGameMap, loadedMessageLog, loadedGameState = loadGame()
    if not success then
        showLoadErrorMessage = true
    else
        player = loadedPlayer
        entities = loadedEntities
        gameMap = loadedGameMap
        messageLog = loadedMessageLog
        gameState = loadedGameState
        showMainMenu = false
    end
end

function quit()
    love.event.quit()
end

function love.mousepressed(x, y, button)
    local gridX = math.floor(x / fontSize) + 1
    local gridY = math.floor(y / fontSize) + 1
    print(string.format("%d %d %s", gridX, gridY, button))
end

function love.draw()
    if showMainMenu then
        drawMainMenu()
        if showLoadErrorMessage then
            drawMessageBox("No save game to load!", 50)
        end
    else
        drawGame()
    end
end

function drawMainMenu()
    drawBackgroundImage()
    drawTitle()
    drawMenu("", {"Play a new game", "Continue last game", "Quit"}, 24)
end

function drawBackgroundImage()
    local width, height = mainMenuBackgroundImage:getWidth(), mainMenuBackgroundImage:getHeight()
    local sw, sh = screenWidth / width, screenHeight / height
    love.graphics.draw(mainMenuBackgroundImage, 0, 0, 0, sw, sh)
end

function drawTitle()
    love.graphics.push()
    love.graphics.scale(2, 2)
    setColor(Colors.YELLOW)
    love.graphics.printf("TOMBS OF THE ANCIENT KINGS", 0, screenHeight / 4 - 4 * fontSize, screenWidth / 2, "center")
    setColor(Colors.WHITE)
    love.graphics.pop()
    love.graphics.printf("by JBtheShadow", 0, screenHeight / 2 - 5.5 * fontSize, screenWidth, "center")
end

function drawMenu(header, options, width)
    if #options > 26 then
        error("Cannot have a menu with more than 26 options.")
    end

    local _, headerLines = font:getWrap(header, width * fontSize)
    local height = (#options + #headerLines) * fontSize

    love.graphics.push()
    love.graphics.translate(screenWidth / 2 - width * fontSize / 2, screenHeight / 2)

    setColor(Colors.BLACK)
    love.graphics.rectangle("fill", -fontSize, -fontSize, (width + 2) * fontSize, height + 2 * fontSize)
    setColor(Colors.WHITE)

    local y = 0
    for _, headerText in ipairs(headerLines) do
        love.graphics.printf(headerText, 0, y, width * fontSize)
        y = y + fontSize
    end

    local letterIndex = string.byte("a")
    for _, optionText in ipairs(options) do
        local text = string.format("(%s) %s", string.char(letterIndex), optionText)
        love.graphics.printf(text, 0, y, width * fontSize)
        y = y + fontSize
        letterIndex = letterIndex + 1
    end
    love.graphics.pop()
end

function setColor(color, alpha)
    love.graphics.setColor(color.color.r, color.color.g, color.color.b, alpha or 1)
end

function setBackgroundColor(color, alpha)
    love.graphics.setBackgroundColor(color.color.r, color.color.g, color.color.b, alpha or 1)
end

function drawMessageBox(text, width)
    drawMenu(text, {}, width)
end

function drawGame()
end