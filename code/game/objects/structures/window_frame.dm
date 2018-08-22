/obj/structure/window_frame
	name = "window frame"
	desc = "A big hole in the wall that used to sport a large window. Can be vaulted through"
	icon = 'icons/obj/structures/window_frames.dmi'
	icon_state = "window0_frame"
	layer = WINDOW_FRAME_LAYER
	density = 1
	throwpass = TRUE
	climbable = 1 //Small enough to vault over, but you do need to vault over it
	climb_delay = 15 //One second and a half, gotta vault fast
	var/obj/item/stack/sheet/sheet_type = /obj/item/stack/sheet/glass/reinforced
	var/obj/structure/window/framed/almayer/window_type = /obj/structure/window/framed/almayer
	var/basestate = "window"
	var/junction = 0
	var/reinforced = FALSE
	var/damage = 0
	var/health_max = 400
	var/soak = 20 //how much damage is reduced before affecting health
	var/max_temperature = 1800
	var/d_state
	
	tiles_with = list(
		/turf/closed/wall)

	var/tiles_special[] = list(/obj/machinery/door/airlock,
		/obj/structure/window/framed,
		/obj/structure/girder,
		/obj/structure/window_frame)

/obj/structure/window_frame/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable non-border objects allow you to universally climb over others
		return 1
	return 0

/obj/structure/window_frame/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	return 1

/obj/structure/window_frame/New(loc, from_window_shatter)
	..()
	var/weed_found
	if(from_window_shatter)
		for(var/obj/effect/alien/weeds/weedwall/window/W in loc)
			weed_found = TRUE
			break
	spawn(0)
		relativewall()
		relativewall_neighbours()
		if(weed_found)
			new /obj/effect/alien/weeds/weedwall/frame(loc) //after smoothing to get the correct junction value


/obj/structure/window_frame/proc/update_nearby_icons()
	relativewall_neighbours()

/obj/structure/window_frame/update_icon()
	relativewall()

/obj/structure/window_frame/Dispose()
	density = 0
	update_nearby_icons()
	for(var/obj/effect/alien/weeds/weedwall/frame/WF in loc)
		cdel(WF)
	. = ..()

/obj/structure/window_frame/attackby(obj/item/W, mob/living/user)
	if(istype(W, sheet_type))
		var/obj/item/stack/sheet/sheet = W
		if(sheet.get_amount() < 2)
			user << "<span class='warning'>You need more [W.name] to install a new window.</span>"
			return
		user.visible_message("<span class='notice'>[user] starts installing a new glass window on the frame.</span>", \
		"<span class='notice'>You start installing a new window on the frame.</span>")
		playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
			user.visible_message("<span class='notice'>[user] installs a new glass window on the frame.</span>", \
			"<span class='notice'>You install a new window on the frame.</span>")
			sheet.use(2)
			new window_type(loc) //This only works on Almayer windows!
			cdel(src)

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(isXeno(user)) return
		if(isliving(G.grabbed_thing))
			var/mob/living/M = G.grabbed_thing
			if(user.grab_level >= GRAB_AGGRESSIVE)
				if(get_dist(src, M) > 1)
					user << "<span class='warning'>[M] needs to be next to [src].</span>"
				else
					if(user.action_busy)
						return
					user.visible_message("<span class='notice'>[user] starts pulling [M] onto [src].</span>",
					"<span class='notice'>You start pulling [M] onto [src]!</span>")
					var/oldloc = loc
					if(!do_mob(user, M, 20, BUSY_ICON_GENERIC) || loc != oldloc) return
					M.KnockDown(2)
					user.visible_message("<span class='warning'>[user] pulls [M] onto [src].</span>",
					"<span class='notice'>You pull [M] onto [src].</span>")
					M.forceMove(loc)
			else
				user << "<span class='warning'>You need a better grip to do that!</span>"

	if(W.flags_item & NOBLUDGEON) return

	else if(damage && istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			user.visible_message("<span class='notice'>[user] starts repairing the damage to the [src].</span>",
			"<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 25, 1)
			if(do_after(user, max(5, round(damage / 5)), TRUE, 5, BUSY_ICON_FRIENDLY) && istype(src, /obj/structure/window_frame) && WT && WT.isOn())
				user.visible_message("<span class='notice'>[user] finishes repairing the damage to [src].</span>",
				"<span class='notice'>You finish repairing the damage to [src].</span>")
				damage = 0
			return
		else
			user << "<span class='warning'>You need more welding fuel to complete this task.</span>"
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
		
	//DECONSTRUCTION
	switch(d_state)
		if(0)
			if(istype(W, /obj/item/tool/screwdriver))

				user.visible_message("<span class='notice'>[user] begins unscrewing the outer plating.</span>",
				"<span class='notice'>You begin unscrewing the outer plating.</span>")
				playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)

				if(do_after(user, 60, TRUE, 5, BUSY_ICON_BUILD))
					if(!istype(src, /turf/closed/wall)) return

					if(d_state == 0)
						d_state++
						user.visible_message("<span class='notice'>[user] unscrews the outer plating.</span>",
						"<span class='notice'>You unscrew the outer plating; use a crowbar to pry it off.</span>")
				return
		if(1)
			if(istype(W, /obj/item/tool/crowbar))

				user.visible_message("<span class='notice'>[user] struggles to pry off the outer plating.</span>",
				"<span class='notice'>You struggle to pry off the outer plating.</span>")
				playsound(src, 'sound/items/Crowbar.ogg', 25, 1)

				if(do_after(user, 60, TRUE, 5, BUSY_ICON_BUILD))
					if(!istype(src, /obj/structure/window_frame)) return

					if(d_state == 1)
						d_state++
						user.visible_message("<span class='notice'>[user] pries off the outer plating.</span>",
						"<span class='notice'>You pry off the outer plating; use a wrench to loosen its bolts and dismantle the frame.</span>")
				return
		if(2)
			if(istype(W, /obj/item/tool/wrench))

				user.visible_message("<span class='notice'>[user] starts loosening the bolts securing the frame.</span>",
				"<span class='notice'>You start loosening the bolts securing the frame.</span>")
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)

				if(do_after(user, 60, TRUE, 5, BUSY_ICON_BUILD))
					if(!istype(src, /obj/structure/window_frame)) return

					if(d_state == 2)
						d_state++
						create_debris(2)
						user.visible_message("<span class='notice'>[user] removes the bolts securing the frame, dismantling it.</span>",
						"<span class='notice'>You remove the bolts securing the frame, dismantling it.</span>")
				return

