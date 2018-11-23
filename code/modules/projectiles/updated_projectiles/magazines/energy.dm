//Energy weapons

/obj/item/ammo_magazine/lasgun
	name = "\improper Lasgun Battery"
	desc = "A specialized high density battery used to power Lasguns."
	var/base_ammo_icon = "m43"
	icon_state = "m43"
	default_ammo = /datum/ammo/energy/lasgun
	max_rounds = 50
	current_rounds = 50
	w_class = 3.0
	gun_type = /obj/item/weapon/gun/energy/lasgun
	caliber = "lasgun"
	flags_magazine = NOFLAGS //Obviously you can't grab bullets from this.

/obj/item/ammo_magazine/lasgun/M43
	name = "\improper M43 lasgun battery"
	desc = "A specialized high density battery used to power the M43 Lasgun."
	base_ammo_icon = "m43"
	icon_state = "m43"
	default_ammo = /datum/ammo/energy/lasgun/M43
	overcharge_ammo = /datum/ammo/energy/lasgun/M43/overcharge
	max_rounds = 50
	current_rounds = 50
	gun_type = /obj/item/weapon/gun/energy/lasgun/M43
	caliber = "M43lasgun"

/obj/item/ammo_magazine/lasgun/M43/New()
	..()
	update_icon()

/obj/item/ammo_magazine/lasgun/M43/emp_act(severity)
	var/amount = round(max_rounds * rand(2,severity) * 0.1)
	current_rounds = max(0,current_rounds - amount)
	update_icon()
	return ..()

/obj/item/ammo_magazine/lasgun/M43/update_icon()
	var/remaining = CEILING((current_rounds / max(1,max_rounds)) * 100, 25)
	icon_state = "[base_ammo_icon]_[remaining]"

/obj/item/ammo_magazine/lasgun/M43/highcap// Large battery
	name = "M43 highcap lasgun battery"
	desc = "An advanced, ultrahigh capacity battery used to power the M43 Lasgun; has nearly fifty percent more charge capacity than standard laspacks."
	base_ammo_icon = "m43_e"
	icon_state = "m43_e"
	max_rounds = 80
	current_rounds = 80
