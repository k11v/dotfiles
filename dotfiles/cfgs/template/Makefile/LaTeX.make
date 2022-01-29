.PHONY: all

all:
	TEXINPUTS=.:./gostarticle:${TEXINPUTS} latexmk -xelatex -bibtex -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=.main main.tex
