<?xml version='1.0'?>
<!-- ==================================================================== -->
<!-- IT Mill Customizations to PDF formatting.                            -->
<!-- ==================================================================== -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:rx="http://www.renderx.com/XSL/Extensions">

  <xsl:import href="../xsl/fo/docbook.xsl"/>

  <!-- For syntax color highlighting. -->
  <xsl:import href="../xsl/highlighting/common.xsl"/>
  <xsl:import href="../xsl/fo/highlight.xsl"/>

  <xsl:param name="manual.fonts.custom" select="false"/>

  <!-- The Symbol font is disabled because it can't be embedded and the Helvetica
       font doesn't include the arrow, so must use some other font for it. -->
  <xsl:param name="menuchoice.menu.separator"><fo:inline font-family="Times New Roman"> &#x2192; </fo:inline></xsl:param>

  <!-- Enable syntax color highlighting. -->
  <xsl:param name="highlight.source" select="1"/>

  <!-- Always have the term above the definition -->
  <xsl:param name="variablelist.as.blocks" select="1"/>

  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.9"/>
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

  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">1.7cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- Do not display URLs in brackets after the link text. -->
  <xsl:param name="ulink.show" select="'0'"/>

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

  <!-- Turn hyphenation on in monospace (actually default) -->
  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="hyphenate">true</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
  </xsl:attribute-set>

  <!-- Deeper indentation of lists. -->
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="margin-left">1cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Table of Contents                                                    -->
  <!-- ==================================================================== -->

  <!-- Have chapter titles in bold. (from autotoc.xsl)-->
  <xsl:template name="toc.line">
    <xsl:param name="toc-context" select="NOTANODE"/>
    
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>
    
    <fo:block xsl:use-attribute-sets="toc.line.properties"
      end-indent="{$toc.indent.width}pt"
      last-line-end-indent="-{$toc.indent.width}pt">

      <!-- Vaadin customization: -->
      <xsl:choose>
        <xsl:when test="self::book">
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="margin-top">5mm</xsl:attribute>
        </xsl:when>

        <xsl:when test="self::part">
          <xsl:attribute name="margin-top">2.5mm</xsl:attribute>
        </xsl:when>

        <xsl:when test="self::chapter or self::appendix">
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="margin-top">2.5mm</xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <xsl:if test="local-name($toc-context) = 'chapter'">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="margin-left">0cm</xsl:attribute>
        <xsl:attribute name="margin-right">2cm</xsl:attribute>
      </xsl:if>

      <fo:inline keep-with-next.within-line="always">
        <fo:basic-link internal-destination="{$id}">
          <!-- Have Part title in the ToC -->
          <xsl:if test="self::part">
            <xsl:text>Part </xsl:text>
          </xsl:if>

          <!-- Have Chapter titles in part ToC-->
          <xsl:if test="self::chapter and name($toc-context) != 'part'">
            <xsl:text>Chapter </xsl:text>
          </xsl:if>

          <!-- Number + separator -->
          <xsl:if test="$label != ''">
            <xsl:copy-of select="$label"/>

            <!-- No separator dot in part ToC, just space -->
            <xsl:choose>
              <xsl:when test="self::chapter and name($toc-context) = 'part'">
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$autotoc.label.separator"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <!-- The title -->
          <!-- The large-size PDF is single-volume, while pocket is multi-volume. -->
          <xsl:apply-templates select="." mode="title.markup"/>
        </fo:basic-link>
      </fo:inline>

      <xsl:choose>
        <!-- No dots and page number for volume. -->
        <xsl:when test="self::book">
          <!-- This is essentially just dummy but needed. -->
          <fo:inline keep-together.within-line="always">
            <xsl:text> </xsl:text>
            <fo:leader leader-pattern="use-content"
              leader-pattern-width="3pt"
              leader-alignment="reference-area"
              keep-with-next.within-line="always"/>
            <xsl:text> </xsl:text>
          </fo:inline>
        </xsl:when>

        <xsl:otherwise>
          <!-- Dots and page number -->
          <fo:inline keep-together.within-line="always">
            <xsl:text> </xsl:text>
            <fo:leader leader-pattern="dots"
              leader-pattern-width="3pt"
              leader-alignment="reference-area"
              keep-with-next.within-line="always"/>
            <xsl:text> </xsl:text>
            <fo:basic-link internal-destination="{$id}">
              <fo:page-number-citation ref-id="{$id}"/>
            </fo:basic-link>
          </fo:inline>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- Only generate ToC of chapters/sections. -->
  <xsl:param name="generate.toc">
    appendix  nop
    article   toc,title
    book      toc,title
    chapter   toc
    part      toc
    preface   nop
    qandadiv  nop
    qandaset  nop
    reference toc,title
    section   nop
    set       nop
  </xsl:param>

  <!-- Only first level section titles in chapter ToC.
       Only chapter titles in part ToC.
       From autotoc.xsl. -->
  <xsl:template match="section" mode="toc">
    <xsl:param name="toc-context" select="."/>

    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="cid">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$toc-context"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="depth" select="count(ancestor::section) + 1"/>
    <xsl:variable name="reldepth"
                  select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

    <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

    <!-- Vaadin: Modify chapter ToC. -->
    <xsl:variable name="toc.section.depth.vaadin">
      <xsl:choose>
        <xsl:when test="local-name($toc-context) = 'chapter'">1</xsl:when>
        <xsl:when test="local-name($toc-context) = 'part'">0</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$toc.section.depth"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$toc.section.depth.vaadin &gt;= $depth">
      <xsl:call-template name="toc.line">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:call-template>

      <xsl:if test="$toc.section.depth > $depth 
                     and $toc.max.depth > $depth.from.context
                    and section">
        <fo:block id="toc.{$cid}.{$id}">
          <xsl:attribute name="margin-{$direction.align.start}">
            <xsl:call-template name="set.toc.indent">
              <xsl:with-param name="reldepth" select="$reldepth"/>
            </xsl:call-template>
          </xsl:attribute>
                
          <xsl:apply-templates select="section|qandaset[$qanda.in.toc != 0]" 
                               mode="toc">
            <xsl:with-param name="toc-context" select="$toc-context"/>
          </xsl:apply-templates>
        </fo:block>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Page numbering                                                       -->
  <!-- ==================================================================== -->

  <!-- From fo/pagesetup.xsl. -->
  <xsl:template name="initial.page.number">
    <xsl:param name="element" select="local-name(.)"/>
    <xsl:param name="master-reference" select="''"/>

    <!-- Start normal numbering from the first chapter of the first part of the first book. -->    
    <xsl:variable name="first.book.content"
      select="ancestor::set/book[1]/*[
              not(self::title or
              self::subtitle or
              self::titleabbrev or
              self::bookinfo or
              self::info or
              self::dedication or
              self::preface or
              self::toc or
              self::lot)][1]"/>

    <xsl:choose>
      <!-- double-sided output -->
      <xsl:when test="$double.sided != 0">
        <xsl:choose>
          <!-- Vaadin: Start ToC numbering from 'i'. -->
          <xsl:when test="$element = 'toc'">1</xsl:when>
          <xsl:when test="$element = 'preface'">auto-odd</xsl:when>
          <xsl:when test="generate-id($first.book.content) =
                          generate-id(.)">1</xsl:when>
          <xsl:otherwise>auto-odd</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- The pocket book never has single-sided output. -->
    </xsl:choose>
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
  <!-- Fonts.                                                               -->
  <!-- ==================================================================== -->

  <xsl:param name="body.font.family">
    <xsl:choose>
      <xsl:when test="$manual.fonts.custom">Helvetica</xsl:when>
      <xsl:otherwise>Times</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <!-- ==================================================================== -->
  <!-- Custom chapter title.                                                -->
  <!-- ==================================================================== -->

  <xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">  
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" 
      xsl:use-attribute-sets="chapter.titlepage.recto.style" 
      margin-left="{$title.margin.left}" 
      font-size="32.0pt" 
      font-weight="bold" 
      font-family="{$title.font.family}">
      <xsl:call-template name="vaadinchapter.title">
        <xsl:with-param name="node" select="ancestor-or-self::chapter[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- Use the same style for the appendices. -->
  <xsl:template match="title" mode="appendix.titlepage.recto.auto.mode">  
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" 
      xsl:use-attribute-sets="chapter.titlepage.recto.style" 
      margin-left="{$title.margin.left}" 
      font-size="32.0pt" 
      font-weight="bold" 
      font-family="{$title.font.family}">
      <xsl:call-template name="vaadinchapter.title">
        <xsl:with-param name="node" select="ancestor-or-self::appendix[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="vaadinchapter.title">
    <xsl:param name="node" select="."/>
    <xsl:variable name="id">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$node"/>
      </xsl:call-template>
    </xsl:variable>
    
    <fo:block id="{$id}"
      xsl:use-attribute-sets="chap.label.properties">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">
          <xsl:choose>
            <xsl:when test="$node/self::chapter">chapter</xsl:when>
            <xsl:when test="$node/self::appendix">appendix</xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$node" mode="label.markup"/>
    </fo:block>
    <fo:block xsl:use-attribute-sets="chap.title.properties">
      <xsl:apply-templates select="$node" mode="title.markup"/>
    </fo:block>
  </xsl:template>

  <!-- The formatting properties for the chapter label. -->
  <xsl:attribute-set name="chap.label.properties">
    <xsl:attribute name="font-size">36pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-before.minimum">4cm</xsl:attribute>
    <xsl:attribute name="space-before.optimum">6cm</xsl:attribute>
    <xsl:attribute name="space-before.maximum">8cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- The formatting properties for the chapter title. -->
  <xsl:attribute-set name="chap.title.properties">
    <xsl:attribute name="font-size">48pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-before.minimum">2cm</xsl:attribute>
    <xsl:attribute name="space-before.optimum">4cm</xsl:attribute>
    <xsl:attribute name="space-before.maximum">6cm</xsl:attribute>
    <xsl:attribute name="space-after.minimum">2cm</xsl:attribute>
    <xsl:attribute name="space-after.optimum">3cm</xsl:attribute>
    <xsl:attribute name="space-after.maximum">4cm</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
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

  <!-- Header cell sizes. -->
  <xsl:param name="header.column.widths">1 10 1</xsl:param>

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

  <!-- Footer cell sizes. -->
  <xsl:param name="footer.column.widths">1 10 1</xsl:param>

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

      <!-- Footer text in chapter title page. -->
      <xsl:when test="$double.sided != 0 and ($sequence = 'first') and $position='center'">
        <xsl:text>Book of Vaadin</xsl:text>
      </xsl:when>

        <!-- Section title in regular (not first or last) page footer. -->
        <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'even') and $position = 'center'">
          <fo:retrieve-marker retrieve-class-name="section.head.marker"
            retrieve-position="first-including-carryover"
            retrieve-boundary="page-sequence"/>
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

  <!-- Disable set title page -->
  <xsl:template match="set">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="content" select="book|set|setindex"/>

    <xsl:variable name="titlepage-master-reference">
      <xsl:call-template name="select.pagemaster">
        <xsl:with-param name="pageclass" select="'titlepage'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="lot-master-reference">
      <xsl:call-template name="select.pagemaster">
        <xsl:with-param name="pageclass" select="'lot'"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- ... Much unnecessary stuff (preamble, toc) removed from here ... -->

    <xsl:apply-templates select="$content"/>
  </xsl:template>

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
  <!-- Dummy custom elements not visible in PDF book                        -->
  <!-- ==================================================================== -->

  <xsl:template match="book-example">
    <!-- Do nothing -->
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Other.                                                               -->
  <!-- ==================================================================== -->

  <!-- Line spacing suitable for proofreading. -->
  <!-- xsl:param name="line-height" select="'2em'"/ -->

</xsl:stylesheet>
