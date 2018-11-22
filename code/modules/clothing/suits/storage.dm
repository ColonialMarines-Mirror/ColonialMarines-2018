/obj/item/storage/internal/armor_pocket
	var/obj/item/clothing/suit/storage/holder

/obj/item/storage/internal/armor_pocket/Dispose()
	holder = null
	return ..()

/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/armor_pocket/pockets

/obj/item/clothing/suit/storage/New()
	. = ..()
	pockets = new/obj/item/storage/internal/armor_pocket(src)
	pockets.holder = src
	pockets.storage_slots = 2	//two slots
	pockets.max_w_class = 2		//fit only small items
	pockets.max_storage_space = 4

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	if(pockets.handle_attack_hand(user))
		return ..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object)
	if(pockets.handle_mousedrop(usr, over_object))
		return ..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	. = ..()
	return pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	return ..()

/obj/item/clothing/suit/storage/hear_talk(mob/M, msg)
	pockets.hear_talk(M, msg)
	return ..()

/obj/item/storage/internal/armor_pocket/can_be_inserted(obj/item/W, stop_messages) //We don't need to stop messages, but it can be left in.
	. = ..()
	if(.) //If the parent did their thing, this should be fine. It pretty much handles all the checks.
		if(istype(W,/obj/item/weapon/gun)) //Is it a gun?
			if(current_gun) //Do we hold a gun?
				if(!stop_messages)
					to_chat(usr, "<span class='warning'>[src] already holds a gun.</span>")
				return FALSE //Nothing else to do.
			else if(pockets.storage_slots >= length(contents)) // Are we over capacity?
				if(!stop_messages)
					to_chat(usr, "<span class='warning'>[src] is full.</span>")
				return FALSE
			else
				return TRUE
		else //Anything besides a gun.
			if(pockets.storage_slots < length(contents)) // Are we over capacity?
				if(!stop_messages)
					to_chat(usr, "<span class='warning'>[src] is full.</span>")
				return FALSE
		return TRUE

/obj/item/clothing/suit/storage/marine/M3HS/Dispose()
	if(current_gun)
		cdel(current_gun)
		current_gun = null
	return ..()

/obj/item/clothing/suit/storage/marine/M3HS/attack_hand(mob/user)
	if(loc == user && current_gun)
		current_gun.attack_hand(user)
	else
		return ..()