
//for all defines that doesn't fit in any other file.

#define CARDINAL_DIRS 		list(1,2,4,8)
#define CARDINAL_ALL_DIRS 	list(1,2,4,5,6,8,9,10)

#define LEFT 1
#define RIGHT 2

//dirt type for each turf types.

#define NO_DIRT				0
#define DIRT_TYPE_GROUND	1
#define DIRT_TYPE_MARS		2
#define DIRT_TYPE_SNOW		3

//wet floors

#define FLOOR_WET_WATER	1
#define FLOOR_WET_LUBE	2
#define FLOOR_WET_ICE	3

//subtypesof(), typesof() without the parent path
#define subtypesof(typepath) ( typesof(typepath) - typepath )

var/global/list/glass_sheet_types = typecacheof(list(
	/obj/item/stack/sheet/glass,
	/obj/item/stack/sheet/rglass,
	/obj/item/stack/sheet/phoronglass,
	/obj/item/stack/sheet/phoronrglass))

#define is_glass_sheet(O) (is_type_in_typecache(O, glass_sheet_types))

//Gets the turf this atom inhabits
#define get_turf(A) get_step(A, 0)


#define RESIZE_DEFAULT_SIZE 1

/var/static/global_unique_id = 1
#define UNIQUEID (global_unique_id++)