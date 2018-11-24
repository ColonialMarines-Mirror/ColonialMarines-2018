/obj/item/clothing/suit/storage/coat
	name = ""
	desc = ""
	icon_state = ""
	item_state = ""
	blood_overlay_type = "coat"
	flags_armor_protection = UPPER_TORSO|ARMS
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')

/obj/item/clothing/suit/storage/coat/verb/toggle()
	set name = "Toggle Labcoat Buttons"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.is_mob_restrained())
		return FALSE

	if(!istype(src, /obj/item/clothing/suit/storage/coat/lab))
		return FALSE

	if(icon_state == item_state)
		icon_state = "[item_state]_open"
		to_chat(usr, "You unbutton the [src].")
	else
		icon_state = "[item_state]"
		to_chat(usr, "You button up the [src].")

	update_clothing_icon()


/obj/item/clothing/suit/storage/coat/lab
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	item_state = "labcoat"
	blood_overlay_type = "coat"
	flags_armor_protection = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/dnainjector,/obj/item/reagent_container/dropper,/obj/item/reagent_container/syringe,/obj/item/reagent_container/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/reagent_container/glass/bottle,/obj/item/reagent_container/glass/beaker,/obj/item/reagent_container/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	permeability_coefficient = 0.6
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


/obj/item/clothing/suit/storage/coat/lab/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. This one is red."
	icon_state = "red_labcoat_open"
	item_state = "red_labcoat"


/obj/item/clothing/suit/storage/coat/lab/blue
	name = "blue labcoat"
	desc = "A suit that protects against minor chemical spills. This one is blue."
	icon_state = "blue_labcoat_open"
	item_state = "blue_labcoat"


/obj/item/clothing/suit/storage/coat/lab/purple
	name = "purple labcoat"
	desc = "A suit that protects against minor chemical spills. This one is purple."
	icon_state = "purple_labcoat_open"
	item_state = "purple_labcoat"


/obj/item/clothing/suit/storage/coat/lab/orange
	name = "orange labcoat"
	desc = "A suit that protects against minor chemical spills. This one is orange."
	icon_state = "orange_labcoat_open"
	item_state = "orange_labcoat"


/obj/item/clothing/suit/storage/coat/lab/green
	name = "green labcoat"
	desc = "A suit that protects against minor chemical spills. This one is green."
	icon_state = "green_labcoat_open"
	item_state = "green_labcoat"


/obj/item/clothing/suit/storage/coat/lab/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo_open"
	item_state = "labcoat_cmo"


/obj/item/clothing/suit/storage/coat/lab/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen_open"
	item_state = "labgreen"


/obj/item/clothing/suit/storage/coat/lab/genetics
	name = "Geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen_open"


/obj/item/clothing/suit/storage/coat/lab/chemist
	name = "Chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem_open"


/obj/item/clothing/suit/storage/coat/lab/virologist
	name = "Virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir_open"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 0)


/obj/item/clothing/suit/storage/coat/lab/science
	name = "Scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox_open"


/obj/item/clothing/suit/storage/coat/lab/officer
	name = "Medical officer's labcoat"
	icon_state = "labcoatg"
	item_state = "labcoatg"


/obj/item/clothing/suit/storage/coat/lab/researcher
	name = "researcher's labcoat"
	desc = "A high quality labcoat, seemingly worn by scholars and researchers alike. It has a distinct leathery feel to it, and goads you towards adventure."
	icon_state = "sciencecoat_open"
	item_state = "sciencecoat_open"


/obj/item/clothing/suit/storage/coat/fr_jacket
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon_state = "fr_jacket_open"
	item_state = "fr_jacket"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/stack/medical, /obj/item/reagent_container/dropper, /obj/item/reagent_container/hypospray, /obj/item/reagent_container/syringe, \
	/obj/item/device/healthanalyzer, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/tank/emergency_oxygen)


/obj/item/clothing/suit/storage/coat/internalaffairs
	name = "Internal Affairs Jacket"
	desc = "A smooth black jacket."
	icon_state = "ia_jacket_open"
	item_state = "ia_jacket"