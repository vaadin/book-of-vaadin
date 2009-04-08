<?xml version='1.0'?>

<!-- This stylesheet builds just the DocBook ToC and plugin.xml for Eclipse Help. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- Use the Eclipse Help template to generate also the Eclipse metada files. -->
  <xsl:import href="../xsl/eclipse/eclipse.xsl"/>

  <!-- Eclipse Help parameters. -->
  <xsl:param name="eclipse.plugin.name" select="'Vaadin Help'"/>
  <xsl:param name="eclipse.plugin.id" select="'com.vaadin.manual'"/>
  <xsl:param name="eclipse.plugin.provider" select="'IT Mill'"/>
  
  <!-- Custom Eclipse Help parameters. -->
  <xsl:param name="eclipse.plugin.version">x.x.x-vyyyymmddhhmm</xsl:param>

  <!-- Use the'xml:id' attribute of chapters and sections for the
       filename with .html extension. -->
  <xsl:param name="use.id.as.filename">1</xsl:param>

  <!-- Suppress warnings from missing IDs for titles. -->
  <xsl:param name="id.warnings">0</xsl:param>
  
  <!-- Chunk quietly so we can see errors more easily. -->
  <xsl:param name="chunk.quietly" select="1"/>

  <!-- For some reason this must not be enabled. -->
  <xsl:param name="tablecolumns.extension" select="0"/>

  <!-- Custom header data elements. Not processed - skip. -->
  <xsl:template match="headerdata|headericon|releasenumber">
  </xsl:template>
</xsl:stylesheet>