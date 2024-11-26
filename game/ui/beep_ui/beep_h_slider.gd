extends HSlider
class_name BeepHSlider

func _ready() -> void:
    focus_exited.connect(Utils.menu_beep)
    focus_entered.connect(Utils.menu_beep)
    value_changed.connect(slider_tick)

func slider_tick(_value: float) -> void:
    SoundFx.play("hslider_ticks", 0.75, -25, 0)
