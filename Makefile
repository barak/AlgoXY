all: cn en

BOOK-CN := $(wildcard *-zh-cn.tex)
BOOK-EN := $(wildcard *-en.tex)

cn: $(BOOK-CN:.tex=.pdf)
en: $(BOOK-EN:.tex=.pdf)

# This forces latexmk to be run even if these targets *seem* up to
# date. The reason to do this is that latexmk knows the true
# dependencies, and will only do work if actually necessary.
$(BOOK-CN:.tex=.pdf): FORCE
$(BOOK-EN:.tex=.pdf): FORCE

DOTS = $(shell find . -name '*.dot')
PDFS = $(DOTS:.dot=.pdf)

pdf: $(PDFS)

TEX_FLAGS =

%.pdf: %.tex; latexmk -cd -lualatex $(TEX_FLAGS) $<

CHAPTERS-CN := $(shell egrep -l documentclass $$(find . -name '*-zh-cn.tex' -a \! -name 'algoxy-*.tex'))
CHAPTERS-EN := $(shell egrep -l documentclass $$(find . -name '*-en.tex' -a \! -name 'algoxy-*.tex'))

chapters: chapters-cn chapters-en
chapters-cn: $(CHAPTERS-CN:.tex=.pdf)
chapters-en: $(CHAPTERS-EN:.tex=.pdf)

FORCE-FLAGS = -g -use-make $(TEX_FLAGS)

force: force-cn force-en

force-cn:
	latexmk -cd -lualatex $(FORCE-FLAGS) $(BOOK-CN)

force-en:
	latexmk -cd -lualatex $(FORCE-FLAGS) $(BOOK-EN)

clean:
	git clean -fdx

.PHONY: all cn en chapters chapters-cn chapters-en
FORCE:
.PHONY:  FORCE force-cn force-en pdf
