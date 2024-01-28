local Dino = {};

function Dino:New()

    print("Création d'une instance de Dino");

    local tmpDino = {};
    setmetatable(tmpDino, {__index = Dino});
    tmpDino.maxLife = 5;
    tmpDino.life = tmpDino.maxLife;
    print("Life: "..tmpDino.life);

    return tmpDino;
end

function Dino:ModifyLife(damages)
    if self.life > 0 then
        self.life = (self.life - damages);
        
        if self.life <= 0 then
            self.life = 0;
            print("Dino dead!");
        end
        print(self.life);
    else
        self.life = self.maxLife;
        print("Rez dino!");
    end
end

return Dino;