<?xml version='1.0'?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <!-- ==================================================================== -->
  <!-- This is the common HTML stylesheet for all HTML-based manuals:       -->
  <!--   - Regular HTML manual                                              -->
  <!--   - Vaadin Manual as an Eclipse Plugin                               -->
  <!--                                                                      -->
  <!-- This is a template that has the following tags:                      -->
  <!--   - @BODYHEADER@                                                     -->
  <!--   - @BODYFOOTER@                                                     -->
  <!-- ==================================================================== -->

  <!-- Use a custom HTML stylesheet. -->
  <xsl:param name="html.stylesheet" select="'html-style/local.css'"/>

  <xsl:param name="tablecolumns.extension">0</xsl:param>

  <!-- Use the'xml:id' attribute of chapters and sections for the
       filename with .html extension. -->
  <xsl:param name="use.id.as.filename">1</xsl:param>

  <!-- Suppress warnings from missing IDs for titles. -->
  <xsl:param name="id.warnings">0</xsl:param>
  
  <!-- Chunk quietly so we can see errors more easily. -->
  <xsl:param name="chunk.quietly" select="1"/>

  <!-- ==================================================================== -->
  <!-- Custom HTML navigation.                                              -->
  <!-- ==================================================================== -->
  <xsl:template name="chunk-element-content" priority="100">
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:param name="nav.context"/>
    <xsl:param name="content">
      <xsl:apply-imports/>
    </xsl:param>

    <xsl:call-template name="user.preroot"/>

    <html>
      <xsl:call-template name="html.head">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
      
      <body>
        <xsl:call-template name="body.attributes"/>
        @BODYHEADER@
        <div id="page">
          <xsl:call-template name="user.header.navigation"/>
		
          <xsl:call-template name="header.navigation">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
            <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>
          
          <xsl:call-template name="user.header.content"/>
		
          <xsl:copy-of select="$content"/>
          
          <xsl:call-template name="user.footer.content"/>
		
          <xsl:call-template name="footer.navigation">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
            <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>
          
          <xsl:call-template name="user.footer.navigation"/>
        </div>
        @BODYFOOTER@
      </body>
    </html>
    <xsl:value-of select="$chunk.append"/>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Chapter numbering                                                    -->
  <!-- ==================================================================== -->

  <!-- Number chapters over the set instead of the book. -->
  <!-- From common/labels.xsl                            -->
  <xsl:template match="chapter" mode="label.markup">
    <xsl:choose>
      <xsl:when test="@label">
        <xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:when test="string($chapter.autolabel) != 0">
        <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::part">
          <xsl:variable name="part.label">
            <xsl:apply-templates select="ancestor::part" 
                                 mode="label.markup"/>
          </xsl:variable>
          <xsl:if test="$part.label != ''">
            <xsl:value-of select="$part.label"/>
            <xsl:apply-templates select="ancestor::part" 
                                 mode="intralabel.punctuation"/>
          </xsl:if>
        </xsl:if>
        <xsl:variable name="format">
          <xsl:call-template name="autolabel.format">
            <xsl:with-param name="format" select="$chapter.autolabel"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$label.from.part != 0 and ancestor::part">
            <xsl:number from="part" count="chapter" format="{$format}" level="any"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Use 'set' here instead of 'book'. -->
            <xsl:number from="set" count="chapter" format="{$format}" level="any"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Custom title page.                                                   -->
  <!-- ==================================================================== -->

  <xsl:include href="custom-html-titlepage.xsl"/>

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
  <xsl:template match="pubdate" mode="book.titlepage.recto.auto.mode">
    <xsl:message>
      <xsl:text>Setting publication date as </xsl:text>
      <xsl:value-of select="$manual.pubdate"/>
    </xsl:message>
    <xsl:call-template name="paragraph">
      <xsl:with-param name="class" select="local-name(.)"/>
      <xsl:with-param name="content">
        <xsl:value-of select="$manual.pubdate"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Custom header data elements. Not processed - skip. -->
  <xsl:template match="headerdata|headericon">
  </xsl:template>

  <!-- Translator info on recto title page -->
  <xsl:template match="authorgroup[@role='translators']" mode="book.titlepage.recto.mode">
    <!-- Include translators only if translated -->
    <xsl:if test="othercredit[1]/contrib != 'Translation'">
      <!-- Get translation of "Translated by" from the first translator -->
      <fo:block>
        <xsl:value-of select="othercredit[1]/contrib"/>
      </fo:block>

      <xsl:apply-templates mode="book.titlepage.recto.mode"/>
    </xsl:if>
  </xsl:template>

  <!-- Format translator name and email -->
  <xsl:template match="othercredit[@class='translator']" mode="book.titlepage.recto.mode">
    <xsl:if test="personname/firstname">
      <xsl:value-of select="personname/firstname"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="personname/lastname"/>
    </xsl:if>
    <xsl:if test="email">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="email"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Table of Contents                                                    -->
  <!-- ==================================================================== -->

  <xsl:param name="generate.toc">
    appendix  nop
    article   toc
    book      toc
    chapter   toc
    part      toc
    preface   nop
    qandadiv  nop
    qandaset  nop
    reference toc,title
    section   nop
    set       toc
  </xsl:param>

  <!-- ==================================================================== -->
  <!-- Book Example References                                              -->
  <!-- ==================================================================== -->

  <!-- URL to the Book Examples application -->
  <xsl:param name="book.examples.url" select="'http://demo.vaadin.com/book-examples-vaadin7/book/'"/>

  <xsl:template match="book-example">
    <xsl:element name="div">
      <xsl:attribute name="class">
        <xsl:value-of select="'book-example'"/>
      </xsl:attribute>
      
      <!-- Optional style attribute -->
      <xsl:if test="@style != ''">
        <xsl:attribute name="style">
          <xsl:value-of select="@style"/>
        </xsl:attribute>
      </xsl:if>

      <!-- Use table to valign the icon and possible caption -->
      <table>
        <tr valign="middle">
          <td>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat($book.examples.url, '#', @eid)"/>
              </xsl:attribute>

              <!-- Open in new window -->
              <xsl:attribute name="target">
                <xsl:value-of select="'_blank'"/>
              </xsl:attribute>
              
              <xsl:element name="img">
                <xsl:attribute name="src">
                  <xsl:value-of select="'img/book-example-lo.png'"/>
                </xsl:attribute>
                <xsl:attribute name="border">
                  <xsl:value-of select="0"/>
                </xsl:attribute>

                <!-- Height is needed for proper vertical-align with text -->
                <xsl:attribute name="width">
                  <xsl:value-of select="227"/>
                </xsl:attribute>
                <xsl:attribute name="height">
                  <xsl:value-of select="38"/>
                </xsl:attribute>
          
                <xsl:attribute name="align">
                  <xsl:value-of select="'absmiddle'"/>
                </xsl:attribute>
              </xsl:element>
            </xsl:element>
          </td>

          <!-- Text content in the element is optional -->
          <xsl:if test="text() != ''">
            <td>
              <span style="font-style: italic">
                <xsl:value-of select="text()"/>
              </span>
            </td>
          </xsl:if>
        </tr>
      </table>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
