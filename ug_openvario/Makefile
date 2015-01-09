TEX = pdflatex -interaction=nonstopmode -output-directory $(OUTPUT_DIR)

#output dir of all generated files
OUTPUT_DIR = output

# path to images, excluding trailing "/"
IMG=figures

# Latex top file
NAME = ug_ov 

# ===== Fix leading and trailing spaces from critical variables (do not change this). =====
IMG:=$(strip $(IMG))
NAME:=$(strip $(NAME))

# ===== PHONY COMMANDS =====
.PHONY: pdf clean help
default : help
pdf : $(NAME).pdf
clean : ; rm -f *~ *aux *backup *log *toc *bbl *blg *lot *lof
superclean : clean
	rm -f $(NAME).pdf $(NAME).dvi $(NAME).dvi.pdf
	#rm -f $(SVG2PDF) $(foreach x,$(EPSs),$(IMG)/$(x).pdf) # remove generated pdf images
	#rm -f $(SVG2EPS) $(foreach x,$(PDFs),$(IMG)/$(x).eps) # remove generated eps files

# ============= SCAN FOR SVG FILES ================
SVGs := $(shell find $(IMG) -name '*.svg' | cut -d '.' -f 1)

#============== STRING MANIPULATIONS ================
SVG2PDF=$(foreach x,$(SVGs),$(x).pdf) # "img/svg1.pdf img/svg2.pdf ", if SVGs="svg1 svg2"
SVG2EPS=$(foreach x,$(SVGs),$(x).eps) # "img/svg1.eps img/svg2.eps ", if SVGs="svg1 svg2"

# ===== SVG Images =====
%.eps : %.svg
	@echo "======= Converting SVG to EPS: $< ======="
	@inkscape --without-gui --file=$< --export-eps=$@ #--export-text-to-path
 
%.pdf : %.svg
	@echo "======= Converting SVG to PDF: $< ======="
	@convert $< $@ 
	
# ===== .tex -> .pdf =====
$(NAME).pdf : $(NAME).tex $(SVG2PDF)
	mkdir -p $(OUTPUT_DIR)
	$(TEX) $(NAME).tex
		
	
#============== PHONY HELP ================
help:
	@echo ""
	@echo "make <cmd> [NAME=<main name>] [RUNBIB=0/1/2]"
	@echo ""
	@echo " <cmd>:"
	@echo "    pdf     - pdflatex: .tex -> pdf."
	@echo ""