//create_debris creates debris like shards and rods. This also includes the window frame for explosions
//If an user is passed, it will create a "user smashes through the window" message. AM is the item that hits
//Please only fire this after a hit
/obj/structure/window_frame/proc/healthcheck(make_hit_sound = 1, create_debris = 1, mob/user, atom/movable/AM)

	if(damage >= health_max)
		if(user)
			user.visible_message("<span class='danger'>[user] smashes apart the [src][AM ? " with [AM]":""]!</span>")
		playsound(loc, 'sound/effects/metal_crash.ogg', 35)
		create_debris()
	if(make_hit_sound)
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)

/obj/structure/window_frame/proc/create_debris(var/create_debris = 1)
	new /obj/item/stack/sheet/metal(loc)
	if(create_debris > 1) //If it was properly dismantled, generate another stack o metal.
		new /obj/item/stack/sheet/metal(loc)
	cdel(src)

/obj/structure/window_frame/bullet_act(var/obj/item/projectile/Proj)
	var/impact = max(0,Proj.damage - soak)
	if(Proj.ammo.damage_type == HALLOSS || impact <= 0)
		return 0

	damage += impact
	..()
	healthcheck()
	return 1

/obj/structure/window_frame/ex_act(severity)
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

/obj/structure/window_frame/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>The [src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	tforce -= soak
	if(tforce)
		damage += tforce
		healthcheck()

/obj/structure/window_frame/attack_hand(mob/user as mob)
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] smashes through the [src]!</span>")
		damage += max(0,100 - soak)
		healthcheck(1, 1, user)

	else if(ishuman(user) && user.a_intent == "hurt")
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, 25)

/obj/structure/window_frame/attack_paw(mob/user as mob)
	return attack_hand(user)

//Used by attack_animal
/obj/structure/window_frame/proc/attack_generic(mob/living/user, impact = 0)
	user.animation_attack_on(src)
	user.visible_message("<span class='danger'>[user] smashes into the [src]!</span>")
	impact -= soak
	if(impact)
		damage += max(impact - soak,0)
		healthcheck(1, 1, user)

/obj/structure/fence/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	attack_generic(M, M.melee_damage_upper)


/obj/structure/window_frame/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > max_temperature)
		damage += round(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()


/obj/structure/window_frame/almayer
	icon_state = "alm_window0_frame"
	basestate = "alm_window"

/obj/structure/window_frame/almayer/white
	icon_state = "white_window0_frame"
	basestate = "white_window"
	window_type = /obj/structure/window/framed/almayer/white

/obj/structure/window_frame/almayer/requisitions/attackby(obj/item/W, mob/living/user)
	if(istype(W, sheet_type))
		user << "<span class='warning'>You can't repair this window.</span>"
		return
	..()

/obj/structure/window_frame/colony
	icon_state = "col_window0_frame"
	basestate = "col_window"

/obj/structure/window_frame/colony/reinforced
	icon_state = "col_rwindow0_frame"
	basestate = "col_rwindow"
	reinforced = TRUE
	health_max = 800
	soak = 30

/obj/structure/window_frame/chigusa
	icon_state = "chig_window0_frame"
	basestate = "chig_window"
	health_max = 200
	soak = 5

/obj/structure/window_frame/wood
	icon_state = "wood_window0_frame"
	basestate = "wood_window"
	health_max = 200
	soak = 5

/obj/structure/window_frame/prison
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"

/obj/structure/window_frame/prison/reinforced
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"
	reinforced = TRUE
	health_max = 800
	soak = 30
