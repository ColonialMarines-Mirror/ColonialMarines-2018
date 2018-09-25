//Refer to life.dm for caller

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & GODMODE || analgesic || (species && species.flags & NO_PAIN)) return //Godmode or some other pain reducers. //Analgesic avoids all traumatic shock temporarily

	if(health < config.health_threshold_softcrit)
		shock_stage = max(shock_stage, 60)//If they took too much damage, they immediately enter shock.

	switch(traumatic_shock)
	if(200 to INFINITY) 
		shock_stage = max(150,min(200,shock_stage++)) //Indescribable pain. At this point, you will immediately be knocked down, with shock stage set to 150.
	
	if(199 to 100)
		shock_stage = min(200,shock_stage++) //If their shock exceeds 100, add more to their shock stage, regardless of health.
	
	if(99 to 75)
		shock_stage = max(0, min(shock_stage, 120)) //No greater than 120 and no smaller than 0
		return
	
	if(74 to 50)
		shock_stage = max(0, min(shock_stage - 2, 80)) 
		return
	
	if(49 to 0)
		shock_stage = max(0, min(shock_stage - 10, 60)) //When we have almost no pain remaining. No greater than 60 and no smaller than 0, reduced by 10 each time.
		return

	//This just adds up effects together at each step, with a few small exceptions. Preferable to copy and paste rather than have a billion if statements.
	switch(shock_stage)
		if(10 to 29) to_chat(src, "<span class='danger'>[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!</span>")
		if(30 to 39)
			if(shock_stage == 30)
				emote("me", 1, "is having trouble keeping their eyes open.")
			if(prob(35))
				to_chat(src, "<span class='danger'>[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!</span>")
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)
		if(40 to 59)
			if(shock_stage == 40)
				to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>")
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)
		if(60 to 79)
			if(shock_stage == 60 && !lying)
				emote("me", 1, " is having trouble standing.")
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)
			if(prob(2))
				to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>")
				KnockDown(20)
		if(80 to 119)
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)
			if(prob(7))
				to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>")
				KnockDown(20)
		if(120 to 149)
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)
			if(prob(7))
				to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>")
				KnockDown(20)
			if(prob(2))
				to_chat(src, "<span class='danger'>[pick("You black out", "You feel like you could die any moment now", "You're about to lose consciousness")]!</span>")
				KnockOut(5)
		if(150 to INFINITY)
			if(shock_stage == 150 && !lying) emote("me", 1, "can no longer stand, collapsing!")
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)
			if(prob(7)) to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>")
			if(prob(2))
				to_chat(src, "<span class='danger'>[pick("You black out", "You feel like you could die any moment now", "You're about to lose consciousness")]!</span>")
				KnockOut(5)
			KnockDown(20)
