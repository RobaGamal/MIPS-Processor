import sys
import string

regs = {
	"r0": "0000",
	"r1": "0001",
	"r2": "0010",
	"r3": "0011",
	"r4": "0100",
	"r5": "0101",
	"r6": "0110",
	"r7": "0111",
	"notregaddr": "1111",
	"immregaddr": "1010",
	"inregaddr": "1011",
	"outregaddr": "1100"
}

no_ops = {
	"nop" : "00000",
	"setc" : "00001",
	"clrc" : "00010",
	"ret" : "10101",
	"rti" : "10110"
}

one_ops = {
	"not" : "00011",
	"inc" : "00100",
	"dec" : "00101",
	"push" : "11000",
	"pop" : "11001",
	"ldm" : "11010",
	"jz" : "10000",
	"jn" : "10001",
	"jc" : "10010",
	"jmp" : "10011",
	"call" : "10100",
}

in_op = {
	"in" : "00111",
	"out" : "00110"
}

two_ops = {
	"mov" : "01000",
	"add" : "01001",
	"sub" : "01010",
	"and" : "01011",
	"or" : "01100",
	"std" : "11100",
	"ldd" : "11011",
}

imm_ops = { 
	"shl" : "01101",
	"shr" : "01110",
}

all_ops = one_ops.copy()
all_ops.update(two_ops)
all_ops.update(no_ops)
all_ops.update(imm_ops)

class State:
	mem_index = 0
	mem = {}

def is_hex_str(s):
	return set(s).issubset(string.hexdigits) and len(s) != 0

def handle_org(line, state):
	if not line.startswith('.org'):
		return False
	line = line[4:]
	line = line.strip()
	state.mem_index = int(line, 16)
	return True

def handle_numeric(line, state):
	for key, _ in all_ops.items():
		if line.startswith(key):
			return False
	line = line.strip()
	if not is_hex_str(line):
		return False
	print(line)
	x = str(bin(int(line, 16)))[2:]
	while len(x) < 16:
		x = "0" + x
	print(x)
	state.mem[state.mem_index] = x
	state.mem_index += 1
	return True

def preprocess(line):
	commend_index = line.find('#')
	line = line[0:commend_index]
	line = line.replace(',', ' ')
	line = line.strip()
	line = line.lower()
	return line

def handle_no_ops(line, state):
	inst = ""
	success = False
	for key, value in no_ops.items():
		if line.startswith(key):
			inst += value + regs["notregaddr"] + regs["notregaddr"] + "000" 
			line = line[len(key):]
			success = True
	if success == False:
		return False
	state.mem[state.mem_index] = inst
	state.mem_index += 1
	return True

def read_operand(line):
	line = line.strip()
	for key, value in regs.items():
		if line.startswith(key):
			line = line[len(key):]
			op = value
	return line, op

def handle_two_ops(line, state):
	inst = ""
	success = False
	for key, value in two_ops.items():
		if line.startswith(key):
			line = line[len(key):]
			inst += value
			line, op1 = read_operand(line)
			line, op2 = read_operand(line)
			inst += op1
			inst += op2
			inst += "000"
			success = True
	if success == False:
		return False
	state.mem[state.mem_index] = inst
	state.mem_index += 1
	return True

def handle_shlshr(line, state):
	inst = ""
	success = False
	for key, value in imm_ops.items():
		if line.startswith(key):
			line = line[len(key):]
			inst += value
			line, op1 = read_operand(line)
			inst += regs["notregaddr"]
			inst += op1
			line = line.strip()
			shift = line[0]
			shift = str(bin(int(shift, 16)))[2:]
			while len(shift) < 3:
				shift = "0" + shift
			inst += shift
			line = line[1:]
			success = True
	if success == False:
		return False
	state.mem[state.mem_index] = inst
	state.mem_index += 1
	return True

def handle_one_ops(line, state):
	inst = ""
	success = False
	for key, value in one_ops.items():
		if line.startswith(key):
			line = line[len(key):]
			inst += value
			line, op = read_operand(line)
			inst += regs["notregaddr"]
			inst += op
			inst += "000"
			success = True
	if success == False:
		return False
	state.mem[state.mem_index] = inst
	state.mem_index += 1
	handle_numeric(line, state)
	return True

def handle_inout(line, state):
	inst = ""
	success = False
	if line.startswith("in"):
		line = line[len("in"):]
		inst += in_op["in"]
		inst += regs["inregaddr"]
		line, op = read_operand(line)
		inst += op
		inst += "000"
		success = True
	elif line.startswith("out"):
		line = line[len("out"):]
		inst += in_op["out"]
		line, op = read_operand(line)
		inst += op
		inst += regs["outregaddr"]
		inst += "000"
		success = True
	if success == False:
		return False
	state.mem[state.mem_index] = inst
	state.mem_index += 1
	return True

if __name__ == "__main__":
	input_file_path = sys.argv[1]
	output_file_path = sys.argv[2]
	state = State()
	with open(input_file_path) as f:
		for line in f:
			line = preprocess(line)
			if len(line) == 0:
				continue
			if handle_numeric(line, state):
				continue
			if handle_org(line, state):
				continue
			if handle_no_ops(line, state):
				continue
			if handle_one_ops(line, state):
				continue
			if handle_two_ops(line, state):
				continue
			if handle_shlshr(line, state):
				continue
			if handle_inout(line, state):
				continue
	
	with open(output_file_path, 'w') as file:
		file.write('// memory data file (do not edit the following line - required for mem load use)\n')
		file.write('// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1\n')
		for key in state.mem.keys():
			file.write(hex(key)[2:] + ": " + state.mem[key] + '\n')


