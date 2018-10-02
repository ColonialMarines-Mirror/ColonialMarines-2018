/mob/living/carbon/Life()
	..()

	handle_fire() //Check if we're on fire

	if(stat != DEAD) //Chemicals in body and some other stuff.
		handle_organs()

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
		var/client/C = client
		var/pixel_x_diff = 0
		var/pixel_y_diff = 0
		var/temp
		var/saved_dizz = dizziness
		if(C)
			var/oldsrc = src
			var/amplitude = dizziness*(sin(dizziness * world.time) + 1) // This shit is annoying at high strength
			src = null
			spawn(0)
				if(C)
					temp = amplitude * sin(saved_dizz * world.time)
					pixel_x_diff += temp
					C.pixel_x += temp
					temp = amplitude * cos(saved_dizz * world.time)
					pixel_y_diff += temp
					C.pixel_y += temp
					sleep(3)
					if(C)
						temp = amplitude * sin(saved_dizz * world.time)
						pixel_x_diff += temp
						C.pixel_x += temp
						temp = amplitude * cos(saved_dizz * world.time)
						pixel_y_diff += temp
						C.pixel_y += temp
					sleep(3)
					if(C)
						C.pixel_x -= pixel_x_diff
						C.pixel_y -= pixel_y_diff
			src = oldsrc
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
				sleeping = max(sleeping - 1, 0)
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
			Dizzy(10)

		if(drunkenness >= 51)
			if(prob(5))
				confused += 10
				vomit()
			Dizzy(25)

		if(drunkenness >= 61)
			if(drunkenness < 81)
				reagent_shock_modifier += PAIN_REDUCTION_LIGHT
			if(prob(50))
				blur_eyes(5)

		if(drunkenness >= 71)
			blur_eyes(5)

		if(drunkenness >= 81)
			if(drunkenness < 91)
				reagent_shock_modifier += PAIN_REDUCTION_MEDIUM
			adjustToxLoss(0.2)
			if(prob(5) && !stat)
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