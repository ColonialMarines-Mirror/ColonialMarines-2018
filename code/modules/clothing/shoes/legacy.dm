/*

Left-overs from old Bay.

*/
/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	desc = "A pair of black shoes."


/obj/item/clothing/shoes/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"


/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blue"


/obj/item/clothing/shoes/green
	name = "green shoes"
	icon_state = "green"


/obj/item/clothing/shoes/yellow
	name = "yellow shoes"
	icon_state = "yellow"


/obj/item/clothing/shoes/purple
	name = "purple shoes"
	icon_state = "purple"


/obj/item/clothing/shoes/brown
	name = "brown shoes"
	icon_state = "brown"


/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"


/obj/item/clothing/shoes/white
	name = "white shoes"
	icon_state = "white"


/obj/item/clothing/shoes/leather
	name = "leather shoes"
	desc = "A sturdy pair of leather shoes."
	icon_state = "leather"


/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very gay shoes."
	icon_state = "rainbow"


/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots"
	name = "galoshes"
	icon_state = "galoshes"
	flags_inventory = NOSLIPPING
	slowdown = SHOES_SLOWDOWN+1


/obj/item/clothing/shoes/clown
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1


/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"


/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"


/obj/item/clothing/shoes/syndicate
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	flags_inventory = NOSLIPPING
	origin_tech = "syndicate=3"


/obj/item/clothing/shoes/ninja
	name = "ninja shoes"
	desc = "A pair of running shoes. Excellent for running and even better for smashing skulls."
	icon_state = "s-ninja"


/obj/item/clothing/shoes/sandals
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"


/obj/item/clothing/shoes/snow
	name = "snow boots"
	desc = "When you feet are as cold as your heart."
	icon_state = "swat"
	flags_cold_protection = FEET
	flags_heat_protection = FEET
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature


/obj/item/clothing/shoes/swat
	name = "\improper SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inventory = NOSLIPPING


/obj/item/clothing/shoes/combat
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inventory = NOSLIPPING
	flags_cold_protection = FEET
	flags_heat_protection = FEET
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature


/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	var/magpulse = 0
	actions_types = list(/datum/action/item_action/toggle)


/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		flags_inventory &= ~NOSLIPPING
		slowdown = SHOES_SLOWDOWN
		magpulse = 0
		icon_state = "magboots0"
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		flags_inventory |= NOSLIPPING
		slowdown = 2
		magpulse = 1
		icon_state = "magboots1"
		to_chat(user, "You enable the mag-pulse traction system.")

	user.update_inv_shoes()	//so our mob-overlays update
	update_action_button_icons()

/obj/item/clothing/shoes/magboots/examine(mob/user)
	. = ..()
	var/state = "disabled"
	if(flags_inventory & NOSLIPPING)
		state = "enabled"

	to_chat(user, "Its mag-pulse traction system appears to be [state].")