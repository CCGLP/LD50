extends StaticBody2D
signal windowChanged(size)

export(int) var tin = 0
export(int) var tout = 0
var thalf
var win = OS.get_window_size()
var shapes =[]
var shapeowners = []

export var windowShrinkSpeedX := 8	
export var windowShrinkSpeedY := 3.5
export var maxWindowYSize = 300
var originalWindowSize
func _ready():
	#OS.set_borderless_window(true)
	OS.set_window_size(OS.get_screen_size())
	originalWindowSize = OS.get_screen_size()
	win = originalWindowSize
	emit_signal("windowChanged",win)
	windowShrinkSpeedX *= originalWindowSize.x / 2560
	windowShrinkSpeedY *= originalWindowSize.y / 1440
	OS.set_window_position(Vector2(0, 0))
	thalf = (tin + tout) /2
	var i = 0
	for extpos in [
			[Vector2(thalf, win.y/2), Vector2(tin - thalf, win.y/2)],  #left
			[Vector2(thalf, win.y/2), Vector2(win.x + thalf - tin, win.y/2)],  #right
			[Vector2(win.x/2, thalf), Vector2(win.x/2, tin - thalf)],  #top
			[Vector2(win.x/2, thalf), Vector2(win.x/2, win.y + thalf - tin)],  #bottom
			]:
		shapes.append(RectangleShape2D.new())
		var shape = shapes[i]
		shape.extents = extpos[0]
		shapeowners.append(create_shape_owner(self))
		var shapeowner = shapeowners[i]
		shape_owner_set_transform(shapeowner, Transform2D(0, extpos[1]))
		shape_owner_add_shape(shapeowner, shape)
		i+= 1
	pass
func _process(delta):
	if (win.y > maxWindowYSize):
		win.x = win.x - windowShrinkSpeedX * delta
		win.y = win.y - windowShrinkSpeedY * delta
		OS.set_window_size(win)
		OS.set_window_position((originalWindowSize-win) * 0.5)

		thalf = (tin + tout) /2
		var i = 0
		for extpos in [
				[Vector2(thalf, win.y/2), Vector2(tin - thalf, win.y/2)],  #left
				[Vector2(thalf, win.y/2), Vector2(win.x + thalf - tin, win.y/2)],  #right
				[Vector2(win.x/2, thalf), Vector2(win.x/2, tin - thalf)],  #top
				[Vector2(win.x/2, thalf), Vector2(win.x/2, win.y + thalf - tin)],  #bottom
				]:
				var shape = shapes[i]
				shape.extents = extpos[0]
				var shapeowner = shapeowners[i]
				shape_owner_set_transform(shapeowner, Transform2D(0, extpos[1]))
				#shape_owner_add_shape(shapeowner, shape)
				i+=1
	

	pass
