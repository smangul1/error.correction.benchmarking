


import sys
from Bio import SeqIO

reference = sys.argv[1]
sam = sys.argv[2]
reads = sys.argv[3]




def reverse_complement(seq):    
    alt_map = {'ins':'0'}
    complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A'} 
    for k,v in alt_map.iteritems():
        seq = seq.replace(k,v)
    bases = list(seq) 
    bases = reversed([complement.get(base,base) for base in bases])
    bases = ''.join(bases)
    for k,v in alt_map.iteritems():
        bases = bases.replace(v,k)
    return bases


sw = {}
handle = open(reference, "rU")
for record in SeqIO.parse(handle, "fasta"):
    sw[record.id] = record.seq.tostring()
handle.close()


rw = {}
handle = open(reads, "rU")
for record in SeqIO.parse(handle, "fastq"):
    rw[record.id] = record.seq.tostring()
handle.close()


with open(sam) as f:
    samlines = f.readlines()

samlines = map(lambda x: x.strip().split("\t"), samlines)


for line in samlines:
    read_name, orient, refseq, startpos = line[:4]
    length = len(line[9])
    if refseq not in sw:
        continue
    true_read = sw[refseq][int(startpos) - 1: int(startpos) - 1 + int(length)]
    if orient == "16":
        true_read = reverse_complement(true_read)
    original_read = rw[read_name]
    print read_name, original_read, true_read





