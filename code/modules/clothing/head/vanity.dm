/*

Cosmetic admin-only items.

*/
/obj/item/clothing/head/centcomm
	name = "\improper CentComm hat"
	desc = "It's good to be emperor."
	icon_state = "centcomm"


/obj/item/clothing/head/hairflower
	name = "hair flower pin"
	desc = "Smells nice."
	icon_state = "hairflower"


/obj/item/clothing/head/wig
	name = "powdered wig"
	desc = "A powdered wig."
	icon_state = "wig"


/obj/item/clothing/head/tophat
	name = "top-hat"
	desc = "It's an amish looking hat."
	icon_state = "tophat"


/obj/item/clothing/head/redcoat
	name = "redcoat's hat"
	desc = "It's a red hat."
	icon_state = "redcoat"


/obj/item/clothing/head/mailman
	name = "station cap"
	desc = "Today's delivery is here!"
	icon_state = "mailman"


/obj/item/clothing/head/plaguedoctor
	name = "plague doctor's hat"
	desc = "These were once used by Plague doctors. They're pretty much useless."
	icon_state = "plaguedoctor"


/obj/item/clothing/head/hastur
	name = "hastur's hood"
	desc = "It's unspeakably stylish"
	icon_state = "hastur"
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	flags_armor_protection = HEAD|FACE|EYES


/obj/item/clothing/head/syndicate
	name = "red space-helmet replica"
	icon_state = "syndicate"
	item_state = "syndicate"
	desc = "A plastic replica of a syndicate agent's space helmet, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	flags_inventory = COVEREYES|COVERMOUTH
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = HEAD|FACE|EYES
	anti_hug = 1


/obj/item/clothing/head/cueball
	name = "cueball helmet"
	desc = "A large, featureless white orb mean to be worn on your head. How do you even see out of this thing?"
	icon_state = "cueball"
	flags_inventory = COVEREYES|COVERMOUTH
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = HEAD|FACE|EYES


/obj/item/clothing/head/justice
	name = "justice hat"
	desc = "fight for what's righteous!"
	icon_state = "justicered"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR


/obj/item/clothing/head/justice/blue
	icon_state = "justiceblue"


/obj/item/clothing/head/justice/yellow
	icon_state = "justiceyellow"


/obj/item/clothing/head/justice/green
	icon_state = "justicegreen"


/obj/item/clothing/head/justice/pink
	icon_state = "justicepink"


/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"


/obj/item/clothing/head/bowler
	name = "bowler hat"
	desc = "For the gentleman of distinction."
	icon_state = "bowler"


/obj/item/clothing/head/beaver
	name = "beaver hat"
	desc = "Soft felt makes this hat both comfortable and elegant."
	icon_state = "beaver"


/obj/item/clothing/head/boater
	name = "boater hat"
	icon_state = "boater_hat"
	item_state = "boater_hat"
	desc = "The ultimate in summer fashion."


/obj/item/clothing/head/fedora
	name = "\improper fedora"
	desc = "A sharp, stylish hat."
	icon_state = "fedora"


/obj/item/clothing/head/trilby
	name = "\improper trilby"
	desc = "A sharp, stylish hat with a feather."
	icon_state = "trilby"


/obj/item/clothing/head/fez
	name = "\improper fez"
	desc = "You should wear a fez. Fezzes are cool."
	icon_state = "fez"


/obj/item/clothing/head/witch
	name = "witch costume wig"
	desc = "Eeeee~heheheheheheh!"
	icon_state = "witch"
	flags_inv_hide = HIDEALLHAIR


/obj/item/clothing/head/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon_state = "chicken"
	flags_inv_hide = HIDEALLHAIR
	flags_armor_protection = HEAD|FACE|EYES


/obj/item/clothing/head/xeno
	name = "xeno helmet"
	desc = "A helmet made out of chitinous alien hide."
	icon_state = "xeno"
	flags_inventory = COVERMOUTH|COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = HEAD|FACE|EYES
	anti_hug = 10


/obj/item/clothing/head/cakehat
	name = "cake-hat"
	desc = "It's tasty looking!"
	icon_state = "cake"
	flags_inventory = COVEREYES
	flags_armor_protection = EYES


/obj/item/clothing/head/pumpkin
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = "pumpkin"
	flags_inventory = COVEREYES|COVERMOUTH
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = HEAD|EYES
	w_class = 3
	anti_hug = 1
	var/brightness_on = 2
	var/on = 0

/obj/item/clothing/head/pumpkin/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in [user.loc]")
		return
	if(icon_state == item_state)
		on = 1
		item_state = "[icon_state]_on"
		user.SetLuminosity(brightness_on)
	else
		on = 0
		item_state = "[icon_state]"
		user.SetLuminosity(-brightness_on)

/obj/item/clothing/head/pumpkin/pickup(mob/user)
	. = ..()
	if(on)
		user.SetLuminosity(brightness_on)
		SetLuminosity(0)

/obj/item/clothing/head/pumpkin/dropped(mob/user)
	. = ..()
	if(on)
		user.SetLuminosity(-brightness_on)
		SetLuminosity(brightness_on)

/obj/item/clothing/head/pumpkin/Dispose()
	if(ismob(src.loc))
		src.loc.SetLuminosity(-brightness_on)
	else
		SetLuminosity(0)
	return ..()


/obj/item/clothing/head/rabbit
	name = "rabbit ears"
	desc = "Wearing these makes you looks useless, and only good for your sex appeal."
	icon_state = "rabbit"


/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = "kitty"
	flags_armor_protection = 0
	siemens_coefficient = 1.5
	var/icon/ears = new /icon("icon" = 'icons/mob/head_0.dmi', "icon_state" = "kitty")
	var/icon/earbit = new /icon("icon" = 'icons/mob/head_0.dmi', "icon_state" = "kittyinner")

/obj/item/clothing/head/kitty/update_icon(mob/living/carbon/human/user, remove = FALSE)
	if(!istype(user)) 
		to_chat(world, "Not an user")
		return
	
	ears = new /icon("icon" = 'icons/mob/head_0.dmi', "icon_state" = "kitty")
	ears.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)
	ears.Blend(earbit, ICON_OVERLAY)

	if(user.head && istype(user.head, /obj/item/clothing/head/kitty) && !remove)
		user.overlays.Add(ears)
	else
		user.overlays.Remove(ears)

/obj/item/clothing/head/kitty/dropped(mob/living/carbon/human/user)
	update_icon(user, remove = TRUE)

/obj/item/clothing/head/kitty/equipped(mob/living/carbon/human/user)
	if(user.head && istype(user.head, /obj/item/clothing/head/kitty))
		update_icon(user)