/datum/ammo/alloy_spike
	name = "alloy spike"
	accuracy = 40
	accurate_range = 10
	max_range = 10
	damage = 40
	penetration= 50
	shrapnel_chance = 75
	ping = "ping_s"
	icon_state = "MSpearFlight"
	sound_hit 	 	= "alloy_hit"
	sound_armor	 	= "alloy_armor"
	sound_bounce	= "alloy_bounce"

/datum/ammo/flamethrower
	name = "flame"
	max_range = 5
	damage = 50
	icon_state = "pulse0"
	damage_type = BURN
	flags_ammo_behavior = AMMO_INCENDIARY|AMMO_IGNORE_ARMOR

/datum/ammo/flamethrower/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_flame(get_turf(P))

/datum/ammo/flamethrower/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_flame(get_turf(P))

/datum/ammo/flamethrower/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_flame(get_turf(P))

/datum/ammo/flamethrower/do_at_max_range(obj/item/projectile/P)
	drop_flame(get_turf(P))

/datum/ammo/flamethrower/tank_flamer/drop_flame(var/turf/T)
	if(!istype(T))
		return
	if(locate(/obj/flamer_fire) in T)
		return
	new /obj/flamer_fire(T, 20, 20, fire_spread_amount = 2)

/datum/ammo/flare
	name = "flare"
	damage = 15
	accuracy = 15
	max_range = 10
	ping = null //no bounce off.
	damage_type = BURN
	flags_ammo_behavior = AMMO_INCENDIARY

/datum/ammo/flare/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_nade(get_turf(P))

/datum/ammo/flare/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_nade(get_turf(P))

/datum/ammo/flare/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_nade(T)

/datum/ammo/flare/do_at_max_range(obj/item/projectile/P)
	drop_nade(get_turf(P))

/datum/ammo/flare/proc/drop_nade(var/turf/T)
	var/obj/item/device/flashlight/flare/G = new (T)
	G.visible_message("<span class='warning'>\A [G] bursts into brilliant light nearby!</span>")
	G.on = 1
	processing_objects += G
	G.icon_state = "flare-on"
	G.damtype = "fire"
	G.SetLuminosity(G.brightness_on)

/datum/ammo/rocket/nobugs
	name = "\improper NO BUGS rocket"
	damage = 1

/datum/ammo/rocket/nobugs/on_hit_mob(mob/M,obj/item/projectile/P)
		to_chat(M, "<font size=6 color=red>NO BUGS</font>")

/datum/ammo/rocket/nobugs/on_hit_obj(obj/O,obj/item/projectile/P)
	return

/datum/ammo/rocket/nobugs/on_hit_turf(turf/T,obj/item/projectile/P)
	return

/datum/ammo/rocket/nobugs/do_at_max_range(obj/item/projectile/P)
	return

/datum/ammo/grenade_container
	name = "grenade shell"
	damage = 15
	accuracy = 15
	max_range = 10
	ping = null
	damage_type = BRUTE
	var/nade_type = /obj/item/explosive/grenade/frag
	icon_state = "grenade"

/datum/ammo/grenade_container/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_nade(get_turf(P))

/datum/ammo/grenade_container/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_nade(get_turf(P))

/datum/ammo/grenade_container/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_nade(get_turf(P))

/datum/ammo/grenade_container/do_at_max_range(obj/item/projectile/P)
	drop_nade(get_turf(P))

/datum/ammo/grenade_container/proc/drop_nade(var/turf/T)
	var/obj/item/explosive/grenade/G = new nade_type(T)
	G.visible_message("<span class='warning'>\A [G] lands on [T]!</span>")
	G.det_time = 10
	G.activate()

/datum/ammo/grenade_container/smoke
	name = "smoke grenade shell"
	nade_type = /obj/item/explosive/grenade/smokebomb
	icon_state = "smoke_shell"
