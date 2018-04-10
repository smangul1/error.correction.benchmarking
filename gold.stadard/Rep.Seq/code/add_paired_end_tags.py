#This script is responsible for adding /1 and /2 to the paired end reads
import sys
file_name = sys.argv[1]
import_file = open(file_name,'r')

lines = []
for line in import_file:
	lines.append(line.rstrip())
import_file.close()

for i in range(len(lines)):
	for j in range(len(lines[i])):
		if (lines[i][j] == '\t'):
			if(i%2 == 0):
				lines[i] = lines[i][:j] + '/1' +lines[i][j:]
				break
			if(i%2 == 1):
				lines[i] = lines[i][:j]+'/2' + lines[i][j:]
				break
write_file = open(file_name,'w')
for line in lines:
	write_file.write(line)
	write_file.write('\n')
write_file.close()
