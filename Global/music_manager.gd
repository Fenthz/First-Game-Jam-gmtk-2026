extends AudioStreamPlayer

func play_sfx(stream: AudioStream, pitch: float = 1.0, volume_db: float = 5.0):
	if stream == null:
		return

	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.pitch_scale = pitch
	sfx_player.volume_db = volume_db
	sfx_player.finished.connect(sfx_player.queue_free)
	
	add_child(sfx_player)
	sfx_player.play()
