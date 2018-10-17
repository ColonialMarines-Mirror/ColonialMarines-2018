/obj/item/device/radio/detpack
	name = "detonation pack"
	desc = "Programmable remotely triggered 'smart' explosive used for demolitions and impromptu booby traps. Can be set to breach or demolition detonation patterns."
	gender = PLURAL
	icon = 'icons/obj/det.dmi'
	icon_state = "detpack_off"
	item_state = "plasticx"
	flags_item = NOBLUDGEON
	frequency = 1457
	w_class = 2.0
	origin_tech = "syndicate=2"
	on = FALSE
	layer = MOB_LAYER - 0.1
	var/armed = FALSE
	var/timer = 10.0
	var/code = 2
	var/det_mode = FALSE //FALSE for breach, TRUE for demolition.
	var/atom/plant_target = null //which atom the detpack is planted on
	var/target_drag_delay = null //store this for restoration later

/obj/item/device/radio/detpack/examine(mob/user)
	. = ..()
	var/details
	if(timer)
		details += "Its timer has [timer] seconds left."
	if(det_mode)
		details += " It appears set to demolition mode."
	else
		details += " It appears set to breaching mode."
	if(armed)
		details += " <b>It is armed!</b>"
	to_chat(user, "<span class='warning'>[details]</span>")


/obj/item/device/radio/detpack/Dispose()
	processing_timers.Remove(src)
	nullvars()
	. = ..()

/obj/item/device/radio/detpack/update_icon()
	if(!anchored)
		if(on)
			icon_state = "detpack_on"
			if(armed)
				icon_state = "detpack_armed"
		else
			icon_state = "detpack_off"
	else
		if(on)
			icon_state = "detpack_set_on"
			if(armed)
				icon_state = "detpack_set_armed"
		else
			icon_state = "detpack_set_off"

/obj/item/device/radio/detpack/attackby(obj/item/W as obj, mob/user as mob)
	. = ..()
	if(istype(W, /obj/item/device/multitool))
		if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_METAL)
			user.visible_message("<span class='notice'>[user] fumbles around figuring out how to use the [src].</span>",
			"<span class='notice'>You fumble around figuring out how to use [src].</span>")
			var/fumbling_time = 30
			if(!do_after(user, fumbling_time, TRUE, 5, BUSY_ICON_BUILD))
				return
			if(prob((SKILL_ENGINEER_METAL - user.mind.cm_skills.engineer) * 20))
				to_chat(user, "<font color='danger'>After several seconds of your clumsy meddling the [src] buzzes angrily as if offended. You have a <b>very</b> bad feeling about this.</font>")
				timer = 0 //Oops. Now you fucked up. Immediate detonation.
		user.visible_message("<span class='notice'>[user] begins disarming [src] with [W].</span>",
		"<span class='notice'>You begin disarming [src] with [W].</span>")
		if(do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD))
			user.visible_message("<span class='notice'>[user] disarms [src].</span>",
			"<span class='notice'>You disarm [src].</span>")
			armed = 0
			update_icon()

/obj/item/device/radio/detpack/attack_hand(mob/user as mob)
	if(armed)
		to_chat(user, "<font color='warning'>Active anchor bolts are holding it in place! Disarm [src] first to remove it!</font>")
		return
	if(anchored)
		user.visible_message("<span class='notice'>[user] begins unsecuring [src] from [plant_target].</span>",
		"<span class='notice'>You begin unsecuring [src] from [plant_target].</span>")
		if(do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD))
			user.visible_message("<span class='notice'>[user] unsecures [src] from [plant_target].</span>",
			"<span class='notice'>You unsecure [src] from [plant_target].</span>")
			anchored = FALSE
			nullvars()
			update_icon()
	return ..()

/obj/item/device/radio/detpack/proc/nullvars()
	if(istype(plant_target, /atom/movable))
		var/atom/movable/T = plant_target
		if(target_drag_delay && T.drag_delay == 3)
			T.drag_delay = target_drag_delay //reset the drag delay of whatever we attached the detpack to
	plant_target = null //null everything out now
	target_drag_delay = null

