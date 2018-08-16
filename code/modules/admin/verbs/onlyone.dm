/client/proc/only_one()
	if(!ticker)
		alert("The game hasn't started yet!")
		return

	switch( alert("Delayed or no?", "PICK ONE!", "NOW!", "Delayed", "Cancel") )
		if("Delayed")
			for(var/M in player_list)
				playsound(M, "sound/misc/highlander_delayed.ogg", 40)
			send_to_playing_players("<font size = 4 color=red>Bagpipes begin to blare. You feel Scottish pride coming over you.</span></font>")
			spawn(420)
				only_one_NOW()
		if("NOW!")
			for(var/M in player_list)
				playsound(M, "sound/misc/highlander.ogg", 40)
			only_one_NOW()
		if("Cancel")
			return

/client/proc/only_one_NOW()
	send_to_playing_players("<b><font size=6 color=red>THERE CAN BE ONLY ONE</font></b></span>")
	for(var/obj/item/disk/nuclear/N in world)
		if(blobstart.len > 0)
			N.loc = pick(blobstart)
			message_admins("Highlander confirmed. Teleporting [N] at ([N.x], [N.y], [N.z]).")
		else
			message_admins("Highlander confirmed. [N] teleport fail at ([N.x], [N.y], [N.z]).")

	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == DEAD || !(H.client))
			continue
		if(is_special_character(H))
			continue
		//highlander stuff starts here
		//delete their suit and hold object
		for(var/obj/item/I in H.get_equipped_items())
			cdel(I)
		for(var/obj/item/I in H.get_held_item())
			cdel(I)
		//give them their shit
		ticker.mode.traitors += H.mind
		H.mind.special_role = "highlander"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/kilt(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/weapon/claymore/highlander, WEAR_L_HAND)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/device/pinpointer(H), WEAR_WAIST)
		for(var/obj/item/device/pinpointer/P in H) //making sure the pinpointer is active
			P.attack_self(H)
		var/obj/item/card/id/W = new(H) //id
		W.name = "[H.real_name]'s ID Card"
		W.icon_state = "centcom"
		W.access = get_all_accesses()
		W.access += get_all_centcom_access()
		W.assignment = "Highlander"
		W.registered_name = H.real_name
		W.flags_item = NODROP
		H.equip_to_slot_or_del(W, WEAR_ID)
		var/obj/item/bloodcrawl/antiwelder = new(H) //no doublehand ree
		antiwelder.name = "compulsion of honor"
		antiwelder.desc = "You are unable to hold anything in this hand until you're the last one left!"
		antiwelder.icon_state = "bloodhand_right"
		H.equip_to_slot_or_del(antiwelder, WEAR_R_HAND)

	message_admins("\blue [key_name_admin(usr)] used THERE CAN BE ONLY ONE!", 1)
	log_admin("[key_name(usr)] used there can be only one.")

/obj/item/bloodcrawl
	name = "blood crawl"
	desc = "You are unable to hold anything while in this form."
	icon = 'icons/effects/blood.dmi'
	flags_item = NODROP