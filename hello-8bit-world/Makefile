KICKASS_JAR=$(KICK_HOME)/KickAss.jar
C1541=$(VICE_HOME)/c1541
PETCAT=$(VICE_HOME)/petcat
PROG=rsimple
EMU=$(VICE_HOME)/x64sc

.PHONY: deploy clean

deploy:$(PROG).d64
	$(EMU) -autoload $(PROG).d64

$(PROG).d64:$(PROG).prg $(PROG)_bas.prg
	$(C1541) -format $(PROG),1 d64 $(PROG).d64 -attach $(PROG).d64 -write $(PROG)_bas.prg loader -write $(PROG).prg $(PROG) 

$(PROG).prg:$(PROG).asm *.asm
	java -jar $(KICKASS_JAR) $(PROG).asm

$(PROG)_bas.d64:$(PROG)_bas.prg
	$(C1541) -format $(PROG),1 d64 $(PROG).d64 -attach $(PROG).d64 -write $(PROG)_bas.prg $(PROG) 

$(PROG)_bas.prg: $(PROG).bas
	$(PETCAT) -w2 -o $(PROG)_bas.prg -- $(PROG).bas



clean:
	rm -f *.prg
	rm -f *.d64
	rm -f *.sym