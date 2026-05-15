extends Node3D

@onready var raccoon_head = $"raccoonHead"
@onready var raccoon_body = $"raccoonBody"
@onready var raccoon_tail = $"raccoonTail/Cylinder"

const RACCOON_PALETTES = {
	"classic": null,
	"dark": {
		"head": Color("4a4a4a"), "body": Color("5a5a5a"), 
		"snout": Color("d9d9d9"), "cheek": Color("1a1a1a"),
		"ear_outer": Color("4a4a4a"), "ear_inner": Color("000000ff"),
		"tail_base": Color("5a5a5a"),  "tail_stripe": Color("1a1a1a")
	},
	"albino": {
		"head": Color("f7f4eb"), "body": Color("ffffff"), 
		"snout": Color("c9b794ff"), "cheek": Color("c9b794ff"),
		"ear_outer": Color("f7f4eb"), "ear_inner": Color("ffbaba"),
		"tail_base": Color("ffffff"),  "tail_stripe": Color("c9b794ff")
	},
	"cinnamon": {
		"head": Color("9a7453ff"), "body": Color("9a7453ff"), 
		"snout": Color("eadecc"), "cheek": Color("4e3e36"),
		"ear_outer": Color("9a7453ff"), "ear_inner": Color("cdbba8"),
		"tail_base": Color("9a7453ff"),  "tail_stripe": Color("5a493f")
	}
}

var palette_names = RACCOON_PALETTES.keys()


func apply_mesh(mesh_list, palette_list, part) -> void:
	for mesh in mesh_list:
		_set_mesh_color(mesh, 0, palette_list[part])

func apply_color_palette(palette_name: String) -> void:
	var colors = RACCOON_PALETTES.get(palette_name, RACCOON_PALETTES["classic"])
	if palette_name == "classic":
		pass
	else:
		# head
		apply_mesh(raccoon_head.raccoon_head, colors, "head")
		apply_mesh(raccoon_head.raccoon_cheeks, colors, "cheek")
		_set_mesh_color(raccoon_head.raccoon_ears[0], 0, colors["ear_outer"])
		_set_mesh_color(raccoon_head.raccoon_ears[0], 1, colors["ear_inner"])
		_set_mesh_color(raccoon_head.raccoon_ears[1], 0, colors["ear_outer"])
		_set_mesh_color(raccoon_head.raccoon_ears[1], 1, colors["ear_inner"])
		_set_mesh_color(raccoon_head.raccoon_snout, 0, colors["snout"])
		
		#body
		_set_mesh_color(raccoon_body, 0, colors["body"])
		_set_mesh_color(raccoon_tail, 0, colors["tail_base"])
		_set_mesh_color(raccoon_tail, 1, colors["tail_stripe"])


func _set_mesh_color(mesh_node: MeshInstance3D, surface_index: int, target_color: Color) -> void:
	if not mesh_node:
		return
		
	if mesh_node.get_surface_override_material_count() <= surface_index:
		if not mesh_node.get_active_material(surface_index):
			return 

	var mat = mesh_node.get_active_material(surface_index)
	if mat:
		mat = mat.duplicate()
	else:
		mat = StandardMaterial3D.new()
		
	mat.albedo_color = target_color
	mesh_node.set_surface_override_material(surface_index, mat)
