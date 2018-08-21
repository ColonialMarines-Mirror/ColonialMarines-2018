/*
 * Morgue
 */
/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in untill someone fetches them."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = 1
	var/obj/structure/morgue_tray/connected = null
	var/morgue_type = "morgue"
	var/tray_path = /obj/structure/morgue_tray
	var/morgue_open = 0
	anchored = 1
	var/obj/item/device/radio/intercom/announce //Intercom for cryo announcements
	var/mob/living/occupant = null //Person waiting to be despawned.
	var/time_till_despawn = 3000 //5 minutes-ish safe period before being despawned.
	var/time_entered = 0 //Used to keep track of the safe period.

/obj/structure/morgue/New()
	..()
	connected = new tray_path(src)

/obj/structure/morgue/Dispose()
	. = ..()
	if(connected)
		cdel(connected)
		connected = null

/obj/structure/morgue/update_icon()
	if (morgue_open)
		icon_state = "[morgue_type]0"
	else
		if (contents.len > 1) //not counting the morgue tray
			icon_state = "[morgue_type]2"
		else
			icon_state = "[morgue_type]1"

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(2)
			if(prob(50))
				return
		if(3)
			if(prob(95))
				return
	for(var/atom/movable/A in src)
		A.forceMove(loc)
		ex_act(severity)
	cdel(src)

/obj/structure/morgue/attack_paw(mob/user)
	toggle_morgue(user)

/obj/structure/morgue/attack_hand(mob/user)
	toggle_morgue(user)

/obj/structure/morgue/proc/toggle_morgue(mob/user)
	add_fingerprint(user)
	if(!connected) return
	if(morgue_open)
		for(var/atom/movable/A in connected.loc)
			if(!A.anchored)
				A.forceMove(src)
				if(ishuman(A))
					var/mob/living/carbon/human/H = A
					if(H.stat == DEAD)
						occupant = H
		connected.loc = src
	else
		if(step(connected, dir))
			connected.dir = dir
			for(var/atom/movable/A in src)
				A.forceMove(connected.loc)
				occupant = null
		else
			connected.loc = src
			return
	morgue_open = !morgue_open
	playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
	update_icon()


/obj/structure/morgue/attackby(obj/item/P, mob/user)
	if (istype(P, /obj/item/weapon/zombie_claws))
		attack_hand()
		return
	else if (istype(P, /obj/item/tool/pen))
		var/t = copytext(stripped_input(user, "What would you like the label to be?", name, null),1,MAX_MESSAGE_LEN)
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, user) && src.loc != user))
			return
		if (t)
			name = "[initial(name)]- '[t]'"
		else
			name = initial(name)
		add_fingerprint(user)
	else
		. = ..()

/obj/structure/morgue/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	toggle_morgue(user)


