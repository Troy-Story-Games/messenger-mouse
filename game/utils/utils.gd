extends Node

func instantiate_scene_on_level(scene: PackedScene, position: Vector2) -> Node:
    var node: = scene.instantiate()
    var main = get_tree().current_scene as World
    if main is World:
        var level: = main.current_level as Level
        if level is Level:
            level.add_child(node)
        else:
            # NOTE: fallback to make it work if no level
            main.add_child(node)
    node.position = position
    return node
