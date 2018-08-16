/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (stat == DEAD)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	src.visible_message("<span class='warning'>[src] gets a horrible look in their eyes!</span>")
	if(confirm == "Yes")
		if(!canmove || is_mob_restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
			src << "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))"
			return
		if(src.mind && src.mind.assigned_role != "Squad Marine") // We don't care about squad marine suicides or people suiciding without minds.
			message_admins("[ckey] as suicided as a [src.mind.assigned_role]", 1)
		
		if(do_after(src, 40, TRUE, 5, BUSY_ICON_HOSTILE))
			suiciding = 1
			var/obj/item/held_item = get_active_hand()
			if(held_item)
				var/damagetype = held_item.suicide_act(src)
				if(damagetype)
					var/damage_mod = 1
					switch(damagetype) //Sorry about the magic numbers.
									   //brute = 1, burn = 2, tox = 4, oxy = 8
						if(15) //4 damage types
							damage_mod = 4

						if(6, 11, 13, 14) //3 damage types
							damage_mod = 3

						if(3, 5, 7, 9, 10, 12) //2 damage types
							damage_mod = 2

						if(1, 2, 4, 8) //1 damage type
							damage_mod = 1

						else //This should not happen, but if it does, everything should still work
							damage_mod = 1

					//Do 175 damage divided by the number of damage types applied.
					if(damagetype & BRUTELOSS)
						adjustBruteLoss(30/damage_mod)	//hack to prevent gibbing
						adjustOxyLoss(145/damage_mod)

					if(damagetype & FIRELOSS)
						adjustFireLoss(175/damage_mod)

					if(damagetype & TOXLOSS)
						adjustToxLoss(175/damage_mod)

					if(damagetype & OXYLOSS)
						adjustOxyLoss(175/damage_mod)

					//If something went wrong, just do normal oxyloss
					if(!(damagetype|BRUTELOSS) && !(damagetype|FIRELOSS) && !(damagetype|TOXLOSS) && !(damagetype|OXYLOSS))
						adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

					updatehealth()
					return


			viewers(src) << pick("\red <b>[src] is attempting to bite \his tongue off! It looks like \he's trying to commit suicide.</b>", \
								"\red <b>[src] is jamming \his thumbs into \his eye sockets! It looks like \he's trying to commit suicide.</b>", \
								"\red <b>[src] is twisting \his own neck! It looks like \he's trying to commit suicide.</b>", \
								"\red <b>[src] is holding \his breath! It looks like \he's trying to commit suicide.</b>")
			adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
			updatehealth()

/mob/living/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(loc) << "\red <b>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</b>"
		spawn(50)
			death(0)
			suiciding = 0

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		if(!canmove || is_mob_restrained())
			src << "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))"
			return
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</b>"
		adjustOxyLoss(max(175- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is powering down. It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is powering down. It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()
