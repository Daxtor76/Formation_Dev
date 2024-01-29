-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

Board = require("board");
board = Board:New(8, 8);

function love.load()
end

function love.update(dt)
end

function love.draw()
    -- Board
    love.graphics.rectangle("line", board.posX, board.posY, board.width, board.height);

    -- Cases
    for i=0, board.lines-1 do
        for y=0, board.columns-1 do
            if (i+y)%2 == 0 then
                love.graphics.setColor(255,0,0);
            else
                love.graphics.setColor(255,255,255);
            end
            local case = board.grid[i][y];
            love.graphics.rectangle("fill", case.posX, case.posY, case.width, case.height);
            love.graphics.setColor(0,0,0);
            love.graphics.print(case.name, case.posX, case.posY);
        end
    end
end

function love.keypressed(key)
end