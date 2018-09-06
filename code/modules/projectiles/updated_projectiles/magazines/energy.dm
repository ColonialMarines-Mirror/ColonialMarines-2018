//Energy weapons

/*
/obj/item/weapon_cell
	name = "\improper Weapon Power Cell"
	desc = "A specialized high density battery used to power weapons."
	icon_state = "flametank"
	var/default_ammo = /datum/ammo/energy/lasgun
	var/maxcharge = 50
	var/charge = 50
	var/reload_delay
	w_class = 3.0
	var/gun_type = /obj/item/weapon/gun/energy/lasgun/M43*/

/obj/item/ammo_magazine/lasgun
	name = "\improper Lasgun Battery"
	desc = "A specialized high density battery used to power Lasguns."
	icon_state = "flametank"
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
	icon_state = "flametank"
	default_ammo = /datum/ammo/energy/lasgun/M43
	overcharge_ammo = /datum/ammo/energy/lasgun/M43/overcharge
	max_rounds = 50
	current_rounds = 50
	w_class = 3.0
	gun_type = /obj/item/weapon/gun/energy/lasgun/M43
	caliber = "M43lasgun"

/obj/item/ammo_magazine/lasgun/M43/hotshot// Large battery
	name = "hotshot lasgun battery"
	desc = "A prototype ultrahigh capacity battery used to power the M43 Lasgun."
	icon_state = "flametank_large"
	max_rounds = 100
	current_rounds = 100