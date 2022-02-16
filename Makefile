LATEX=xelatex
BIBTEX=bibtex
STEM="main"

all : commands

## commands   : show all commands.
commands :
	@grep -E '^##' Makefile | sed -e 's/## //g'

## counts      : get tex word counts
counts :
	find . -type f -name "*.tex" | xargs texcount 2>/dev/null | grep -w "Words in text:" | cut -d : -f 2 | awk '{Total=Total+$$1} END {print "Total is: " Total}'

## pdf        : re-generate PDF
pdf :
	${LATEX} -synctex=1 -interaction=nonstopmode ${STEM}
#	# nomenclature/abbreviations
	makeindex ${STEM}.nlo -s nomencl.ist -o ${STEM}.nls
#	${BIBTEX} ${STEM}
	${LATEX} -synctex=1 -interaction=nonstopmode ${STEM}
	${LATEX} -synctex=1 -interaction=nonstopmode ${STEM}

## clean      : clean up junk files.
clean :
	rm -f $$(cat .gitignore)
	rm -f ./*/*.synctex.gz ./*/*.xdv ./*/*.nlo

## sync      : sync overleaf -> local -> GitHub
sync:
	git fetch --all --prune
	git pull leaf master:main
	git push origin main:main
	git log --oneline --graph --all -n 10

## push      : push local to GitHub and Overleaf
push:
	git push origin main:main
	git push leaf main:master
	git log --oneline --graph --all -n 10


## fetch    : fetch remotes origin + leaf
fetch:
	git fetch --all --prune
	git log --oneline --graph --all -n 10

