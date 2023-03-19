################################################################################
# composer settings file
################################################################################
ifneq ($(COMPOSER_CURDIR),)
ifneq ($(filter %/resume,$(CURDIR)),)
################################################################################

override FILE_TARGETS			:= html docx pdf txt
override TYPE_TARGETS			:= ocm pjm pdm
override DOCX_TARGETS			:= $(foreach TYPE,$(TYPE_TARGETS),resume-$(TYPE).docx)

########################################

#>>>	resume_hacks
#>>>	$(foreach FILE,$(FILE_TARGETS),$(foreach TYPE,$(TYPE_TARGETS),resume-$(TYPE).$(FILE)))
#>>>	resume_docx
override COMPOSER_TARGETS		:= \
	$(foreach FILE,$(FILE_TARGETS),resume.$(FILE)) \
	$(foreach FILE,$(FILE_TARGETS),resume-cover.$(FILE))
override COMPOSER_SUBDIRS		:= .null

########################################

override c_site				:=
override c_level			:= 1
override c_margin			:=
override c_margin_top			:= 0.8in
override c_margin_bottom		:= 0.6in
override c_margin_left			:= 0.8in
override c_margin_right			:= 0.8in
override c_options			:=

ifeq ($(c_type),docx)
#>>>override c_options			:= $(c_options) --reference-doc="./resume.template.docx"
endif

################################################################################

override define PDF_HACK =
\\usepackage{fancyhdr}
\\pagestyle{fancy}
\\fancyhf{}
% \\fancyhead[EL]{\\author}
\\fancyhead[EL]{Gary B. Genett}
\\fancyhead[OL]{}
\\fancyhead[ER]{Page \\thepage}
\\fancyhead[OR]{}
\\fancyfoot[EL]{}
\\fancyfoot[OL]{}
\\fancyfoot[ER]{}
\\fancyfoot[OR]{continued...}
\\renewcommand{\\headrulewidth}{0pt}
\\renewcommand{\\footrulewidth}{0pt}
endef

################################################################################

ifeq ($(c_type),html)
ifeq ($(c_base),.resume-cover.html)
override c_options := $(c_options) --metadata=pagetitle='Cover Letter'
else
override c_options := $(c_options) --metadata=pagetitle='Resume'
endif
endif
resume.html:		resume.md
resume-cover.html:	resume-cover.md
resume.html \
resume-cover.html \
:
	@$(eval override MOD_BASE := $(subst .html,,$(@)))
	@$(SED) "s|^<\!-- link: (.+) -->$$| \1|g" $(MOD_BASE).md >.$(@).md
	@if [ "$(MOD_BASE)" = "resume" ]; then \
		{ \
			$(ECHO) "---\n"; \
			$(ECHO) "pagetitle: Resume\n"; \
			$(ECHO) "date: $(DATEMARK)\n"; \
			$(ECHO) "tags:\n  - Personal\n"; \
			$(ECHO) "---\n"; \
		} >$(COMPOSER_ROOT)/me/resume.md; \
		$(SED) \
			-e "s|^(#.+) -- [^-]+$$|\1|g" \
			-e "s|^(#.+)[,][^,]+$$|\1|g" \
			.$(@).md >>$(COMPOSER_ROOT)/me/resume.md; \
	fi
#>>>	@$(DIFF) $(MOD_BASE).md .$(@).md || $(TRUE)
#>>>	@$(DIFF) $(MOD_BASE).md $(COMPOSER_ROOT)/me/resume.md || $(TRUE)
	@$(call $(COMPOSER_TINYNAME)-make,$(COMPOSER_PANDOC) \
		c_type="html" \
		c_base=".$(@)" \
		c_list=".$(@).md" \
	)
	@$(SED) -i "/x-icon/d" .$(@).html
	@$(call $(COMPOSER_TINYNAME)-mv,.$(@).html,$(@))
	@$(call $(COMPOSER_TINYNAME)-rm,.$(@).md)

########################################

ifeq ($(c_type),pdf)
override c_options := $(c_options) --variable=classoption="twoside"
ifeq ($(c_base),.resume-cover.pdf)
override c_options := $(c_options) --include-in-header=".resume-cover.pdf.latex"
override c_options := $(c_options) --metadata=title-meta='Gary B. Genett - Cover Letter'
else
override c_options := $(c_options) --include-in-header=".resume.pdf.latex"
override c_options := $(c_options) --metadata=title-meta='Gary B. Genett - Resume'
endif
endif
resume.pdf:		resume.md
resume-cover.pdf:	resume-cover.md
resume.pdf \
resume-cover.pdf\
:
	@$(eval override MOD_BASE := $(subst .pdf,,$(@)))
	@$(call DO_HEREDOC,PDF_HACK) >.$(@).latex
#>>>	@$(CAT) .$(@).latex
	@$(SED) \
		-e "s|^([-]{3}[-]+)$$|<\!-- \1 -->|g" \
		-e "s|^<\!-- (----) -->$$| \1|g" \
		-e "s|^<\!-- (\\\\) -->$$| \1|g" \
		$(MOD_BASE).md >.$(@).md
#>>>	@$(DIFF) $(MOD_BASE).md .$(@).md || $(TRUE)
	@$(call $(COMPOSER_TINYNAME)-make,$(COMPOSER_PANDOC) \
		c_type="pdf" \
		c_base=".$(@)" \
		c_list=".$(@).md" \
	)
	@$(call $(COMPOSER_TINYNAME)-mv,.$(@).pdf,$(@))
	@$(call $(COMPOSER_TINYNAME)-rm,.$(@).latex)
	@$(call $(COMPOSER_TINYNAME)-rm,.$(@).md)

################################################################################

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

################################################################################
endif
endif
################################################################################
# end of file
################################################################################
