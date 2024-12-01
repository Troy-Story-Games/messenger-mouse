extends Node2D
class_name Cutscene

@export var next_scene: PackedScene

func finished() -> void:
	get_tree().change_scene_to_packed(next_scene)