//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/structure/morgue/process()
	if(occupant)
		//Allow a five minute gap between entering the pod and actually despawning.
		if(world.time - time_entered < time_till_despawn)
			return

		if(occupant.stat == DEAD) //Occupant is dead

			//Drop all items into the pod.
			for(var/obj/item/W in occupant)
				occupant.drop_inv_item_to_loc(W, src)

			//Delete all items not on the preservation list.

			var/list/items = contents.Copy()
			items -= occupant //Don't delete the occupant
			items -= announce //or the autosay radio.

			var/list/dept_console = frozen_items["REQ"]
			if(ishuman(occupant))
				var/mob/living/carbon/human/H = occupant
				switch(H.job)
					if("Military Police","Chief MP")
						dept_console = frozen_items["MP"]
					if("Doctor","Researcher","Chief Medical Officer")
						dept_console = frozen_items["Med"]
					if("Maintenance Tech","Chief Engineer")
						dept_console = frozen_items["Eng"]

			var/list/deleteempty = list(/obj/item/storage/backpack/marine/satchel)

			var/list/deleteall = list(/obj/item/clothing/mask/cigarette, \
			/obj/item/clothing/glasses/sunglasses, \
			/obj/item/device/pda, \
			/obj/item/clothing/glasses/mgoggles, \
			/obj/item/clothing/head/cmberet/red, \
			/obj/item/clothing/gloves/black, \
			/obj/item/weapon/baton, \
			/obj/item/weapon/gun/energy/taser, \
			/obj/item/clothing/glasses/sunglasses/sechud, \
			/obj/item/device/radio/headset/almayer, \
			/obj/item/card/id, \
			/obj/item/clothing/under/marine, \
			/obj/item/clothing/shoes/marine, \
			/obj/item/clothing/head/cmcap)

			var/list/strippeditems = list()

			item_loop:
				for(var/obj/item/W in items)
					if((W.flags_inventory & CANTSTRIP) || (W.flags_item & NODROP)) //We don't keep donor items and undroppable/unremovable items
						if(istype(W, /obj/item/clothing/suit/storage))
							var/obj/item/clothing/suit/storage/SS = W
							for(var/obj/item/I in SS.pockets) //But we keep stuff inside them
								SS.pockets.remove_from_storage(I, loc)
								strippeditems += I
								I.loc = null
						if(istype(W, /obj/item/storage))
							var/obj/item/storage/S = W
							for(var/obj/item/I in S)
								S.remove_from_storage(I, loc)
								strippeditems += I
								I.loc = null
						cdel(W)
						continue


					//special items that store stuff in a nonstandard way, we properly remove those items

					if(istype(W, /obj/item/clothing/suit/storage))
						var/obj/item/clothing/suit/storage/SS = W
						for(var/obj/item/I in SS.pockets)
							SS.pockets.remove_from_storage(I, loc)
							strippeditems += I
							I.loc = null

					if(istype(W, /obj/item/clothing/under))
						var/obj/item/clothing/under/UN = W
						if(UN.hastie)
							var/obj/item/TIE = UN.hastie
							UN.remove_accessory()
							strippeditems += TIE
							TIE.loc = null

					if(istype(W, /obj/item/clothing/shoes/marine))
						var/obj/item/clothing/shoes/marine/MS = W
						if(MS.knife)
							strippeditems += MS.knife
							MS.knife.loc = null
							MS.knife = null



					for(var/TT in deleteempty)
						if(istype(W, TT))
							if(length(W.contents) == 0)
								cdel(W) // delete all the empty satchels
								continue item_loop
							break // not empty, don't delete

					for(var/DA in deleteall)
						if(istype(W, DA))
							cdel(W)
							continue item_loop



					dept_console += W
					W.loc = null

			stripped_items:
				for(var/obj/item/A in strippeditems)
					for(var/DAA in deleteall)
						if(istype(A, DAA))
							cdel(A)
							continue stripped_items

					dept_console += A
					A.loc = null

			//Delete them from datacore.
			if(PDA_Manifest.len)
				PDA_Manifest.Cut()
			for(var/datum/data/record/R in data_core.medical)
				if((R.fields["name"] == occupant.real_name))
					data_core.medical -= R
					cdel(R)
			for(var/datum/data/record/T in data_core.security)
				if((T.fields["name"] == occupant.real_name))
					data_core.security -= T
					cdel(T)
			for(var/datum/data/record/G in data_core.general)
				if((G.fields["name"] == occupant.real_name))
					data_core.general -= G
					cdel(G)


			occupant.ghostize(0) //We want to make sure they are not kicked to lobby.
			//TODO: Check objectives/mode, update new targets if this mob is the target, spawn new antags?

			//Make an announcement and log the person entering storage.
			frozen_crew += "[occupant.real_name]"

			announce.autosay("[occupant.real_name]'s remains have been consigned to cryogenic storage. Belongings moved to hypersleep inventory.", "Cryo Storage System")
			visible_message("<span class='notice'>[src] hums and hisses as it moves [occupant.real_name] into cryogenic storage.</span>")

			//Delete the mob.

			cdel(occupant)
			occupant = null


