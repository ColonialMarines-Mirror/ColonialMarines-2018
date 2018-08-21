//items designed as weapon
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/items/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/proc/dust(user) //shitty edition of "dusting" feature
	new /obj/effect/decal/cleanable/ash(get_turf(user))
	cdel(user)