extends Marker2D
class_name EnemySpawner

const FlyingEnemyScene: PackedScene = preload("res://game/enemy/flying_enemy.tscn")
const GroundEnemyScene: PackedScene = preload("res://game/enemy/ground_enemy.tscn")

## Type of enemy to spawn
@export_enum("flying_enemy", "ground_enemy") var enemy_type: String = "flying_enemy"

var spawned_enemy: Enemy

func _ready() -> void:
    assert(enemy_type, "No enemy type for spawner")
    Events.player_died.connect(_on_player_died)
    call_deferred("spawn")

func spawn() -> void:
    var enemy: Enemy = null
    match enemy_type:
        "flying_enemy":
            enemy = Utils.instantiate_scene_on_level(FlyingEnemyScene, global_position) as Enemy
        "ground_enemy":
            enemy = Utils.instantiate_scene_on_level(GroundEnemyScene, global_position) as Enemy

    spawned_enemy = enemy
    spawned_enemy.died.connect(_on_spawned_enemy_died)

func _on_spawned_enemy_died() -> void:
    spawned_enemy = null

func check_and_spawn() -> void:
    if not spawned_enemy or not is_instance_valid(spawned_enemy):
        spawn()
    else:
        spawned_enemy.global_position = global_position

func _on_player_died() -> void:
    call_deferred("check_and_spawn")
