function CreateAliens()
    local aliens = {
        nombre = 0;
    };

    aliens.AddAlien = function()
        aliens.nombre = aliens.nombre + 1;
        print("Nombre d'aliens: "..aliens.nombre);
    end

    return aliens;
end

function AddAlien(packName)
    packName.nombre = packName.nombre + 1;
    print("Nombre d'aliens: "..packName.nombre);
end