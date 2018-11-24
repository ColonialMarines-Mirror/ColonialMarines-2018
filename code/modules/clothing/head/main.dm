/*

Currently actively used in-game.

Categories:
	Helmet
	Marine

	Welding
	Hardhat
*/
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/head.dmi'
	w_class = 2.0
	flags_equip_slot = SLOT_HEAD
	siemens_coefficient = 0.9
	var/anti_hug = 0

/obj/item/clothing/head/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()


/obj/item/clothing/head/surgical
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon_state = "surgicalgreen"
	flags_inv_hide = HIDETOPHAIR


/obj/item/clothing/head/cmo
	name = "\improper Chief Medical hat"
	desc = "A somewhat fancy hat, typically worn by those who wish to command medical respect."
	icon_state = "cmohat"


/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon_state = "cardborg_h"
	item_state = "cardborg_h"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = HEAD|FACE|EYES


/obj/item/clothing/head/boonie
	name = "Boonie Hat"
	desc = "The pinnacle of tacticool technology."
	icon_state = "booniehat"
	item_state = "booniehat"


/obj/item/clothing/head/beanie
	name = "\improper USCM beanie"
	desc = "A standard military beanie, often worn by non-combat military personnel and support crews, though the occasional one finds its way to the front line. Popular due to being comfortable and snug."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "beanie_cargo"
	flags_inv_hide = HIDETOPHAIR


/obj/item/clothing/head/bandana
	name = "\improper USCM bandana"
	desc = "Typically worn by heavy-weapon operators, mercenaries and scouts, the bandana serves as a lightweight and comfortable hat. Comes in two stylish colors."
	icon_state = "bandana"
	flags_inv_hide = HIDETOPHAIR

/obj/item/clothing/head/bandana/New()
	select_gamemode_skin(type, list(MAP_ICE_COLONY = "s_band") )
	return ..()


/obj/item/clothing/head/bandana/tan
	icon_state = "bandana_tan"


/obj/item/clothing/head/beret
	name = "\improper USCM beret"
	desc = "A hat typically worn by the field-officers of the USCM. Occasionally they find their way down the ranks into the hands of squad-leaders and decorated grunts."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "beret"

/obj/item/clothing/head/beret/New()
	select_gamemode_skin(/obj/item/clothing/head/cmberet, list(MAP_ICE_COLONY = "s_beret"))
	return ..()


/obj/item/clothing/head/beret/tan
	icon_state = "berettan"

/obj/item/clothing/head/beret/tan/New()
	select_gamemode_skin(/obj/item/clothing/head/cmberet/tan)
	return ..()


/obj/item/clothing/head/beret/red
	icon_state = "beretred"


/obj/item/clothing/head/beret/black
	name = "\improper USCM chief MP beret"
	desc = "A beret with the lieutenant insignia emblazoned on it. It shines with the glow of corrupt authority and a smudge of doughnut."
	icon_state = "beretwo"


/obj/item/clothing/head/headband
	name = "\improper USCM headband"
	desc = "A rag typically worn by the less-orthodox weapons operators in the USCM. While it offers no protection, it is certainly comfortable to wear compared to the standard helmet. Comes in two stylish colors."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "headband"

/obj/item/clothing/head/headband/New()
	select_gamemode_skin(type, list(MAP_ICE_COLONY = "ushanka") )
	. = ..()
	switch(icon_state)
		if("ushanka") //Weird case, since the item basically transforms into another item.
			name = "\improper USCM ushanka"
			desc = "Worn during cold operations by idiots."
			flags_cold_protection = HEAD
			min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
			flags_inventory = BLOCKSHARPOBJ
			flags_inv_hide = HIDEEARS|HIDETOPHAIR


/obj/item/clothing/head/headband/red
	icon_state = "headband_red"


/obj/item/clothing/head/headband/rambo
	name = "headband"
	desc = "It flutters in the face of the wind, defiant and unrestrained, like the man who wears it."
	icon_state = "headband_rambo"


/obj/item/clothing/head/headset
	name = "\improper USCM headset"
	desc = "A headset typically found in use by radio-operators and officers. This one appears to be malfunctioning."
	icon_state = "headset"


/obj/item/clothing/head/cap
	name = "\improper USCM cap"
	desc = "A casual cap occasionally worn by Squad-leaders and Combat-Engineers. While it has limited combat functionality, some prefer to wear it instead of the standard issue helmet."
	icon_state = "cap"
	icon = 'icons/obj/clothing/cm_hats.dmi'

