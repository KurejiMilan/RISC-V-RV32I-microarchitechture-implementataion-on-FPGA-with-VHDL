import sys

address = 0

line, lines = [], []

if len(sys.argv) < 2:
	print("filename is missing from the argument")
	exit(1)

filename = sys.argv[1]

sim_filename = filename[0:filename.find(".txt")]

sim_filename += "_sim.txt"

#file open try and except
try :	
	f = open(filename, 'r')
except:
	print("ERROR: file does not be found")
	exit(1)  

# file open for write try and except
try:
	fw = open(sim_filename, 'w')
except:
	print("ERROR: could not open file for write purpose")
	exit(1)
	

# read line by line and striping the white spaces
while True:
	line = f.readline()
	if not line: 
		break
	lines.append(line.strip()) 

f.close()	#close the file for opened for reading                      

hextxt = "" 
instruction = ""

for i in range(len(lines)):
	#print(lines[i])
	hextxt = lines[i]
	txt_out = ""	
	# check if the address needs to be changed	
	if "org" in hextxt:
		address = int(hextxt.split()[1])
	else:
		for j in range(3,-1,-1):
			instruction = hextxt[j*2: j*2+2]
			fw.write('if address_bus = std_logic_vector(to_unsigned('+ str(address)+', 32)) then'+'\n\t'+'data_bus <= X"'+instruction+'";\n'+'end if;'+'\n')		
			print(str(address)+': '+instruction)
			address += 1;


fw.close()
