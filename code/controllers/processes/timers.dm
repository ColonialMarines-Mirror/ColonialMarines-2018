datum/controller/process/timers

datum/controller/process/timers/setup()
	name = "Timers"
	schedule_interval = 10 //1 second

/*	to_chat(world, "\red \b Initializing objects")
	sleep(-1)
	for(var/atom/movable/object in world)
		object.initialize()*/

datum/controller/process/timers/doWork()

	var/i = 1
	while(i<=processing_timers.len)
		var/obj/Object = processing_timers[i]
		if(Object)
			Object.process()
			i++
			continue
		processing_objects.Cut(i,i+1)