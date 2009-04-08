all: images

DATE = `date +'%Y-%m-%d'`
VERSION = `cat ../build/VERSION.properties|sed -e 's/^version=\([0-9\.]\+\).\+/\1/'`

# Command-line parameters for Docbook
DBPARS =	-param section.autolabel 1 \
			-param section.label.includes.component.label 1 \
			-param section.autolabel.max.depth 2 \
			-param draft.watermark.image '' \
			-param draft.mode 'no' \
			-param double.sided 1 \
			-param manual.pubdate ${DATE} \
			-param manual.version $(VERSION)

# List of images to be converted from SVG to PNG
IMAGES =	intro/architecture intro/architecture-detailed intro/toolchain intro/toolkit-package \
			intro/intro-themes-faded \
			arch/clientside-arch \
			application/application-architecture application/resource_classdiagram \
			themes/theme-contents \
			gwt/gwt-widgets gwt/gwt-widget-files gwt/gwt-hostedmode-project-annotated\

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
# Docbook processing
################################################################################

DOCBOOK = ../build/docbook/conf/custom-fo-docbook.xsl

# Process Docbook to FO
book.fo: book.xml part1.xml images
	@echo $(VERSION)
	java -Xms256M -Xmx512M -classpath ../build/lib/xalan.jar:../build/lib/xercesImpl.jar:../build/lib/xml-apis.jar org.apache.xalan.xslt.Process -xsl $(DOCBOOK) -in book.xml -out book.fo $(DBPARS)

# Run XEP FO processor to convert FO to PDF.
book.pdf: book.fo
	/opt/RenderX/XEP/xep <book.fo >book.pdf
#	rm book.fo

# View the result
viewbook: book.pdf FORCE
	kpdf book.pdf

################################################################################
# Misc
################################################################################

FORCE:
