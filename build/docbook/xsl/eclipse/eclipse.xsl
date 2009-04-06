<?xml version="1.0"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ng="http://docbook.org/docbook-ng"
        xmlns:db="http://docbook.org/ns/docbook"
        xmlns:exsl="http://exslt.org/common"
        exclude-result-prefixes="db ng exsl"
		version="1.0">
  
  <xsl:import href="../html/chunk.xsl"/>

  <xsl:output method="html"
              encoding="ISO-8859-1"
              indent="no"/>

<!-- ********************************************************************
     $Id: eclipse.xsl 6118 2006-07-28 21:20:20Z kosek $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- This template is copied from chunk-code.xsl, just adding the generation of
     the Eclipse help file metadata.
     This was broken in the DocBook release, as it was not copied properly
     from the original template as it should have been. -->
<xsl:template match="/">
  <xsl:choose>
    <!-- include extra test for Xalan quirk -->
      <xsl:when test="(function-available('exsl:node-set') or
                      contains(system-property('xsl:vendor'),
                      'Apache Software Foundation'))
                      and (*/self::ng:* or */self::db:*)">
        <!-- Hack! If someone hands us a DocBook V5.x or DocBook NG document,
             toss the namespace and continue. Someday we'll reverse this logic
             and add the namespace to documents that don't have one.
             But not before the whole stylesheet has been converted to use
             namespaces. i.e., don't hold your breath -->
        <xsl:message>Stripping namespace from DocBook 5 document.</xsl:message>
        <xsl:variable name="nons">
          <xsl:apply-templates mode="stripNS"/>
        </xsl:variable>
        <xsl:message>Processing stripped document.</xsl:message>
        <xsl:apply-templates select="exsl:node-set($nons)"/>
      </xsl:when>
      <!-- Can't process unless namespace removed -->
      <xsl:when test="*/self::ng:* or */self::db:*">
        <xsl:message terminate="yes">
          <xsl:text>Unable to strip the namespace from DB5 document,</xsl:text>
          <xsl:text> cannot proceed.</xsl:text>
        </xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$rootid != ''">
            <xsl:choose>
              <xsl:when test="count(key('id',$rootid)) = 0">
                <xsl:message terminate="yes">
                  <xsl:text>ID '</xsl:text>
                  <xsl:value-of select="$rootid"/>
                  <xsl:text>' not found in document.</xsl:text>
                </xsl:message>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$collect.xref.targets = 'yes' or
                              $collect.xref.targets = 'only'">
                  <xsl:apply-templates select="key('id', $rootid)"
                    mode="collect.targets"/>
                </xsl:if>
                <xsl:if test="$collect.xref.targets != 'only'">
                  <xsl:apply-templates select="key('id',$rootid)"
                    mode="process.root"/>
                  <xsl:if test="$tex.math.in.alt != ''">
                    <xsl:apply-templates select="key('id',$rootid)"
                      mode="collect.tex.math"/>
                  </xsl:if>
                  <xsl:if test="$generate.manifest != 0">
                    <xsl:call-template name="generate.manifest">
                      <xsl:with-param name="node" select="key('id',$rootid)"/>
                    </xsl:call-template>
                  </xsl:if>
                  
                  <!-- Generate Eclipse metadata: -->
                  <xsl:call-template name="etoc"/>
                  <xsl:call-template name="plugin.xml"/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$collect.xref.targets = 'yes' or
                          $collect.xref.targets = 'only'">
              <xsl:apply-templates select="/" mode="collect.targets"/>
            </xsl:if>
            <xsl:if test="$collect.xref.targets != 'only'">
              <xsl:apply-templates select="/" mode="process.root"/>
              <xsl:if test="$tex.math.in.alt != ''">
                <xsl:apply-templates select="/" mode="collect.tex.math"/>
              </xsl:if>
              <xsl:if test="$generate.manifest != 0">
                <xsl:call-template name="generate.manifest">
                  <xsl:with-param name="node" select="/"/>
                </xsl:call-template>
              </xsl:if>
              
              <!-- Generate Eclipse metadata: -->
              <xsl:call-template name="etoc"/>
              <xsl:call-template name="plugin.xml"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<xsl:template name="etoc">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:if test="$manifest.in.base.dir != 0">
        <xsl:value-of select="$base.dir"/>
      </xsl:if>
      <xsl:value-of select="'toc.xml'"/>
    </xsl:with-param>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="encoding" select="'UTF-8'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="content">
      <xsl:choose>

        <xsl:when test="$rootid != ''">
          <xsl:variable name="title">
            <xsl:if test="$eclipse.autolabel=1">
              <xsl:variable name="label.markup">
                <xsl:apply-templates select="key('id',$rootid)" mode="label.markup"/>
              </xsl:variable>
              <xsl:if test="normalize-space($label.markup)">
                <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
              </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="key('id',$rootid)" mode="title.markup"/>
          </xsl:variable>
          <xsl:variable name="href">
            <xsl:call-template name="href.target.with.base.dir">
              <xsl:with-param name="object" select="key('id',$rootid)"/>
            </xsl:call-template>
          </xsl:variable>
          
          <!-- Don't use $title for the label, but the plugin name. -->
          <toc label="{$eclipse.plugin.name}" topic="{$href}">
            <xsl:apply-templates select="key('id',$rootid)/*" mode="etoc"/>
          </toc>
        </xsl:when>

        <xsl:otherwise>
          <xsl:variable name="title">
            <xsl:if test="$eclipse.autolabel=1">
              <xsl:variable name="label.markup">
                <xsl:apply-templates select="/*" mode="label.markup"/>
              </xsl:variable>
              <xsl:if test="normalize-space($label.markup)">
                <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
              </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="/*" mode="title.markup"/>
          </xsl:variable>
          <xsl:variable name="href">
            <xsl:call-template name="href.target.with.base.dir">
              <xsl:with-param name="object" select="/"/>
            </xsl:call-template>
          </xsl:variable>
          
          <!-- Don't use $title for the label, but the plugin name. -->
          <toc label="{$eclipse.plugin.name}" topic="{$href}">
            <xsl:apply-templates select="/*/*" mode="etoc"/>
          </toc>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="book|part|reference|preface|chapter|bibliography|appendix|article|glossary|section|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index" mode="etoc">
  <xsl:variable name="title">
    <xsl:if test="$eclipse.autolabel=1">
      <xsl:variable name="label.markup">
        <xsl:apply-templates select="." mode="label.markup"/>
      </xsl:variable>
      <xsl:if test="normalize-space($label.markup)">
        <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <xsl:variable name="href">
    <xsl:call-template name="href.target.with.base.dir">
      <xsl:with-param name="context" select="/"/>        <!-- Generate links relative to the location of root file/toc.xml file -->
    </xsl:call-template>
  </xsl:variable>

  <topic href="{$href}" label="{$title}">
    <xsl:apply-templates select="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index" mode="etoc"/>
  </topic>
</xsl:template>

<xsl:template match="text()" mode="etoc"/>

<xsl:template name="plugin.xml">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:if test="$manifest.in.base.dir != 0">
        <xsl:value-of select="$base.dir"/>
      </xsl:if>
      <xsl:value-of select="'plugin.xml'"/>
    </xsl:with-param>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="encoding" select="'UTF-8'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="content">
      <plugin name="{$eclipse.plugin.name}"
        id="{$eclipse.plugin.id}"
        version="{$eclipse.plugin.version}"
        provider-name="{$eclipse.plugin.provider}">

        <extension point="org.eclipse.help.toc">
          <toc file="toc.xml" primary="true"/>
        </extension>
          
      </plugin>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>
