extends CharacterBody2D
class_name Enemy

@export var stats: Stats

var spawn_point: Vector2

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox

func _ready():
    assert(stats, "Missing enemy stats")
    spawn_point = global_position
    hurtbox.hurt.connect(take_hit)
    stats.no_health.connect(die)
    Events.player_died.connect(respawn)

func take_hit(hitbox: Hitbox):
    stats.health -= hitbox.damage

func respawn():
    stats.health = stats.max_health
    global_position = spawn_point
    show()
    hitbox.set_deferred("monitoring", true)

func die():
    Events.enemy_killed.emit()
    hide()
    hitbox.set_deferred("monitoring", false)