/*
 * Morgue tray
 */

/obj/structure/morgue_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morguet"
	density = 1
	layer = OBJ_LAYER
	var/obj/structure/morgue/linked_morgue = null
	anchored = 1
	throwpass = 1

/obj/structure/morgue_tray/New(loc, obj/structure/morgue/morgue_source)
	if(morgue_source)
		linked_morgue = morgue_source
	..()

/obj/structure/morgue_tray/Dispose()
	. = ..()
	linked_morgue = null

/obj/structure/morgue_tray/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/structure/morgue_tray/attack_hand(mob/user)
	if(linked_morgue)
		linked_morgue.toggle_morgue(user)


/obj/structure/morgue_tray/MouseDrop_T(atom/movable/O, mob/user)
	if (!istype(O) || O.anchored || !isturf(O.loc))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/bodybag))
		return
	if (!istype(user) || user.is_mob_incapacitated())
		return
	O.forceMove(loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			B.show_message("\red [user] stuffs [O] into [src]!", 1)



/*
 * Crematorium
 */

/obj/structure/morgue/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon_state = "crema1"
	dir = SOUTH
	tray_path = /obj/structure/morgue_tray/crematorium
	morgue_type = "crema"
	var/cremating = 0
	var/id = 1


/obj/structure/morgue/crematorium/toggle_morgue(mob/user)
	if (cremating)
		to_chat(user, "<span class='warning'>It's locked.</span>")
		return
	..()


/obj/structure/morgue/crematorium/relaymove(mob/user)
	if(cremating) return
	..()


/obj/structure/morgue/crematorium/update_icon()
	if(cremating)
		icon_state = "[morgue_type]_active"
	else
		..()


/obj/structure/morgue/crematorium/proc/cremate(mob/user)
	set waitfor = 0
	if(cremating)
		return

	if(contents.len <= 1) //1 because the tray is inside.
		visible_message("\red You hear a hollow crackle.")
	else
		visible_message("\red You hear a roar as the crematorium activates.")

		cremating = 1

		update_icon()

		for(var/mob/living/M in contents)
			if (M.stat!=DEAD)
				if (!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C = M
					if (!(C.species && (C.species.flags & NO_PAIN)))
						C.emote("scream")

			user.attack_log +="\[[time_stamp()]\] Cremated <b>[M]/[M.ckey]</b>"
			log_attack("\[[time_stamp()]\] <b>[user]/[user.ckey]</b> cremated <b>[M]/[M.ckey]</b>")
			M.death(1)
			M.ghostize()
			cdel(M)

		for(var/obj/O in contents)
			if(istype(O, /obj/structure/morgue_tray)) continue
			cdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = 0
		update_icon()
		playsound(src.loc, 'sound/machines/ding.ogg', 25, 1)


/*
 * Crematorium tray
 */

/obj/structure/morgue_tray/crematorium
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon_state = "cremat"


/*
 * Crematorium switch
 */

/obj/machinery/crema_switch/attack_hand(mob/user)
	if(allowed(user))
		for (var/obj/structure/morgue/crematorium/C in range(7,src))
			if (C.id == id)
				if(!C.cremating)
					C.cremate(user)
	else
		to_chat(user, "\red Access denied.")



/*
 * Sarcophagus
 */

/obj/structure/morgue/sarcophagus
    name = "sarcophagus"
    desc = "Used to store predators."
    icon_state = "sarcophagus1"
    morgue_type = "sarcophagus"
    tray_path = /obj/structure/morgue_tray/sarcophagus


/*
 * Sarcophagus tray
 */

/obj/structure/morgue_tray/sarcophagus
    name = "sarcophagus tray"
    desc = "Apply corpse before closing."
    icon_state = "sarcomat"
