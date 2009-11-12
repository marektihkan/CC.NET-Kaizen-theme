<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="nant.root" select="//buildresults"/>
  <xsl:variable name="nant.isavailable" select="count($nant.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="warnings.list" select="$nant.root//message[(contains(text(), 'warning')) or @level='Warning']" />

  <xsl:variable name="warnings.warning.boundary" select="1" />
  <xsl:variable name="warnings.error.boundary" select="20" />
  <xsl:variable name="warnings.level" select="count($warnings.list)" />

  <xsl:variable name="warnings.isfailed" select="$warnings.level &gt;= $warnings.error.boundary" />
  <xsl:variable name="warnings.iswarning" select="$warnings.level &gt;= $warnings.warning.boundary and $warnings.level &lt; $warnings.error.boundary" />
  <xsl:variable name="warnings.issuccess" select="not($warnings.isfailed) and not($warnings.iswarning)" />

  <xsl:variable name="warnings.title.name" select="'Warnings'" />
  <xsl:variable name="warnings.title.data" select="$warnings.level" />

  <!-- Design variables -->
  <xsl:variable name="warnings.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$warnings.isfailed" />
      <xsl:with-param name="iswarning" select="$warnings.iswarning" />
      <xsl:with-param name="issuccess" select="$warnings.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$nant.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$warnings.isfailed" />
        <xsl:with-param name="iswarning" select="$warnings.iswarning" />
        <xsl:with-param name="issuccess" select="$warnings.issuccess" />
        <xsl:with-param name="title" select="$warnings.title.name" />
        <xsl:with-param name="data" select="$warnings.title.data" />
      </xsl:call-template>

      <xsl:if test="$warnings.level &gt; 0">
        <div class="section-content">
          <xsl:attribute name="class">
            <xsl:value-of select="$warnings.content.class"/>
          </xsl:attribute>
          <xsl:call-template name="sectionContent" />
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- Templates -->
  <xsl:template name="sectionContent">
    <table>
      <tbody>
        <xsl:apply-templates select="$warnings.list"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="message">
    <tr>
      <td class="data">
        <span class="data-warning-message"><xsl:value-of select="text()"/></span>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>