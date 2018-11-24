/*

Currently actively used in-game.

Categories:
	Gas
	Breath
*/
/obj/item/clothing/mask
	name = "face"
	icon = 'icons/obj/clothing/mask.dmi'
	flags_armor_protection = HEAD
	flags_equip_slot = SLOT_FACE
	flags_armor_protection = FACE|EYES
	var/anti_hug = 0

/obj/item/clothing/mask/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_face()

/obj/item/clothing/mask/proc/filter_air(list/air_info)
	if(flags_inventory & ALLOWREBREATH)
		air_info[2] = T20C //Sets the temperature of the air to be breathable.
	return air_info


/obj/item/clothing/mask/rebreather
	name = "rebreather"
	desc = "A close-fitting device that instantly heats or cools down air when you inhale so it doesn't damage your lungs."
	icon_state = "rebreather"
	w_class = 2
	flags_armor_protection = 0
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDELOWHAIR


/obj/item/clothing/mask/coif
	name = "heat absorbent coif"
	desc = "A close-fitting cap that covers the top, back, and sides of the head. Can also be adjusted to cover the lower part of the face so it keeps the user warm in harsh conditions."
	icon_state = "coif"
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDEALLHAIR|HIDEEARS
	flags_cold_protection = HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature


/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = 2
	flags_inventory = COVERMOUTH
	flags_armor_protection = 0
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 25, rad = 0)


/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	flags_inventory = COVERMOUTH
	flags_armor_protection = 0
	w_class = 2
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/muzzle/attack_paw(mob/user as mob)
	if(src == user.wear_mask)
		return
	else
		return ..()



//Gas
/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "gas_alt"
	flags_inventory = COVERMOUTH|COVEREYES|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDELOWHAIR
	flags_cold_protection = HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	w_class = 2.0
	item_state = "gas_alt"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	tint = 2
	var/gas_filter_strength = 1
	var/list/filtered_gases = list("phoron", "sleeping_agent", "carbon_dioxide")


/obj/item/clothing/mask/gas/pmc
	name = "\improper M8 pattern armored balaclava"
	desc = "An armored balaclava designed to conceal both the identity of the operator and act as an air-filter."
	item_state = "helmet"
	icon_state = "pmc_mask"
	anti_hug = 3
	tint = 0
	armor = list(melee = 10, bullet = 10, laser = 5, energy = 5, bomb = 10, bio = 1, rad = 1)
	flags_inventory = COVERMOUTH|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR


/obj/item/clothing/mask/gas/pmc/leader
	name = "\improper M8 pattern armored balaclava"
	desc = "An armored balaclava designed to conceal both the identity of the operator and act as an air-filter. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_mask"


/obj/item/clothing/mask/gas/upp
	name = "\improper UPP armored commando balaclava"
	icon_state = "upp_mask"
	armor = list(melee = 10, bullet = 10, laser = 5, energy = 5, bomb = 10, bio = 1, rad = 1)
	flags_inventory = COVERMOUTH|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR


/obj/item/clothing/mask/gas/bear
	name = "tactical balaclava"
	desc = "A superior balaclava worn by the Iron Bears."
	icon_state = "bear_mask"
	anti_hug = 2
	tint = 0


//Breath
/obj/item/clothing/mask/breath
	desc = "A close-fitting face that can be connected to an air supply."
	name = "breath face"
	icon_state = "breath"
	item_state = "breath"
	flags_inventory = COVERMOUTH|ALLOWINTERNALS
	flags_armor_protection = 0
	w_class = 2
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	var/hanging = 0


/obj/item/clothing/mask/breath/verb/toggle()
	set category = "Object"
	set name = "Adjust face"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.is_mob_restrained())
		if(!src.hanging)
			src.hanging = !src.hanging
			gas_transfer_coefficient = 1 //gas is now escaping to the turf and vice versa
			flags_inventory &= ~(COVERMOUTH|ALLOWINTERNALS)
			icon_state = "breathdown"
			to_chat(usr, "Your face is now hanging on your neck.")

		else
			src.hanging = !src.hanging
			gas_transfer_coefficient = 0.10
			flags_inventory |= COVERMOUTH|ALLOWINTERNALS
			icon_state = "breath"
			to_chat(usr, "You pull the face up to cover your face.")

		update_clothing_icon()


/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile face that can be connected to an air supply."
	name = "medical face"
	icon_state = "medical"
	item_state = "medical"
	permeability_coefficient = 0.01