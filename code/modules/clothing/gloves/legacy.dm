/*

Left-overs from old Bay.

*/
/obj/item/clothing/gloves/captain
	name = "captain's gloves"
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	icon_state = "captain"
	item_state = "captain"


/obj/item/clothing/gloves/yellow
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "lightbrown"
	item_state = "lightbrown"
	siemens_coefficient = 0
	permeability_coefficient = 0.05


/obj/item/clothing/gloves/fyellow
	name = "budget insulated gloves"
	desc = "These gloves are cheap copies of the coveted gloves, no way this can end badly."
	icon_state = "lightbrown"
	item_state = "lightbrown"
	siemens_coefficient = 1
	permeability_coefficient = 0.05

/obj/item/clothing/gloves/fyellow/New()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)
	return ..()


/obj/item/clothing/gloves/black
	name = "black gloves"
	desc = "These gloves are fire-resistant."
	icon_state = "black"
	item_state = "black"


/obj/item/clothing/gloves/orange
	name = "orange gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange"
	item_state = "orange"


/obj/item/clothing/gloves/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"
	item_state = "rainbow"


/obj/item/clothing/gloves/green
	name = "green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"
	item_state = "green"


/obj/item/clothing/gloves/light_brown
	name = "light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"
	item_state = "lightbrown"


/obj/item/clothing/gloves/brown
	name = "brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"
	item_state = "brown"


/obj/item/clothing/gloves/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "latex"
	item_state = "latex"


/obj/item/clothing/gloves/swat
	name = "\improper SWAT Gloves"
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	icon_state = "black"
	item_state = "swat"


/obj/item/clothing/gloves/combat 
	name = "combat gloves"
	desc = "These tactical gloves are somewhat fire and impact resistant."
	icon_state = "black"
	item_state = "swat"


/obj/item/clothing/gloves/botanic_leather
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state = "leather"


/obj/item/clothing/gloves/boxing
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/wirecutters) || istype(W, /obj/item/tool/surgery/scalpel))
		to_chat(user, "<span class='notice'>That won't work.</span>"	)
		return
	return ..()


/obj/item/clothing/gloves/boxing/green
	icon_state = "boxinggreen"
	item_state = "boxinggreen"


/obj/item/clothing/gloves/boxing/blue
	icon_state = "boxingblue"
	item_state = "boxingblue"


/obj/item/clothing/gloves/boxing/yellow
	icon_state = "boxingyellow"
	item_state = "boxingyellow"