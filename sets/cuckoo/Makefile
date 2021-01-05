# STRIPED HASH MAKEFILE

CC = gcc
CIVL = civl

cuckoo_seq : cuckoo_seq.cvl
	$(CC) $^ -o $@

verify_seq : cuckoo_seq.cvl
	$(CIVL) verify $^

striped_cuckoo : striped_cuckoo.cvl
	$(CC) $^ -o $@

verify_striped : striped_cuckoo.cvl
	$(CIVL) verify $^

clean:
	rm -rf *~ *.out *.trace *.log *.gch
