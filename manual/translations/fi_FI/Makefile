LANGUAGE =	fi
POFILES  =	book.po chapter-introduction.po
IMAGES =	intro/architecture-vaadin7
XMLFILES =  book.xml \
			chapter-advanced.xml chapter-architecture.xml chapter-datamodel.xml \
			chapter-getting-started.xml chapter-introduction.xml chapter-themes.xml \
			chapter-vaadin.xml chapter-application.xml chapter-components.xml \
			chapter-eclipse.xml chapter-gwt.xml chapter-layout.xml chapter-uidl.xml

all:
	@echo "Targets: 'make merge' or 'make compile'"

################################################################################
# Image conversions
################################################################################

# SVG source images
SRCIMAGES := $(foreach file, $(IMAGES), original-drawings/$(file).svg)

# Two size of target images
TRGIMAGES_HI := $(foreach file, $(IMAGES), img/$(file)-hi.png)
TRGIMAGES_LO := $(foreach file, $(IMAGES), img/$(file)-lo.png)

images: $(TRGIMAGES_HI) $(TRGIMAGES_LO) FORCE

$(TRGIMAGES_HI): img/%-hi.png: original-drawings/%.svg
	inkscape --export-png $@ --export-dpi=300 --export-area-drawing $<

$(TRGIMAGES_LO): img/%-lo.png: original-drawings/%.svg
	inkscape --export-png $@ --export-dpi=90 --export-area-drawing $<

################################################################################
# Merge
################################################################################
merge: $(POFILES)

%.po: ../pot/%.pot
	msgmerge --no-wrap -U $@ $<

################################################################################
# Compile
################################################################################
WORKDIR = result
TRANSLATED_XMLFILES := $(foreach file, $(POFILES), $(patsubst %.po, $(WORKDIR)/%.xml, $(file)))

compile: create-workdir copy-images copy-source-xml include-translated
	cd $(WORKDIR) ; make -f ../../../Makefile book.pdf DOCROOT=../../../.. MANUALPATH=manual/translations/fi_FI/result DBLANGUAGE=$(LANGUAGE)

create-workdir:
	mkdir -p $(WORKDIR)

# TODO: Allow localized images.
copy-images:
	cp -a -f ../../img  $(WORKDIR)
	cp -a -f ../../original-drawings $(WORKDIR)

# Copy the original files in case some of the files are not translated.
copy-source-xml:
	cp -a ../../*.xml ../../*.dtd $(WORKDIR)

# Copy the translated files on top of the untranslated ones
include-translated: $(TRANSLATED_XMLFILES)

$(WORKDIR)/%.xml: %.po FORCE
	po2xml ../../$(patsubst %.po,%.xml,$<) $< > $@

FORCE:
