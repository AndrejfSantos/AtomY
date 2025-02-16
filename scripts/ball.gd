extends Polygon2D

@export var radius:float = 12.0

func _ready() -> void:
	draw_circle_polygon()

func draw_circle_polygon() -> void:
	var points = PackedVector2Array()
	var number_of_points = 42
	for i in range(number_of_points+1):
		var point = deg_to_rad(i*360.0/number_of_points-90)
		points.push_back(Vector2.ZERO+Vector2(cos(point),sin(point))*radius)
	
	polygon = points
