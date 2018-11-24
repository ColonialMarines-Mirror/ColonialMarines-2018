/obj/item/clothing
	name = "clothing"
	var/eye_protection = 0 //Used for headgear, masks, and glasses, to see how much they protect eyes from bright lights.
	var/tint = 0 //Headgear, mask and glasses, for vision impairment overlays.

//Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

/obj/item/clothing/mob_can_equip(M as mob, slot)
	//If we can't equip the item anyway, don't bother checking the rest.
	. = ..()
	if(!.)
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/clothing/under/U = H.w_uniform
		//Some clothes can only be worn when wearing specific uniforms.
		if(uniform_restricted && (!is_type_in_list(U, uniform_restricted) || !U))
			to_chat(H, "<span class='warning'>Your [U ? "[U.name]":"naked body"] doesn't allow you to wear this [name].</span>")
			return FALSE
	return TRUE