/datum/ammo/energy
	accuracy = 20
	ping = null //no bounce off. We can have one later.
	sound_hit 	 	= "energy_hit"
	sound_miss		= "energy_miss"
	sound_bounce	= "energy_bounce"
	damage_type = BURN
	flags_ammo_behavior = AMMO_ENERGY

/datum/ammo/energy/emitter //Damage is determined in emitter.dm
	name = "emitter bolt"
	accurate_range = 10
	max_range = 10
	icon_state = "emitter"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_ARMOR

/datum/ammo/energy/taser
	name = "taser bolt"
	icon_state = "stun"
	damage_type = OXY
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST //Not that ignoring will do much right now.

/datum/ammo/energy/taser/on_hit_mob(mob/M, obj/item/projectile/P)
	stun_living(M,P)

/datum/ammo/energy/yautja/
	accurate_range = 10
	shell_speed = 3

/datum/ammo/energy/yautja/pistol
	name = "plasma pistol bolt"
	damage = 40
	shell_speed = 2
	icon_state = "ion"
	flags_ammo_behavior = AMMO_ENERGY

/datum/ammo/energy/yautja/caster/bolt
	name = "plasma bolt"
	damage = 10
	icon_state = "ion"
	debilitate = list(2,2,0,0,0,1,0,0)
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/caster/blast
	name = "plasma blast"
	damage = 30
	shell_speed = 5
	icon_state = "pulse1"

/datum/ammo/energy/yautja/caster/sphere
	name = "plasma eradication sphere"
	damage = 40
	shell_speed = 4
	icon_state = "bluespace"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_EXPLOSIVE

/datum/ammo/energy/yautja/caster/sphere/on_hit_mob(mob/M,obj/item/projectile/P)
	explosion(get_turf(P.loc), -1, -1, 2, 2)

/datum/ammo/energy/yautja/caster/sphere/on_hit_turf(turf/T,obj/item/projectile/P)
	explosion(T, -1, -1, 2, 2)

/datum/ammo/energy/yautja/caster/sphere/on_hit_obj(obj/O,obj/item/projectile/P)
	explosion(get_turf(P.loc), -1, -1, 2, 2)

/datum/ammo/energy/yautja/rifle
	damage = 10

/datum/ammo/energy/yautja/rifle/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P.damage > 25)
		knockback(M,P)
		playsound(M.loc, 'sound/weapons/pulse.ogg', 25, 1)

/datum/ammo/energy/yautja/rifle/on_hit_turf(turf/T,obj/item/projectile/P)
	if(P.damage > 25)
		explosion(T, -1, -1, 2, -1)

/datum/ammo/energy/yautja/rifle/on_hit_obj(obj/O,obj/item/projectile/P)
	if(P.damage > 25)
		explosion(get_turf(P), -1, -1, 2, -1)

/datum/ammo/energy/yautja/rifle/bolt
	name = "plasma rifle bolt"
	icon_state = "ion"
	debilitate = list(0,2,0,0,0,0,0,0)
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/rifle/blast
	name = "plasma rifle blast"
	icon_state = "bluespace"
	shell_speed = 4