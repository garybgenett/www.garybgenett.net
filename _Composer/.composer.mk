################################################################################
# composer settings file
################################################################################

override _EXPORT_GIT_REPO		:= ssh://git@github.com/garybgenett/www.garybgenett.net.git
override _EXPORT_GIT_BRANCH		:= gh-pages

################################################################################

override COMPOSER_EXPORTS		:= CNAME README .nojekyll .composer.mk .composer.yml .targets
ifneq ($(COMPOSER_CURDIR),)
override COMPOSER_SUBDIRS		:= .null
override COMPOSER_IGNORES		:= library
endif

########################################

override MAKEJOBS			:= 0

override COMPOSER_INCLUDE		:= 1
override c_site				:= 1

override c_logo				:= $(COMPOSER_ROOT)/favicon.png
override c_icon				:= $(COMPOSER_ROOT)/favicon.png

################################################################################
ifeq ($(CURDIR),$(COMPOSER_ROOT))
################################################################################

.PHONY: .publish
.publish:
	@$(TOUCH) $(COMPOSER_ROOT)/.nojekyll
	@$(MAKE) --directory $(COMPOSER_ROOT) $(EXPORTS)
	@$(RSYNC) \
		$(abspath $(COMPOSER_ROOT)/../../coding/composer/$(notdir $(PUBLISH_ROOT))/$(notdir $(COMPOSER_EXPORT_DEFAULT)))/ \
		$(COMPOSER_EXPORT)/projects/composer/$(notdir $(PUBLISH_ROOT))
	@(cd $(COMPOSER_ROOT) && $(HOME)/.bashrc git-perms root)

################################################################################
endif
################################################################################
# end of file
################################################################################
