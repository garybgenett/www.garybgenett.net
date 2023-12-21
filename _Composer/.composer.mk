################################################################################
# composer settings file
################################################################################

override _EXPORT_GIT_REPO		:= ssh://git@github.com/garybgenett/www.garybgenett.net.git
override _EXPORT_GIT_BNCH		:= gh-pages

override _EXPORT_FIRE_ACCT		:= gary@tresobis.org
override _EXPORT_FIRE_PROJ		:= garybgenett-site

################################################################################

override COMPOSER_EXPORTS		:= CNAME README.markdown .nojekyll
override COMPOSER_EXPORTS		+= .composer.mk .composer.yml .composer-*
override COMPOSER_EXPORTS		+= _header* _footer*
override COMPOSER_EXPORTS		+= .targets
ifneq ($(COMPOSER_CURDIR),)
override COMPOSER_SUBDIRS		:= .null
override COMPOSER_IGNORES		:= library
endif

########################################

override MAKEJOBS			:= 0
override COMPOSER_INCLUDE		:= 1

override c_site				:= 1
override c_logo				:= $(COMPOSER_ROOT)/_branding/logo.png
override c_icon				:= $(COMPOSER_ROOT)/_branding/logo.png

################################################################################
ifeq ($(COMPOSER_CURDIR),)
################################################################################

.PHONY: $(notdir $(COMPOSER_ROOT))-$(EXPORTS)
$(notdir $(COMPOSER_ROOT))-$(EXPORTS):
	@$(TOUCH) $(COMPOSER_ROOT)/.nojekyll
	@$(RSYNC) \
		$(abspath $(COMPOSER_ROOT)/../../coding/composer/$(notdir $(PUBLISH_ROOT))/$(notdir $(COMPOSER_EXPORT_DEFAULT)))/ \
		$(COMPOSER_EXPORT)/projects/composer/$(notdir $(PUBLISH_ROOT))
	@(cd $(COMPOSER_ROOT) && $(HOME)/.bashrc git-perms root)

################################################################################
endif
################################################################################
# end of file
################################################################################
