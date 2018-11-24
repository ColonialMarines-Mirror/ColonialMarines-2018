/*

Cosmetic admin-only items.

*/
/obj/item/clothing/eyes/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"


/obj/item/clothing/eyes/3d
	name = "3D eyes"
	desc = "A long time ago, people used these eyes to makes images from screens threedimensional."
	icon_state = "3d"


/obj/item/clothing/eyes/green
	name = "Green Glasses"
	desc = "Forest green eyes, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "green"


/obj/item/clothing/eyes/hud/security/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensen"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING
	toggleable = FALSE
	actions_types = list()


/obj/item/clothing/eyes/thermal/jensen
	name = "Optical Thermal Implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	toggleable = FALSE


/obj/item/clothing/eyes/thermal/syndi
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	actions_types = list(/datum/action/item_action/toggle)
	origin_tech = "magnets=3;syndicate=4"


/obj/item/clothing/eyes/thermal/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermonocle"
	flags_atom = null //Doesn't protect the eyes.
	toggleable = FALSE
	flags_armor_protection = 0


/obj/item/clothing/eyes/thermal/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	toggleable = FALSE
	flags_armor_protection = 0


/obj/item/clothing/eyes/hud/security/swat
	name = "Swat SecHUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swat"
	toggleable = FALSE