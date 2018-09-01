/datum/ammo/rocket
	name = "high explosive rocket"
	accuracy = 10
	accurate_range = 20
	max_range = 30
	damage = 15
	shell_speed = 1
	icon_state = "missile"
	ping = null //no bounce off.
	sound_bounce	= "rocket_bounce"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET
	var/datum/effect_system/smoke_spread/smoke

/datum/ammo/rocket/New()
	..()
	smoke = new()

/datum/ammo/rocket/Dispose()
	cdel(smoke)
	smoke = null
	. = ..()

/datum/ammo/rocket/on_hit_mob(mob/M, obj/item/projectile/P)
	explosion(get_turf(M), -1, 1, 4, 5)
	smoke.set_up(1, get_turf(M))
	smoke.start()

/datum/ammo/rocket/on_hit_obj(obj/O, obj/item/projectile/P)
	explosion(get_turf(O), -1, 1, 4, 5)
	smoke.set_up(1, get_turf(O))
	smoke.start()

/datum/ammo/rocket/on_hit_turf(turf/T, obj/item/projectile/P)
	explosion(T,  -1, 1, 4, 5)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/do_at_max_range(obj/item/projectile/P)
	explosion(get_turf(P),  -1, 1, 4, 5)
	smoke.set_up(1, get_turf(P))
	smoke.start()

/datum/ammo/rocket/ap
	name = "anti-armor rocket"
	accuracy = -5
	accuracy_var_low = 7
	accurate_range = 10
	max_range = 20
	damage = 150 //lmao tons of hit damage but it's never processed due to the below proc redefinitions
	penetration= 80
	damage_falloff = 0

/datum/ammo/rocket/ap/on_hit_mob(mob/M, obj/item/projectile/P)
	explosion(get_turf(M), -1, 1, 2, 5)
	smoke.set_up(1, get_turf(M))
	smoke.start()

/datum/ammo/rocket/ap/on_hit_obj(obj/O, obj/item/projectile/P)
	explosion(get_turf(O), -1, 1, 2, 5)
	smoke.set_up(1, get_turf(O))
	smoke.start()

/datum/ammo/rocket/ap/on_hit_turf(turf/T, obj/item/projectile/P)
	explosion(T,  -1, 1, 2, 5)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/do_at_max_range(obj/item/projectile/P)
	explosion(get_turf(P),  -1, 1, 2, 5)
	smoke.set_up(1, get_turf(P))
	smoke.start()

/datum/ammo/rocket/ltb
	name = "cannon round"
	accuracy = 15
	accurate_range = 30
	max_range = 40
	damage = 30
	shell_speed = 3
	icon_state = "ltb"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET

/datum/ammo/rocket/ltb/on_hit_mob(mob/M, obj/item/projectile/P)
	explosion(get_turf(M), 1, 1, 5, 6)

/datum/ammo/rocket/ltb/on_hit_obj(obj/O, obj/item/projectile/P)
	explosion(get_turf(P), 1, 1, 5, 6)

/datum/ammo/rocket/ltb/on_hit_turf(turf/T, obj/item/projectile/P)
	explosion(get_turf(P), 1, 1, 5, 6)

/datum/ammo/rocket/ltb/do_at_max_range(obj/item/projectile/P)
	explosion(get_turf(P), 1, 1, 5, 6)

/datum/ammo/rocket/wp
	name = "white phosphorous rocket"
	accuracy_var_low = 7
	accurate_range = 10
	damage = 120
	max_range = 20
	flags_ammo_behavior = AMMO_ROCKET|AMMO_INCENDIARY|AMMO_EXPLOSIVE
	damage_type = BURN

/datum/ammo/rocket/wp/drop_flame(turf/T)
	if(!istype(T))
		return
	smoke.set_up(1, T)
	smoke.start()
	if(locate(/obj/flamer_fire) in T)
		return
	new /obj/flamer_fire(T, pick(15, 20, 25, 30))
	for(var/mob/living/carbon/M in range(3, T))
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.fire_immune)
				continue
		if(M.stat == DEAD)
			continue
		M.adjust_fire_stacks(rand(5, 25))
		M.IgniteMob()
		M.visible_message("<span class='danger'>[M] bursts into flames!</span>","[isXeno(M)?"<span class='xenodanger'>":"<span class='highdanger'>"]You burst into flames!</span>")

/datum/ammo/rocket/wp/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_flame(get_turf(M))

/datum/ammo/rocket/wp/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_flame(get_turf(O))

/datum/ammo/rocket/wp/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_flame(T)

/datum/ammo/rocket/wp/do_at_max_range(obj/item/projectile/P)
	drop_flame(get_turf(P))

/datum/ammo/rocket/wp/quad
	name = "thermobaric rocket"
	damage = 150
	max_range = 30
	flags_ammo_behavior = AMMO_ROCKET

/datum/ammo/rocket/wp/quad/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_flame(get_turf(M))
	explosion(P.loc,  -1, 2, 4, 5)

/datum/ammo/rocket/wp/quad/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_flame(get_turf(O))
	explosion(P.loc,  -1, 2, 4, 5)

/datum/ammo/rocket/wp/quad/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_flame(T)
	explosion(P.loc,  -1, 2, 4, 5)

/datum/ammo/rocket/wp/quad/do_at_max_range(obj/item/projectile/P)
	drop_flame(get_turf(P))
	explosion(P.loc,  -1, 2, 4, 5)
