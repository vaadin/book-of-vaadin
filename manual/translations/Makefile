USERNAME =
PASSWORD =

IMPORTZIP = import/translated.zip
IMPORTDIR = import
RESULTDIR = ../../build/result/package/WebContent/docs
PUBLISHURI = vaadin@vaadin.com:download/book-of-vaadin/current/translations
PUBLISHZIP = book-of-vaadin-translations.zip

LANGUAGES = fi-fi

all: import compile publish

compile: fi

publish:
	cd $(RESULTDIR) ; zip -r book-of-vaadin-translations.zip book-fi
	scp $(RESULTDIR)/$(PUBLISHZIP) $(PUBLISHURI)
	ssh vaadin@vaadin.com bin/unpack-book-translations.py

################################################################################
# Language builds
################################################################################

fi:
	cd ../../build ; ant localized-docs -Dlocale=fi_FI

################################################################################
# Import from translation site
################################################################################
import: copyover FORCE

unzip: $(IMPORTZIP) FORCE
	unzip -o $(IMPORTZIP) -d $(IMPORTDIR)
	touch $(IMPORTDIR)/*/*

$(IMPORTZIP): FORCE
	mkdir -p $(IMPORTDIR)
	rm -rf ./$(IMPORTDIR)/*-*
	curl --user $(USERNAME):$(PASSWORD) https://www.getlocalization.com/bookofvaadin/api/translations/zip -o $(IMPORTZIP)

# Copy imported PO files over the old translations
copyover: fi_FI/*.po unzip FORCE

fi_FI/%.po: $(IMPORTDIR)/fi-fi/%_fi-fi.po* unzip FORCE
	cp $< $@

################################################################################

FORCE:
