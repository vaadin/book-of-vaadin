
  <xsl:attribute-set name="book.titlepage.recto.style">
    <xsl:attribute name="color">#2f2f2f</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>  
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">.1mm</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.6"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>  
  </xsl:attribute-set> 

  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    <xsl:attribute name="background-color">#cecfff</xsl:attribute>
    <xsl:attribute name="padding">0.3em</xsl:attribute>
    <xsl:attribute name="start-indent">0pc</xsl:attribute>
    <xsl:attribute name="end-indent">0pc</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.4"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>  
  </xsl:attribute-set> 

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">.1mm</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>  
  </xsl:attribute-set> 

  <xsl:attribute-set name="formal.title.properties">

    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.0"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>

    <xsl:attribute name="space-after.minimum">0.0em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.4em</xsl:attribute>

    <!--
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    -->

  </xsl:attribute-set> 

  <xsl:attribute-set name="list.block.spacing">

    <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0em</xsl:attribute>

    <xsl:attribute name="space-after.minimum">0.0em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.7em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.7em</xsl:attribute>

    <!--
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    -->

  </xsl:attribute-set> 

  <xsl:attribute-set name="list.item.spacing">

    <xsl:attribute name="space-before.minimum">0.0em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0.3em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.3em</xsl:attribute>

    <xsl:attribute name="space-after.minimum">0em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.2em</xsl:attribute>

    <!--
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    -->

  </xsl:attribute-set> 

  <xsl:template match="processing-instruction('line-break')">
    <fo:block/>
  </xsl:template>