/obj/item/clothing/head/cap/New()
	select_gamemode_skin(/obj/item/clothing/head/cap)
	return ..()

/obj/item/clothing/head/cap/verb/fliphat()
	set name = "Flip hat"
	set category = "Object"
	set src in usr

	if(!isliving(usr)) 
		return
	if(usr.is_mob_incapacitated()) 
		return

	if(icon_state == item_state)
		item_state = "[icon_state]_back"
		to_chat(usr, "You spin the hat backwards! You look like a tool.")
	else
		item_state = "[icon_state]"
		to_chat(usr, "You spin the hat back forwards. That's better.")

	update_clothing_icon()


/obj/item/clothing/head/cap/ro
	name = "\improper USCM officer cap"
	desc = "A hat usually worn by officers in the USCM. While it has limited combat functionality, some prefer to wear it instead of the standard issue helmet."
	icon_state = "rocap"

/obj/item/clothing/head/cap/ro/New()
	select_gamemode_skin(/obj/item/clothing/head/cmcap/ro)
	return ..()


/obj/item/clothing/head/cap/req
	name = "\improper USCM requisition cap"
	desc = "It's a fancy hat for a not-so-fancy military supply clerk."
	icon_state = "cargocap"


/obj/item/clothing/head/beret/marine
	name = "marine officer beret"
	desc = "A beret with the ensign insignia emblazoned on it. It radiates respect and authority."
	icon_state = "beret_badge"
	armor = list(melee = 40, bullet = 40, laser = 40,energy = 20, bomb = 10, bio = 0, rad = 0)
	flags_inventory = BLOCKSHARPOBJ


/obj/item/clothing/head/beret/marine/commander
	name = "marine commander beret"
	desc = "A beret with the commander insignia emblazoned on it. Wearer may suffer the heavy weight of responsibility upon his head and shoulders."
	icon_state = "centcomcaptain"


/obj/item/clothing/head/beret/marine/chiefofficer
	name = "chief officer beret"
	desc = "A beret with the lieutenant-commander insignia emblazoned on it. It emits a dark aura and may corrupt the soul."
	icon_state = "hosberet"


/obj/item/clothing/head/beret/marine/techofficer
	name = "technical officer beret"
	desc = "A beret with the lieutenant insignia emblazoned on it. There's something inexplicably efficient about it..."
	icon_state = "e_beret_badge"


/obj/item/clothing/head/beret/marine/logisticsofficer
	name = "logistics officer beret"
	desc = "A beret with the lieutenant insignia emblazoned on it. It inspires a feeling of respect."
	icon_state = "hosberet"


/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushanka"
	armor = list(melee = 35, bullet = 35, laser = 20, energy = 10, bomb = 10, bio = 0, rad = 0)
	flags_cold_protection = HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	anti_hug = 1

/obj/item/clothing/head/ushanka/attack_self(mob/user as mob)
	if(icon_state == item_state)
		item_state = "[icon_state]_up"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		item_state = "[icon_state]"
		to_chat(user, "You lower the ear flaps on the ushanka.")



//Helmet
/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state = "helmet"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_atom = CONDUCT
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	flags_cold_protection = HEAD
	flags_heat_protection = HEAD
	flags_armor_protection = HEAD
	min_cold_protection_temperature = HELMET_min_cold_protection_temperature
	max_heat_protection_temperature = HELMET_max_heat_protection_temperature
	siemens_coefficient = 0.7
	w_class = 4


/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks. It covers your ears."
	icon_state = "riot"
	armor = list(melee = 82, bullet = 15, laser = 5, energy = 5, bomb = 5, bio = 2, rad = 0)
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDETOPHAIR



