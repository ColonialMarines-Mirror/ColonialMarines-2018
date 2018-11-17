
/mob/living/carbon/Xenomorph/can_ventcrawl()
	if(mob_size == MOB_SIZE_BIG || !xeno_caste.can_vent_crawl)
		return FALSE
	else
		return TRUE

/mob/living/carbon/Xenomorph/ventcrawl_carry()
	return TRUE


/mob/living/carbon/Xenomorph/can_inject()
	return FALSE




//These don't do much currently. Or anything? Only around for legacy code.
/mob/living/carbon/Xenomorph/is_mob_restrained()
	return FALSE
