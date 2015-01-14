all: TEM_draft.pdf

TEM_draft.pdf: TEM_draft.tex
	pdflatex TEM_draft
	bibtex TEM_draft
	pdflatex TEM_draft
	pdflatex TEM_draft

tidy:
	rm -f TEM_draft.{aux,bbl,blg,log}

clean: tidy
	rm -f TEM_draft.pdf

.PHONY: all tidy clean
