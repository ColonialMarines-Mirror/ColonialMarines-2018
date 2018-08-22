/obj/structure/cargo_container
	name = "Cargo Container"
	desc = "A huge industrial shipping container."
	icon = 'icons/contain.dmi'
	icon_state = "blue"
	bound_width = 32
	bound_height = 64
	density = 1
	var/damage = 0
	var/health_max = 200
	var/soak = 10 //how much damage is reduced before affecting health
	var/max_temperature = 1800
	opacity = 1
	anchored = 1

/obj/structure/cargo_container/proc/healthcheck(make_hit_sound = 1, create_debris = 1, mob/user, atom/movable/AM)

	if(damage >= health_max)
		if(user)
			user.visible_message("<span class='danger'>[user] smashes through [src][AM ? " with [AM]":""]!</span>")
		playsound(loc, 'sound/effects/metal_crash.ogg', 35)
		create_debris()
	if(make_hit_sound)
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
		
/obj/structure/cargo_container/proc/create_debris(var/create_debris = 1)
	new /obj/item/stack/sheet/metal(loc)
	if(create_debris > 1) //If it was properly dismantled, generate another stack o metal.
		new /obj/item/stack/sheet/metal(loc)
	cdel(src)

/obj/structure/cargo_container/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > max_temperature)
		damage += round(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()

/obj/structure/cargo_container/ex_act(severity)
	var/impact 
	switch(severity)
		if(1)
			cdel(src) //Nope
		if(2)
			impact = max(0,rand(100, 300) - soak)
			if(impact)
				damage += impact 
				healthcheck(0, 1)
		if(3)
			impact = max(0,rand(25, 100) - soak)
			if(impact)
				damage += impact 
				healthcheck(0, 1)

/obj/structure/cargo_container/attack_hand(mob/user as mob)

	playsound(loc, 'sound/effects/clang.ogg', 25, 1)

	var/damage_dealt
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))

			user.visible_message("<span class='warning'>[user] smashes [src] to no avail.</span>", \
					 "<span class='warning'>You beat against [src] to no effect</span>", \
					 "You hear twisting metal.")

	if(!damage_dealt)
		user.visible_message("<span class='warning'>[user] beats against the [src] to no avail.</span>", \
						 "<span class='warning'>[user] beats against the [src].</span>", \
						 "You hear twisting metal.")
						 
/obj/structure/cargo_container/bullet_act(var/obj/item/projectile/Proj)
	var/impact = max(0,Proj.damage - soak)
	if(Proj.ammo.damage_type == HALLOSS || impact <= 0)
		return 0

	damage += impact
	..()
	healthcheck()
	return 1
						 
/obj/structure/cargo_container/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/weldingtool))
		user.visible_message("<span class='notice'>[user] starts cutting through [src] with [W].</span>",
		"<span class='notice'>You start cutting through [src] with [W]")
		playsound(src, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
			playsound(src, 'sound/items/Welder.ogg', 25, 1)
			user.visible_message("<span class='notice'>[user] cuts through [src] with [W].</span>",
			"<span class='notice'>You cut apart the [src] with [W]")
			create_debris(2)
		return
	else
		var/strike = max(0,(W.force - soak))
		playsound(loc, 'sound/effects/clang.ogg', 25, 1)
		if(strike)
			damage += strike
			healthcheck(0, 1, user, W)
		else
			user.visible_message("<span class='notice'>[user]'s attack with [W] bounces harmlessly off the [src].</span>",
			"<span class='notice'>Your attack with [W] bounces harmlessly off the [src]")
		..()

/obj/structure/cargo_container/horizontal
	name = "Cargo Container"
	desc = "A huge industrial shipping container,"
	icon = 'icons/containHorizont.dmi'
	icon_state = "blue"
	bound_width = 64
	bound_height = 32
	density = 1
	opacity = 1
