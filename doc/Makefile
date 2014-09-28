S=hunspell -d en_US -t
P=pdflatex -halt-on-error -interaction batchmode --shell-escape 
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
	$O document.pdf

spell:
	$S *.tex

clean:
	rm *.aux *.bak *.idx *.ilg *.ind *.lof *.lot *.log *.out *.toc *~ *.bbl *.blg 2> /dev/null