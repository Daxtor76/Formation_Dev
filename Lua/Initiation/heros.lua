local Heros = {};

local heros_mt = {__index = Heros};

function Heros.Create()

    print("Création d'une instance de Heros");

    local tmpHeros = {};
    tmpHeros.nombre = 1;

    return setmetatable(tmpHeros, heros_mt);
end

function Heros:Add()
    self.nombre = self.nombre + 1;

    print("Nb Héros: ", self.nombre);
end

return Heros;