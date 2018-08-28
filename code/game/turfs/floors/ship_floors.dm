//Floors
/turf/open/floor/almayer
	icon = 'icons/turf/almayer.dmi'
	icon_state = "default"

/turf/open/floor/plating/almayer
	icon = 'icons/turf/almayer.dmi'

/turf/open/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"

/turf/open/floor/plating/airless/New()
	..()
	name = "plating"

/turf/open/floor/plating/icefloor
	icon_state = "plating"
	name = "ice colony plating"

/turf/open/floor/plating/icefloor/New()
	..()
	name = "plating"

/turf/open/floor/plating/plating_catwalk
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating_catwalk"
	var/base_state = "plating" //Post mapping
	name = "catwalk"
	desc = "Cats really don't like these things."
	var/covered = 1 //1 for theres the cover, 0 if there isn't.

/turf/open/floor/plating/plating_catwalk/New()
	..()
	icon_state = base_state
	update_turf_overlay()

/turf/open/floor/plating/plating_catwalk/proc/update_turf_overlay()
	var/image/reusable/I = rnew(/image/reusable, list(icon, src, "catwalk", CATWALK_LAYER))
	switch(covered)
		if(0)
			overlays -= I
			cdel(I)
		if(1)
			overlays += I

/turf/open/floor/plating/plating_catwalk/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/tool/crowbar))
		if(covered)
			var/obj/item/stack/catwalk/R = new(usr.loc)
			R.add_to_stacks(usr)
			covered = 0
			update_turf_overlay()
			return
	if(istype(W, /obj/item/stack/catwalk))
		if(!covered)
			var/obj/item/stack/catwalk/E = W
			E.use(1)
			covered = 1
			update_turf_overlay()
			return
	..()

/turf/open/floor/plating/plating_catwalk/prison
	icon = 'icons/turf/prison.dmi'

/turf/open/floor/plating/ironsand/New()
	..()
	name = "Iron Sand"
	icon_state = "ironsand[rand(1,15)]"

/turf/open/floor/plating/catwalk
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk0"
	name = "catwalk"
	desc = "Cats really don't like these things."

//Cargo elevator
/turf/open/floor/almayer/empty
	name = "empty space"
	desc = "There seems to be an awful lot of machinery down below"
	icon = 'icons/turf/floors.dmi'
	icon_state = "black"

/turf/open/floor/almayer/empty/is_weedable()
	return FALSE

/turf/open/floor/almayer/empty/ex_act(severity) //Should make it indestructable
	return

/turf/open/floor/almayer/empty/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/floor/almayer/empty/attackby() //This should fix everything else. No cables, etc
	return

/turf/open/floor/almayer/empty/Entered(var/atom/movable/AM)
	..()
	spawn(2)
		if(AM.throwing == 0 && istype(get_turf(AM), /turf/open/floor/almayer/empty))
			AM.visible_message("<span class='warning'>[AM] falls into the depths!</span>", "<span class='warning'>You fall into the depths!</span>")
			if(get_area(src) == get_area(get_turf(HangarUpperElevator)))
				var/list/droppoints = list()
				for(var/turf/TL in get_area(get_turf(HangarLowerElevator)))
					droppoints += TL
				AM.forceMove(pick(droppoints))
				if(ishuman(AM))
					var/mob/living/carbon/human/human = AM
					human.take_overall_damage(50, 0, "Blunt Trauma")
					human.KnockDown(2)
				for(var/mob/living/carbon/human/landedon in AM.loc)
					if(AM == landedon)
						continue
					landedon.KnockDown(3)
					landedon.take_overall_damage(50, 0, "Blunt Trauma")
				if(isXeno(AM))
					var/list/L = orange(rand(2,4))		// Not actually the fruit
					for (var/mob/living/carbon/human/H in L)
						H.KnockDown(3)
						H.take_overall_damage(10, 0, "Blunt Trauma")
				playsound(AM.loc, 'sound/effects/bang.ogg', 10, 0)
			else
				for(var/obj/structure/disposaloutlet/retrieval/R in structure_list)
					if(R.z != src.z)	continue
					var/obj/structure/disposalholder/H = new()
					AM.loc = H
					sleep(10)
					H.loc = R
					for(var/mob/living/M in H)
						M.take_overall_damage(100, 0, "Blunt Trauma")
					sleep(20)
					for(var/mob/living/M in H)
						M.take_overall_damage(20, 0, "Blunt Trauma")
					for(var/obj/effect/decal/cleanable/C in contents) //get rid of blood
						cdel(C)
					R.expel(H)
					return

				cdel(AM)

		else
			for(var/obj/effect/decal/cleanable/C in contents) //for the off chance of someone bleeding mid=flight
				cdel(C)

//Others
/turf/open/floor/almayer/uscm
	icon_state = "logo_c"
	name = "\improper USCM Logo"

/turf/open/floor/almayer/uscm/directional
	icon_state = "logo_directional"


// RESEARCH STUFF
/turf/open/floor/almayer/research/containment/entrance
	icon_state = "containment_entrance"

/turf/open/floor/almayer/research/containment/floor1
	icon_state = "containment_floor_1"

/turf/open/floor/almayer/research/containment/floor2
	icon_state = "containment_floor_2"

/turf/open/floor/almayer/research/containment/corner
	icon_state = "containment_corner"

/turf/open/floor/almayer/research/containment/corner1
	icon_state = "containment_corner_1"

/turf/open/floor/almayer/research/containment/corner2
	icon_state = "containment_corner_2"

/turf/open/floor/almayer/research/containment/corner3
	icon_state = "containment_corner_3"

/turf/open/floor/almayer/research/containment/corner4
	icon_state = "containment_corner_4"

/turf/open/floor/almayer/research/containment/corner_var1
	icon_state = "containment_corner_variant_1"

/turf/open/floor/almayer/research/containment/corner_var2
	icon_state = "containment_corner_variant_2"

//Outerhull
/turf/open/floor/almayer_hull
	icon = 'icons/turf/almayer.dmi'
	icon_state = "outerhull"
	name = "hull"
	hull_floor = TRUE
