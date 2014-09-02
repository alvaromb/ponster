S=hunspell -d en_US
P=pdflatex -halt-on-error -interaction batchmode
B=bibtex
O=open
all: latex

fast:
	$P document
	$P document
	$O document.pdf

latex:
	$P document
	$B document
	$P document
	$P document
	$O document

spell:
	$S intro.tex

clean:
	rm *.aux *.bak *.idx *.ilg *.ind *.lof *.lot *.log *.out *.toc *~ *.bbl *.blg 2> /dev/null