/datum/ammo/xeno
	accuracy = 15
	accuracy_var_low = 5
	accuracy_var_high = 5
	max_range = 10
	icon_state = "neurotoxin"
	ping = "ping_x"
	damage_type = TOX
	flags_ammo_behavior = AMMO_XENO_ACID
	var/added_spit_delay = 0 //used to make cooldown of the different spits vary.
	var/spit_cost

/datum/ammo/xeno/toxin
	name = "neurotoxic spit"
	shell_speed = 2
	max_range = 5
	damage_falloff = 0
	debilitate = list(1,2,0,0,0,0,0,0)
	flags_ammo_behavior = AMMO_XENO_TOX|AMMO_IGNORE_RESIST
	spit_cost = 50

/datum/ammo/xeno/toxin/medium //Spitter
	name = "neurotoxic spatter"
	shell_speed = 3
	accuracy_var_low = 9
	accuracy_var_high = 9
	debilitate = list(2,3,0,0,1,2,0,0)

/datum/ammo/xeno/toxin/heavy //Praetorian
	name = "neurotoxic splash"
	max_range = 5
	shell_speed = 2
	debilitate = list(3,4,0,0,3,5,0,0)

/datum/ammo/xeno/sticky
	name = "sticky resin spit"
	shell_speed = 3
	accuracy_var_high = 10
	max_range = 40
	icon_state = "sticky"
	ping = null
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE
	added_spit_delay = 5
	spit_cost = 40

/datum/ammo/xeno/sticky/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_resin(get_turf(P))

/datum/ammo/xeno/sticky/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_resin(get_turf(P))

/datum/ammo/xeno/sticky/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_resin(T)

/datum/ammo/xeno/sticky/do_at_max_range(obj/item/projectile/P)
	drop_resin(get_turf(P))

/datum/ammo/xeno/sticky/proc/drop_resin(turf/T)
	if(T.density)
		return
	for(var/obj/O in T.contents)
		if(istype(O, /obj/item/clothing/mask/facehugger))
			return
		if(istype(O, /obj/effect/alien/egg))
			return
		if(istype(O, /obj/structure/mineral_door) || istype(O, /obj/effect/alien/resin) || istype(O, /obj/structure/bed))
			return
		if(O.density && !(O.flags_atom & ON_BORDER))
			return
	new /obj/effect/alien/resin/sticky/thin(T)

/datum/ammo/xeno/acid
	name = "acid spit"
	damage = 20
	shell_speed = 2
	icon_state = "xeno_acid"
	sound_hit 	 = "acid_hit"
	sound_bounce	= "acid_bounce"
	damage_type = BURN
	added_spit_delay = 10
	spit_cost = 100

/datum/ammo/xeno/acid/on_shield_block(mob/M, obj/item/projectile/P)
	burst(M,P,damage_type)

/datum/ammo/xeno/acid/on_hit_mob(mob/M, obj/item/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.status_flags & XENO_HOST && istype(C.buckled, /obj/structure/bed/nest) || C.stat == DEAD)
			return
	..()

/datum/ammo/xeno/acid/medium
	name = "acid spatter"
	damage = 30
	damage_var_low = 5
	damage_var_high = 7
	shell_speed = 3

/datum/ammo/xeno/acid/heavy
	name = "acid splash"
	added_spit_delay = 20
	max_range = 5
	damage = 50
	damage_var_low = 7
	damage_var_high = 9
	shell_speed = 2

/datum/ammo/xeno/boiler_gas
	name = "glob of gas"
	accuracy_var_high = 10
	max_range = 30
	icon_state = "boiler_gas2"
	ping = "ping_x"
	debilitate = list(19,21,0,0,11,12,0,0)
	flags_ammo_behavior = AMMO_XENO_TOX|AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE|AMMO_IGNORE_RESIST
	var/datum/effect_system/smoke_spread/smoke_system

/datum/ammo/xeno/boiler_gas/New()
	..()
	set_xeno_smoke()

/datum/ammo/xeno/boiler_gas/Dispose()
	cdel(smoke_system)
	smoke_system = null
	. = ..()

/datum/ammo/xeno/boiler_gas/on_hit_mob(mob/M, obj/item/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.status_flags & XENO_HOST && istype(C.buckled, /obj/structure/bed/nest) || C.stat == DEAD)
			return
	if(isXenoBoiler(P.firer))
		var/mob/living/carbon/Xenomorph/Boiler/B = P.firer
		smoke_system.amount = B.upgrade
	drop_nade(get_turf(P))

/datum/ammo/xeno/boiler_gas/on_hit_obj(obj/O, obj/item/projectile/P)
	if(isXenoBoiler(P.firer))
		var/mob/living/carbon/Xenomorph/Boiler/B = P.firer
		smoke_system.amount = B.upgrade
	drop_nade(get_turf(P))

/datum/ammo/xeno/boiler_gas/on_hit_turf(turf/T, obj/item/projectile/P)
	if(isXenoBoiler(P.firer))
		var/mob/living/carbon/Xenomorph/Boiler/B = P.firer
		smoke_system.amount = B.upgrade
	if(T.density && isturf(P.loc))
		drop_nade(P.loc) //we don't want the gas globs to land on dense turfs, they block smoke expansion.
	else
		drop_nade(T)

/datum/ammo/xeno/boiler_gas/do_at_max_range(obj/item/projectile/P)
	if(isXenoBoiler(P.firer))
		var/mob/living/carbon/Xenomorph/Boiler/B = P.firer
		smoke_system.amount = B.upgrade
	drop_nade(get_turf(P))

/datum/ammo/xeno/boiler_gas/proc/set_xeno_smoke(obj/item/projectile/P)
		smoke_system = new /datum/effect_system/smoke_spread/xeno_weaken()

/datum/ammo/xeno/boiler_gas/proc/drop_nade(turf/T)
	smoke_system.set_up(4, 0, T)
	smoke_system.start()
	T.visible_message("<span class='danger'>A glob of acid lands with a splat and explodes into noxious fumes!</span>")

/datum/ammo/xeno/boiler_gas/corrosive
	name = "glob of acid"
	damage = 50
	damage_var_high = 10
	damage_type = BURN
	icon_state = "boiler_gas"
	sound_hit 	 = "acid_hit"
	sound_bounce	= "acid_bounce"
	debilitate = list(1,1,0,0,1,1,0,0)
	flags_ammo_behavior = AMMO_XENO_ACID|AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE|AMMO_IGNORE_ARMOR

/datum/ammo/xeno/boiler_gas/on_shield_block(mob/M, obj/item/projectile/P)
	burst(M,P,damage_type)

/datum/ammo/xeno/boiler_gas/set_xeno_smoke(obj/item/projectile/P)
	smoke_system = new /datum/effect_system/smoke_spread/xeno_acid()

/datum/ammo/xeno/boiler_gas/drop_nade(turf/T)
	smoke_system.set_up(3, 0, T)
	smoke_system.start()
	T.visible_message("<span class='danger'>A glob of acid lands with a splat and explodes into corrosive bile!</span>")