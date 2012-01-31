<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../xsl/epub/docbook.xsl"/>

  <!-- ==================================================================== -->
  <!-- Settings                                                             -->
  <!-- ==================================================================== -->

  <xsl:param name="chapter.autolabel" select="1"/>
  <xsl:param name="part.autolabel" select="'I'"/>
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.autolabel.max.depth" select="2"/>
  <xsl:param name="section.label.includes.component.label" select="1"/>
  <xsl:param name="toc.max.depth" select="3"/>

  <!-- ==================================================================== -->
  <!-- Discarded elements                                                   -->
  <!-- ==================================================================== -->

  <xsl:template match="book-example">
    <!-- Simply ignore for now. Links are supported very poorly in readers. -->
  </xsl:template>

  <xsl:template match="releasenumber">
  </xsl:template>
</xsl:stylesheet>
