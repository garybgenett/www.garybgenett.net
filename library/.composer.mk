override COMPOSER_INCLUDE := $(COMPOSER_DIR) $(COMPOSER_ROOT) $(CURDIR)
override COMPOSER_DEPENDS := 
override COMPOSER_EXT := .md
override COMPOSER_TARGETS := 
override COMPOSER_SUBDIRS := .null
override c_site := 1
override c_type := html
index.html: index-include.md.cms
sitemap.html: sitemap-include.md.cms
