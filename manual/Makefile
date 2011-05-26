all: images icons

################################################################################
################################################################################

DOCROOT = ..

# Document language; this is the default, translations can override this.
DBLANGUAGE = en

DBEXTRAPARS = l10n.gentext.language=$(DBLANGUAGE)

# Command-line parameters for Docbook
DBPARS =	section.autolabel=1 \
			section.label.includes.component.label=1 \
			section.autolabel.max.depth=2 \
			draft.mode='no' \
			double.sided=1 \
			manual.pubdate=${DATE} \
			manual.version=$(VERSION) \
			manual.fonts.custom=1 \
			xep.extensions=1 \
			$(DBEXTRAPARS)

# List of images to be converted from SVG to PNG
IMAGES =	intro/architecture intro/architecture-detailed intro/toolchain intro/toolkit-package \
			intro/intro-themes-faded \
			arch/clientside-arch \
			components/component-diagram components/component-abstractions \
			components/tooltip-plain-withpointer components/tooltip-richtext-withpointer \
			components/field-diagram components/field-interface \
			components/slider-example1 \
			components/textfield-diagram \
			application/application-architecture application/resource_classdiagram \
			advanced/liferay-display \
			themes/theme-contents themes/eclipse-theme-created-annotated \
			gwt/gwt-widgets gwt/gwt-widget-files gwt/gwt-hostedmode-project-annotated\
			gwt/gwt-custom-architecture \
			vaadin-logo book-example \
			eclipse/editor-design-2-crop eclipse/widgetset-compiling-toolbar \
			datamodel/datamodel-interfaces \
			rapid/domain-model

# List of source XML files
XMLFILES =  book.xml \
			part1-advanced.xml part1-architecture.xml part1-datamodel.xml \
			part1-getting-started.xml part1-introduction.xml part1-themes.xml \
			part1-vaadin.xml part1-application.xml part1-components.xml \
			part1-eclipse.xml part1-gwt.xml part1-layout.xml part1-uidl.xml


# List if icons in img/icons
ICONS =		warning note

# Date format
DATE = `date +'%Y-%m-%d'`

# Determine Vaadin version number
VERSION = `cat $(DOCROOT)/build/VERSION.properties|sed -e 's/^version=\([0-9]\+\.[0-9]\+\).\+/\1/'`

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
# Icons
################################################################################

SRCICONS := $(foreach file, $(ICONS), original-drawings/icons/$(file).svg)
TRGICONS := $(foreach file, $(ICONS), img/icons/$(file).png)

icons: $(TRGICONS) FORCE

$(TRGICONS): img/icons/%.png: original-drawings/icons/%.svg
	inkscape --export-png $@ --export-dpi=150 --export-area-drawing $<

################################################################################
# Docbook processing
################################################################################
# Main target: book.pdf
# Parameters:
#     A4: Make A4 page size. 
#         $ make book.pdf A4=1

DOCBOOK = $(DOCROOT)/build/docbook/conf/custom-fo-docbook.xsl
DOCBOOK_POCKET = $(DOCROOT)/build/docbook/conf/custom-fo-docbook-pocket.xsl
#HIGHLIGHTER_CONFIG = -Dxslthl.config=$(PWD)/../build/docbook/xsl/highlighting/xslthl-config.xml

# The highlighter configuration is included in the DocBook package.
# It must be given as an absolute URL.
HIGHLIGHTER_CONFIG = -Dxslthl.config="file://$(PWD)/../build/docbook/xsl/highlighting/xslthl-config.xml"

# Process Docbook to FO
book.fo: $(XMLFILES) images
	@echo $(VERSION)
	@echo "Highlighter configuration: $(HIGHLIGHTER_CONFIG)"
	java -Xms256M -Xmx512M -classpath $(DOCROOT)/build/lib/saxon.jar:$(DOCROOT)/build/lib/xercesImpl.jar:$(DOCROOT)/build/lib/xml-apis.jar:$(DOCROOT)/build/lib/xslthl.jar $(HIGHLIGHTER_CONFIG) com.icl.saxon.StyleSheet -o book.fo book.xml $(DOCBOOK) $(DBPARS)
# ../build/lib/xalan.jar ... org.apache.xalan.xslt.Process

book-pocket.fo: $(XMLFILES) images
	@echo $(VERSION)
	@echo "Highlighter configuration: $(HIGHLIGHTER_CONFIG)"
	java -Xms256M -Xmx512M -classpath $(DOCROOT)/build/lib/saxon.jar:$(DOCROOT)/build/lib/xercesImpl.jar:$(DOCROOT)/build/lib/xml-apis.jar:$(DOCROOT)/build/lib/xslthl.jar $(HIGHLIGHTER_CONFIG) com.icl.saxon.StyleSheet -o book-pocket.fo book.xml $(DOCBOOK_POCKET) $(DBPARS)

XEPPARS = -Dcom.renderx.xep.CONFIG=build/lib/XEP/xep-vaadinfonts.xml -quiet

# Run XEP FO processor to convert FO to PDF.
book.pdf: book.fo
	cd $(DOCROOT) ; /opt/RenderX/XEP/xep $(XEPPARS) <manual/book.fo >manual/book.pdf
	cp book.pdf /var/www/book.pdf
	rm book.fo

book-pocket.pdf: book-pocket.fo
	cd $(DOCROOT) ; /opt/RenderX/XEP/xep $(XEPPARS) <manual/book-pocket.fo >manual/book-pocket.pdf
	cp book-pocket.pdf /var/www/book-pocket.pdf
	rm book-pocket.fo

# View the result
viewbook: book.pdf FORCE
	kpdf book.pdf

################################################################################
# Internationalization
################################################################################

i18n: pot

POTFILES := $(foreach file, $(XMLFILES), $(patsubst %.xml, %.pot, translations/pot/$(file)))

pot: $(POTFILES)

translations/pot/%.pot: %.xml
	xml2pot $< > $@

################################################################################
# Compile localizations
################################################################################

l10n: fi_FI

FI_TRANSLATED := book.po

################################################################################
# Misc
################################################################################

FORCE:
