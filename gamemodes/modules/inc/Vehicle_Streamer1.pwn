#include a_samp

#define max_dynamic_vehicles 5000 // Maximum amount of vehicles the script can handle; don't put extreme values, try to keep it between 1 - 10000

enum e_vehicles
{
	v_real_id, // Vehicle's real ID, given upon creation by the streamer
	v_stream_id, // Vehicle's stream ID, given upon creation in user's script and will remain the same until the vehicle is destroyed by the user
	v_model_id, // Vehicle's model ID
	Float:v_x_coord_original, // Original X position of a vehicle (given upon creation in user's script)
	Float:v_y_coord_original, // Original Y position of a vehicle (-||-)
	Float:v_z_coord_original, // Original Z position of a vehicle (-||-)
	Float:v_a_coord_original, // Original vehicle's facing angle (-||-)
	Float:v_x_coord_last, // Last X position of a vehicle (before vehicle has been destroyed by the streamer)
	Float:v_y_coord_last, // Last Y position of a vehicle (-||-)
	Float:v_z_coord_last, // Last Z position of a vehicle (-||-)
	Float:v_a_coord_last, // Last vehicle's facing angle (-||-)
	v_color_1, // Vehicle's primary color
	v_color_2, // Vehicle's secondary color
	v_Float:health, // Vehicle's health
	v_component[13], // Vehicle's components (13)
	v_interior, // Vehicle's interior
	v_virtual_world, // Vehicle's virtual world
};
new vehicle_data[max_dynamic_vehicles][e_vehicles];
