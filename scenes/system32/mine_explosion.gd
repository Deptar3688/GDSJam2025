extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Indication.scale = Vector2(0,0)
	var tween = get_tree().create_tween()
	tween.tween_property($Indication, "scale", Vector2(1,1),1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.wait_time == 0.5:
		$Mine.modulate = Color(100, 100, 100)
		$Indication.modulate.r = 100


func _on_timer_timeout():
	$CollisionShape2D.visible = true
	$Mine.visible = false
	$Indication. visible = false
	DustParticle.create_dust_explosion($Mine.global_position, 4, 300, get_parent())
	
	for body in get_overlapping_bodies():
			if body is Player:
				body.take_damage()
				
	queue_free()
