/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	flags_armor_protection = 0
	allowed = list (/obj/item/reagent_container/spray/plantbgone,/obj/item/device/analyzer/plant_analyzer,/obj/item/seeds,/obj/item/reagent_container/glass/fertilizer,/obj/item/tool/minihoe)
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


//Surgical Apron
/obj/item/clothing/suit/surgical
	name = "surgical apron"
	desc = "A plastic covering to prevent the passage of bodily fluids during surgery."
	icon_state = "surgical"
	item_state = "surgical"
	flags_armor_protection = UPPER_TORSO
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


//Captain
/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon_state = "captunic"
	item_state = "bio_suit"
	flags_armor_protection = UPPER_TORSO|ARMS
	flags_inv_hide = HIDEJUMPSUIT
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon_state = "capjacket"
	item_state = "bio_suit"
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv_hide = HIDEJUMPSUIT


//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "This suit says to you 'hush'!"
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	flags_armor_protection = UPPER_TORSO|ARMS
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	item_state = "nun"
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv_hide = HIDESHOES|HIDEJUMPSUIT
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


//Chef
/obj/item/clothing/suit/chef
	name = "Chef's apron"
	desc = "An apron used by a high class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (/obj/item/tool/kitchen/knife,/obj/item/tool/kitchen/knife/butcher)
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


//Chef
/obj/item/clothing/suit/chef/classic
	name = "A classic chef's apron."
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	flags_armor_protection = 0


//Security
/obj/item/clothing/suit/security/navyofficer
	name = "security officer's jacket"
	desc = "This jacket is for those special occasions when a security officer actually feels safe."
	icon_state = "officerbluejacket"
	item_state = "officerbluejacket"
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|ARMS


/obj/item/clothing/suit/security/navywarden
	name = "warden's jacket"
	desc = "Perfectly suited for the warden that wants to leave an impression of style on those who visit the brig."
	icon_state = "wardenbluejacket"
	item_state = "wardenbluejacket"
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|ARMS


/obj/item/clothing/suit/security/navyhos
	name = "head of security's jacket"
	desc = "This piece of clothing was specifically designed for asserting superior authority."
	icon_state = "hosbluejacket"
	item_state = "hosbluejacket"
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|ARMS


//Detective
/obj/item/clothing/suit/storage/det_suit
	name = "coat"
	desc = "An 18th-century multi-purpose trenchcoat. Someone who wears this means serious business."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	flags_armor_protection = UPPER_TORSO|ARMS
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/tool/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


/obj/item/clothing/suit/storage/det_suit/black
	icon_state = "detective2"


//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	item_state = "det_suit"
	flags_armor_protection = UPPER_TORSO|ARMS
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/baton,/obj/item/handcuffs,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 0, bio = 0, rad = 0)


/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."
	icon_state = "forensics_red"


/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon_state = "forensics_blue"


//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	allowed = list (/obj/item/device/analyzer, /obj/item/device/flashlight, /obj/item/device/multitool, /obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner, \
	/obj/item/tool/crowbar, /obj/item/tool/screwdriver, /obj/item/tool/weldingtool, /obj/item/tool/wirecutters, /obj/item/tool/wrench, /obj/item/tank/emergency_oxygen, \
	/obj/item/clothing/mask/gas, /obj/item/tool/taperoll/engineering)
	flags_armor_protection = UPPER_TORSO
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')


//Lawyer
/obj/item/clothing/suit/storage/lawyer/bluejacket
	name = "Blue Suit Jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_blue_open"
	item_state = "suitjacket_blue_open"
	blood_overlay_type = "coat"
	flags_armor_protection = UPPER_TORSO|ARMS


/obj/item/clothing/suit/storage/lawyer/purpjacket
	name = "Purple Suit Jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"
	blood_overlay_type = "coat"
	flags_armor_protection = UPPER_TORSO|ARMS


//Mime
/obj/item/clothing/suit/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here
	flags_armor_protection = 0


//Snow suits
/obj/item/clothing/suit/storage/snow_suit
	name = "snow suit"
	desc = "A standard snow suit. It can protect the wearer from extreme cold."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "snowsuit_alpha"
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7
	permeability_coefficient = 0.8
	allowed = list (/obj/item/device/flashlight, /obj/item/tank/emergency_oxygen)


/obj/item/clothing/suit/storage/snow_suit/doctor
	name = "doctor's snow suit"
	icon_state = "snowsuit_doctor"
	permeability_coefficient = 0.6
	armor = list(melee = 25, bullet = 35, laser = 35, energy = 20, bomb = 10, bio = 0, rad = 0)


/obj/item/clothing/suit/storage/snow_suit/engineer
	name = "engineer's snow suit"
	icon_state = "snowsuit_engineer"
	armor = list(melee = 25, bullet = 35, laser = 35, energy = 20, bomb = 10, bio = 0, rad = 0)