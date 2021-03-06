# >> HEADERS
override COMPOSER_ABSPATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
override COMPOSER_TEACHER := $(abspath $(COMPOSER_ABSPATH)/../Makefile)

override FILE_TARGETS := html docx pdf txt
override TYPE_TARGETS := ocm pjm pdm
override DOCX_TARGETS := $(foreach TYPE,$(TYPE_TARGETS),resume-$(TYPE).docx)

#>>> export COMPOSER_DEBUGIT := 1

# >> DEFINITIONS
#>>>	resume_hacks
#>>>	$(foreach FILE,$(FILE_TARGETS),$(foreach TYPE,$(TYPE_TARGETS),resume-$(TYPE).$(FILE)))
#>>>	resume_docx
override COMPOSER_TARGETS ?= \
	$(foreach FILE,$(FILE_TARGETS),resume.$(FILE)) \
	$(foreach FILE,$(FILE_TARGETS),resume-cover.$(FILE))
override COMPOSER_SUBDIRS ?=
override COMPOSER_DEPENDS ?=

# >> VARIABLES
override LVL ?=
override MGN ?= 0.8in
override FNT ?= 10pt
override OPT ?= --reference-doc="./resume.template.docx"

override MGN_TOP := $(MGN)
override MGN_BOT := $(MGN)
override MGN_LFT := $(MGN)
override MGN_RGT := $(MGN)

# >> INCLUDE
include $(COMPOSER_TEACHER)
.DEFAULT_GOAL := all

%.html: %.md
	@$(RUNMAKE) $(*).mod.html

%.mod.html: %.md
	@$(SED) \
		-e "s|^(# Gary B. Genett)$$|<\!-- \1 -->|g" \
		-e "s|^<\!-- link: (.+) -->$$| \1|g" \
		$(shell realpath $(*).md) >.$(*).mod.md
	@$(COMPOSE) \
		OPT=" \
			--metadata title=\"Gary B. Genett\" \
			$(OPT) \
		" \
		LIST=".$(*).mod.md" \
		BASE="$(*)" \
		TYPE="html"
	@$(RM) .$(*).mod.md >/dev/null

%.pdf: %.md
	@$(RUNMAKE) $(*).mod.pdf

%.mod.pdf: %.md
	@$(SED) \
		-e "s|^([-]+)$$|<\!-- \1 -->|g" \
		-e "s|^<\!-- (----) -->$$| \1|g" \
		-e "s|^<\!-- (\\\\) -->$$| \1|g" \
		$(shell realpath $(*).md) >.$(*).mod.md
	@$(COMPOSE) \
		OPT=" \
			--variable=\"geometry=top=$(MGN_TOP)\" \
			--variable=\"geometry=bottom=$(MGN_BOT)\" \
			--variable=\"geometry=left=$(MGN_LFT)\" \
			--variable=\"geometry=right=$(MGN_RGT)\" \
		" \
		LIST=".$(*).mod.md" \
		BASE="$(*)" \
		TYPE="pdf"
	@$(RM) .$(*).mod.md >/dev/null

.PHONY: resume_hacks
resume_hacks:
	$(SED) -e "s|Pathfinder \& Technologist|Organizational Change Manager|g"	resume.md > resume-ocm.md
	$(SED) -e "s|Pathfinder \& Technologist|Senior Technical Project Manager|g"	resume.md > resume-pjm.md
	$(SED) -e "s|Pathfinder \& Technologist|Senior Technical Product Manager|g"	resume.md > resume-pdm.md
	touch --reference resume.md resume-{ocm,pjm,pdm}.md

.PHONY: resume_docx
resume_docx: $(DOCX_TARGETS)

$(DOCX_TARGETS): resume.docx
	$(CP) resume.docx $(@)
