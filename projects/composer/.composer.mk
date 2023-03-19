#>override COMPOSER_TARGETS		:= .targets index.html
override COMPOSER_TARGETS		:= index.html license.html
override COMPOSER_SUBDIRS		:= .null
override COMPOSER_IGNORES		:= README.md LICENSE.md license.md artifacts
#>index.html: README.html
#>index.html:
#>	@$(call $(COMPOSER_TINYNAME)-ln,README.html,$(@))
