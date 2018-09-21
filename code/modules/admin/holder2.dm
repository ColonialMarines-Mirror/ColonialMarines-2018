var/list/admin_datums = list()

/datum/admins
	var/rank			= "Temporary Admin"
	var/client/owner	= null
	var/rights = 0
	var/fakekey			= null

	var/datum/marked_datum

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as

/datum/admins/New(initial_rank = "Temporary Admin", initial_rights = 0, ckey)
	if(!ckey)
		error("Admin datum created without a ckey argument. Datum has been deleted")
		cdel(src)
		return
	admincaster_signature = "Weyland-Yutani Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	rank = initial_rank
	rights = initial_rights
	if (rights & R_DEBUG) //grant profile access
		world.SetConfig("APP/admin", ckey, "role=admin")
	admin_datums[ckey] = src

/datum/admins/proc/associate(client/C)
	if(istype(C))
		owner = C
		owner.holder = src
		owner.add_admin_verbs()	//TODO
		admins |= C

/datum/admins/proc/disassociate()
	if(owner)
		admins -= owner
		owner.remove_admin_verbs()
		owner.holder = null
		owner = null

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

proc/admin_proc()
	if(!check_rights(R_ADMIN)) return
	to_chat(world, "you have enough rights!")

NOTE: it checks usr! not src! So if you're checking somebody's rank in a proc which they did not call
you will have to do something like if(client.holder.rights & R_ADMIN) yourself.
*/
/proc/check_rights(rights_required, show_msg=1)
	if(usr && usr.client)
		if(rights_required)
			if(usr.client.holder)
				if(rights_required & usr.client.holder.rights)
					return 1
				else
					if(show_msg)
						to_chat(usr, "<font color='red'>Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required," ")].</font>")
		else
			if(usr.client.holder)
				return 1
			else
				if(show_msg)
					to_chat(usr, "<font color='red'>Error: You are not an admin.</font>")
	return 0

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr && usr.client)
		if(usr.client.holder)
			if(!other || !other.holder)
				return 1
			if(usr.client.holder.rights != other.holder.rights)
				if( (usr.client.holder.rights & other.holder.rights) == other.holder.rights )
					return 1	//we have all the rights they have and more
		to_chat(usr, "<font color='red'>Error: Cannot proceed. They have more or equal rights to us.</font>")
	return 0

/client/proc/deadmin()
	admin_datums -= ckey
	if(holder)
		holder.disassociate()
		cdel(holder)
		holder = null
	return 1

/client/proc/readmin()
	if(config.admin_legacy_system)
		load_admin_ranks()

		//load text from file
		var/list/Lines = file2list("config/admins.txt")

		var/found = FALSE
		//process each line seperately
		for(var/line in Lines)
			if(!length(line))
				continue
			if(copytext(line,1,2) == "#")
				continue

			//Split the line at every "-"
			var/list/List = text2list(line, "-")
			if(!List.len)
				continue

			//ckey is before the first "-"
			var/dckey = ckey(List[1])
			if(!dckey )
				continue
			if(dckey != ckey)
				continue
			//rank follows the first "-"
			var/rank = ""
			if(List.len >= 2)
				rank = ckeyEx(List[2])
				found = TRUE



			//load permissions associated with this rank
			if(found)
				var/rights = admin_ranks[rank]
				var/datum/admins/D = new /datum/admins(rank, rights, dckey)
				D.associate(directory[dckey])

	else
		//The current admin system uses SQL

		establish_db_connection()
		if(!dbcon.IsConnected())
			error("Failed to connect to database in load_admins(). Reverting to legacy system.")
			log_misc("Failed to connect to database in load_admins(). Reverting to legacy system.")
			config.admin_legacy_system = 1
			load_admins()
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, rank, level, flags FROM erro_admin")
		query.Execute()
		while(query.NextRow())
			var/dckey = query.item[1]
			var/rank = query.item[2]
			if(rank == "Removed")	continue	//This person was de-adminned. They are only in the admin list for archive purposes.

			var/rights = query.item[4]
			if(istext(rights))
				rights = text2num(rights)
			if(dckey == ckey)
				var/datum/admins/D = new /datum/admins(rank, rights, dckey)
				D.associate(directory[dckey])
				break
		if(!admin_datums)
			error("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			log_misc("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			config.admin_legacy_system = 1
			load_admins()
			return
