/*

Left-overs from old Bay.

*/
/obj/item/clothing/eyes/science
	name = "science goggles"
	desc = "The goggles do nothing! Can be used as safety googles."
	icon_state = "science"


/obj/item/clothing/eyes/material
	name = "Optical Material Scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	deactive_state = "goggles_off"
	actions_types = list(/datum/action/item_action/toggle)
	origin_tech = "magnets=3;engineering=3"
	toggleable = TRUE
	vision_flags = SEE_OBJS