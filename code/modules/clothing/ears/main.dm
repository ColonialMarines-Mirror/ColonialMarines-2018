/*

Currently actively used in-game.

*/
/obj/item/clothing/ears
	name = "ears"
	icon = 'icons/obj/clothing/ears.dmi'
	w_class = 1.0
	throwforce = 2
	flags_equip_slot = SLOT_EAR

/obj/item/clothing/ears/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_ears()


/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"