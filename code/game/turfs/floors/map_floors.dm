//Snow Floor
/turf/open/snow
	name = "snow layer"
	icon = 'icons/turf/snow2.dmi'
	icon_state = "snow_0"
	is_groundmap_turf = TRUE

	//PLACING/REMOVING/BUILDING
/turf/open/snow/attackby(var/obj/item/I, var/mob/user)
	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already a [L]  at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, TRUE, 5, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = 1
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.x = x
		L.y = y
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.SetLuminosity(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)

//Update icon and sides on start, but skip nearby check for turfs.
/turf/open/snow/New()
	..()
	update_icon(1,1)

/turf/open/snow/Entered(atom/movable/AM)
	if(slayer > 0)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			var/slow_amount = 0.75
			var/can_stuck = 1
			if(istype(C, /mob/living/carbon/Xenomorph)||isYautja(C))
				slow_amount = 0.25
				can_stuck = 0
			C.next_move_slowdown += slow_amount * slayer
			if(prob(2))
				to_chat(C, "<span class='warning'>Moving through [src] slows you down.</span>")
			else if(can_stuck && slayer == 3 && prob(2))
				to_chat(C, "<span class='warning'>You get stuck in [src] for a moment!</span>")
				C.next_move_slowdown += 10
	..()

//Update icon
/turf/open/snow/update_icon(var/update_full, var/skip_sides)
	icon_state = "snow_[slayer]"
	dir = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)
	switch(slayer)
		if(0)
			name = "dirt floor"
		if(1)
			name = "shallow [initial(name)]"
		if(2)
			name = "deep [initial(name)]"
		if(3)
			name = "very deep [initial(name)]"

	//Update the side overlays
	if(update_full)
		var/turf/open/T
		if(!skip_sides)
			for(var/dirn in alldirs)
				var/turf/open/snow/D = get_step(src,dirn)
				if(istype(D))
					//Update turfs that are near us, but only once
					D.update_icon(1,1)

		overlays.Cut()

		for(var/dirn in alldirs)
			T = get_step(src, dirn)
			if(istype(T))
				if(slayer > T.slayer && T.slayer < 1)
					var/image/I = new('icons/turf/snow2.dmi', "snow_[(dirn & (dirn-1)) ? "outercorner" : pick("innercorner", "outercorner")]", dir = dirn)
					switch(dirn)
						if(NORTH)
							I.pixel_y = 32
						if(SOUTH)
							I.pixel_y = -32
						if(EAST)
							I.pixel_x = 32
						if(WEST)
							I.pixel_x = -32
						if(NORTHEAST)
							I.pixel_x = 32
							I.pixel_y = 32
						if(SOUTHEAST)
							I.pixel_x = 32
							I.pixel_y = -32
						if(NORTHWEST)
							I.pixel_x = -32
							I.pixel_y = 32
						if(SOUTHWEST)
							I.pixel_x = -32
							I.pixel_y = -32

					I.layer = layer + 0.001 + slayer * 0.0001
					overlays += I
//Explosion act
/turf/open/snow/ex_act(severity)
	switch(severity)
		if(1)
			if(slayer)
				slayer = 0
				update_icon(1, 0)
		if(2)
			if(prob(60) && slayer)
				slayer = max(slayer - 2, 0)
				update_icon(1, 0)
		if(3)
			if(prob(20) && slayer)
				slayer -= 1
				update_icon(1, 0)

//SNOW LAYERS//
/turf/open/snow/layer0
	icon_state = "snow_0"
	slayer = 0

/turf/open/snow/layer1
	icon_state = "snow_1"
	slayer = 1

/turf/open/snow/layer2
	icon_state = "snow_2"
	slayer = 2

/turf/open/snow/layer3
	icon_state = "snow_3"
	slayer = 3


// Jungle turfs (Whiksey Outpost)
/turf/open/jungle
	allow_construction = FALSE
	var/bushes_spawn = 1
	var/plants_spawn = 1
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "grass1"
	var/icon_spawn_state = "grass1"

