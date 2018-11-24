/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/tank/emergency_oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_equip_slot = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	var/list/supporting_limbs = null
	siemens_coefficient = 0.9
	w_class = 3

/obj/item/clothing/suit/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_suit()

/obj/item/clothing/suit/mob_can_equip(mob/M, slot, disable_warning = 0)
	. = ..()
	//if we can't equip the item anyway, don't bother with other checks.
	if(!.)
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/clothing/under/U = H.w_uniform
		if(!U)
			to_chat(H, "<span class='warning'>You must be wearing something under it.</span>")
			return FALSE

		//some uniforms prevent you from wearing any suits but certain types
		if(U?.suit_restricted && !is_type_in_list(src, U.suit_restricted))
			to_chat(H, "<span class='warning'>[src] can't be worn with [U].</span>")
			return FALSE
	return TRUE

/obj/item/clothing/suit/equipped(mob/M)
	check_limb_support()
	return ..()


/obj/item/clothing/suit/dropped()
	check_limb_support()
	return ..()


/obj/item/clothing/suit/Dispose()
	check_limb_support()
	return ..()

// Some space suits are equipped with reactive membranes that support
// broken limbs - at the time of writing, only the ninja suit, but
// I can see it being useful for other suits as we expand them. ~ Z
// The actual splinting occurs in /datum/limb/proc/fracture()
/obj/item/clothing/suit/proc/check_limb_support()
	// If this isn't set, then we don't need to care.
	if(!supporting_limbs?.len)
		return

	var/mob/living/carbon/human/H = loc

	// If the holder isn't human, or the holder IS and is wearing the suit, it keeps supporting the limbs.
	if(!istype(H) || H.wear_suit == src)
		return

	// Otherwise, remove the splints.
	for(var/datum/limb/E in supporting_limbs)
		E.status &= ~ LIMB_SPLINTED
	supporting_limbs = list()