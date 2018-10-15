
//procs directly related to mob health


/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	bruteloss += amount

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	oxyloss += amount

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	toxloss += amount

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	fireloss += amount

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	cloneloss += amount

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	brainloss += amount

/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	halloss += amount

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	halloss = amount

/mob/living/proc/getTraumatic_Shock()
	return traumatic_shock

/mob/living/proc/adjustTraumatic_Shock(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	traumatic_shock += amount

/mob/living/proc/setTraumatic_Shock(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	traumatic_shock = amount

/mob/living/proc/getShock_Stage()
	return shock_stage

/mob/living/proc/adjustShock_Stage(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	shock_stage += amount

/mob/living/proc/setShock_Stage(var/amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	shock_stage = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	maxHealth = newMaxHealth







// heal ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_limb_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/take_limb_damage(var/brute, var/burn)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY limbs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY limbs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return



/mob/living/proc/revive(keep_viruses)
	rejuvenate()


/mob/living/proc/rejuvenate()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	setHalLoss(0)
	setTraumatic_Shock(0)
	setShock_Stage(0)
	SetKnockedout(0)
	SetStunned(0)
	SetKnockeddown(0)
	ExtinguishMob()
	fire_stacks = 0

	// shut down ongoing problems
	radiation = 0
	nutrition = 400
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	set_blindness(0, TRUE)
	set_blurriness(0, TRUE)
	setEarDamage(0, 0)
	heal_overall_damage(getBruteLoss(), getFireLoss())

	// restore all of a human's blood
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.restore_blood()
		H.reagents.clear_reagents() //and clear all reagents in them
		H.undefibbable = FALSE
		H.chestburst = 0
		H.mutations.Remove(HUSK)

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src
		tod = null
		timeofdeath = 0

	// restore us to conciousness
	stat = CONSCIOUS
	updatehealth()

	// make the icons look correct
	regenerate_icons()
	med_hud_set_status()
	med_hud_set_health()
	reload_fullscreens()