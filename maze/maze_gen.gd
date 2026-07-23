class_name MazeGen

# bits represent connections in the order ESWN LITTLE ENDIAN, so least significant bit is EAST
# bit is one if connected to the cell in that direction
# compass also counts in this direction: 0, 1, 2, 3 - E, S, W, N

const CONNECT_BITS = 0b1111

const start_location = Vector2i(0, 0)
var maze : PackedInt32Array = PackedInt32Array()
var maze_size = Vector2i(10, 10)
const dirs : Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]
const CONNECTIONS : PackedByteArray = [0b0001, 0b0010, 0b0100, 0b1000]
const OPP_CONNECTIONS : PackedByteArray = [0b0100, 0b1000, 0b0001, 0b0010]

func generate_maze(maze_size_input=Vector2i(10, 10)) -> PackedInt32Array:
	print('Generate Maze Function Called')
	#initialise_arrays()
	maze_size = maze_size_input
	
	maze.resize(maze_size.x + maze_size.x * maze_size.y)
	
	connect_cells(Vector2i(0, 1), Vector2i(1, 1), 0)
	connect_cells(Vector2i(1, 1), Vector2i(2, 1), 0)
	connect_cells(Vector2i(2, 1), Vector2i(3, 1), 0)
	
	var currentcell_neighbours = cell_neighbours(Vector2i(1, 1))
	print(currentcell_neighbours)
	
	#print(maze)
	return maze

func cell_neighbours(cell : Vector2i):
	var neighbours = Array()
	for compass in range(dirs.size()):
		var dir = dirs[compass]
		var neighbour_loc : Vector2i = cell + dir
		if neighbour_loc.x >= 0 && neighbour_loc.y >= 0 && neighbour_loc.x < maze_size.x && neighbour_loc.y < maze_size.y:
			var neighbour = maze[(cell.x + dir.x) + ((cell.y + dir.y) * maze_size.x)]
			#print(String.num_int64(neighbour & CONNECT_BITS, 2))
			if (neighbour & CONNECT_BITS) == 0: # if the neighbour hasn't been visited, add it to the list to be returned
				neighbours.append(Vector3i(neighbour_loc.x, neighbour_loc.y, compass)) # neighbour x, neighbour y, compass_index - 0, 1, 2, 3, ESNW
	return neighbours

func connect_cells(from_cell : Vector2i, to_cell : Vector2i, compass : int):
	maze[(from_cell.x) + (from_cell.y * maze_size.x)] |= CONNECTIONS[compass]
	maze[(to_cell.x) + (to_cell.y * maze_size.x)] |= OPP_CONNECTIONS[compass]
