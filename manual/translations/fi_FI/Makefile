LANGUAGE =	fi
POFILES  =	book.po part1-introduction.po
XMLFILES =  book.xml \
			part1-advanced.xml part1-architecture.xml part1-datamodel.xml \
			part1-getting-started.xml part1-introduction.xml part1-themes.xml \
			part1-vaadin.xml part1-application.xml part1-components.xml \
			part1-eclipse.xml part1-gwt.xml part1-layout.xml part1-uidl.xml

all:
	@echo "Targets: 'make merge' or 'make compile'"

################################################################################
# Merge
################################################################################
merge: $(POFILES)

%.po: ../pot/%.pot
	msgmerge -U $@ $<


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
