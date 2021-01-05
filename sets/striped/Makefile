# STRIPED HASH MAKEFILE

CC = gcc
CIVL = civl

striped_hash : striped_hash.cvl
	$(CC) $^ -o $@

verify : striped_hash.cvl
	$(CIVL) verify $^

clean:
	rm -rf *~ *.out *.trace *.log *.gch
