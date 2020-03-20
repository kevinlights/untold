extends Spatial

onready var audio_explosion = $Audio_Explosion
onready var light = $OmniLight
onready var tween = $Tween

func explode() -> void:
	audio_explosion.play()
	tween.interpolate_property(light, "light_energy", 50.0, 0.0, 0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
