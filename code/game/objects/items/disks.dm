/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items/disk.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"

/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	w_class = 1

/obj/item/disk/nuclear/ex_act(severity) //Should make it indestructable
	return

/obj/item/disk/nuclear/fire_act(exposed_temperature, exposed_volume)
	return

/obj/item/disk/nuclear/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/claymore/highlander))
		var/obj/item/weapon/claymore/highlander/H = I
		if(H.nuke_disk)
			user << "<span class='notice'>Wait... what?</span>"
			cdel(H.nuke_disk)
			H.nuke_disk = null
			return
		user << "<span class='userdanger'>You've got the disk! Defend it with your life!</span>"
		send_to_playing_players("<span class='warning'>[user] captures [src]!</span>")
		forceMove(H)
		H.nuke_disk = src
		return TRUE
	return ..()