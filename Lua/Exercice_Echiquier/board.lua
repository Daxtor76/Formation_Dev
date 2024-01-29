local Case = require("case");
local Board = {};

function Board:New(lines, columns)

    print("Create instance: Board");

    local tmpBoard = {};
    setmetatable(tmpBoard, {__index = Board});
    tmpBoard.lines = lines;
    tmpBoard.columns = columns;
    tmpBoard.width = screenHeight;
    tmpBoard.height = screenHeight;
    tmpBoard.posX = (screenWidth - tmpBoard.width)/2;
    tmpBoard.posY = 0;
    tmpBoard.grid = tmpBoard:Populate(tmpBoard.lines, tmpBoard.columns);

    return tmpBoard;
end

function Board:Populate(l, c)
    local grid = {};
    for i=0, l-1 do
        grid[i] = {};
        for y=0, c-1 do
            local caseWidth = self.width/l;
            local caseHeight = self.height/c;
            grid[i][y] = Case:New(i, y, caseWidth, caseHeight, y*caseWidth + self.posX, i*caseHeight, string.char(65+(l-1-i))..y+1);
        end
    end
    print("Chess: "..l*c.." cases");
    return grid;
end

return Board;