/turf/open/jungle/New()
	icon_state = icon_spawn_state

	if(plants_spawn && prob(40))
		if(prob(90))
			var/image/I
			if(prob(35))
				I = image('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi',"plant[rand(1,7)]")
			else
				if(prob(30))
					I = image('icons/obj/flora/ausflora.dmi',"reedbush_[rand(1,4)]")
				else if(prob(33))
					I = image('icons/obj/flora/ausflora.dmi',"leafybush_[rand(1,3)]")
				else if(prob(50))
					I = image('icons/obj/flora/ausflora.dmi',"fernybush_[rand(1,3)]")
				else
					I = image('icons/obj/flora/ausflora.dmi',"stalkybush_[rand(1,3)]")
			I.pixel_x = rand(-6,6)
			I.pixel_y = rand(-6,6)
			overlays += I
		else
			var/obj/structure/jungle_plant/J = new(src)
			J.pixel_x = rand(-6,6)
			J.pixel_y = rand(-6,6)
	if(bushes_spawn && prob(90))
		new /obj/structure/bush(src)

/turf/open/jungle/proc/Spread(probability, prob_loss = 50)
	if(probability <= 0)
		return
	//to_chat(world, "\blue Spread([probability])")
	for(var/turf/open/jungle/J in orange(1, src))
		if(!J.bushes_spawn)
			continue

		var/turf/open/jungle/P = null
		if(J.type == src.type)
			P = J
		else
			P = new src.type(J)

		if(P && prob(probability))
			P.Spread(probability - prob_loss)

/turf/open/jungle/clear
	bushes_spawn = 0
	plants_spawn = 0
	icon_state = "grass_clear"
	icon_spawn_state = "grass3"

/turf/open/jungle/path
	bushes_spawn = 0
	name = "dirt"
	desc = "it is very dirty."
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "grass_path"
	icon_spawn_state = "dirt"

/turf/open/jungle/path/New()
	..()
	for(var/obj/structure/bush/B in src)
		cdel(B)

/turf/open/jungle/impenetrable
	bushes_spawn = 0
	icon_state = "grass_impenetrable"
	icon_spawn_state = "grass1"
	New()
		..()
		var/obj/structure/bush/B = new(src)
		B.indestructable = 1

/turf/open/jungle/water
	bushes_spawn = 0
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/misc/beach.dmi'
	icon_state = "water"
	icon_spawn_state = "water"
	can_bloody = FALSE

/turf/open/jungle/water/New()
	..()
	for(var/obj/structure/bush/B in src)
		cdel(B)

/turf/open/jungle/water/Entered(atom/movable/O)
	..()
	if(istype(O, /mob/living))
		var/mob/living/M = O
		if(prob(10 + (M.m_intent == MOVE_INTENT_RUN ? 40 : 0))) //slip in the murky water if we try to run through it
			to_chat(M, pick("\blue You slip on something slimy.","\blue You fall over into the murk."))
			M.Stun(2)
			M.KnockDown(1)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25))
			to_chat(M, "\blue You feel something slithering around your legs.")
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick("\red Something sharp bites you!","\red Sharp teeth grab hold of you!","\red You feel something take a chunk out of your leg!"))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)

/turf/open/jungle/water/deep
	plants_spawn = 0
	density = 1
	icon_state = "water2"
	icon_spawn_state = "water2"



//Desert Map
/turf/open/desertdam //Basic groundmap turf parent
	name = "desert dirt"
	icon = 'icons/turf/desertdam_map.dmi'
	icon_state = "desert1"
	is_groundmap_turf = TRUE

/turf/open/desertdam/ex_act(severity) //Should make it indestructable
	return

/turf/open/desertdam/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/desertdam/attackby() //This should fix everything else. No cables, etc
	return

/turf/open/desertdam/desert //desert floor
	name = "desert"
	icon_state = "desert1"

/turf/open/desertdam/asphault //asphalt road
	name = "asphault"
	icon_state = "sunbleached_asphalt1"

/turf/open/desertdam/cave //CAVE
	icon_state = "outer_cave_floor1"

