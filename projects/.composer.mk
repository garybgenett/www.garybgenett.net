################################################################################
# composer settings file
################################################################################
ifneq ($(COMPOSER_CURDIR),)
################################################################################

override CODE_DIR			:= $(abspath ../../../coding)
override PROJECTS			:= composer gary-os

########################################

override COMPOSER_IGNORES		:= index.md

################################################################################

override define DO_PROJECT_MK =
#>override COMPOSER_TARGETS		:= .targets index.html
override COMPOSER_TARGETS		:= index.html license.html
override COMPOSER_SUBDIRS		:= .null
override COMPOSER_IGNORES		:= README.md LICENSE.md license.md artifacts
#>index.html: README.html
#>index.html:
#>	@$$(call $$(COMPOSER_TINYNAME)-ln,README.html,$$(@))
endef

override define DO_PROJECT_YML =
variables:
  site-nav-left:
    TAGLINE:
      - _: "$(if $(filter composer,$(1)),*Happy Making!*,*Happy Hacking!*)"
endef

########################################

.PHONY: projects-all
projects-all: $(addsuffix /index.md,$(PROJECTS))
projects-all:
#>	@+$(MAKE) site-library
	@$(ECHO) ""

.PHONY: projects-clean
projects-clean: $(addprefix clean-,$(PROJECTS))
projects-clean:
	@+$(MAKE) projects-all
#>	@$(ECHO) ""

.PHONY: $(addprefix clean-,$(PROJECTS))
$(addprefix clean-,$(PROJECTS)):
	@$(eval $(@) := $(patsubst $(CLEANER)-%,%,$(@)))
#>	@$(call $(COMPOSER_TINYNAME)-rm,$(CURDIR)/$($(@)),1)
	@$(call $(COMPOSER_TINYNAME)-rm,$(CURDIR)/$($(@))/index.md)

$(foreach FILE,$(PROJECTS),$(eval $(abspath ../library/site-library): $(FILE)/index.md))
$(foreach FILE,$(PROJECTS),$(eval $(FILE)/index.md: $(CODE_DIR)/$(FILE)/README.md))

#>.PHONY: $(addsuffix /index.md,$(PROJECTS))
$(addsuffix /index.md,$(PROJECTS)):
	@$(eval $(@) := $(patsubst %/index.md,%,$(@)))
	@$(call $(COMPOSER_TINYNAME)-note,$(notdir $(@)))
	@$(call $(COMPOSER_TINYNAME)-mkdir,$(CURDIR)/$($(@)))
	@$(call $(COMPOSER_TINYNAME)-makefile,$(CURDIR)/$($(@))/$(MAKEFILE))
	@$(call DO_HEREDOC,DO_PROJECT_MK,,$($(@))) >$(CURDIR)/$($(@))/$(COMPOSER_SETTINGS)
	@$(call DO_HEREDOC,DO_PROJECT_YML,,$($(@))) >$(CURDIR)/$($(@))/$(COMPOSER_YML)
	@if [ -n "$(COMPOSER_DEBUGIT)" ]; then	$(ECHO) "$(_E)"; \
		else				$(ECHO) "$(_F)"; \
		fi
	@$(RSYNC) --delete-excluded \
		--filter="P_/.compose**" \
		--filter="P_/$(MAKEFILE)" \
		--filter="P_/index.*" \
		--filter="P_/license.*" \
		--filter="+_/LICENSE.*" \
		--filter="+_/README.*" \
		--filter="+_/artifacts" \
		--filter="-_/*" \
		$(CODE_DIR)/$($(@))/ \
		$(CURDIR)/$($(@)) \
		$($(DEBUGIT)-output)
	@$(ECHO) "$(_F)"
	@if [ "$($(@))" = "composer" ]; then \
		TITL="$$($(SED) -n "s|^title[:][[:space:]]+[\"](.+)[:][^:]+$$|\1|gp" $(^))"; \
		VERS="$$($(SED) -n "s|^date[:][[:space:]]+(v[0-9.]+).+([0-9-]{10}).+$$|\1|gp" $(^))"; \
		DATE="$$($(SED) -n "s|^date[:][[:space:]]+(v[0-9.]+).+([0-9-]{10}).+$$|\2|gp" $(^))"; \
	elif [ "$($(@))" = "gary-os" ]; then \
		TITL="$$($(SED) -n "s|^# Welcome to (.+)$$|\1|gp" $(^))"; \
		VERS="$$($(SED) -n "s|^.*Latest.*(v[0-9.]+)[[:space:]]+([x0-9-]{10}).+$$|\1|gp" $(^))"; \
		DATE="$$($(SED) -n "s|^.*Latest.*(v[0-9.]+)[[:space:]]+([x0-9-]{10}).+$$|\2|gp" $(^))"; \
	fi; \
		{ \
			$(ECHO) "---\n"; \
			$(ECHO) "title: $${TITL} $${VERS}\n"; \
			$(ECHO) "date: $${DATE}\n"; \
			$(ECHO) "tags:\n"; \
			$(ECHO) "  - Releases\n"; \
			$(ECHO) "---\n"; \
		} >$(CURDIR)/$(@); \
		$(SED) \
			-e "1i ---\ntitle: $${TITL} License\n---\n" \
			$(CURDIR)/$($(@))/LICENSE.md \
		>$(CURDIR)/$($(@))/license.md
	@if [ "$($(@))" = "composer" ]; then \
		$(CAT) $(CURDIR)/$($(@))/artifacts/README.site.md \
			| $(SED) \
				-e "1,/^---$$/d" \
				; \
	elif [ "$($(@))" = "gary-os" ]; then \
		$(CAT) $(^) \
			| $(SED) \
				-e "s|^(# .+ #+)$$|<!-- composer >> box-end >> -->\n<!-- composer >> spacer >> -->\n<!-- composer >> box-begin 0 >> -->\n\n\1\n\n<!-- composer >> box-end -->\n<!-- composer >> spacer -->\n|g" \
				-e "s|^## (.+) #+$$|<!-- composer >> box-end >> -->\n<!-- composer >> spacer >> -->\n<!-- composer >> box-begin 2 \1 >> -->\n|g" \
				-e "/^----/d" \
				-e "/GaryOS Download/d" \
				-e "s|^.*End Of File.*$$|<!-- composer >> box-end >> -->|g" \
			| $(SED) \
				-e "1,/box-end/{ /box-end/d; }" \
				; \
	fi \
		| $(SED) \
			-e "s|^([[]License.*[]]:) http.+$$|\1 license.html|g" \
			-e "s|([( ])(artifacts[/])|\1<composer_root>/projects/$($(@))/\2|g" \
		>>$(CURDIR)/$(@)
	@$(ECHO) "$(_D)"

################################################################################
endif
################################################################################
# end of file
################################################################################
