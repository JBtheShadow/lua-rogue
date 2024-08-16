local Colors = require "enums.Colors"

local constants, variables
local font, fontSize
local screenWidth, screenHeight
local player, entities, gameMap, messageLog, gameState
local showMainMenu = true
local showLoadErrorMessage = false
local mainMenuBackgroundImage

function love.load()
    constants = require "config.constants"
    variables = require "config.variables"
    setFont()
    screenWidth = constants.screen.width * fontSize
    screenHeight = constants.screen.height * fontSize
    loadBackgroundImage()
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

function loadBackgroundImage()
    mainMenuBackgroundImage = love.graphics.newImage("img/menu_background.png")
end

function love.update(dt)
end

function love.draw()
    if showMainMenu then
        drawMainMenu()
        if showLoadErrorMessage then
            drawMessageBox("No save game to load", 50 * fontSize)
        end
    else
        drawGame()
    end
end

function drawMainMenu()
    drawBackgroundImage()
    drawTitle()
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
    love.graphics.printf("by JBtheShadow", 0, screenHeight / 2 - 3 * fontSize, screenWidth, "center")
end

function setColor(color, alpha)
    love.graphics.setColor(color.r, color.g, color.b, alpha or 1)
end

function setBackgroundColor(color, alpha)
    love.graphics.setBackgroundColor(color.r, color.g, color.b, alpha or 1)
end

function drawMessageBox(text, width)
end

function drawGame()
end