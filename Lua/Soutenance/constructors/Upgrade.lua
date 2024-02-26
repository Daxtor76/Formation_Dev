local Upgrade = {};
local Tornado = require("entities/projectiles/Tornado");

local tornadoCount = 0;

function Upgrade:New(label, event)
    local tmpUpgrade = {};
    setmetatable(tmpUpgrade, {__index = Upgrade});

    tmpUpgrade.label = label
    tmpUpgrade.onSelect = event;

    return tmpUpgrade;
end

function Upgrade.OnArrowUpgradeSelected(self)
    weapon.arrowsUpgraded = true;
    buttons = {};
    isUpgrading = false;
end

function Upgrade.OnFireRateUpgrade(self)
    weapon.chargeTimer = weapon.chargeTimer - 0.1;
    weapon.reloadSpeed = weapon.reloadSpeed - 0.1;
    buttons = {};
    isUpgrading = false;
end

function Upgrade.OnLifeUpgrade(self)
    hero.maxlife = hero.maxlife + 1;
    hero.life = hero.life + 1;
    buttons = {};
    isUpgrading = false;
end

function Upgrade.OnDamageUpgrade()
    weapon.damages = weapon.damages + 1;
    buttons = {};
    isUpgrading = false;
end

function Upgrade.OnTornadoSelected()
    hero.tornadoCount = hero.tornadoCount + 1;

    hero:DisableTornados();

    for i = 0, hero.tornadoCount - 1 do
        local angle = 360/(hero.tornadoCount / (hero.tornadoCount - i));
        table.insert(hero.tornados, Tornado:New(hero.position.x, hero.position.y, 1, angle));
    end

    buttons = {};
    isUpgrading = false;
end

return Upgrade;