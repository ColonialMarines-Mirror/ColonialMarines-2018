/datum/job/pmc
	special_role = "PMC"
	comm_title = "WY"
	faction = "Weyland-Yutani"
	supervisors = "the team leader"
	idtype = /obj/item/card/id/centcom
	skills_type = /datum/skills/pfc/crafty
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT

	generate_entry_conditions(mob/living/carbon/human/H)
		H.real_name = "PMC " + H.real_name


//PMC Standard
/datum/job/pmc/standard
	title = "PMC Standard"
	paygrade = "PMC1"
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN)

	generate_equipment(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/PMC(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/baton(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite(H), WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_R_STORE)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap(H.back), WEAR_IN_BACK)

//PMC support engineer.
/datum/job/pmc/gunner
	title = "PMC Mechanic"
	paygrade = "PMC2"
	skills_type = /datum/skills/combat_engineer
	equipment = TRUE
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN)

	generate_equipment(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/gunner(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
		H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/snow(H), WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)

//PMC Sniper
/datum/job/pmc/sniper
	title = "PMC Triage"
	paygrade = "PMC3"
	skills_type = /datum/skills/combat_engineer
	equipment = TRUE
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN)

	generate_equipment(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/sniper(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/sniper(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles(H), WEAR_EYES)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/elite(H), WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sniper(H), WEAR_L_STORE)


//PMC Leader
/datum/job/pmc/leader
	title = "PMC Leader"
	paygrade = "PMC4"
	skills_type = /datum/skills/combat_engineer
	equipment = TRUE
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_CORPORATE)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_PILOT, ACCESS_MARINE_TANK, ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_CORPORATE)

	generate_equipment(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/leader(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/leader(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/leader(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/baton(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite(H), WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_R_STORE)