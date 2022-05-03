SUBDIRS = ug_openvario dev_openvario release_notes
     
.PHONY: pdf $(SUBDIRS)
     
pdf: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@ pdf