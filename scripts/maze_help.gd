extends Node

# ESWN little endian
# NWSE big endian (reading binary left to right)
const tiletype_binary = {
	'WE' : 0b0101,
	'NS' : 0b1010,
	'SE' : 0b0011,
	'SW' : 0b0110,
	'NW' : 0b1100,
	'NE' : 0b1001,
	'NES': 0b1011,
	'NWS': 0b1110,
	'SWE': 0b0111,
	'NWE': 0b1101,
	'NWSE': 0b1111,
	'N': 0b1000,
	'W': 0b0100,
	'S': 0b0010,
	'E': 0b0001,
	'START': 0b00010000,
	'END': 0b00100000,
}

const tiletype_atlascoord = {
	'WE' : Vector2i(1, 0),
	'NS' : Vector2i(0, 1),
	'SE' : Vector2i(0, 0),
	'SW' : Vector2i(2, 0),
	'NW' : Vector2i(2, 2),
	'NE' : Vector2i(0, 2),
	'NES': Vector2i(3, 0),
	'NWS': Vector2i(4, 0),
	'SWE': Vector2i(3, 1),
	'NWE': Vector2i(4, 1),
	'NWSE': Vector2i(1, 1),
	'N': Vector2i(1, 4),
	'W': Vector2i(2, 4),
	'S': Vector2i(2, 3),
	'E': Vector2i(1, 3),
	'START': Vector2i(3, 4),
	'END': Vector2i(4, 3),
}

const CONNECTIONS : PackedByteArray = [0b0001, 0b0010, 0b0100, 0b1000]
const OPP_CONNECTIONS : PackedByteArray = [0b0100, 0b1000, 0b0001, 0b0010]
const START = 0b00010000
const END = 0b00100000

const startend_mask = 0b11110000
const connect_mask = 0b00001111

const dirs : Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]