/turf/open/desertdam/cave/desert_into_outer_cave_floor //desert floor to outer cave floor transition
	name = "cave"
	icon_state = "outer_cave_transition1"

/turf/open/desertdam/cave/outer_cave_floor //outer cave floor
	name = "cave"
	icon_state = "outer_cave_floor1"

/turf/open/desertdam/cave/outer_cave_to_inner_cave //outer to inner cave floor transition
	name = "cave"
	icon_state = "outer_cave_to_inner1"

/turf/open/desertdam/cave/inner_cave_floor //inner cave floor
	name = "cave"
	icon_state = "inner_cave_1"

//River
/turf/open/desertdam/river
	icon_state = "shallow_water_clean"

/turf/open/desertdam/river/clean/shallow //shallow water
	name = "river"
	icon_state = "shallow_water_clean"

/turf/open/desertdam/river/clean/shallow_edge //shallow water transition to deep
	name = "river"
	icon_state = "shallow_to_deep_clean_water1"

/turf/open/desertdam/river/clean/deep_water_clean //deep water
	name = "river"
	icon_state = "deep_water_clean"

/turf/open/desertdam/river/clean/shallow_water_desert_coast //shallow water coast
	name = "river"
	icon_state = "shallow_water_desert_coast1"

/turf/open/desertdam/river/clean/shallow_water_desert_waterway //desert floor waterway
	name = "river"
	icon_state = "desert_waterway1"

/turf/open/desertdam/river/clean/shallow_water_cave_coast //shallow water cave coast
	name = "river"
	icon_state = "shallow_water_cave_coast1"

/turf/open/desertdam/river/clean/shallow_water_cave_waterway //cave floor waterway
	name = "river"
	icon_state = "shallow_water_cave_waterway1"

//TOXIC
/turf/open/desertdam/river/toxic
	icon_state = "shallow_water_toxic"

/turf/open/desertdam/river/toxic/shallow_water_toxic //shallow water
	name = "river"
	icon_state = "shallow_water_toxic"

/turf/open/desertdam/river/toxic/shallow_edge_toxic //shallow water transition to deep
	name = "river"
	icon_state = "shallow_to_deep_toxic_water1"

/turf/open/desertdam/river/toxic/deep_water_toxic //deep water
	name = "river"
	icon_state = "deep_water_toxic"

/turf/open/desertdam/river/toxic/shallow_water_desert_coast_toxic //shallow water coast
	name = "river"
	icon_state = "shallow_water_desert_coast_toxic1"

/turf/open/desertdam/river/toxic/shallow_water_desert_waterway_toxic //desert floor waterway
	name = "river"
	icon_state = "desert_waterway_toxic1"

/turf/open/desertdam/river/toxic/shallow_water_cave_coast_toxic //shallow water cave coast
	name = "river"
	icon_state = "shallow_water_cave_coast_toxic1"

/turf/open/desertdam/river/toxic/shallow_water_cave_waterway_toxic //cave floor waterway
	name = "river"
	icon_state = "shallow_water_cave_waterway_toxic1"


// Mars grounds
/turf/open/mars
	name = "sand"
	icon = 'icons/turf/bigred.dmi'
	icon_state = "mars_sand_1"
	is_groundmap_turf = TRUE


/turf/open/mars_cave
	name = "cave"
	icon = 'icons/turf/bigred.dmi'
	icon_state = "mars_cave_1"


/turf/open/mars_cave/New()
	..()
	spawn(10)
		var/r = rand(0, 2)

		if (r == 0 && icon_state == "mars_cave_2")
			icon_state = "mars_cave_3"

/turf/open/mars_dirt
	name = "dirt"
	icon = 'icons/turf/bigred.dmi'
	icon_state = "mars_dirt_1"

/turf/open/mars_dirt/New()
	..()
	spawn(10)
		prob(32)
			switch(rand(1,2))
				if(1)
					icon_state = "mars_dirt_1"
					return
				if(2)
					icon_state = "mars_dirt_2"
					return
		prob(4)
			icon_state = "mars_dirt_7"
			return


