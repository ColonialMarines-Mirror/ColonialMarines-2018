
/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/is_mob_restrained()
	if (handcuffed)
		return 1
	return

//Unvore
/mob/living/carbon/proc/unvore(var/mob/living/carbon/C, var/forced = FALSE)
	if(!C.stomach_contents)
		return FALSE
	for(var/atom/movable/A in C.stomach_contents)
		C.stomach_contents.Remove(A)
		A.forceMove(loc)
		if(ismob(A))
			if(forced)
				visible_message("<span class='danger'>[A] bursts out of [src]!</span>")
			if(isliving(A))
				var/mob/living/L = A
				L.devoured = FALSE //remove the devour flag
	return TRUE

/mob/living/carbon/proc/unvore_forced(var/mob/living/carbon/Xenomorph/X)
	if(!stomach_contents.len)
		return
	for(var/atom/movable/M in X.stomach_contents)
		if(world.time > X.devour_timer && ishuman(M) && !X.is_ventcrawling)
			X.stomach_contents.Remove(M)
			if(M.loc != src)
				continue
			M.forceMove(loc)
			if(isliving(M))
				var/mob/living/L = M
				L.devoured = FALSE //remove the devour flag