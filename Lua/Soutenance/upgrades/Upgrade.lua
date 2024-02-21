local Upgrade = {};

function Upgrade:New(label, event)
    local tmpUpgrade = {};
    setmetatable(tmpUpgrade, {__index = Upgrade});

    tmpUpgrade.label = label
    tmpUpgrade.onSelect = event;

    return tmpUpgrade;
end

function Upgrade.OnArrowUpgradeSelected(self)
    weapon.arrowsUpgraded = true;
    Buttons = {};
    isPaused = false;
end

function Upgrade.OnFireRateUpgrade(self)
    weapon.chargeTimer = weapon.chargeTimer - 0.1;
    weapon.reloadSpeed = weapon.reloadSpeed - 0.1;
    Buttons = {};
    isPaused = false;
end

function Upgrade.OnLifeUpgrade(self)
    hero.maxlife = hero.maxlife + 1;
    hero.life = hero.life + 1;
    Buttons = {};
    isPaused = false;
end

function Upgrade.OnDamageUpgrade()
    weapon.damages = weapon.damages + 1;
    Buttons = {};
    isPaused = false;
end

function Upgrade.OnShieldUpgradeSelected(self)
    Buttons = {};
    isPaused = false;
end

return Upgrade;