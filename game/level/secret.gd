extends Area2D
class_name Secret

@export_enum("SecretArea", "CheatCode") var secret_type: String
@export var secret_name: String = ""
@export var secret_data: Resource

var found: bool = false : set = set_found
var revealed: bool = false : set = set_revealed

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var mask_tiles: TileMapLayer = $MaskTiles
@onready var reveal_area_2d: Area2D = $RevealArea2D

func _ready() -> void:
    assert(secret_type, "Secret type not set!!")
    assert(secret_name, "Secret name not set!!")
    mask_tiles.modulate = Color.WHITE
    match secret_type:
        "SecretArea":
            assert(not secret_data, "Secret data should not be set for secret areas")
            if secret_name in SaveAndLoad.save_data.secrets:
                print("Secret ", secret_name, " already found")
                revealed = true
                found = true
        "CheatCode":
            assert(secret_data, "Cheat codes need secret_data populated with the cheat code resource")
            if secret_name in SaveAndLoad.save_data.cheats:
                print("Cheat ", secret_name, " already found")
                revealed = true
                found = false  # So it can be re-found and popup the cheat code

    area_entered.connect(_on_area_entered)
    reveal_area_2d.area_entered.connect(_on_reveal_area_2d_area_entered)

func set_found(value: bool) -> void:
    found = value

func set_revealed(value: bool) -> void:
    revealed = value
    if revealed:
        mask_tiles.hide()
    else:
        mask_tiles.show()

func found_secret() -> void:
    match secret_type:
        "SecretArea":
            Events.secret_found.emit(self)
        "CheatCode":
            SoundFx.play("cheat_code_pickup", 1, -15, 0)
            Events.cheat_found.emit(self)

func _on_area_entered(_area: Area2D) -> void:
    print("Found by player: ", secret_name)
    if not found:
        if not revealed:
            print("Revealed too!")
            revealed = true
            SoundFx.play("secret_discovered_sound", 1, -15, 0)
        found = true
        found_secret()

func _on_reveal_area_2d_area_entered(_area: Area2D) -> void:
    print("Reveal the secret area")
    if not revealed:
        SoundFx.play("secret_discovered_sound", 1, -15, 0)
        revealed = true
