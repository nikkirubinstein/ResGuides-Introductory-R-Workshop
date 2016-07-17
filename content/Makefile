
# R Markdown files.
SRC_RMD = $(wildcard ??-*.Rmd)
DST_RMD = $(patsubst %.Rmd,%.md,$(SRC_RMD))

# All Markdown files (hand-written and generated).
ALL_MD = $(wildcard *.md) $(DST_RMD)
EXCLUDE_MD = README.md LAYOUT.md FAQ.md DESIGN.md CONTRIBUTING.md CONDUCT.md
SRC_MD = $(filter-out $(EXCLUDE_MD),$(ALL_MD))

# All outputs.
DST_ALL = $(SRC_MD)

# Chunk options for knitr (used in R conversion).
R_CHUNK_OPTS = ../tools/chunk-options.R

# Ensure that intermediate (generated) Markdown files from R are kept.
.SECONDARY: $(DST_RMD)

# Default action is to show what commands are available.
all : commands

## clean    : Clean up temporary and intermediate files.
clean :
	@rm -rf $$(find . -name '*~' -print)

## preview  : Build website locally for checking.
preview : $(DST_ALL)

# Pattern to convert R Markdown to Markdown.
%.md: %.Rmd $(R_CHUNK_OPTS) ../tools/check_knitr_version.R
	Rscript -e "source('../tools/check_knitr_version.R')"
	Rscript -e "knitr::knit('$$(basename $<)', output = '$$(basename $@)')"

## commands : Display available commands.
commands : Makefile
	@sed -n 's/^##//p' $<

