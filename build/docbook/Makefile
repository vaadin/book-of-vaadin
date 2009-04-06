# This just builds the custom title page XSL for the manual.
# This needs to be run only if the conf/custom-fo-titlepage.xml is changed.

all: titlepage

titlepage: conf/custom-fo-titlepage.xsl

conf/custom-fo-titlepage.xsl: conf/custom-fo-titlepage.xml xsl/template/titlepage.xsl
	java -classpath /usr/share/java/saxon.jar com.icl.saxon.StyleSheet conf/custom-fo-titlepage.xml xsl/template/titlepage.xsl > conf/custom-fo-titlepage.xsl
