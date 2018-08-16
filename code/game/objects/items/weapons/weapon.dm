
//items designed as weapon
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/items/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/weapon/proc/consume(user)
	new /obj/effect/decal/cleanable/ash(get_turf(user))
	cdel(user)