<?xml version='1.0'?>
<!-- ==================================================================== -->
<!-- IT Mill Customizations to PDF formatting.                            -->
<!-- ==================================================================== -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="../xsl/fo/docbook.xsl"/>

  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.80"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>  
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.6"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.4"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Turn off Part ToC. -->
  <xsl:template name="generate.part.toc">
  </xsl:template>

  <!-- Make some elements look bold. -->
  <xsl:template match="guibutton">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guilabel">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guimenu">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guisubmenu">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guimenuitem">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="classname">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>

  <!-- Turn hyphenation off in monospace (parameter)-->
  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>

  <!-- Deeper indentation of lists. -->
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="margin-left">1cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Admonitions (warnings, notes, etc.)                                  -->
  <!-- ==================================================================== -->

  <!-- Admonition graphics (warning and note boxes). -->
  <xsl:param name="admon.graphics">1</xsl:param>
  <xsl:param name="admon.graphics.path">manual/img/icons/</xsl:param>

  <!-- Admonition (warning/note) box. -->
  <xsl:attribute-set name="graphical.admonition.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">1pt</xsl:attribute>
    <xsl:attribute name="border-color">grey</xsl:attribute>
    <xsl:attribute name="padding">2pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Admonition (warning/note) title. -->
  <xsl:attribute-set name="admonition.title.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Custom headers.                                                      -->
  <!-- ==================================================================== -->

  <!-- Custom header data element. Not processed - skip. -->
  <xsl:template match="headerdata">
  </xsl:template>

  <!-- Custom header logo element. -->
  <xsl:template match="headerlogo">
    <xsl:apply-templates select="imagedata"/>
  </xsl:template>

  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    
    <fo:block>
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing -->
        </xsl:when>
        
        <xsl:when test="$sequence='even' and $position='left'">
          <xsl:apply-templates select="/book/headerdata/headerlogo"/>
        </xsl:when>
        
        <xsl:when test="$sequence='odd' and $position='left'">
          <!-- nothing -->
        </xsl:when>
        
        <xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
          <xsl:if test="$pageclass != 'titlepage'">
            <xsl:choose>
              <xsl:when test="ancestor::book and ($double.sided != 0)">
                <fo:block>
                  <!-- Have an empty line above the section header because of the logo. -->
                  <xsl:apply-templates select="." mode="titleabbrev.markup"/>
                </fo:block>
                <fo:block>
                  <fo:retrieve-marker retrieve-class-name="section.head.marker"
                    retrieve-position="first-including-carryover"
                    retrieve-boundary="page-sequence"/>
                </fo:block>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="." mode="titleabbrev.markup"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:when>
        
        <xsl:when test="$position='center'">
          <!-- nothing for empty and blank sequences -->
        </xsl:when>
        
        <xsl:when test="$sequence='odd' and $position='right'">
          <xsl:apply-templates select="/book/headerdata/headerlogo"/>
        </xsl:when>
      
        <xsl:when test="$sequence='even' and $position='right'">
          <!-- nothing -->
        </xsl:when>
        
        <xsl:when test="$sequence = 'first'">
          <!-- nothing for first pages -->
        </xsl:when>
        
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing for blank pages -->
        </xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Custom footers.                                                      -->
  <!-- ==================================================================== -->
<xsl:template name="footer.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- nop; no footer on title pages -->
      </xsl:when>

      <xsl:when test="$double.sided != 0 and $sequence = 'even' and $position='left'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='left'">
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='right'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'even') and $position='right'">
      </xsl:when>

      <xsl:when test="$double.sided != 0 and $position='center'">
        <!-- Custom footer: -->
        <xsl:value-of select="/book/info/title"/>
        <!-- <xsl:text>Vaadin Reference Manual</xsl:text>  -->
      </xsl:when>

      <xsl:when test="$double.sided = 0 and $position='center'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$sequence='blank'">
        <xsl:choose>
          <xsl:when test="$double.sided != 0 and $position = 'left'">
            <fo:page-number/>
          </xsl:when>
          <xsl:when test="$double.sided = 0 and $position = 'center'">
            <fo:page-number/>
          </xsl:when>
          <xsl:otherwise>
            <!-- nop -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

    
  <!-- ==================================================================== -->
  <!-- Custom title page.                                                   -->
  <!-- ==================================================================== -->

  <xsl:include href="custom-fo-titlepage.xsl"/>

  <!-- Get the publication date from the command-line arguments. -->
  <xsl:param name="manual.pubdate">xxxx-xx-xx</xsl:param>
  <xsl:template match="pubdate" mode="titlepage.mode">
    <fo:block>
      <xsl:text>Published: </xsl:text> 
      <xsl:value-of select="$manual.pubdate"/>
    </fo:block>
  </xsl:template>

  <!-- Get the version number from the command-line arguments. -->
  <xsl:param name="manual.version">x.x.x</xsl:param>
  <xsl:template match="releasenumber">
    <xsl:value-of select="$manual.version"/>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Custom floating figure to replace broken informalfigure.             -->
  <!-- ==================================================================== -->

  <!-- This is copied as is from 'figure' template. -->
  <xsl:template match="informalfigure">
    <xsl:variable name="param.placement"
      select="substring-after(normalize-space($formal.title.placement),
              concat(local-name(.), ' '))"/>

    <xsl:variable name="placement">
      <xsl:choose>
        <xsl:when test="contains($param.placement, ' ')">
          <xsl:value-of select="substring-before($param.placement, ' ')"/>
        </xsl:when>
        <xsl:when test="$param.placement = ''">before</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$param.placement"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="figure">
      <xsl:choose>
        <xsl:when test="@pgwide = '1'">
          <fo:block xsl:use-attribute-sets="pgwide.properties">
            <xsl:call-template name="formal.object">
              <xsl:with-param name="placement" select="$placement"/>
            </xsl:call-template>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="formal.object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="floatstyle">
      <xsl:call-template name="floatstyle"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$floatstyle != ''">
        <xsl:call-template name="floater">
          <xsl:with-param name="position" select="$floatstyle"/>
          <xsl:with-param name="content" select="$figure"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$figure"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Other.                                                               -->
  <!-- ==================================================================== -->

  <!-- Line spacing suitable for proofreading. -->
  <!-- xsl:param name="line-height" select="'2em'"/ -->

</xsl:stylesheet>
