all: images itmill-toolkit-tutorial.pdf

DATE = `date +'%Y-%m-%d'`
VERSION = `cat ../../build/VERSION.properties|sed -e 's/^version=\([0-9\.]\+\).\+/\1/'`

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
IMAGES =	

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

DOCBOOK = ../../build/docbook/conf/custom-fo-docbook.xsl

# Process Docbook to FO
itmill-toolkit-tutorial.fo: tutorial.xml FORCE
	@echo $(VERSION)
	java -Xms256M -Xmx512M -classpath ../../build/lib/xalan.jar:../../build/lib/xercesImpl.jar:../../build/lib/xml-apis.jar org.apache.xalan.xslt.Process -xsl $(DOCBOOK) -in $< -out $@ $(DBPARS)

XEPCONF = -Dcom.renderx.xep.CONFIG=../../build/lib/XEP/xep.xml

# Run XEP FO processor to convert FO to PDF.
itmill-toolkit-tutorial.pdf: itmill-toolkit-tutorial.fo
	/opt/RenderX/XEP/xep $(XEPCONF) < $< > $@
#	rm book.fo

# View the result
viewbook: itmill-toolkit-tutorial.pdf FORCE
	kpdf $<

################################################################################
# Misc
################################################################################

FORCE:
