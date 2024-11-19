extends CanvasLayer
class_name PlayerHurtFlash

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    Events.player_hurt.connect(animation_player.play.bind("flash"))
