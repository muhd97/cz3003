extends TileMap

func _on_LeftTunnelEntrance_area_entered(area):
	area.cur_speed = area.original_speed / 2

func _on_LeftTunnelEntrance_area_exited(area):
	area.cur_speed = area.original_speed

func _on_RightTunnelEntrance_area_entered(area):
	area.cur_speed = area.original_speed / 2

func _on_RightTunnelEntrance_area_exited(area):
	area.cur_speed = area.original_speed
