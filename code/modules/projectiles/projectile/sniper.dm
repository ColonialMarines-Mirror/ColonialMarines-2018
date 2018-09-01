/datum/ammo/bullet/sniper
	name = "sniper bullet"
	damage_falloff = 0
	iff_signal = ACCESS_IFF_MARINE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_SKIPS_HUMANS
	accurate_range_min = 10
	accurate_range = 5
	max_range = 40
	scatter = -20
	damage = 80
	penetration= 60
	shell_speed = 5

/datum/ammo/bullet/sniper/incendiary
	name = "incendiary sniper bullet"
	accuracy = 0
	accuracy_var_high = 7
	max_range = 20
	scatter = 15
	damage = 55
	penetration= 20
	damage_type = BURN
	iff_signal = ACCESS_IFF_MARINE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_INCENDIARY|AMMO_SNIPER|AMMO_SKIPS_HUMANS

/datum/ammo/bullet/sniper/flak
	name = "flak sniper bullet"
	accuracy = -10
	max_range = 20
	scatter = 15
	damage = 55
	damage_var_high = 5
	penetration= -5
	iff_signal = ACCESS_IFF_MARINE

/datum/ammo/bullet/sniper/flak/on_hit_mob(mob/M,obj/item/projectile/P)
	burst(get_turf(M),P,damage_type)

/datum/ammo/bullet/sniper/svd
	name = "crude sniper bullet"
	iff_signal = null

/datum/ammo/bullet/sniper/elite
	name = "supersonic sniper bullet"
	accuracy = 40
	damage = 120
	shell_speed = 6 //was config +1 so i just added it together because same result
	iff_signal = ACCESS_IFF_PMC
