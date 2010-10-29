all: vaadin-sqlcontainer-tutorial.pdf

DATE = `date +'%Y-%m-%d'`
VERSION = `cat ../../../build/VERSION.properties|sed -e 's/^version=\([0-9\.]\+\).\+/\1/'`

# Command-line parameters for Docbook
DBPARS =	-param section.autolabel 1 \
			-param section.label.includes.component.label 1 \
			-param section.autolabel.max.depth 2 \
			-param draft.watermark.image '' \
			-param draft.mode 'no' \
			-param double.sided 1 \
			-param manual.pubdate ${DATE} \
			-param manual.version $(VERSION)

################################################################################
# Docbook processing
################################################################################

DOCBOOK = ../../../build/docbook/conf/custom-fo-docbook.xsl

# Process Docbook to FO
vaadin-sqlcontainer-tutorial.fo: tutorial.xml FORCE
	@echo $(VERSION)
	java -Xms256M -Xmx512M -classpath ../../../build/lib/xalan.jar:../../../build/lib/xercesImpl.jar:../../../build/lib/xml-apis.jar org.apache.xalan.xslt.Process -xsl $(DOCBOOK) -in $< -out $@ $(DBPARS)

XEPCONF = -Dcom.renderx.xep.CONFIG=../../../build/lib/XEP/xep.xml

# Run XEP FO processor to convert FO to PDF.
vaadin-sqlcontainer-tutorial.pdf: vaadin-sqlcontainer-tutorial.fo
	/opt/RenderX/XEP/xep $(XEPCONF) < $< > $@
#	rm book.fo

# View the result
viewbook: vaadin-sqlcontainer-tutorial.pdf FORCE
	kpdf $<

################################################################################
# Misc
################################################################################

FORCE:
