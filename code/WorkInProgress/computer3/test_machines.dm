
/obj/machinery/computer3/testing
	spawn_files =	list(/datum/file/program/aifixer,/datum/file/program/arcade,/datum/file/program/atmos_alert,
						/datum/file/program/security,/datum/file/program/card_comp,
						/datum/file/program/borg_control,/datum/file/program/holodeck, /datum/file/program/communications,
						/datum/file/program/crew,/datum/file/program/op_monitor, /datum/file/program/powermon,

						/datum/file/camnet_key,/datum/file/camnet_key/mining,/datum/file/camnet_key/entertainment,/datum/file/camnet_key/research,
						/datum/file/camnet_key/bombrange,/datum/file/camnet_key/xeno,/datum/file/camnet_key/singulo,/datum/file/camnet_key/prison)
	spawn_parts =	list(/obj/item/computer3_part/storage/hdd/big,/obj/item/computer3_part/storage/removable,/obj/item/computer3_part/ai_holder,
						/obj/item/computer3_part/networking/radio/subspace,/obj/item/computer3_part/networking/cameras,
						/obj/item/computer3_part/cardslot/dual,/obj/item/computer3_part/networking/area)
	New(var/L,var/built=0)
		if(!built && !battery)
			battery = new /obj/item/weapon/cell(src)
		..(L,built)

/obj/machinery/computer3/laptop/testing
	spawn_files =	list(/datum/file/program/aifixer,/datum/file/program/arcade,/datum/file/program/atmos_alert,
						/datum/file/program/security,/datum/file/program/card_comp,
						/datum/file/program/borg_control,/datum/file/program/holodeck, /datum/file/program/communications,
						/datum/file/program/crew,/datum/file/program/op_monitor, /datum/file/program/powermon,

						/datum/file/camnet_key,/datum/file/camnet_key/mining,/datum/file/camnet_key/entertainment,/datum/file/camnet_key/research,
						/datum/file/camnet_key/bombrange,/datum/file/camnet_key/xeno,/datum/file/camnet_key/singulo,/datum/file/camnet_key/prison)
	spawn_parts =	list(/obj/item/computer3_part/storage/hdd/big,/obj/item/computer3_part/storage/removable,/obj/item/computer3_part/ai_holder,
						/obj/item/computer3_part/networking/radio/subspace,/obj/item/computer3_part/networking/cameras,
						/obj/item/computer3_part/cardslot/dual,/obj/item/computer3_part/networking/area)
	New(var/L,var/built=0)
		if(!built && !battery)
			battery = new /obj/item/weapon/cell/super(src)
		..(L,built)

/obj/machinery/computer3/wall_comp/testing
	spawn_files =	list(/datum/file/program/aifixer,/datum/file/program/arcade,/datum/file/program/atmos_alert,
						/datum/file/program/security,/datum/file/program/card_comp,
						/datum/file/program/borg_control,/datum/file/program/holodeck, /datum/file/program/communications,
						/datum/file/program/crew,/datum/file/program/op_monitor, /datum/file/program/powermon,

						/datum/file/camnet_key,/datum/file/camnet_key/mining,/datum/file/camnet_key/entertainment,/datum/file/camnet_key/research,
						/datum/file/camnet_key/bombrange,/datum/file/camnet_key/xeno,/datum/file/camnet_key/singulo,/datum/file/camnet_key/prison)
	spawn_parts =	list(/obj/item/computer3_part/storage/hdd/big,/obj/item/computer3_part/storage/removable,/obj/item/computer3_part/ai_holder,
						/obj/item/computer3_part/networking/radio/subspace,/obj/item/computer3_part/networking/cameras,
						/obj/item/computer3_part/cardslot/dual,/obj/item/computer3_part/networking/area)
	New(var/L,var/built=0)
		if(!built && !battery)
			battery = new /obj/item/weapon/cell(src)
		..(L,built)

/obj/machinery/computer3/server/testing
	spawn_files =	list(/datum/file/program/aifixer,/datum/file/program/arcade,/datum/file/program/atmos_alert,
						/datum/file/program/security,/datum/file/program/card_comp,
						/datum/file/program/borg_control,/datum/file/program/holodeck, /datum/file/program/communications,
						/datum/file/program/crew,/datum/file/program/op_monitor, /datum/file/program/powermon,

						/datum/file/camnet_key,/datum/file/camnet_key/mining,/datum/file/camnet_key/entertainment,/datum/file/camnet_key/research,
						/datum/file/camnet_key/bombrange,/datum/file/camnet_key/xeno,/datum/file/camnet_key/singulo,/datum/file/camnet_key/prison)
	spawn_parts =	list(/obj/item/computer3_part/storage/hdd/big,/obj/item/computer3_part/storage/removable,/obj/item/computer3_part/ai_holder,
						/obj/item/computer3_part/networking/radio/subspace,/obj/item/computer3_part/networking/cameras,
						/obj/item/computer3_part/cardslot/dual,/obj/item/computer3_part/networking/area)
	New(var/L,var/built=0)
		if(!built && !battery)
			battery = new /obj/item/weapon/cell(src)
		..(L,built)

/obj/machinery/computer3/server/rack/testing
	spawn_files =	list(/datum/file/program/aifixer,/datum/file/program/arcade,/datum/file/program/atmos_alert,
						/datum/file/program/security,/datum/file/program/card_comp,
						/datum/file/program/borg_control,/datum/file/program/holodeck, /datum/file/program/communications,
						/datum/file/program/crew,/datum/file/program/op_monitor, /datum/file/program/powermon,

						/datum/file/camnet_key,/datum/file/camnet_key/mining,/datum/file/camnet_key/entertainment,/datum/file/camnet_key/research,
						/datum/file/camnet_key/bombrange,/datum/file/camnet_key/xeno,/datum/file/camnet_key/singulo,/datum/file/camnet_key/prison)
	spawn_parts =	list(/obj/item/computer3_part/storage/hdd/big,/obj/item/computer3_part/storage/removable,/obj/item/computer3_part/ai_holder,
						/obj/item/computer3_part/networking/radio/subspace,/obj/item/computer3_part/networking/cameras,
						/obj/item/computer3_part/cardslot/dual,/obj/item/computer3_part/networking/area)
	New(var/L,var/built=0)
		if(!built && !battery)
			battery = new /obj/item/weapon/cell(src)
		..(L,built)

/obj/item/weapon/storage/box/testing_disks
	New()
		..()
		for(var/typekey in subtypesof(/obj/item/weapon/disk/file))
			new typekey(src)