

/*****************************Pickaxe********************************/

/obj/item/tool/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "pickaxe"
	flags_atom = CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 15.0
	throwforce = 4.0
	item_state = "pickaxe"
	w_class = 4.0
	matter = list("metal" = 3750)
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "picking"
	sharp = IS_SHARP_ITEM_SIMPLE
	var/excavation_amount = 100

/obj/item/tool/pickaxe/hammer
	name = "sledgehammer"
	//icon_state = "sledgehammer" Waiting on sprite
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."

/obj/item/tool/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 30
	origin_tech = "materials=3"
	desc = "This makes no metallurgic sense."

/obj/item/tool/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 30
	origin_tech = "materials=2;powerstorage=3;engineering=2"
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"

/obj/item/tool/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 20 //faster than drill, but cannot dig
	origin_tech = "materials=3;powerstorage=2;engineering=2"
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"

/obj/item/tool/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 20
	origin_tech = "materials=4"
	desc = "This makes no metallurgic sense."

/obj/item/tool/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 10
	origin_tech = "materials=6;engineering=4"
	desc = "A pickaxe with a diamond pick head, this is just like minecraft."

/obj/item/tool/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 5 //Digs through walls, girders, and can dig up sand
	origin_tech = "materials=6;powerstorage=4;engineering=5"
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"

/obj/item/tool/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"


/obj/item/tool/pickaxe/plasmacutter
	name = "plasma cutter"
	icon_state = "plasma_cutter_on"
	item_state = "plasmacutter"
	w_class = 4.0
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	force = 40.0
	damtype = "fire"
	digspeed = 20 //Can slice though normal walls, all girders, or be used in reinforced wall deconstruction/ light thermite on fire
	origin_tech = "materials=4;phorontech=3;engineering=3"
	desc = "A tool that cuts with deadly hot plasma. You could use it to cut limbs off of xenos! Or, you know, cut apart walls or mine through stone. Eye protection strongly recommended."
	drill_verb = "cutting"
	heat_source = 3800
	var/cutting_sound = 'sound/items/Welder2.ogg'
	var/powered = FALSE
	var/dirt_amt_per_dig = 5
	var/charge_cost = 1000
	var/obj/item/cell/high/cell //Starts with a high capacity energy cell.

/obj/item/tool/pickaxe/plasmacutter/New()
	..()
	cell = new /obj/item/cell/high(src)
	powered = TRUE
	update_icon()


/obj/item/tool/pickaxe/plasmacutter/examine(mob/user)
	..()
	if(cell)
		to_chat(user, "It has a loaded power cell and its readout counter is active. <b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b>")
	else
		to_chat(user, "<span class='warning'>It does not have a power source installed!</span>")

/obj/item/tool/pickaxe/plasmacutter/attack_self(mob/user as mob)
	toggle()
	return

//Toggles the cutter off and on
/obj/item/tool/pickaxe/plasmacutter/proc/toggle(var/message = 0)
	var/mob/M
	if(ismob(loc))
		M = loc
	if(!powered)
		if(cell)
			if(cell.charge > 0)
				playsound(loc, 'sound/weapons/saberon.ogg', 25)
				powered = TRUE
				if(M)
					to_chat(M, "<span class='notice'>You switch [src] on. <b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b></span>")
				update_icon()
			else
				if(M)
					fizzle_message(M)
				return
		else
			if(M)
				fizzle_message(M)
				return
	else
		playsound(loc, 'sound/weapons/saberoff.ogg', 25)
		powered = FALSE
		if(M)
			to_chat(M, "<span class='notice'>You switch [src] off. <b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b></span>")
		update_icon()

/obj/item/tool/pickaxe/plasmacutter/proc/fizzle_message(mob/user)
	var/fizzle = "<span class='warning'>The plasma cutter has inadequate charge remaining! Replace or recharge the battery.</span>"
	playsound(src, 'sound/machines/buzz-two.ogg', 25, 1)
	if(!cell)
		to_chat(user, "<span class='warning'>[src]'s has no battery installed!</span>")
	else if(!powered)
		to_chat(user, "<span class='warning'>[src] is turned off!</span>")
	else
		to_chat(user, "<span class='warning'>[fizzle] <b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b></span>")

/obj/item/tool/pickaxe/plasmacutter/proc/start_cut(mob/user, name = "", atom/source)
	eyecheck(user)
	playsound(source, cutting_sound, 25, 1)
	var/datum/effect_system/spark_spread/spark_system
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, source)
	spark_system.attach(source)
	spark_system.start(source)
	to_chat(user, "<span class='notice'>You start cutting apart the [name] with [src]. <b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b></span>")

/obj/item/tool/pickaxe/plasmacutter/proc/cut_apart(mob/user, name = "", atom/source, charge_amount = charge_cost)
	eyecheck(user)
	playsound(source, cutting_sound, 25, 1)
	var/datum/effect_system/spark_spread/spark_system
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, source)
	spark_system.attach(source)
	spark_system.start(source)
	use_charge(user, charge_amount, FALSE)
	to_chat(user, "<span class='notice'>You cut apart the [name] with [src]. <b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b></span>")