//Marine
/obj/item/clothing/head/helmet/marine
	name = "\improper M10 pattern marine helmet"
	desc = "A standard M10 Pattern Helmet. It reads on the label, 'The difference between an open-casket and closed-casket funeral. Wear on head for best results.'. Contains a small built-in camera."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "helmet"
	armor = list(melee = 65, bullet = 35, laser = 30, energy = 20, bomb = 25, bio = 0, rad = 0)
	health = 5
	var/obj/machinery/camera/camera
	var/helmet_overlays[]
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS
	var/flags_marine_helmet = HELMET_SQUAD_OVERLAY|HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY|HELMET_STORE_GARB
	var/obj/item/storage/internal/pockets
	var/list/allowed_helmet_items = list(
						/obj/item/tool/lighter/random = "helmet_lighter_",
						/obj/item/tool/lighter/zippo = "helmet_lighter_zippo",
						/obj/item/storage/box/matches = "helmet_matches",
						/obj/item/storage/fancy/cigarettes = "helmet_cig_kpack",
						/obj/item/storage/fancy/cigarettes/kpack = "helmet_cig_kpack",
						/obj/item/storage/fancy/cigarettes/lucky_strikes = "helmet_cig_ls",
						/obj/item/storage/fancy/cigarettes/dromedaryco = "helmet_cig_kpack",
						/obj/item/storage/fancy/cigarettes/lady_finger = "helmet_cig_lf",
						/obj/item/toy/deck = "helmet_card_card",
						/obj/item/toy/handcard = "helmet_card_card",
						/obj/item/reagent_container/food/drinks/flask = "helmet_flask",
						/obj/item/reagent_container/food/drinks/flask/marine = "helmet_flask",
						/obj/item/reagent_container/food/snacks/eat_bar = "helmet_snack_eat",
						/obj/item/reagent_container/food/snacks/packaged_burrito = "helmet_snack_burrito",
						/obj/item/clothing/glasses/mgoggles = "goggles",
						/obj/item/clothing/glasses/mgoggles/prescription = "goggles")

