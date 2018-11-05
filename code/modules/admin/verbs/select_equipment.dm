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
