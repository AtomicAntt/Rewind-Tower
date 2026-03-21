@tool
class_name CoinSnapZone
extends XRToolsSnapZone

@onready var visual_coin: Node3D = $VisualCoin
@onready var from_marker: Marker3D = $From
@onready var to_marker: Marker3D = $To

## Emitted whenever a coin gets inserted in the snap zone.
signal coin_inserted

func _on_has_picked_up(what: Variant) -> void:
	var tween = create_tween()
	
	visual_coin.visible = true
	
	what.queue_free()
	emit_signal("coin_inserted")
	
	tween.tween_property(visual_coin, "global_position", to_marker.global_position, 0.1)
	await tween.finished
	visual_coin.visible = false
	
