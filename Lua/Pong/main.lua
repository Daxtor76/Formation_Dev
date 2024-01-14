-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- int !Les variables ne sont pas typées donc utile de créer un petit espace pour regrouper les variables par type!
nombreDeVies = 5;
print("Nb life: "..nombreDeVies); --.. est l'équivalent de + pour concaténer les chaines de caractère

-- float
local enemyCount;

-- variables complexe: table / Pas de système de class ?
-- deux façons de déclarer des tables
heros = { 
    vies = 5,
    energie = 100,
    nom = "toto",
    inventaire = {nombre = 10}
};
print(heros.nom);
print(heros["energie"]); -- accède à un élément d'une table par le nom de l'élément

enemy = {};
enemy.vies = 5;
enemy.energie = 1000;
enemy.nom = "méchant";
print(enemy.nom);

couleurs = {};
couleurs[1] = "bleu";
couleurs[2] = "rouge";
table.insert(couleurs, "vert");
print(#couleurs); -- #nomdelatable pour afficher le nombre d'éléments dans la table
for n=1,#couleurs do -- boucle for
    print(couleurs[n]);
end

table.remove(couleurs, 2); -- remove l'élément 2 de la table
couleurs.nom = "Table des couleurs" -- ajoute un élément non numérique à la table qui ne sera pas parsée avec couleurs[i] par exemple
for n, c in pairs(couleurs) do -- équivalent du foreach
    print(n, c);
end
for n, c in ipairs(couleurs) do -- équivalent du foreach sur valeurs numériques uniquement
    print(n, c);
end

lignes = {};
lignes[1] = {};
lignes[1][1] = "A";
lignes[1][2] = "B";
lignes[2] = {};
lignes[2][1] = "C";
lignes[2][2] = "D";

for i=1, #lignes do
    for y=1, #lignes[i] do
        -- parcourt la liste 2D (liste de listes)
        print(i,y,lignes[i][y]);
    end
end

-- modularité
require("aliens"); -- va inclure le fichier lua écrit en paramètre, méthode pas très claire et pas opti
mesAliens = CreateAliens();
mesAliens.AddAlien();

 -- méthode POO simple
mesAutresAliens = CreateAliens();
AddAlien(mesAutresAliens);

-- POO en lua
local Heros = require("heros");
local myHeros = Heros.Create();
myHeros:Add();


function love.load()
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key)
end
