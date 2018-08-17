/client/verb/looc(msg as text)
	set name = "LOOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return
	if(usr.talked == 2)
		usr << "\red Your spam has been consumed for it's nutritional value."
		return
	if((usr.talked == 1) && (usr.chatWarn >= 5))
		usr.talked = 2
		usr << "\red You have been flagged for spam.  You may not speak for at least [usr.chatWarn] seconds (if you spammed alot this might break and never unmute you).  This number will increase each time you are flagged for spamming"
		if(usr.chatWarn >10)
			message_admins("[key_name(usr, usr.client)] is spamming like a dirty bitch, their current chatwarn is [usr.chatWarn]. ")
		spawn(usr.chatWarn*10)
			usr.talked = 0
			usr << "\blue You may now speak again."
			usr.chatWarn++
		return
	else if(usr.talked == 1)
		usr << "\blue You just said something, take a breath."
		usr.chatWarn++
		return

	if(!mob)
		return
	if(IsGuestKey(key))
		src << "Guests may not use LOOC."
		return

	msg = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)
		return

	if(!(prefs.toggles_chat & CHAT_LOOC))
		src << "\red You have LOOC muted."
		return

	if(!holder)
		if(!looc_allowed)
			src << "\red LOOC is globally muted"
			return
		if(!dlooc_allowed && (mob.stat == DEAD))
			usr << "\red LOOC for dead mobs has been turned off."
			return
		if(prefs.muted & MUTE_OOC)
			src << "\red You cannot use LOOC (muted)."
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in LOOC: [msg]")
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")

	var/list/heard = get_mobs_in_view(7, src.mob)
	var/mob/S = src.mob
	var/display_name = S.key

	if(S.stat != DEAD)
		display_name = S.name

	for(var/mob/M in heard) // Handle non-admins
		if(!M.client)
			continue
		var/client/C = M.client
		if (C in admins)
			continue //they are handled after that

		if(C.prefs.toggles_chat & CHAT_LOOC)
			if(holder)
				if(holder.fakekey)
					if(C.holder)
						display_name = "[holder.fakekey]/([src.key])"
					else
						display_name = holder.fakekey
			C << "<font color='#6699CC'><span class='ooc'><span class='prefix'>LOOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"

	display_name = S.key // Now handle admins
	if(S.stat != DEAD)
		display_name = "[S.name]/([S.key])"

	for(var/client/C in admins)
		if(C.prefs.toggles_chat & CHAT_LOOC)
			var/prefix = "(R)LOOC"
			if (C.mob in heard)
				prefix = "LOOC"
			C << "<font color='#6699CC'><span class='ooc'><span class='prefix'>[prefix]:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"
	usr.talked = 1
	spawn (5)
		if (usr.talked ==2)
			return
		usr.talked = 0