/obj/item/device/radio/detpack/receive_signal(datum/signal/signal)
	if(signal?.encryption != code || !on)
		return

	if(!armed)
		if(!anchored) //has to be planted on something to begin detonating.
			return
		armed = TRUE
		//bombtick()
		processing_timers.Add(src)
		to_chat(world, "<font color='red'>DEBUG: Detpack Triggered: [loc]</font>")
	else
		armed = FALSE
		to_chat(world, "<font color='red'>DEBUG: Detpack Disarmed: [loc]</font>")
		update_icon()

	if(master && wires & 1)
		master.receive_signal()
	return

/obj/item/device/radio/detpack/Topic(href, href_list)
	//..()
	if(usr.stat || usr.is_mob_restrained())
		return
	if(((istype(usr, /mob/living/carbon/human) && ((!( ticker ) || (ticker && ticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(master) || (in_range(src, usr) && istype(loc, /turf)))))
		usr.set_interaction(src)
		if(href_list["freq"])
			var/new_frequency = (frequency + text2num(href_list["freq"]))
			if(new_frequency < 1200 || new_frequency > 1600)
				new_frequency = sanitize_frequency(new_frequency)
			set_frequency(new_frequency)
		else
			if(href_list["code"])
				code += text2num(href_list["code"])
				code = round(code)
				code = min(100, code)
				code = max(1, code)
			else if(href_list["det_mode"])
				det_mode = !( det_mode )
				update_icon()
			else if(href_list["power"])
				on = !( on )
				update_icon()
			else
				if(href_list["timer"])
					timer += text2num(href_list["timer"])
					timer = round(timer)
					timer = min(300, timer)
					timer = max(10, timer)
		if(!( master ))
			if(istype(loc, /mob))
				attack_self(loc)
			else
				for(var/mob/M in viewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(istype(master.loc, /mob))
				attack_self(master.loc)
			else
				for(var/mob/M in viewers(1, master))
					if(M.client)
						attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/device/radio/detpack/attack_self(mob/user as mob, flag1)

	if(!istype(user, /mob/living/carbon/human))
		return
	if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_METAL)
		user.visible_message("<span class='notice'>[user] fumbles around figuring out how to use [src].</span>",
		"<span class='notice'>You fumble around figuring out how to use [src].</span>")
		var/fumbling_time = 20
		if(!do_after(user, fumbling_time, TRUE, 5, BUSY_ICON_BUILD))
			return
	user.set_interaction(src)
	var/dat = {"<TT>
<A href='?src=\ref[src];power=1'>Turn [on ? "Off" : "On"]</A><BR>

<B>Current Detonation Mode:</B> [det_mode ? "Demolition" : "Breach"]<BR>
<A href='?src=\ref[src];det_mode=1'><B>Set Detonation Mode:</B> [det_mode ? "Breach" : "Demolition"]</A><BR>

<B>Frequency/Code for Detpack:</B><BR>
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A>
[format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

<B>Signal Code:</B><BR>
<A href='byond://?src=\ref[src];code=-5'>-</A>
<A href='byond://?src=\ref[src];code=-1'>-</A> [code]
<A href='byond://?src=\ref[src];code=1'>+</A>
<A href='byond://?src=\ref[src];code=5'>+</A><BR>

<B>Timer (Max 300 seconds, Min 10 seconds):</B><BR>
<A href='byond://?src=\ref[src];timer=-50'>-</A>
<A href='byond://?src=\ref[src];timer=-10'>-</A>
<A href='byond://?src=\ref[src];timer=-5'>-</A>
<A href='byond://?src=\ref[src];timer=-1'>-</A> [timer]
<A href='byond://?src=\ref[src];timer=1'>+</A>
<A href='byond://?src=\ref[src];timer=5'>+</A>
<A href='byond://?src=\ref[src];timer=10'>+</A>
<A href='byond://?src=\ref[src];timer=50'>+</A><BR>

</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return


/obj/item/device/radio/detpack/afterattack(atom/target, mob/user, flag)
	if(!flag)
		return FALSE
	if(istype(target, /obj/structure/ladder) || istype(target, /obj/item) || istype(target, /turf/open) || istype(target, /mob))
		return FALSE
	if(istype(target, /obj/effect) || istype(target, /obj/machinery))
		var/obj/O = target
		if(O.unacidable)
			return FALSE
	if(istype(target, /turf/closed/wall))
		var/turf/closed/wall/W = target
		if(W.hull)
			return FALSE
	if(istype(target, /obj/structure/window))
		var/obj/structure/window/W = target
		if(!W.damageable)
			to_chat(user, "<span class='warning'>[W] is much too tough for you to do anything to it with [src]</span>.")
			return FALSE
	if(istype(target, /atom/movable))
		var/atom/movable/T = target
		if(T.drag_delay < 3) //Anything with a fast drag delay we need to modify to avoid kamikazi tactics
			target_drag_delay = T.drag_delay
			T.drag_delay = 3

	if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_METAL)
		user.visible_message("<span class='notice'>[user] fumbles around figuring out how to use [src].</span>",
		"<span class='notice'>You fumble around figuring out how to use [src].</span>")
		var/fumbling_time = 50
		if(!do_after(user, fumbling_time, TRUE, 5, BUSY_ICON_BUILD))
			return

	user.visible_message("<span class='warning'>[user] is trying to plant [name] on [target]!</span>",
	"<span class='warning'>You are trying to plant [name] on [target]!</span>")
	bombers += "[key_name(user)] attached [src] to [target.name]."

	if(do_mob(user, target, 30, BUSY_ICON_HOSTILE))
		user.drop_held_item()
		plant_target = target
		playsound(src.loc, 'sound/weapons/mine_armed.ogg', 25, 1)
		var/location
		if (isturf(target))
			location = target
		if (isobj(target))
			location = target.loc

		forceMove(location)

		message_admins("[key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>) with [timer] second fuse",0,1)
		log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

		//target.overlays += image('icons/obj/items/assemblies.dmi', "plastic-explosive2")
		user.visible_message("<span class='warning'>[user] plants [name] on [target]!</span>",
		"<span class='warning'>You plant [name] on [target]! Timer set for [timer] seconds.</span>")
		anchored = TRUE
		update_icon()

/obj/item/device/radio/detpack/process()
	if(!on) //need to be active and armed.
		return
	if(!armed)
		if(timer < 10) //reset to minimum 10 seconds; no 'cooking' with aborted detonations.
			timer = 10
		to_chat(world, "<font color='red'>DEBUG: Detpack Detonation Aborted.</font>")
		processing_timers.Remove(src)
		return
	if(timer)
		timer--
		if(timer < 11)
			playsound(src.loc, 'sound/weapons/mine_tripped.ogg', 150 + (timer-timer*2)*10, FALSE)
		else
			playsound(src.loc, 'sound/weapons/mine_tripped.ogg', 50, FALSE)
		to_chat(world, "<font color='red'>DEBUG: Detpack Timer: [timer]</font>")
		return
	else
		playsound(src.loc, 'sound/weapons/ring.ogg', 200, FALSE)
		to_chat(world, "<font color='red'>DEBUG: Detpack Detonated: [timer]</font>")
		if(det_mode == TRUE) //If we're on demolition mode, big boom.
			explosion(loc, 2, 4, 5, 6)
		else //if we're not, focused boom.
			explosion(loc, 1, 1, 2, 3)
		if(plant_target)
			plant_target.ex_act(1)
			if(isobj(plant_target))
				cdel(plant_target)
		cdel(src)
		processing_timers.Remove(src)
	return

/obj/item/device/radio/detpack/attack(mob/M as mob, mob/user as mob, def_zone)
	return
