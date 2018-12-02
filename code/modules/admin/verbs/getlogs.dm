/*
	HOW DO I LOG RUNTIMES?
	Firstly, start dreamdeamon if it isn't already running. Then select "world>Log Session" (or press the F3 key)
	navigate the popup window to the data/logs/runtime/ folder from where your tgstation .dmb is located.
	(you may have to make this folder yourself)

	OPTIONAL: 	you can select the little checkbox down the bottom to make dreamdeamon save the log everytime you
				start a world. Just remember to repeat these steps with a new name when you update to a new revision!

	Save it with the name of the revision your server uses (e.g. r3459.txt).
	Game Masters will now be able to grant access any runtime logs you have archived this way!
	This will allow us to gather information on bugs across multiple servers and make maintaining the TG
	codebase for the entire /TG/station commuity a TONNE easier :3 Thanks for your help!
*/


//This proc allows Game Masters to grant a client access to the .getruntimelog verb
//Permissions expire at the end of each round.
//Runtimes can be used to meta or spot game-crashing exploits so it's advised to only grant coders that
//you trust access. Also, it may be wise to ensure that they are not going to play in the current round.
/client/proc/giveruntimelog()
	set name = ".giveruntimelog"
	set desc = "Give somebody access to any session logfiles saved to the /log/runtime/ folder."
	set category = null

	if(!src.holder)
		to_chat(src, "<font color='red'>Only Admins may use this command.</font>")
		return

	var/client/target = input(src,"Choose somebody to grant access to the server's runtime logs (permissions expire at the end of each round):","Grant Permissions",null) as null|anything in clients
	if(!istype(target,/client))
		to_chat(src, "<font color='red'>Error: giveruntimelog(): Client not found.</font>")
		return

	target.verbs |= /client/proc/getruntimelog
	to_chat(target, "<font color='red'>You have been granted access to runtime logs. Please use them responsibly or risk being banned.</font>")
	return


//This proc allows download of runtime logs saved within the data/logs/ folder by dreamdeamon.
//It works similarly to show-server-log.
/client/proc/getruntimelog()
	set name = ".getruntimelog"
	set desc = "Retrieve any session logfiles saved by dreamdeamon."
	set category = null

	var/path = browse_files("data/logs/runtime/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	src << run( file(path) )
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	return


//This proc allows download of past server logs saved within the data/logs/ folder.
//It works similarly to show-server-log.
/client/proc/getserverlog()
	set name = ".getserverlog"
	set desc = "Fetch logfiles from data/logs"
	set category = null

	var/path = browse_files("data/logs/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	src << run( file(path) )
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	return


//Other log stuff put here for the sake of organisation

//Shows today's server log
/datum/admins/proc/view_txt_log()
	set category = "Admin"
	set name = "Show Server Log"
	set desc = "Shows today's server log."

	var/path = "data/logs/[time2text(world.realtime,"YYYY/MM-Month/DD-Day")].log"
	if( fexists(path) )
		src << run( file(path) )
	else
		var/pathyesteday = "data/logs/[time2text(world.realtime-400000,"YYYY/MM-Month/DD-Day")].log" // roughly 12 hours before this, should cover for most issues
		if( fexists(pathyesteday) )
			src << run( file(pathyesteday) )
		else
			to_chat(src, "<font color='red'>Error: view_txt_log(): File not found/Invalid path([path]) or path([pathyesteday]).</font>")
			return
	feedback_add_details("admin_verb","VTL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

//Shows today's attack log
/datum/admins/proc/view_atk_log()
	set category = "Admin"
	set name = "Show Server Attack Log"
	set desc = "Shows today's server attack log."

	var/path = "data/logs/[time2text(world.realtime,"YYYY/MM-Month/DD-Day")] Attack.log"
	if( fexists(path) )
		src << run( file(path) )
	else
		to_chat(src, "<font color='red'>Error: view_atk_log(): File not found/Invalid path([path]).</font>")
		return
	usr << run( file(path) )
	feedback_add_details("admin_verb","SSAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

//This proc allows download of past server logs saved within the data/logs/ folder.
/client/proc/getserverlogs()
	set name = "Get Server Logs"
	set desc = "View/retrieve logfiles."
	set category = "Admin"

	browseserverlogs()

/client/proc/getcurrentlogs()
	set name = "Get Current Logs"
	set desc = "View/retrieve logfiles for the current round."
	set category = "Admin"

	browseserverlogs("[log_directory]/")

/client/proc/browseserverlogs(path = "data/logs/")
	path = browse_files(path)
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	switch(alert("View (in game), Open (in your system's text editor), or Download?", path, "View", "Open", "Download"))
		if ("View")
			src << browse("<pre style='word-wrap: break-word;'>[html_encode(file2text(file(path)))]</pre>", list2params(list("window" = "viewfile.[path]")))
		if ("Open")
			src << run(file(path))
		if ("Download")
			src << ftp(file(path))
		else
			return
	to_chat(src, "Attempting to send [path], this may take a fair few minutes if the file is very large.")
	return


/client/proc/getfolderlogs()
	set name = "Get Server Logs Folder"
	set desc = "Yeah okay."
	set category = "Admin"

	var/path = "data/logs/"
	path = browse_folders(path)
	
	to_chat(world, "Path [path]")


	iterate_download(path)



/client/proc/iterate_download(var/folder)
	var/files = flist(folder)
	to_chat(world, "Starting iterate_download [folder]")
	for(var/thing in files)
		if(copytext(thing, -1, 0) == "/")
			to_chat(world, "Going deeper [folder][thing]")
			iterate_download(folder+thing)
		else
			to_chat(world, "Downloading [folder][thing]")
			var/fil = replacetext("[folder][thing]", "/", "_")
			src << ftp(file(folder+thing),fil)



/client/proc/browse_folders(root="data/logs/", max_iterations=100)
	var/path = root

	for(var/i=0, i<max_iterations, i++)
		var/list/choices = flist(path)
		if(path != root)
			choices.Insert(1,"/")

		var/choice = input(src,"Choose a folder to access:","Download",null) as null|anything in choices
		switch(choice)
			if(null)
				return
			if("/")
				path = root
				continue

		path += choice
		

		if(copytext(path,-1,0) != "/")		//didn't choose a directory, no need to iterate again
			return FALSE
		else
			var/choicee = input(src,"Is this the folder you want to download?:","Download",null) as null|anything in list("Yes", "No")
			switch(choicee)
				if("Yes")
					to_chat(world, "Chosen final folder")
					break
				if("No")
					to_chat(world, "Continuing the loop")
					continue

	return path