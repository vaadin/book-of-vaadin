# This just builds the custom title page XSL for the manual.
# This needs to be run only if the conf/custom-fo-titlepage.xml is changed.

CLASSPATH = ../lib/XEP/lib/saxon.jar

TARGETS = conf/custom-fo-titlepage.xsl conf/custom-fo-titlepage-pocket.xsl conf/custom-html-titlepage.xsl

all: titlepage

titlepage: $(TARGETS)

conf/custom-fo-titlepage.xsl: conf/custom-fo-titlepage.xml xsl/template/titlepage.xsl
	java -classpath $(CLASSPATH) com.icl.saxon.StyleSheet $^ > $@

conf/custom-fo-titlepage-pocket.xsl: conf/custom-fo-titlepage-pocket.xml xsl/template/titlepage.xsl
	java -classpath $(CLASSPATH) com.icl.saxon.StyleSheet $^ > $@

conf/custom-html-titlepage.xsl: conf/custom-html-titlepage.xml xsl/template/titlepage.xsl
	java -classpath $(CLASSPATH) com.icl.saxon.StyleSheet $^ > $@

clean: FORCE
	rm $(TARGETS)

FORCE:
