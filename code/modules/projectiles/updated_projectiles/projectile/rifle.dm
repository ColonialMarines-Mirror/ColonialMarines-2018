/datum/ammo/bullet/rifle
	name = "rifle bullet"
	damage = 40
	accurate_range = 10
	penetration = 10

/datum/ammo/bullet/rifle/ap
	name = "armor-piercing rifle bullet"
	damage = 35
	penetration = 50

/datum/ammo/bullet/rifle/incendiary
	name = "incendiary rifle bullet"
	damage_type = BURN
	accuracy = -10
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_INCENDIARY

/datum/ammo/bullet/rifle/m4ra
	name = "A19 high velocity bullet"
	damage = 55
	scatter = -15
	penetration = 30
	shell_speed = 3
	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range_min = 6

/datum/ammo/bullet/rifle/m4ra/incendiary
	name = "A19 high velocity incendiary bullet"
	damage = 55
	accuracy = 20
	scatter = -15
	penetration = 20
	shell_speed = 3
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_INCENDIARY

/datum/ammo/bullet/rifle/m4ra/impact
	name = "A19 high velocity impact bullet"
	damage = 55
	accuracy = -10
	scatter = -15
	penetration = 20
	shell_speed = 3

/datum/ammo/bullet/rifle/m4ra/impact/on_hit_mob(mob/M, obj/item/projectile/P)
	knockback(M, P, 40)

/datum/ammo/bullet/rifle/mar40
	name = "heavy rifle bullet"
	damage = 50
	accuracy = -10
	penetration= -10
