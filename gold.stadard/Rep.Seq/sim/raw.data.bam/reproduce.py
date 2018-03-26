import_file = open('samples.txt','r')

lines = []
for line in import_file:
	lines.append(line.rstrip())

sample = []
for line in lines:
	if (line[0:3] == 'IGH'):
		sample.append(line[3:])

write_file = open('samples.suffix.txt','w')
for line in sample:
	write_file.write(line)
	write_file.write('\n')
