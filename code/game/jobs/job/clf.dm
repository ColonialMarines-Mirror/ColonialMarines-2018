/datum/job/clf
	special_role = "CLF"
	comm_title = "CLF"
	faction = "Colonial Liberation Force"
	supervisors = "the team leader"
	idtype = /obj/item/card/id
	skills_type = /datum/skills/pfc/crafty
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT


//CLF Standard
/datum/job/clf/standard
	title = "CLF Standard"
	paygrade = "CLF1"
	equipment = TRUE
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

	generate_equipment(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/militia(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/uzi/extended(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/uzi/extended(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/uzi/extended(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_R_STORE)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/uzi(H), WEAR_L_HAND)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/uzi(H), WEAR_R_HAND)


//CLF Medic
/datum/job/clf/medic
	title = "CLF Medic"
	paygrade = "CLF2"
	equipment = TRUE
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

	generate_equipment(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/storage/belt/combatLifesaver/upp(H), WEAR_WAIST)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/skorpion/upp(H), WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/skorpion(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/skorpion(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp_smg, WEAR_R_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

//CLF Leader
/datum/job/clf/leader
	title = "CLF Leader"
	paygrade = "CLF3"
	equipment = TRUE
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

	generate_equipment(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/heavy(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer(H), WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard(H), WEAR_WAIST)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/upp(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)