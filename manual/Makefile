all: images icons

################################################################################
################################################################################

DATE = `date +'%Y-%m-%d'`
VERSION = `cat ../build/VERSION.properties|sed -e 's/^version=\([0-9\.]\+\).\+/\1/'`

# Command-line parameters for Docbook
DBPARS =	section.autolabel=1 \
			section.label.includes.component.label=1 \
			section.autolabel.max.depth=2 \
			draft.mode='no' \
			double.sided=1 \
			manual.pubdate=${DATE} \
			manual.version=$(VERSION) \
			manual.fonts.custom=1

# List of images to be converted from SVG to PNG
IMAGES =	intro/architecture intro/architecture-detailed intro/toolchain intro/toolkit-package \
			intro/intro-themes-faded \
			arch/clientside-arch \
			components/component-diagram components/component-abstractions \
			components/tooltip-plain-withpointer components/tooltip-richtext-withpointer \
			components/field-diagram components/field-interface \
			application/application-architecture application/resource_classdiagram \
			advanced/liferay-display \
			themes/theme-contents themes/eclipse-theme-created-annotated \
			gwt/gwt-widgets gwt/gwt-widget-files gwt/gwt-hostedmode-project-annotated\
			vaadin-logo

# List if icons in img/icons
ICONS =		warning note

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
	inkscape --export-png $@ --export-dpi=150 --export-area-drawing $<

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

DOCBOOK = ../build/docbook/conf/custom-fo-docbook.xsl
DOCBOOK_POCKET = ../build/docbook/conf/custom-fo-docbook-pocket.xsl
#HIGHLIGHTER_CONFIG = -Dxslthl.config=$(PWD)/../build/docbook/xsl/highlighting/xslthl-config.xml

# The highlighter configuration is included in the DocBook package.
# It must be given as an absolute URL.
HIGHLIGHTER_CONFIG = -Dxslthl.config="file://$(PWD)/../build/docbook/xsl/highlighting/xslthl-config.xml"

# Process Docbook to FO
book.fo: book.xml part1.xml images
	@echo $(VERSION)
	@echo "Highlighter configuration: $(HIGHLIGHTER_CONFIG)"
	java -Xms256M -Xmx512M -classpath ../build/lib/saxon.jar:../build/lib/xercesImpl.jar:../build/lib/xml-apis.jar:../build/lib/xslthl.jar $(HIGHLIGHTER_CONFIG) com.icl.saxon.StyleSheet -o book.fo book.xml $(DOCBOOK) $(DBPARS)
# ../build/lib/xalan.jar ... org.apache.xalan.xslt.Process

book-pocket.fo: book.xml part1.xml images
	@echo $(VERSION)
	@echo "Highlighter configuration: $(HIGHLIGHTER_CONFIG)"
	java -Xms256M -Xmx512M -classpath ../build/lib/saxon.jar:../build/lib/xercesImpl.jar:../build/lib/xml-apis.jar:../build/lib/xslthl.jar $(HIGHLIGHTER_CONFIG) com.icl.saxon.StyleSheet -o book-pocket.fo book.xml $(DOCBOOK_POCKET) $(DBPARS)

XEPPARS = -Dcom.renderx.xep.CONFIG=build/lib/XEP/xep-vaadinfonts.xml

# Run XEP FO processor to convert FO to PDF.
book.pdf: book.fo
	cd .. ; /opt/RenderX/XEP/xep $(XEPPARS) <manual/book.fo >manual/book.pdf
#	rm book.fo

book-pocket.pdf: book-pocket.fo
	cd .. ; /opt/RenderX/XEP/xep $(XEPPARS) <manual/book-pocket.fo >manual/book-pocket.pdf

# View the result
viewbook: book.pdf FORCE
	kpdf book.pdf

################################################################################
# Misc
################################################################################

FORCE:
