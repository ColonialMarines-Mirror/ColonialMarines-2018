/*

Currently actively used in-game.

Categories:
	Marine
*/
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	flags_armor_protection = HANDS
	flags_equip_slot = SLOT_HANDS
	attack_verb = list("challenged")
	var/wired = 0
	var/clipped = 0

/obj/item/clothing/gloves/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return FALSE

/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/wirecutters) || istype(W, /obj/item/tool/surgery/scalpel))
		if(clipped)
			to_chat(user, "<span class='notice'>The [src] have already been clipped!</span>")
			update_icon()
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		user.visible_message("\red [user] cuts the fingertips off of the [src].","\red You cut the fingertips off of the [src].")

		clipped = 1
		name = "mangled [name]"
		desc = "[desc]<br>They have had the fingertips cut off of them."


/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "latex"


//Marine
/obj/item/clothing/gloves/marine
	name = "marine combat gloves"
	desc = "Standard issue marine tactical gloves. It reads: 'knit by Marine Widows Association'."
	icon_state = "gray"
	item_state = "gray"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05
	flags_cold_protection = HANDS
	flags_heat_protection = HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature
	flags_armor_protection = HANDS
	armor = list(melee = 60, bullet = 40, laser = 10,energy = 10, bomb = 10, bio = 10, rad = 0)


/obj/item/clothing/gloves/marine/alpha
	name = "alpha squad gloves"
	icon_state = "red"
	item_state = "red"


/obj/item/clothing/gloves/marine/alpha/insulated
	name = "insulated alpha squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0


/obj/item/clothing/gloves/marine/bravo
	name = "bravo squad gloves"
	icon_state = "yellow"
	item_state = "yellow"


/obj/item/clothing/gloves/marine/bravo/insulated
	name = "insulated bravo squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0


/obj/item/clothing/gloves/marine/charlie
	name = "charlie squad gloves"
	icon_state = "purple"
	item_state = "purple"


/obj/item/clothing/gloves/marine/charlie/insulated
	name = "insulated charlie squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0


/obj/item/clothing/gloves/marine/delta
	name = "delta squad gloves"
	icon_state = "blue"
	item_state = "blue"


/obj/item/clothing/gloves/marine/delta/insulated
	name = "insulated delta squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0


/obj/item/clothing/gloves/marine/officer
	name = "tech officer gloves"
	desc = "Sterile AND insulated! Why is not everyone issued with these?"
	icon_state = "lightbrown"
	siemens_coefficient = 0
	permeability_coefficient = 0.01


/obj/item/clothing/gloves/marine/commander
	name = "commander's gloves"
	desc = "You may like these gloves, but THEY think you are unworthy of them."
	icon_state = "captain"
	siemens_coefficient = 0
	permeability_coefficient = 0.01


/obj/item/clothing/gloves/marine/B18
	name = "\improper B18 defensive gauntlets"
	desc = "A pair of heavily armored gloves."
	icon_state = "black"
	armor = list(melee = 80, bullet = 95, laser = 75, energy = 60, bomb = 45, bio = 15, rad = 15)
	unacidable = 1


/obj/item/clothing/gloves/marine/PMC
	name = "\improper PMC gloves"
	desc = "Armored gloves used in special operations. They are also insulated against electrical shock."
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 60, laser = 35, energy = 20, bomb = 10, bio = 10, rad = 0)


/obj/item/clothing/gloves/marine/PMC/commando
	name = "\improper PMC commando gloves"
	desc = "A pair of heavily armored, insulated, acid-resistant gloves."
	icon_state = "brown"
	item_state = "brown"
	armor = list(melee = 90, bullet = 120, laser = 100, energy = 90, bomb = 50, bio = 30, rad = 30)
	unacidable = 1