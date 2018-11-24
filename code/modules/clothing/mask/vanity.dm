/*

Cosmetic admin-only items.

*/
/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEFACE|HIDEALLHAIR|HIDEEYES|HIDEEARS
	w_class = 2
	siemens_coefficient = 0.9
	flags_armor_protection = HEAD|FACE|EYES


/obj/item/clothing/mask/horse
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEFACE|HIDEALLHAIR|HIDEEYES|HIDEEARS
	flags_armor_protection = HEAD|FACE|EYES
	w_class = 2
	var/voicechange = 0
	siemens_coefficient = 0.9


/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	icon_state = "sexyclown"
	item_state = "sexyclown"


/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"
	flags_armor_protection = HEAD|FACE|EYES


/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon_state = "sexymime"
	item_state = "sexymime"


/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"


/obj/item/clothing/mask/gas/owl
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"


/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out phoron but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "gas_mask"
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 75, rad = 0)
	flags_armor_protection = HEAD|FACE


/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchador"
	flags_inv_hide = HIDEFACE|HIDEALLHAIR
	flags_armor_protection = HEAD|FACE
	w_class = 2
	siemens_coefficient = 3.0


/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon_state = "luchador_tecnicos"


/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon_state = "luchador_rudos"