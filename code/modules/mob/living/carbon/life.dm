/mob/living/carbon/Life()

	if(stat != DEAD) //Chemicals in body and some other stuff.
		handle_organs()

	..()

	handle_fire() //Check if we're on fire

/mob/living/carbon/handle_regular_hud_updates()
	..()

	if(!isXeno(src)) // They have a different HUD.
		if (hud_used && hud_used.healths)
			if (stat != DEAD)
				switch(round(health * 100 / maxHealth))
					if(100 to INFINITY)
						hud_used.healths.icon_state = "health0"
					if(75 to 99)
						hud_used.healths.icon_state = "health1"
					if(50 to 74)
						hud_used.healths.icon_state = "health2"
					if(25 to 49)
						hud_used.healths.icon_state = "health3"
					if(10 to 24)
						hud_used.healths.icon_state = "health4"
					if(0 to 9)
						hud_used.healths.icon_state = "health5"
					else
						hud_used.healths.icon_state = "health6"
			else
				hud_used.healths.icon_state = "health7"

/mob/living/carbon/update_stat()
	if(status_flags & GODMODE)
		return

	if(stat == DEAD)
		return

	if(health <= config.health_threshold_dead)
		death()
		return

	var/crit_threshold = ishuman(src) ? config.health_threshold_crit : 0
	if(knocked_out || sleeping || getOxyLoss() > 50 || health < crit_threshold)
		stat = UNCONSCIOUS
		blind_eyes(1)
	else
		stat = CONSCIOUS
		adjust_blindness(-1)
	update_canmove()

/mob/living/carbon/handle_status_effects()
	..()

	var/restingpwr = 1 + 4 * resting

	//Dizziness
	if(dizziness)
		Dizzy(-restingpwr)

	if(drowsyness)
		drowsyness = max(drowsyness - restingpwr, 0)
		blur_eyes(2)
		if(prob(5))
			Sleeping(1)
			KnockOut(5)

	if(jitteriness)
		do_jitter_animation(jitteriness)
		Jitter(-restingpwr)

	if(hallucination)
		if(hallucination >= 20)
			if(prob(3))
				fake_attack(src)
			if(!handling_hal)
				spawn handle_hallucinations()//The not boring kind!

		hallucination = max(hallucination - 3, 0)

	else
		for(var/atom/a in hallucinations)
			hallucinations -=a
			cdel(a)

	if(halloss > 100)
		visible_message("<span class='warning'>\The [src] slumps to the ground, too weak to continue fighting.</span>", \
		"<span class='warning'>You slump to the ground, you're in too much pain to keep going.</span>")
		KnockOut(10)
		setHalLoss(99)

	if(knocked_out)
		if(halloss > 0)
			adjustHalLoss(-3)
	else if(sleeping)
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			H.speech_problem_flag = 1
		handle_dreams()
		adjustHalLoss(-3)
		if(mind)
			if((mind.active && client != null) || immune_to_ssd) //This also checks whether a client is connected, if not, sleep is not reduced.
				AdjustSleeping(-1)
		if(!isXeno(src))
			if(prob(2) && health && !hal_crit)
				spawn()
					emote("snore")

	//Resting
	if(resting)
		adjustHalLoss(-3)
	else
		adjustHalLoss(-1)

	if(drunkenness)
		drunkenness = max(drunkenness - (drunkenness * 0.03), 0)
		if(drunkenness >= 6)
			if(prob(25))
				slurring += 2
			Jitter(-3)

		if(drunkenness >= 11 && slurring < 5)
			slurring += 1.2

		if(drunkenness >= 41)
			if(drunkenness < 61)
				reagent_shock_modifier += PAIN_REDUCTION_VERY_LIGHT
			if(prob(25))
				confused += 2
			if(dizziness < 450) // To avoid giving the player overly dizzy too
				Dizzy(5)

		if(drunkenness >= 51)
			if(prob(5))
				confused += 5
				vomit()
			if(dizziness < 600)
				Dizzy(10)

		if(drunkenness >= 61)
			if(drunkenness < 81)
				reagent_shock_modifier += PAIN_REDUCTION_LIGHT
			if(prob(25))
				blur_eyes(3)

		if(drunkenness >= 71)
			blur_eyes(4)

		if(drunkenness >= 81)
			if(drunkenness < 91)
				reagent_shock_modifier += PAIN_REDUCTION_MEDIUM
			adjustToxLoss(0.2)
			if(prob(10) && !stat)
				to_chat(src, "<span class='warning'>Maybe you should lie down for a bit...</span>")
				drowsyness += 5

		if(drunkenness >= 91)
			reagent_shock_modifier += PAIN_REDUCTION_HEAVY
			adjustBrainLoss(0.2)
			if(prob(15 && !stat))
				to_chat(src, "<span class='warning'>Just a quick nap...</span>")
				Sleeping(40)

		if(drunkenness >=101) //Let's be honest, you should be dead by now
			adjustToxLoss(4)