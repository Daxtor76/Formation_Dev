-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

Dino = require("dino");
dinos = {};

function love.load()
    dinos = PopulateDinos(10);
end

function love.update(dt)
    -- Dino movement
    for i=1, #dinos do
        if dinos[i].state == 1 then
            dinos[i]:Move(dt);

            if dinos[i]:IsCollidingOnWalls() ~= 0 then
                dinos[i]:ChangeState("hit");
            end
        elseif dinos[i].state == 2 then
            if dinos[i]:IsAnimOver(dt) then
                if dinos[i]:IsCollidingOnWalls() == 1 then
                    dinos[i]:ChangeDirection(4);
                    dinos[i]:Replace(dinos[i].width, dinos[i].posY);
                elseif dinos[i]:IsCollidingOnWalls() == 3 then
                    dinos[i]:ChangeDirection(0);
                    dinos[i]:Replace(screenWidth - dinos[i].width, dinos[i].posY);
                end
                dinos[i]:ChangeState("run");
            end
        end
        dinos[i]:UpdateAnim(dt);
        dinos[i].update(dt); -- TEST : Appelle l'update de l'instance de Dino

        for key, value in pairs(dinos) do -- Récupère chaque élément d'une table et sa valeur
            --print(key.." - "..value);
        end

        for index, value in ipairs(dinos) do -- Récupère un élément d'une table pour tous les éléments d'une table
            print(index.." - "..value.posX);
        end
    end
end

function love.draw()
    -- Ship rendering
    for i=1, #dinos do
        dinos[i].draw();
    end
end

function love.keypressed(key)
end

function PopulateDinos(amount)
    local dinos = {}
    for i=1, amount do
        dino = Dino:New(love.math.random(100, screenWidth - 100), love.math.random(100, screenHeight - 100));
        dinos[i] = dino;
    end
    return dinos;
end