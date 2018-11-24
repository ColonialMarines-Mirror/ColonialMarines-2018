/*

Left-overs from old Bay.

*/
/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv_hide = HIDEFACE
	flags_armor_protection = 0


/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags_inv_hide = HIDEFACE
	flags_armor_protection = 0

	
/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	item_state = "balaclava"
	flags_inv_hide = HIDEFACE|HIDEALLHAIR
	flags_armor_protection = FACE
	w_class = 2


/obj/item/clothing/mask/balaclava/tactical
	name = "green balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm."
	icon_state = "swatclava"
	item_state = "balaclava"
	w_class = 2


/obj/item/clothing/mask/scarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blueneckscarf"
	item_state = "blueneckscarf"
	flags_inventory = COVERMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90


/obj/item/clothing/mask/scarf/red
	name = "red scarf"
	desc = "A red and white checkered neck scarf."
	icon_state = "redwhite_scarf"
	item_state = "redwhite_scarf"


/obj/item/clothing/mask/scarf/green
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "green_scarf"
	item_state = "green_scarf"


/obj/item/clothing/mask/scarf/ninja
	name = "ninja scarf"
	desc = "A stealthy, dark scarf."
	icon_state = "ninja_scarf"
	item_state = "ninja_scarf"
	siemens_coefficient = 0


/obj/item/clothing/mask/gas/syndicate
	name = "syndicate mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7


/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	anti_hug = 1
	tint = 0
	siemens_coefficient = 0.7
	flags_armor_protection = FACE|EYES


/obj/item/clothing/mask/gas/ninja
	name = "ninja mask"
	desc = "A close-fitting mask that acts both as an air filter and a post-modern fashion statement."
	icon_state = "s-ninja"
	var/vchange = 1
	var/mode = 0// 0==Scouter|1==Night Vision|2==Thermal|3==Meson
	var/voice = "Unknown"
	siemens_coefficient = 0.2


/obj/item/clothing/mask/gas/clown
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	icon_state = "clown"
	tint = 0


/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon_state = "mime"


/obj/item/clothing/mask/gas/death_commando
	name = "Death Commando Mask"
	icon_state = "death_commando_mask"
	siemens_coefficient = 0.2