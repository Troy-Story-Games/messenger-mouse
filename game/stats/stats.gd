extends Resource
class_name Stats

signal max_health_changed(new_max_health: float)
signal health_changed(new_health: float)
signal no_health()

@export var max_health: = 1.0 :
	set(value):
		var change: = value - max_health
		max_health = value
		health = max_health
		if change != 0:
			max_health_changed.emit(max_health)

var health: = max_health :
	set(value):
		var change: = value - health
		health = clamp(value, 0.0, max_health)
		if change != 0:
			health_changed.emit(health)
		if health == 0:
			no_health.emit()