/obj/item/tool/pickaxe/plasmacutter/proc/use_charge(mob/user, amount = charge_cost, mention_charge = TRUE)
	cell.charge -= min(cell.charge, amount)
	if(mention_charge)
		to_chat(user, "<span class='notice'><b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b></span>")
	update_icon()
	..()

/obj/item/tool/pickaxe/plasmacutter/proc/calc_delay(mob/user)
	var/final_delay = PLASMACUTTER_CUT_DELAY
	if (istype(user))
		if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_ENGI)
			user.visible_message("<span class='notice'>[user] fumbles around figuring out how to use [src].</span>",
			"<span class='notice'>You fumble around figuring out how to use [src].</span>")
			final_delay *= max(1, 4 + (user.mind.cm_skills.engineer * -1)) //Takes twice to four times as long depending on your skill.
		else
			final_delay -= min(PLASMACUTTER_CUT_DELAY,(user.mind.cm_skills.engineer - 3)*5)
	return final_delay

/obj/item/tool/pickaxe/plasmacutter/emp_act(severity)
	cell.use(round(cell.maxcharge / severity))
	update_icon()
	..()

/obj/item/tool/pickaxe/plasmacutter/update_icon(mob/user)
	if(!cell || cell.charge <= 0 || powered == FALSE)
		icon_state = "plasma_cutter_off"
		if(powered)
			playsound(loc, 'sound/weapons/saberoff.ogg', 25)
			powered = FALSE
			to_chat(user, "<span class='warning'>The plasma cutter abruptly shuts down due to a lack of power!</span>")
		force = 5
		damtype = "brute"
		heat_source = 0
		if(user)
			user.SetLuminosity(-2)
		else
			SetLuminosity(0)
	else
		icon_state = "plasma_cutter_on"
		powered = TRUE
		force = 40
		damtype = "fire"
		heat_source = 3800
		if(user)
			user.SetLuminosity(2)
		else
			SetLuminosity(2)


/obj/item/tool/pickaxe/plasmacutter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell))
		if(user.drop_held_item())
			W.loc = src
			var/replace_install = "You replace the cell in [src]"
			if(!cell)
				replace_install = "You install a cell in [src]"
			else
				cell.updateicon()
				user.put_in_hands(cell)
			cell = W
			to_chat(user, "<span class='notice'>[replace_install] <b>Charge Remaining: [cell.charge]/[cell.maxcharge]</b></span>")
			playsound(user, 'sound/weapons/gun_rifle_reload.ogg', 25, 1, 5)
			update_icon()


/obj/item/tool/pickaxe/plasmacutter/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(cell)
			cell.updateicon()
			user.put_in_active_hand(cell)
			cell = null
			playsound(user, 'sound/machines/click.ogg', 25, 1, 5)
			to_chat(user, "<span class='notice'>You remove the cell from [src].</span>")
			update_icon()
			return
	return ..()


/obj/item/tool/pickaxe/plasmacutter/attack(mob/M, mob/user)

	if(powered)
		if(cell.charge < charge_cost * 0.25)
			fizzle_message(user)
		else
			use_charge(user, charge_cost * 0.25)
			playsound(M, cutting_sound, 25, 1)
			eyecheck(user)
			update_icon()
			var/datum/effect_system/spark_spread/spark_system
			spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, M)
			spark_system.attach(M)
			spark_system.start(M)
			to_chat(user, "<span class='notice'>Attack Debug: Damtype: [damtype] Force: [force].</span>")
			return ..()
	return ..()



/obj/item/tool/pickaxe/plasmacutter/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(user.action_busy)
		return

	if(isturf(target))//Melting snow with the plasma cutter.
		var/turf/T = target
		var/turfdirt = T.get_dirt_type()
		if(turfdirt)
			if(turfdirt == DIRT_TYPE_SNOW)
				var/turf/open/snow/ST = T
				if(!ST.slayer)
					return
			if(cell.charge >= charge_cost * PLASMACUTTER_VLOW_MOD && powered)
				to_chat(user, "<span class='notice'>You start melting the snow with [src].</span>")
				playsound(user.loc, 'sound/items/Welder.ogg', 25, 1)
				if(!do_after(user, calc_delay(user) * PLASMACUTTER_VLOW_MOD, TRUE, 5, BUSY_ICON_BUILD))
					return
				var/transf_amt = dirt_amt_per_dig
				if(turfdirt == DIRT_TYPE_SNOW)
					var/turf/open/snow/ST = T
					if(!ST.slayer)
						return
					transf_amt = min(ST.slayer, dirt_amt_per_dig)
					ST.slayer -= transf_amt
					ST.update_icon(1,0)
					to_chat(user, "<span class='notice'>You melt the snow with [src].</span>")
					use_charge(user, name, ST, charge_cost * PLASMACUTTER_VLOW_MOD) //costs 25% normal
				else
					return
			else
				fizzle_message(user)
				return





