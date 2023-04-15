function speed_up()
    Player.speed = Player.speed + 50
    --increases movement speed of player
    print("Player speed UP")
end

function meleedmg_up()
    Player.base_melee_dmg = Player.base_melee_dmg + 20
    --increases melee damage
    print("Player melee damage UP")
end

function range_up()
    Player.range = Player.range + 10
    --increases melee hitbox
    print("Player melee range UP")
end

function firerate_up()
    Player.firerate = Player.firerate * 0.85
    --increases firerate
    print("Player fire rate UP")
end

function bulletsize_up()
    Projectiles.size = Projectiles.size + 5
    --increases bullet size
    print("Player bullet size UP")
end

