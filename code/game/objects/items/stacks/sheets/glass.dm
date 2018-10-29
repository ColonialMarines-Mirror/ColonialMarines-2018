/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Phoron Glass Sheets
 *		Reinforced Phoron Glass Sheets (AKA Holy fuck strong windows)
 */

/*
 * Glass sheets
 */
var/global/list/datum/stack_recipe/glass_recipes = list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/base/unanchored, one_per_turf = 2, on_floor = TRUE, skill_req = SKILL_CONSTRUCTION_METAL), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/base/fulltile/unanchored, 4, time = 20, one_per_turf = 1, on_floor = TRUE, skill_req = SKILL_CONSTRUCTION_METAL) \
	)

/obj/item/stack/sheet/glass
	name = "glass"
	desc = "Glass is a non-crystalline solid, made out of silicate, the primary constituent of sand. It is valued for its transparency, albeit it is not too resistant to damage."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	matter = list("glass" = 3750)
	origin_tech = "materials=1"
	stack_id = "glass sheet"

/obj/item/stack/sheet/glass/cyborg
	matter = null

/obj/item/stack/sheet/glass/New()
	recipes = glass_recipes
	return ..()

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user)
	add_fingerprint(user)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if (!(CC.get_amount() >= 5 && get_amount() >= 1))
			to_chat(user, "<span class='warning'>You need five lengths of coil and one sheet of glass to make wired glass.</span>")
			return
		CC.use(5)
		use(1)
		to_chat(user, "<span class='notice'>You attach wire to the [name].</span>")
		var/obj/item/stack/light_w/new_tile = new(get_turf(user))
		new_tile.add_fingerprint(user)
	else if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V  = W
		if (V.get_amount() < 1 || get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one rod and one sheet of glass to make reinforced glass.</span>")
			return
		var/obj/item/stack/sheet/rglass/RG = new(get_turf(user))
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		var/obj/item/stack/sheet/glass/G = src
		var/replace = (user.get_inactive_hand()==src)
		V.use(1)
		use(1)
		if (G.disposed && replace)
			user.put_in_hands(RG)
	..()

/*
 * Reinforced glass sheets
 */

var/global/list/datum/stack_recipe/reinforced_glass_recipes = list ( \
	new/datum/stack_recipe("windoor frame", /obj/structure/windoor_assembly, 5, time = 20, on_floor = TRUE, one_per_turf = 2, skill_req = SKILL_CONSTRUCTION_ADVANCED), \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/base/reinforced/unanchored, on_floor = TRUE, one_per_turf = 1, skill_req = SKILL_CONSTRUCTION_METAL), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/base/reinforced/fulltile/unanchored, 4, time = 10, on_floor = TRUE, one_per_turf = 1, skill_req = SKILL_CONSTRUCTION_METAL) \
)

/obj/item/stack/sheet/rglass
	name = "reinforced glass"
	desc = "Reinforced glass is made out of squares of regular silicate glass layered on a metallic rod matrice. This glass is more resistant to direct impacts, even if it may crack."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	stack_id = "reinf glass sheet"
	matter = list("metal" = 1875,"glass" = 3750)
	origin_tech = "materials=2"

/obj/item/stack/sheet/rglass/cyborg
	matter = null

/obj/item/stack/sheet/rglass/New()
	recipes = reinforced_glass_recipes
	return ..()

/*
 * Phoron Glass sheets
 */
var/global/list/datum/stack_recipe/pglass_recipes = list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/base/phoron/unanchored, on_floor = TRUE, one_per_turf = 2, skill_req = SKILL_CONSTRUCTION_PLASTEEL), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/base/phoron/fulltile/unanchored, 4, time = 10, on_floor = TRUE, one_per_turf = 1, skill_req = SKILL_CONSTRUCTION_PLASTEEL) \
)

/obj/item/stack/sheet/phoronglass
	name = "phoron glass"
	desc = "Phoron glass is a silicate-phoron alloy turned into a non-crystalline solid. It is transparent just like glass, even if visibly tainted pink, and very resistant to damage and heat."
	singular_name = "phoron glass sheet"
	icon_state = "sheet-phoronglass"
	matter = list("glass" = 7500)
	origin_tech = "materials=3;phorontech=2"

/obj/item/stack/sheet/phoronglass/New()
	recipes = pglass_recipes
	return ..()


/obj/item/stack/sheet/phoronglass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W,/obj/item/stack/rods))
		var/obj/item/stack/rods/V  = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/phoronrglass/RG = new (get_turf(user))
			RG.add_fingerprint(user)
			RG.add_to_stacks(user)
			V.use(1)
			var/replace = (user.get_inactive_hand()==src)
			use(1)
			if (disposed && !RG && replace)
				user.put_in_hands(RG)
		else
			to_chat(user, "<span class='warning'>You need one rod and one sheet of plasma glass to make reinforced plasma glass!</span>")
			return
	else
		return ..()

/*
 * Reinforced phoron glass sheets
 */

var/global/list/datum/stack_recipe/prglass_recipes = list ( \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/base/phoron/reinforced/unanchored, on_floor = TRUE, one_per_turf = 2, skill_req = SKILL_CONSTRUCTION_PLASTEEL), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/base/phoron/reinforced/fulltile/unanchored, 4, time = 10, on_floor = TRUE, one_per_turf = 1, skill_req = SKILL_CONSTRUCTION_PLASTEEL) \
)

/obj/item/stack/sheet/phoronrglass
	name = "reinforced phoron glass"
	desc = "Reinforced phoron glass is made out of squares of silicate-phoron alloy glass layered on a metallic rod matrice. It is insanely resistant to both physical shock and heat."
	singular_name = "reinforced phoron glass sheet"
	icon_state = "sheet-phoronrglass"
	matter = list("glass" = 7500,"metal" = 1875)
	origin_tech = "materials=4;phorontech=2"

/obj/item/stack/sheet/phoronrglass/New()
	recipes = prglass_recipes
	return ..()