// Beach
/turf/open/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/open/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/open/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/open/beach/water
	name = "Water"
	icon_state = "water"
	can_bloody = FALSE

/turf/open/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

/turf/open/beach/water2
	name = "Water"
	icon_state = "water"
	can_bloody = FALSE

/turf/open/beach/water2/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)


//LV ground
/turf/open/gm //Basic groundmap turf parent
	name = "ground dirt"
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "desert"


/turf/open/gm/ex_act(severity) //Should make it indestructable
	return

/turf/open/gm/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/gm/attackby() //This should fix everything else. No cables, etc
	return

/turf/open/gm/dirt
	name = "dirt"
	icon_state = "desert"

/turf/open/gm/dirt/New()
	..()
	if(rand(0,15) == 0)
		icon_state = "desert[pick("0","1","2","3")]"

/turf/open/gm/grass
	name = "grass"
	icon_state = "grass1"

/turf/open/gm/dirt2
	name = "dirt"
	icon_state = "dirt"


/turf/open/gm/dirtgrassborder
	name = "grass"
	icon_state = "grassdirt_edge"

/turf/open/gm/dirtgrassborder2
	name = "grass"
	icon_state = "grassdirt2_edge"


/turf/open/gm/river
	name = "river"
	icon_state = "seashallow"
	can_bloody = FALSE

/turf/open/gm/river/New()
	..()
	overlays += image("icon"='icons/turf/ground_map.dmi',"icon_state"="riverwater","layer"=MOB_LAYER+0.1)

/turf/open/gm/river/Entered(atom/movable/AM)
	..()
	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		var/river_slowdown = 1.75

		if(ishuman(C))
			var/mob/living/carbon/human/H = AM
			cleanup(H)
			if(H.gloves && rand(0,100) < 60)
				if(istype(H.gloves,/obj/item/clothing/gloves/yautja))
					var/obj/item/clothing/gloves/yautja/Y = H.gloves
					if(Y && istype(Y) && Y.cloaked)
						to_chat(H, "<span class='warning'> Your bracers hiss and spark as they short out!</span>")
						Y.decloak(H)

		else if(isXeno(C))
			river_slowdown = 1.3
			if(isXenoBoiler(C))
				river_slowdown = -0.5

		if(C.on_fire)
			C.ExtinguishMob()

		C.next_move_slowdown += river_slowdown

/turf/open/gm/river/proc/cleanup(var/mob/living/carbon/human/M)
	if(!M || !istype(M)) return

	if(M.back)
		if(M.back.clean_blood())
			M.update_inv_back(0)
	if(M.wear_suit)
		if(M.wear_suit.clean_blood())
			M.update_inv_wear_suit(0)
	if(M.w_uniform)
		if(M.w_uniform.clean_blood())
			M.update_inv_w_uniform(0)
	if(M.gloves)
		if(M.gloves.clean_blood())
			M.update_inv_gloves(0)
	if(M.shoes)
		if(M.shoes.clean_blood())
			M.update_inv_shoes(0)
	M.clean_blood()

/turf/open/gm/river/poison/New()
	..()
	overlays += image("icon"='icons/effects/effects.dmi',"icon_state"="greenglow","layer"=MOB_LAYER+0.1)

/turf/open/gm/river/poison/Entered(mob/living/M)
	..()
	if(istype(M))
		M.apply_damage(55,TOX)

/turf/open/gm/coast
	name = "coastline"
	icon_state = "beach"

/turf/open/gm/riverdeep
	name = "river"
	icon_state = "seadeep"
	can_bloody = FALSE

/turf/open/gm/riverdeep/New()
	..()
	overlays += image("icon"='icons/turf/ground_map.dmi',"icon_state"="water","layer"=MOB_LAYER+0.1)

//ELEVATOR SHAFT
/turf/open/gm/empty
	name = "empty space"
	icon = 'icons/turf/floors.dmi'
	icon_state = "black"
	density = 1

/turf/open/gm/empty/is_weedable()
	return FALSE
