/datum/job/upp
	special_role = "UPP"
	comm_title = "UPP"
	faction = "Union of Progressive People"
	supervisors = "the team leader"
	idtype = /obj/item/card/id
	skills_type = /datum/skills/pfc
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT


//UPP standard.
/datum/job/upp/standard
	title = "UPP Standard"
	paygrade = "UPP1"
	total_positions = -1
	spawn_positions = -1
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/distress/bears,
				WEAR_BODY = /obj/item/clothing/under/marine/veteran/UPP,
				WEAR_FEET = /obj/item/clothing/shoes/marine,
				WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/PMC,
				WEAR_JACKET = /obj/item/clothing/suit/storage/faction/UPP,
				WEAR_WAIST = /obj/item/storage/belt/marine/upp/full,
				WEAR_HEAD = /obj/item/clothing/head/helmet/UPP,
				WEAR_BACK = /obj/item/storage/backpack/lightpack,
				WEAR_L_STORE = /obj/item/storage/pouch/firstaid/full,
				WEAR_R_STORE = /obj/item/storage/pouch/magazine/upp,
			)

	generate_stored_equipment()
		. = list(
				WEAR_J_STORE = /obj/item/weapon/gun/rifle/type71,
				WEAR_IN_BACK = /obj/item/explosive/plastique,
				WEAR_IN_BACK = /obj/item/reagent_container/food/snacks/upp,
				WEAR_IN_BACK = /obj/item/explosive/grenade/frag/upp,
			)