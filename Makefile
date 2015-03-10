SUBDIRS = ug_openvario dev_openvario
     
.PHONY: pdf $(SUBDIRS)
     
pdf: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@ pdf