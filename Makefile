# Author: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>

PACK = xharmi00


.PHONY: pack
pack: clean $(PACK).tar.gz


$(PACK).tar.gz: project.xml fpga mcu
	mkdir $(PACK)
	cp -r $^ $(PACK)
	tar -czf $@ $(PACK)
	rm -rf $(PACK)


.PHONY: clean
clean:
	rm -rf $(PACK).tar.gz $(PACK)
