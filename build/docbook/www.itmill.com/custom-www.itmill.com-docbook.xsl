<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../xsl/html/chunk.xsl"/>

  <xsl:param name="html.stylesheet" select="'../itmill.css'" />
  
  <xsl:param name="tablecolumns.extension">0</xsl:param>
  
  <!-- Use the'xml:id' attribute of chapters and sections for the
       filename with .html extension. -->
  <xsl:param name="use.id.as.filename">1</xsl:param>

  <!-- Suppress warnings from missing IDs for titles. -->
  <xsl:param name="id.warnings">0</xsl:param>
  
  <!-- Chunk quietly so we can see errors more easily. -->
  <!-- xsl:param name="chunk.quietly" select="1"/ -->

  <xsl:template name="chunk-element-content" priority="100">
    <xsl:param name="prev" />
    <xsl:param name="next" />
    <xsl:param name="nav.context" />
    <xsl:param name="content">
      <xsl:apply-imports />
    </xsl:param>

    <!-- <xsl:call-template name="user.preroot" /> -->

    <xsl:text disable-output-escaping="yes">
      <![CDATA[<%String menu="3";String title="]]></xsl:text><xsl:value-of select="normalize-space(title)"/><xsl:text disable-output-escaping="yes"><![CDATA[";%><jsp:include page="/inc/header.jsp"><jsp:param name="title" value="<%=title %>" /><jsp:param name="menu" value="<%=menu %>" /></jsp:include>]]>
    </xsl:text>
    
							<table class="columns subpage manual">
								<tr>
									<td class="left">

										<xsl:call-template
											name="user.header.navigation" />

										<xsl:call-template
											name="header.navigation">
											<xsl:with-param name="prev"
												select="$prev" />
											<xsl:with-param name="next"
												select="$next" />
											<xsl:with-param
												name="nav.context" select="$nav.context" />
										</xsl:call-template>

										<xsl:call-template
											name="user.header.content" />

										<xsl:copy-of select="$content" />

										<xsl:call-template
											name="user.footer.content" />

										<xsl:call-template
											name="footer.navigation">
											<xsl:with-param name="prev"
												select="$prev" />
											<xsl:with-param name="next"
												select="$next" />
											<xsl:with-param
												name="nav.context" select="$nav.context" />
										</xsl:call-template>

										<xsl:call-template
											name="user.footer.navigation" />

									</td>
									<td class="right"></td>
								</tr>
							</table>
<xsl:text disable-output-escaping="yes">
<![CDATA[<jsp:include page="/inc/footer.jsp"><jsp:param name="submenu" value="3" /></jsp:include>]]>
</xsl:text>
<xsl:value-of select="$chunk.append" />
</xsl:template>

<!-- ==================================================================== -->
  <!-- Custom title page.                                                   -->
  <!-- ==================================================================== -->

  <!-- Use the version number given as command-line parameter. -->
  <xsl:param name="manual.version">x.x.x</xsl:param>
  <xsl:template match="releasenumber">
    <xsl:value-of select="$manual.version"/>
  </xsl:template>

  <!-- Display the productname without line break that the default template uses,
       because otherwise there will be a line break before the manual version number. -->
  <xsl:template match="productname" mode="titlepage.mode">
    <span>
      <xsl:apply-templates select="." mode="class.attribute"/>
      <xsl:apply-templates mode="titlepage.mode"/>
    </span>
  </xsl:template>

  <!-- Use the publication date given as command-line parameter. -->
  <xsl:param name="manual.pubdate">XXXX-XX-XX</xsl:param>
  <xsl:template match="pubdate" mode="titlepage.mode">
    <xsl:call-template name="paragraph">
      <xsl:with-param name="class" select="local-name(.)"/>
      <xsl:with-param name="content">
        <xsl:value-of select="$manual.pubdate"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>