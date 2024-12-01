extends Cutscene
class_name IntroCutscene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chat_box_sprite: Sprite2D = $CanvasLayer/ChatBox/ChatBoxSprite
@onready var captain_chat_text: Label = $CanvasLayer/ChatBox/CaptainChatText
@onready var messenger_chat_text: Label = $CanvasLayer/ChatBox/MessengerChatText

func _ready() -> void:
	Music.stop()
	animation_player.play("animate")

func set_captain_text(value: String) -> void:
	chat_box_sprite.frame = 0
	captain_chat_text.text = value
	captain_chat_text.visible_ratio = 0.0

func set_messenger_text(value: String) -> void:
	chat_box_sprite.frame = 1
	messenger_chat_text.text = value
	messenger_chat_text.visible_ratio = 0.0

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	finished()
