extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_max_health(value):
	$Health.max_value = value

func update_score(score):
	$Score.text = str(score)

func update_health(health):
	$Health.value = health