/obj/item/clothing/head/helmet/marine/New(loc,expected_type 		= /obj/item/clothing/head/helmet/marine,
	new_name[] 			= list(MAP_ICE_COLONY =  "\improper M10 pattern marine snow helmet"),
	new_protection[]	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	select_gamemode_skin(expected_type,null,new_name,new_protection)
	. = ..()
	helmet_overlays = list("damage","band","item") //To make things simple.
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 2
	pockets.max_w_class = 1 //can hold tiny items only, EXCEPT for glasses & metal flask.
	pockets.bypass_w_limit = list("/obj/item/clothing/glasses", "/obj/item/reagent_container/food/drinks/flask")
	pockets.max_storage_space = 3
	camera = new /obj/machinery/camera(src)
	camera.network = list("LEADER")

/obj/item/clothing/head/helmet/marine/attack_hand(mob/user)
	if(pockets.handle_attack_hand(user))
		return ..()

/obj/item/clothing/head/helmet/marine/MouseDrop(over_object, src_location, over_location)
	if(pockets.handle_mousedrop(usr, over_object))
		return ..()

/obj/item/clothing/head/helmet/marine/attackby(obj/item/W, mob/user)
	. = ..()
	return pockets.attackby(W, user)

/obj/item/clothing/head/helmet/marine/on_pocket_insertion()
	update_icon()

/obj/item/clothing/head/helmet/marine/on_pocket_removal()
	update_icon()

/obj/item/clothing/head/helmet/marine/update_icon()
	if(pockets.contents.len && (flags_marine_helmet & HELMET_GARB_OVERLAY))
		if(!helmet_overlays["band"])
			var/image/reusable/I = rnew(/image/reusable, list('icons/obj/clothing/cm_hats.dmi', src, "helmet_band"))
			helmet_overlays["band"] = I

		if(!helmet_overlays["item"])
			var/obj/O = pockets.contents[1]
			if(O.type in allowed_helmet_items)
				var/image/reusable/I = rnew(/image/reusable, list('icons/obj/clothing/cm_hats.dmi', src, "[allowed_helmet_items[O.type]][O.type == /obj/item/tool/lighter/random ? O:clr : ""]"))
				helmet_overlays["item"] = I
	else
		if(helmet_overlays["item"])
			var/image/reusable/RI = helmet_overlays["item"]
			helmet_overlays["item"] = null
			cdel(RI)
		if(helmet_overlays["band"])
			var/image/reusable/J = helmet_overlays["band"]
			helmet_overlays["band"] = null
			cdel(J)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()

/obj/item/clothing/head/helmet/marine/equipped(var/mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
	return ..()

/obj/item/clothing/head/helmet/marine/dropped(var/mob/living/carbon/human/mob)
	if(camera)
		camera.c_tag = "Unknown"
	return ..()

/obj/item/clothing/head/helmet/marine/proc/add_hugger_damage() //This is called in XenoFacehuggers.dm to first add the overlay and set the var.
	if(flags_marine_helmet & HELMET_DAMAGE_OVERLAY && !(flags_marine_helmet & HELMET_IS_DAMAGED))
		helmet_overlays["damage"] = image('icons/obj/clothing/cm_hats.dmi',icon_state = "hugger_damage")
		flags_marine_helmet |= HELMET_IS_DAMAGED
		update_icon()
		desc += "\n<b>This helmet seems to be scratched up and damaged, particularly around the face area...</b>"


/obj/item/clothing/head/helmet/marine/tech
	name = "\improper M10 technician helmet"

/obj/item/clothing/head/helmet/marine/tech/New(loc,expected_type 		= type,
	new_name[] 			= list(MAP_ICE_COLONY = "\improper M10 technician snow helmet"),
	new_protection[]	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	return ..(loc, expected_type, new_name, new_protection)


/obj/item/clothing/head/helmet/marine/medic
	name = "\improper M10 medic helmet"

/obj/item/clothing/head/helmet/marine/medic/New(loc,expected_type 		= type,
	new_name[] 			= list(MAP_ICE_COLONY = "\improper M10 medic snow helmet"),
	new_protection[]	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	return ..(loc, expected_type, new_name, new_protection)


/obj/item/clothing/head/helmet/marine/leader
	name = "\improper M11 pattern leader helmet"
	desc = "A slightly fancier helmet for marine leaders. This one contains a small built-in camera and has cushioning to project your fragile brain."
	armor = list(melee = 75, bullet = 45, laser = 40, energy = 40, bomb = 35, bio = 10, rad = 10)

/obj/item/clothing/head/helmet/marine/leader/New(loc,expected_type 		= type,
	new_name[] 			= list(MAP_ICE_COLONY = "\improper M11 pattern leader snow helmet"),
	new_protection[]	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	return ..(loc, expected_type, new_name, new_protection)


/obj/item/clothing/head/helmet/marine/b18
	name = "\improper B18 helmet"
	desc = "The B18 Helmet that goes along with the B18 Defensive Armor. It's heavy, reinforced, and protects more of the face."
	armor = list(melee = 95, bullet = 105, laser = 75, energy = 65, bomb = 70, bio = 15, rad = 15)
	unacidable = 1
	anti_hug = 6

/obj/item/clothing/head/helmet/marine/specialist/New(loc,expected_type 		= type,
	new_name[] 			= list(MAP_ICE_COLONY = "\improper B18 snow helmet"),
	new_protection[]	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	return ..(loc,expected_type,new_name,new_protection)


/obj/item/clothing/head/helmet/marine/scout
	name = "\improper M3-S helmet"
	icon_state = "scout_helmet"
	desc = "A custom helmet designed for USCM Scouts."
	armor = list(melee = 75, bullet = 45, laser = 40, energy = 40, bomb = 35, bio = 10, rad = 10)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature

/obj/item/clothing/head/helmet/marine/scout/New()
	select_gamemode_skin(type)
	return ..()


/obj/item/clothing/head/helmet/marine/pyro
	name = "\improper M35 helmet"
	icon_state = "pyro_helmet"
	desc = "A helmet designed for USCM Pyrotechnicians. Contains heavy insulation, covered in nomex weave."
	armor = list(melee = 85, bullet = 75, laser = 60, energy = 50, bomb = 50, bio = 10, rad = 10)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	max_heat_protection_temperature = FIRESUIT_max_heat_protection_temperature

/obj/item/clothing/head/helmet/marine/pyro/New()
	select_gamemode_skin(type)
	return ..()


/obj/item/clothing/head/helmet/marine/pilot
	name = "\improper M30 tactical helmet"
	desc = "The M30 tactical helmet has an left eyepiece filter used to filter tactical data. It is required to fly the Alamo and Normandy dropships manually and in safety."
	icon_state = "helmetp"
	armor = list(melee = 65, bullet = 50, laser = 35, energy = 45, bomb = 30, bio = 15, rad = 15)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	flags_marine_helmet = NOFLAGS

/obj/item/clothing/head/helmet/marine/pilot/New()
	select_gamemode_skin(/obj/item/clothing/head/helmet/marine/pilot)
	return ..()


/obj/item/clothing/head/helmet/marine/tanker
	name = "\improper M50 tanker helmet"
	desc = "The lightweight M50 tanker helmet is designed for use by armored crewmen in the USCM. It offers low weight protection, and allows agile movement inside the confines of an armored vehicle."
	icon_state = "tanker_helmet"
	armor = list(melee = 40, bullet = 40, laser = 35, energy = 45, bomb = 30, bio = 15, rad = 15)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	flags_marine_helmet = NOFLAGS

/obj/item/clothing/head/helmet/marine/tanker/New()
	select_gamemode_skin(/obj/item/clothing/head/helmet/marine/tanker)
	return ..()


/obj/item/clothing/head/helmet/marine/pmc
	name = "\improper PMC tactical cap"
	desc = "A protective cap made from flexible kevlar. Standard issue for most security forms in the place of a helmet."
	icon_state = "pmc_hat"
	armor = list(melee = 38, bullet = 38, laser = 32, energy = 22, bomb = 12, bio = 5, rad = 5)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NOFLAGS
	flags_marine_helmet = NOFLAGS


/obj/item/clothing/head/helmet/marine/pmc/leader
	name = "\improper PMC beret"
	desc = "The pinacle of fashion for any aspiring mercenary leader. Designed to protect the head from light impacts."
	icon_state = "officer_hat"


/obj/item/clothing/head/helmet/marine/pmc/sniper
	name = "\improper PMC sniper helmet"
	desc = "A helmet worn by PMC Marksmen"
	icon_state = "pmc_sniper_hat"
	flags_armor_protection = HEAD|FACE|EYES
	armor = list(melee = 55, bullet = 65, laser = 45, energy = 55, bomb = 60, bio = 10, rad = 10)
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY


/obj/item/clothing/head/helmet/marine/pmc/gunner
	name = "\improper PMC gunner helmet"
	desc = "A modification of the standard Armat Systems M3 armor."
	icon_state = "heavy_helmet"
	flags_armor_protection = HEAD|FACE|EYES
	armor = list(melee = 80, bullet = 80, laser = 50, energy = 60, bomb = 70, bio = 10, rad = 10)
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY


/obj/item/clothing/head/helmet/marine/pmc/commando
	name = "\improper PMC commando helmet"
	desc = "A fully enclosed, armored helmet made for Weyland Yutani elite commandos."
	icon_state = "commando_helmet"
	flags_armor_protection = HEAD|FACE|EYES
	armor = list(melee = 90, bullet = 120, laser = 90, energy = 90, bomb = 90, bio = 100, rad = 100)
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY
	unacidable = 1


/obj/item/clothing/head/helmet/marine/dutch
	name = "\improper Dutch's Dozen helmet"
	desc = "A protective helmet worn by some seriously experienced mercs."
	icon_state = "dutch_helmet"
	armor = list(melee = 70, bullet = 70, laser = 0,energy = 20, bomb = 0, bio = 0, rad = 0)
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY|HELMET_STORE_GARB


/obj/item/clothing/head/helmet/marine/dutch/cap
	name = "\improper Dutch's Dozen cap"
	desc = "A protective cap worn by some seriously experienced mercs."
	icon_state = "dutch_cap"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NOFLAGS
	flags_marine_helmet = NOFLAGS


/obj/item/clothing/head/helmet/marine/dutch/band
	name = "\improper Dutch's Dozen band"
	desc = "A protective band worn by some seriously experienced mercs."
	icon_state = "dutch_band"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NOFLAGS
	flags_marine_helmet = NOFLAGS


/obj/item/clothing/head/helmet/marine/dutch/bear
	name = "\improper Iron Bear helmet"
	desc = "Is good for winter, because it has hole to put vodka through."
	icon_state = "dutch_helmet"
	armor = list(melee = 90, bullet = 65, laser = 40, energy = 35, bomb = 35, bio = 5, rad = 5)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY|HELMET_STORE_GARB


/obj/item/clothing/head/helmet/upp
	name = "\improper UM4 helmet"
	desc = "A skirted helmet designed for use with the UM/UH system."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "upp_helmet1"
	armor = list(melee = 70, bullet = 55, laser = 40, energy = 35, bomb = 35, bio = 5, rad = 5)
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature


/obj/item/clothing/head/helmet/upp/heavy
	name = "\improper UH7 helmet"
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "upp_helmet_heavy"
	armor = list(melee = 90, bullet = 85, laser = 60, energy = 65, bomb = 85, bio = 5, rad = 5)
	unacidable = 1
	anti_hug = 3


/obj/item/clothing/head/helmet/rag
	name = "specialist head-rag"
	desc = "A hat worn by heavy-weapons operators to block sweat."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "spec"
	armor = list(melee = 35, bullet = 35, laser = 35, energy = 15, bomb = 10, bio = 0, rad = 0)
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = 0

/obj/item/clothing/head/helmet/rag/New()
	select_gamemode_skin(type)
	return ..()


/obj/item/clothing/head/helmet/durag
	name = "durag"
	desc = "Good for keeping sweat out of your eyes"
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "durag"
	armor = list(melee = 35, bullet = 35, laser = 35, energy = 15, bomb = 10, bio = 0, rad = 0)
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR


/obj/item/clothing/head/helmet/durag/jungle
	name = "\improper M8 marksman cowl"
	desc = "A cowl worn to conceal the face of a marksman in the jungle."
	icon_state = "duragm"

/obj/item/clothing/head/helmet/durag/jungle/New(loc,expected_type 	= type,
	new_name[] 		= list(MAP_ICE_COLONY = "\improper M6 marksman hood"),
	new_protection[] 	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	select_gamemode_skin(expected_type,,new_name,new_protection)
	. = ..()
	switch(icon_state)
		if("s_duragm")
			desc = "A hood meant to protect the wearer from both the cold and the guise of the enemy in the tundra."
			flags_inventory = BLOCKSHARPOBJ
			flags_inv_hide = HIDEEARS|HIDEALLHAIR




/obj/item/clothing/head/helmet/marine/mercenary
	name = "\improper K12 ceramic helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_heavy_helmet"
	flags_armor_protection = HEAD|FACE|EYES
	armor = list(melee = 80, bullet = 80, laser = 50, energy = 60, bomb = 70, bio = 10, rad = 10)
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY


/obj/item/clothing/head/helmet/marine/veteran/mercenary/miner
	name = "\improper Y8 miner helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_miner_helmet"
	flags_armor_protection = HEAD|FACE|EYES
	armor = list(melee = 55, bullet = 55, laser = 45, energy = 55, bomb = 55, bio = 10, rad = 10)


/obj/item/clothing/head/helmet/marine/veteran/mercenary/engineer
	name = "\improper Z7 engineer helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_engineer_helmet"
	flags_armor_protection = HEAD|FACE|EYES
	armor = list(melee = 55, bullet = 60, laser = 45, energy = 55, bomb = 60, bio = 10, rad = 10)


/obj/item/clothing/head/bearpelt
	name = "bear pelt hat"
	desc = "Fuzzy."
	icon_state = "bearpelt"
	siemens_coefficient = 2.0
	anti_hug = 4
	flags_armor_protection = HEAD|UPPER_TORSO|ARMS
	armor = list(melee = 90, bullet = 70, laser = 45, energy = 55, bomb = 45, bio = 10, rad = 10)
	flags_cold_protection = HEAD|UPPER_TORSO|ARMS
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR


/obj/item/clothing/head/upp
	name = "\improper armored UPP cap"
	desc = "Standard UPP head gear for covert operations and low-ranking officers alike. Sells for high prices on the black market due to their rarity."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	icon_state = "upp_cap"
	sprite_sheet_id = 1
	siemens_coefficient = 2.0
	//anti_hug = 2
	flags_armor_protection = HEAD
	armor = list(melee = 50, bullet = 50, laser = 45, energy = 55, bomb = 45, bio = 10, rad = 10)
	flags_cold_protection = HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS


/obj/item/clothing/head/upp/beret
	name = "\improper armored UPP beret"
	icon_state = "upp_beret"


/obj/item/clothing/head/frelancer
	name = "\improper armored Freelancer cap"
	desc = "A sturdy freelancer's cap. More protective than it seems."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "freelancer_cap"
	siemens_coefficient = 2.0
	flags_armor_protection = HEAD
	armor = list(melee = 50, bullet = 50, laser = 45, energy = 55, bomb = 45, bio = 10, rad = 10)
	flags_cold_protection = HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS


/obj/item/clothing/head/frelancer/beret
	name = "\improper armored Freelancer beret"
	icon_state = "freelancer_beret"


/obj/item/clothing/head/militia
	name = "\improper armored militia cowl"
	desc = "A large hood in service with some militias, meant for obscurity on the frontier. Offers some head protection due to the study fibers utilized in production."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "rebel_hood"
	siemens_coefficient = 2.0
	flags_armor_protection = HEAD|UPPER_TORSO
	armor = list(melee = 30, bullet = 30, laser = 45, energy = 35, bomb = 45, bio = 20, rad = 30)
	flags_cold_protection = HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR


/obj/item/clothing/head/admiral
	name = "\improper armored Admiral cap"
	desc = "A sturdy admiral's cap. More protective than it seems. Please don't ditch this for a helmet like a punk."
	icon_state = "admiral_helmet"
	siemens_coefficient = 2.0
	flags_armor_protection = HEAD
	armor = list(melee = 60, bullet = 60, laser = 45, energy = 55, bomb = 55, bio = 10, rad = 10)
	flags_cold_protection = HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS



//Welding
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	item_state = "welding"
	matter = list("metal" = 3000, "glass" = 1000)
	var/up = 0
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_atom = CONDUCT
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE
	flags_armor_protection = HEAD|FACE|EYES
	actions_types = list(/datum/action/item_action/toggle)
	siemens_coefficient = 0.9
	w_class = 3
	anti_hug = 2
	eye_protection = 2
	tint = 2
	var/hug_memory = 0 //Variable to hold the "memory" of how many anti-hugs remain.  Because people were abusing the fuck out of it.

/obj/item/clothing/head/welding/attack_self()
	toggle()

/obj/item/clothing/head/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding mask"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.is_mob_restrained())
		if(up)
			flags_inventory |= COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
			flags_inv_hide |= HIDEEARS|HIDEEYES|HIDEFACE
			icon_state = initial(icon_state)
			eye_protection = initial(eye_protection)
			tint = initial(tint)
			to_chat(usr, "You flip the [src] down to protect your eyes.")
			anti_hug = hug_memory //This will reset the hugged var, but ehh. More efficient than making a new var for it.
		else
			flags_inventory &= ~(COVEREYES|COVERMOUTH|BLOCKSHARPOBJ)
			flags_inv_hide &= ~(HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = "[initial(icon_state)]up"
			eye_protection = 0
			tint = 0
			to_chat(usr, "You push the [src] up out of your face.")
			hug_memory = anti_hug
			anti_hug = 0
		up = !up

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(H.head == src)
				H.update_tint()

		update_clothing_icon()
		update_action_button_icons()



//Hardhat
/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat"
	item_state = "hardhat"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	actions_types = list(/datum/action/item_action/toggle)
	siemens_coefficient = 0.9
	flags_inventory = BLOCKSHARPOBJ
	var/brightness_on = 4
	var/on = FALSE

/obj/item/clothing/head/hardhat/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in [user.loc]")
		return

	if(icon_state == item_state)
		item_state = "[item_state]_on"
		on = TRUE
		user.SetLuminosity(brightness_on)
	else
		item_state = "[item_state]"
		on = FALSE
		user.SetLuminosity(-brightness_on)

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()
	update_action_button_icons()

/obj/item/clothing/head/hardhat/pickup(mob/user)
	if(on)
		user.SetLuminosity(brightness_on)
		SetLuminosity(0)
	return ..()

/obj/item/clothing/head/hardhat/dropped(mob/user)
	if(on)
		user.SetLuminosity(-brightness_on)
		SetLuminosity(brightness_on)
	return ..()

/obj/item/clothing/head/hardhat/Dispose()
	if(ismob(src.loc))
		src.loc.SetLuminosity(-brightness_on)
	else
		SetLuminosity(0)
	return ..()


/obj/item/clothing/head/hardhat/firefighter
	name = "firefighter helmet"
	icon_state = "hardhat_red"
	flags_inventory = NOPRESSUREDMAGE|BLOCKSHARPOBJ
	flags_heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_max_heat_protection_temperature


/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat_orange"


/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat_white"
	flags_inventory = NOPRESSUREDMAGE|BLOCKSHARPOBJ
	flags_heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_max_heat_protection_temperature


/obj/item/clothing/head/hardhat/blue
	icon_state = "hardhat_dblue"