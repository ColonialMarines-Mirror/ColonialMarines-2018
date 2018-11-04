/client/proc/cmd_admin_select_mob_rank(var/mob/living/carbon/human/H in mob_list)
	set category = null
	set name = "Select Rank"
	if(!istype(H))
		alert("Invalid mob.")
		return

	var/rank_list = list("Custom") + RoleAuthority.roles_by_name

	var/newrank = input("Select new rank for [H]", "Change the mob's rank and skills") as null|anything in rank_list
	if(!newrank)
		return
	if(!H || !H.mind)
		return
	feedback_add_details("admin_verb","SMRK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(newrank != "Custom")
		H.set_everything(H, newrank)
	else
		var/newcommtitle = input("Write the custom title appearing on comms chat (e.g. Spc)", "Comms title") as null|text
		if(!newcommtitle)
			return
		if(!H || !H.mind)
			return

		H.mind.role_comm_title = newcommtitle
		var/obj/item/card/id/I = H.wear_id
		if(!istype(I) || I != H.wear_id)
			to_chat(usr, "The mob has no id card, unable to modify ID and chat title.")
		else
			var/newchattitle = input("Write the custom title appearing in chat (e.g. SGT)", "Chat title") as null|text
			if(!newchattitle)
				return
			if(!H || I != H.wear_id)
				return

			I.paygrade = newchattitle

			var/IDtitle = input("Write the custom title on your ID (e.g. Squad Specialist)", "ID title") as null|text
			if(!IDtitle)
				return
			if(!H || I != H.wear_id)
				return

			I.rank = IDtitle
			I.assignment = IDtitle
			I.name = "[I.registered_name]'s ID Card ([I.assignment])"

		if(!H.mind)
			to_chat(usr, "The mob has no mind, unable to modify skills.")
		else
			var/newskillset = input("Select a skillset", "Skill Set") as null|anything in RoleAuthority.roles_by_name
			if(!newskillset)
				return

			if(!H || !H.mind)
				return

			var/datum/job/J = RoleAuthority.roles_by_name[newskillset]
			H.mind.set_cm_skills(J.skills_type)




/client/proc/cmd_admin_dress(var/mob/living/carbon/human/M in mob_list)
	set category = null
	set name = "Select Equipment"
	if(!ishuman(M))
		return

	var/list/dresspacks = list("Strip") + RoleAuthority.roles_by_equipment
	var/list/paths = list("Strip") + RoleAuthority.roles_by_equipment_paths

	var/dresscode = input("Choose equipment for [M]", "Select Equipment") as null|anything in dresspacks
	if(isnull(dresscode))
		return
	var/path = paths[dresspacks.Find(dresscode)]
	feedback_add_details("admin_verb","SEQ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	for(var/obj/item/I in M)
		if(istype(I, /obj/item/implant))
			continue
		cdel(I)
	var/datum/job/J = new path
	J.generate_equipment(M)
	M.regenerate_icons()
	log_admin("[key_name(usr)] changed the equipment of [key_name(M)] to [dresscode].")
	message_admins("\blue [key_name_admin(usr)] changed the equipment of [key_name_admin(M)] to [dresscode].", 1)
	return


//note: when adding new dresscodes, on top of adding a proper skills_list, make sure the ID given has
//a rank that matches a job title unless you want the human to bypass the skill system.
/mob/proc/arm_equipment(var/mob/living/carbon/human/M, var/dresscode)
	switch(dresscode)
		
		if("Weyland-Yutani Deathsquad")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles	(M), WEAR_EYES)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/commando(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/commando(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/commando(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(M), WEAR_FACE)
			M.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(M), WEAR_L_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(M), WEAR_R_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(M), WEAR_L_STORE)

			M.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite(M), WEAR_J_STORE)

			var/obj/item/card/id/W = new(M)
			W.assignment = "Commando"
			W.rank = "PMC Commando"
			W.registered_name = M.real_name
			W.name = "[M.real_name]'s ID Card ([W.assignment])"
			W.icon_state = "centcom"
			W.access = get_antagonist_pmc_access()
			M.equip_to_slot_or_del(W, WEAR_ID)

			if(M.mind)
				M.reset_comm_title(W.rank)
				M.reset_role(W.rank)
				M.reset_cm_skills(W.rank)
				M.mind.special_role = "DEATH SQUAD"



		if("UPP Commando (Standard)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(M), WEAR_FACE)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(M), WEAR_EYES)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(M), WEAR_J_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(M.back), WEAR_IN_BACK)

			M.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/device/chameleon	(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(M), WEAR_R_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(M), WEAR_L_STORE)

			M.equip_to_slot_or_del(new /obj/item/handcuffs(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/handcuffs(M.back), WEAR_IN_BACK)


			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "UPP Commando"
			W.registered_name = M.real_name
			W.paygrade = "E2"
			W.access = get_antagonist_access()
			M.equip_to_slot_or_del(W, WEAR_ID)
			M.add_language("Russian")

			if(M.mind)
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "UPP"
				M.mind.set_cm_skills(/datum/skills/commando)


		if("UPP Commando (Medic)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(M), WEAR_FACE)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(M), WEAR_EYES)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(M), WEAR_J_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(M.back), WEAR_IN_BACK)

			M.equip_to_slot_or_del(new /obj/item/device/defibrillator(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(M), WEAR_R_STORE)

			M.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/device/chameleon	(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp(M), WEAR_L_STORE)

			M.equip_to_slot_or_del(new /obj/item/handcuffs(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/handcuffs(M.back), WEAR_IN_BACK)


			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "UPP Commando Medic"
			W.registered_name = M.real_name
			W.paygrade = "E4"
			W.access = get_antagonist_access()
			M.equip_to_slot_or_del(W, WEAR_ID)
			M.add_language("Russian")

			if(M.mind)
				M.mind.role_comm_title = "Cpl"
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "UPP"
				M.mind.set_cm_skills(/datum/skills/commando/medic)

		if("UPP Commando (Leader)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(M), WEAR_FACE)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(M), WEAR_EYES)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(M), WEAR_J_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(M.back), WEAR_IN_BACK)

			M.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/device/chameleon	(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(M), WEAR_R_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp(M), WEAR_L_STORE)

			M.equip_to_slot_or_del(new /obj/item/handcuffs(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/handcuffs(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(M.back), WEAR_IN_BACK)




			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "UPP Commando Leader"
			W.registered_name = M.real_name
			W.paygrade = "E6"
			W.access = get_antagonist_access()
			M.equip_to_slot_or_del(W, WEAR_ID)
			M.add_language("Russian")


			if(M.mind)
				M.mind.role_comm_title = "SL"
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "UPP"
				M.mind.set_cm_skills(/datum/skills/commando/leader)

		if("CLF Fighter (Standard)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/militia(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/device/flashlight(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/general(M), WEAR_R_STORE)

			spawn_rebel_gun(M)
			spawn_rebel_gun(M,1)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "Colonist"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, WEAR_ID)
			W.access = get_antagonist_access()

			if(M.mind)
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "CLF"
				M.mind.set_cm_skills(/datum/skills/pfc)

		if("CLF Fighter (Medic)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/militia(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)

			M.equip_to_slot_or_del(new /obj/item/device/defibrillator(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/device/flashlight(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(M), WEAR_EYES)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/general(M), WEAR_L_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(M), WEAR_R_STORE)


			spawn_rebel_gun(M)
//			spawn_rebel_gun(M,1)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "Colonist Medic"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, WEAR_ID)
			W.access = get_antagonist_access()

			if(M.mind)
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "CLF"
				M.mind.set_cm_skills(/datum/skills/combat_medic)

		if("CLF Fighter (Leader)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/device/flashlight(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(M), WEAR_R_STORE)

			spawn_rebel_gun(M)
			spawn_rebel_gun(M,1)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "Colonist Leader"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, WEAR_ID)
			W.access = get_antagonist_access()

			if(M.mind)
				M.mind.role_comm_title = "Lead"
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "CLF"
				M.mind.set_cm_skills(/datum/skills/SL)

		if("Freelancer (Standard)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/marine(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/general(M), WEAR_R_STORE)

			spawn_merc_gun(M)
			spawn_rebel_gun(M,1)


			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "Freelancer"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, WEAR_ID)
			W.access = get_all_accesses()

			if(M.mind)
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "FREELANCERS"
				M.mind.set_cm_skills(/datum/skills/pfc)

		if("Freelancer (Medic)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/marine(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)

			M.equip_to_slot_or_del(new /obj/item/device/defibrillator(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(M), WEAR_L_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/general(M), WEAR_R_STORE)

			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(M), WEAR_EYES)

			spawn_merc_gun(M)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "Freelancer Medic"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, WEAR_ID)
			W.access = get_all_accesses()

			if(M.mind)
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "FREELANCERS"
				M.mind.set_cm_skills(/datum/skills/combat_medic)


		if("Freelancer (Leader)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer/beret(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/marine(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/stick(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(M), WEAR_R_STORE)

			spawn_merc_gun(M)
			spawn_merc_gun(M,1)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.access = list()
			W.assignment = "Freelancer Warlord"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, WEAR_ID)
			M.add_language("Russian")
			M.add_language("Sainja")
			W.access = get_all_accesses()

			if(M.mind)
				M.mind.role_comm_title = "Lead"
				M.mind.assigned_role = "MODE"
				M.mind.special_role = "FREELANCERS"
				M.mind.set_cm_skills(/datum/skills/SL)


		if("Mercenary (Heavy)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(M), WEAR_FACE)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)

			var/obj/item/card/id/W = new(M)
			W.assignment = "Mercenary"
			W.rank = "Mercenary Enforcer"
			W.registered_name = M.real_name
			W.name = "[M.real_name]'s ID Card ([W.assignment])"
			W.icon_state = "centcom"
			W.access = get_antagonist_pmc_access()
			M.equip_to_slot_or_del(W, WEAR_ID)

			if(M.mind)
				M.mind.set_cm_skills(/datum/skills/mercenary)


		if("Mercenary (Miner)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(M), WEAR_FACE)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)

			var/obj/item/card/id/W = new(M)
			W.assignment = "Mercenary"
			W.rank = "Mercenary Worker"
			W.registered_name = M.real_name
			W.name = "[M.real_name]'s ID Card ([W.assignment])"
			W.icon_state = "centcom"
			W.access = get_antagonist_pmc_access()
			M.equip_to_slot_or_del(W, WEAR_ID)

			if(M.mind)
				M.mind.set_cm_skills(/datum/skills/mercenary)


		if("Mercenary (Engineer)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/engineer(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/engineer(M), WEAR_JACKET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/engineer(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(M), WEAR_FACE)
			M.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/explosive/plastique(M.back), WEAR_IN_BACK)

			var/obj/item/card/id/W = new(M)
			W.assignment = "Mercenary"
			W.rank = "Mercenary Engineer"
			W.registered_name = M.real_name
			W.name = "[M.real_name]'s ID Card ([W.assignment])"
			W.icon_state = "centcom"
			W.access = get_antagonist_pmc_access()
			M.equip_to_slot_or_del(W, WEAR_ID)

			if(M.mind)
				M.mind.set_cm_skills(/datum/skills/mercenary)



/proc/spawn_merc_gun(var/atom/M,var/sidearm = 0)
	if(!M) return

	var/atom/spawnloc = M

	var/list/merc_sidearms = list(
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
		/obj/item/weapon/gun/pistol/m1911 = /obj/item/ammo_magazine/pistol/m1911,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/automatic,
		/obj/item/weapon/gun/pistol/holdout = /obj/item/ammo_magazine/pistol/holdout,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/smg/mp7 = /obj/item/ammo_magazine/smg/mp7,
		/obj/item/weapon/gun/smg/skorpion = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended)

	var/list/merc_firearms = list(
		/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/shotgun,
		/obj/item/weapon/gun/shotgun/combat = /obj/item/ammo_magazine/shotgun,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/m41aMK1 = /obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/weapon/gun/smg/p90 = /obj/item/ammo_magazine/smg/p90,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended)

	var/gunpath = sidearm? pick(merc_sidearms) : pick(merc_firearms)
	var/ammopath = sidearm? merc_sidearms[gunpath] : merc_firearms[gunpath]
	var/obj/item/weapon/gun/gun

	if(gunpath)
		gun = new gunpath(spawnloc)
		if(ishuman(spawnloc))
			var/mob/living/carbon/human/H = spawnloc
			H.equip_to_slot_or_del(gun, sidearm? WEAR_L_HAND : WEAR_J_STORE)
			if(ammopath && H.back && istype(H.back,/obj/item/storage))
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
		else
			if(ammopath)
				spawnloc = get_turf(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)

	return 1

/proc/spawn_rebel_gun(var/atom/M,var/sidearm = 0)
	if(!M) return
	var/atom/spawnloc = M

	var/list/rebel_firearms = list(
		/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/shotgun,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/automatic,
		/obj/item/weapon/gun/pistol/holdout = /obj/item/ammo_magazine/pistol/holdout,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/smg/mp7 = /obj/item/ammo_magazine/smg/mp7,
		/obj/item/weapon/gun/smg/skorpion = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/smg/skorpion/upp = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/pistol/c99 = /obj/item/ammo_magazine/pistol/c99,
		/obj/item/weapon/gun/pistol/vp70 = /obj/item/ammo_magazine/pistol/vp70
		)


	//no guns in sidearms list, we don't want players spawning with a gun in hand.
	var/list/rebel_sidearms = list(
		/obj/item/storage/large_holster/katana/full = null,
		/obj/item/storage/large_holster/katana/full = null,
		/obj/item/storage/large_holster/katana/full = null,
		/obj/item/storage/large_holster/machete/full = null,
		/obj/item/weapon/combat_knife = null,
		/obj/item/explosive/grenade/frag/stick = null,
		/obj/item/explosive/grenade/frag/stick = null,
		/obj/item/explosive/grenade/frag/stick = null,
		/obj/item/weapon/combat_knife/upp = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/clothing/tie/storage/webbing = null,
		/obj/item/clothing/tie/storage/webbing = null,
		/obj/item/storage/belt/marine = null,
		/obj/item/storage/pill_bottle/tramadol = null,
		/obj/item/explosive/grenade/phosphorus = null,
		/obj/item/clothing/glasses/welding = null,
		/obj/item/reagent_container/syringe/ld50_syringe/choral = null,
		/obj/item/storage/firstaid/regular = null,
		/obj/item/reagent_container/pill/cyanide = null,
		/obj/item/device/megaphone = null,
		/obj/item/storage/belt/utility/full = null,
		/obj/item/storage/belt/utility/full = null,
		/obj/item/storage/bible = null,
		/obj/item/tool/surgery/scalpel = null,
		/obj/item/tool/surgery/scalpel = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat/metal = null,
		/obj/item/explosive/grenade/empgrenade = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/phosphorus/upp = null,
		/obj/item/tool/hatchet = null,
		/obj/item/tool/hatchet = null,
		/obj/item/tool/hatchet = null,
		/obj/item/storage/box/MRE = null,
		/obj/item/clothing/mask/gas/PMC = null,
		/obj/item/clothing/glasses/night/m42_night_goggles/upp = null,
		/obj/item/storage/box/handcuffs = null,
		/obj/item/storage/pill_bottle/happy = null,
		/obj/item/weapon/twohanded/fireaxe = null,
		/obj/item/weapon/twohanded/spear = null
		)

	var/gunpath = sidearm? pick(rebel_sidearms) : pick(rebel_firearms)
	var/ammopath = sidearm? rebel_sidearms[gunpath] : rebel_firearms[gunpath]
	var/obj/item/weapon/gun/gun

	if(gunpath)
		gun = new gunpath(spawnloc)
		if(ishuman(spawnloc))
			var/mob/living/carbon/human/H = spawnloc
			H.equip_to_slot_or_del(gun, sidearm? WEAR_L_HAND : WEAR_J_STORE)
			if(ammopath && H.back && istype(H.back,/obj/item/storage))
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
		else
			if(ammopath != null)
				spawnloc = get_turf(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)


	return 1

/mob/living/proc/set_ID(new_job)
	return

/mob/living/carbon/human/set_ID(new_job)
	var/datum/job/J = RoleAuthority.roles_by_name[new_job]
	if(new_job)
		if(wear_id)
			var/obj/item/card/id/I = wear_id.GetID()
			if(I)
				var/title_alt = J.get_alternative_title(src)
				I.access = J.get_access()
				I.rank = J.title
				I.assignment = title_alt ? title_alt :  J.disp_title
				I.name = "[I.registered_name]'s ID Card ([I.assignment])"
				I.paygrade = J.paygrade
		else
			J.equip_identification(src, J)
