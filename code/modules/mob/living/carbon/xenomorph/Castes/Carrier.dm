//Carrier Code - Colonial Marines - Last Edit: Apophis775 - 11JUN16

/mob/living/carbon/Xenomorph/Carrier
	caste = "Carrier"
	name = "Carrier"
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon = 'icons/Xeno/2x2_Xenos.dmi' //They are now like, 2x2
	icon_state = "Carrier Walking"
	melee_damage_lower = 20
	melee_damage_upper = 30
	tackle_damage = 30
	health = 200
	maxHealth = 200
	plasma_stored = 50
	plasma_max = 250
	upgrade_threshold = 200
	evolution_allowed = FALSE
	plasma_gain = 8
	caste_desc = "A carrier of huggies."
	drag_delay = 6 //pulling a big dead xeno is hard
	aura_strength = 1 //Carrier's pheromones are equivalent to Hivelord. Climbs 0.5 up to 2.5
	speed = 0
	armor_deflection = 5
	mob_size = MOB_SIZE_BIG
	var/huggers_max = 8
	var/huggers_cur = 0
	var/threw_a_hugger = 0
	var/hugger_delay = 25
	var/eggs_cur = 0
	var/eggs_max = 3
	var/used_spawn_facehugger = FALSE
	var/last_spawn_facehugger
	var/cooldown_spawn_facehugger = 100 //10 seconds; keeping this as a var for now as I may have it adjust with upgrade level
	tier = 2
	upgrade = 0
	pixel_x = -16 //Needed for 2x2
	old_x = -16

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/emit_pheromones,
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/activable/retrieve_egg,
		/datum/action/xeno_action/place_trap,
		/datum/action/xeno_action/spawn_hugger,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)

	death(gibbed)
		if(..() && !gibbed && huggers_cur)
			var/obj/item/clothing/mask/facehugger/F
			var/i = 3
			var/chance = 75
			visible_message("<span class='xenowarning'>The chittering mass of tiny aliens is trying to escape [src]!</span>")
			while(i && huggers_cur)
				if(prob(chance))
					huggers_cur--
					F = new(loc)
					F.hivenumber = hivenumber
					step_away(F,src,1)
				i--
				chance -= 30


/mob/living/carbon/Xenomorph/Carrier/Stat()
	if (!..())
		return 0

	stat(null, "Stored Huggers: [huggers_cur] / [huggers_max]")
	stat(null, "Stored Eggs: [eggs_cur] / [eggs_max]")
	return 1

/mob/living/carbon/Xenomorph/Carrier/proc/store_hugger(obj/item/clothing/mask/facehugger/F)
	if(huggers_cur < huggers_max)
		if(F.stat == CONSCIOUS && !F.sterile)
			huggers_cur++
			to_chat(src, "<span class='notice'>You store the facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max].</span>")
			cdel(F)
		else
			to_chat(src, "<span class='warning'>This [F.name] looks too unhealthy.</span>")
	else
		to_chat(src, "<span class='warning'>You can't carry more facehuggers on you.</span>")


/mob/living/carbon/Xenomorph/Carrier/proc/throw_hugger(atom/T)
	if(!T) return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = T
		if(isturf(F.loc) && Adjacent(F))
			if(F.hivenumber != hivenumber)
				to_chat(src, "<span class='warning'>That facehugger is tainted!</span>")
				drop_inv_item_on_ground(F)
				return
			store_hugger(F)
			return

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(!F) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			to_chat(src, "<span class='warning'>You don't have any facehuggers to use!</span>")
			return
		F = new()
		F.hivenumber = hivenumber
		huggers_cur--
		put_in_active_hand(F)
		to_chat(src, "<span class='xenonotice'>You grab one of the facehugger in your storage. Now sheltering: [huggers_cur] / [huggers_max].</span>")
		return

	if(!istype(F)) //something else in our hand
		to_chat(src, "<span class='warning'>You need a facehugger in your hand to throw one!</span>")
		return

	if(!threw_a_hugger)
		threw_a_hugger = 1
		update_action_button_icons()
		drop_inv_item_on_ground(F)
		F.throw_at(T, CARRIER_HUGGER_THROW_DISTANCE, CARRIER_HUGGER_THROW_SPEED)
		visible_message("<span class='xenowarning'>\The [src] throws something towards \the [T]!</span>", \
		"<span class='xenowarning'>You throw a facehugger towards \the [T]!</span>")
		spawn(hugger_delay)
			threw_a_hugger = 0
			update_action_button_icons()



/mob/living/carbon/Xenomorph/Carrier/proc/store_egg(obj/item/xeno_egg/E)
	if(E.hivenumber != hivenumber)
		to_chat(src, "<span class='warning'>That egg is tainted!</span>")
		return
	if(eggs_cur < eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			to_chat(src, "<span class='notice'>You store the egg and carry it for safekeeping. Now sheltering: [eggs_cur] / [eggs_max].</span>")
			cdel(E)
		else
			to_chat(src, "<span class='warning'>This [E.name] looks too unhealthy.</span>")
	else
		to_chat(src, "<span class='warning'>You can't carry more eggs on you.</span>")


/mob/living/carbon/Xenomorph/Carrier/proc/retrieve_egg(atom/T)
	if(!T) return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/E = T
		if(isturf(E.loc) && Adjacent(E))
			store_egg(E)
			return

	var/obj/item/xeno_egg/E = get_active_hand()
	if(!E) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(eggs_cur <= 0)
			to_chat(src, "<span class='warning'>You don't have any egg to use!</span>")
			return
		E = new()
		E.hivenumber = hivenumber
		eggs_cur--
		put_in_active_hand(E)
		to_chat(src, "<span class='xenonotice'>You grab one of the eggs in your storage. Now sheltering: [eggs_cur] / [eggs_max].</span>")
		return

	if(!istype(E)) //something else in our hand
		to_chat(src, "<span class='warning'>You need an empty hand to grab one of your stored eggs!</span>")
		return
