class_name MazeGen

# bits represent connections in the order ESWN LITTLE ENDIAN, so least significant bit is EAST
# bit is one if connected to the cell in that direction
# compass also counts in this direction: 0, 1, 2, 3 - E, S, W, N

const start_cell = Vector2i(0, 0)
var maze : PackedInt32Array = PackedInt32Array()
var maze_size = Vector2i(10, 10)


func generate_maze(maze_size_input=Vector2i(10, 10)) -> PackedInt32Array:
	print('Generate Maze Function Called')
	#initialise_arrays()
	maze_size = maze_size_input
	var end_cell = Vector2i(maze_size.x - 1, maze_size.y - 1)
	maze.resize(maze_size.x * maze_size.y)
	
	var total_cells = maze.size()
	var visited_cells = 1
	var current_cell : Vector2i = start_cell
	var stack : Array[Vector2i]
	while visited_cells < total_cells:
		var neighbours = cell_neighbours(current_cell)
		if neighbours.size() > 0:
			var rand = randi_range(0, neighbours.size() - 1)
			var next_cell = Vector2i(neighbours[rand].x, neighbours[rand].y)
			connect_cells(current_cell, next_cell, neighbours[rand].z)
			stack.push_back(current_cell)
			current_cell = next_cell
			visited_cells += 1
			print('Visited ' + String.num_int64(visited_cells) + '/' + String.num_int64(total_cells))
		else:
			current_cell = stack.pop_back()
	maze[(start_cell.x) + (start_cell.y * maze_size.x)] |= MazeHelp.START
	maze[(end_cell.x) + (end_cell.y * maze_size.x)] |= MazeHelp.END
	return maze


func cell_neighbours(cell : Vector2i):
	var neighbours = Array()
	for compass in range(MazeHelp.dirs.size()):
		var dir = MazeHelp.dirs[compass]
		var neighbour_loc : Vector2i = cell + dir
		if neighbour_loc.x >= 0 && neighbour_loc.y >= 0 && neighbour_loc.x < maze_size.x && neighbour_loc.y < maze_size.y:
			var neighbour = maze[(cell.x + dir.x) + ((cell.y + dir.y) * maze_size.x)]
			#print(String.num_int64(neighbour & MazeHelp.connect_mask, 2))
			if (neighbour & MazeHelp.connect_mask) == 0: # if the neighbour hasn't been visited, add it to the list to be returned
				neighbours.append(Vector3i(neighbour_loc.x, neighbour_loc.y, compass)) # neighbour x, neighbour y, compass_index - 0, 1, 2, 3, ESNW
	return neighbours


func connect_cells(from_cell : Vector2i, to_cell : Vector2i, compass : int):
	maze[(from_cell.x) + (from_cell.y * maze_size.x)] |= MazeHelp.CONNECTIONS[compass]
	maze[(to_cell.x) + (to_cell.y * maze_size.x)] |= MazeHelp.OPP_CONNECTIONS[compass]
