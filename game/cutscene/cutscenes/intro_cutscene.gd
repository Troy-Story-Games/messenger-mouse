extends Cutscene
class_name IntroCutscene

var animation_order: Array = ["secret_note", "convo_cap_1", "convo_mouse_1", "convo_cap_2"]
var current_animation = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var battle_sounds: AudioStreamPlayer = $BattleSounds
@onready var fade_out_animation_player: AnimationPlayer = $FadeOutAnimationPlayer
@onready var chat_box: Control = $CanvasLayer/Control/ChatBox
@onready var captain_chat_text: Label = $CanvasLayer/Control/ChatBox/CaptainChatText
@onready var messenger_chat_text: Label = $CanvasLayer/Control/ChatBox/MessengerChatText
@onready var chat_box_sprite: Sprite2D = $CanvasLayer/Control/ChatBox/ChatBoxSprite
@onready var continue_label: Label = $CanvasLayer/Control/ContinueLabelContainer/ContinueLabel
@onready var skip_label: Label = $CanvasLayer/Control/SkipLabelContainer/SkipLabel
@onready var note_contents: RichTextLabel = $CanvasLayer/Control/CenterContainer/HBoxContainer/NoteContents

func _ready() -> void:
    if not Music.is_playing("intro_cutscene"):
        Music.play("intro_cutscene", 1, -25.0, 1.0)
    chat_box.hide()
    continue_label.hide()
    battle_sounds.play()
    skip_label.hide()
    current_animation = animation_order.pop_front()
    animation_player.play(current_animation)
    animation_player.animation_finished.connect(_on_animation_player_finished)
    fade_out_animation_player.animation_finished.connect(_on_animation_player_finished)

    if Input.get_connected_joypads():
        continue_label.text = "Press A/B to continue"
        skip_label.text = "Press START to skip"
    elif OS.get_name() == "Web":
        continue_label.text = "Press SPACE to continue"
        skip_label.text = "Press P to skip"
    else:
        continue_label.text = "Press SPACE to continue"
        skip_label.text = "Press ESC or P to skip"

func set_captain_text(value: String) -> void:
    chat_box_sprite.frame = 0
    captain_chat_text.text = value
    captain_chat_text.text = value
    captain_chat_text.visible_ratio = 0.0

func set_messenger_text(value: String) -> void:
    chat_box_sprite.frame = 1
    messenger_chat_text.text = value
    messenger_chat_text.visible_ratio = 0.0

func _input(event: InputEvent) -> void:
    if skip_label.visible and event.is_action_pressed("pause"):
        fade_out_animation_player.play("fade_out")
    if not continue_label.visible and (event.is_action_pressed("jump") or event.is_action_pressed("crouch")) and animation_player.is_playing():
        skip_ahead(animation_player.current_animation)
    if continue_label.visible and (event.is_action_pressed("jump") or event.is_action_pressed("crouch")):
        continue_label.hide()
        current_animation = animation_order.pop_front()
        if current_animation:
            animation_player.play(current_animation)
        else:
            fade_out_animation_player.play("fade_out")

func skip_ahead(_anim_name: String) -> void:
    animation_player.speed_scale = clamp(animation_player.speed_scale + 3.0, 0.0, 9.0)

func _on_animation_player_finished(anim_name: String) -> void:
    animation_player.speed_scale = 1.0
    if anim_name == "fade_out":
        finished()
        return
    continue_label.show()

func _on_skip_timer_timeout() -> void:
    skip_label.show()
