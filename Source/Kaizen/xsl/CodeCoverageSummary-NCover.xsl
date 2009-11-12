<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="ncover.root" select="//coverage"/>
  <xsl:variable name="ncover.isavailable" select="count($ncover.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="codecoverage.root" select="$ncover.root" />

  <xsl:variable name="codecoverage.covered.lines" select="count($codecoverage.root/module/method/seqpnt[@visitcount > 0])" />
  <xsl:variable name="codecoverage.uncovered.lines" select="count($codecoverage.root/module/method/seqpnt[@visitcount = 0])" />

  <xsl:variable name="codecoverage.warning.boundary" select="80" />
  <xsl:variable name="codecoverage.error.boundary" select="70" />
  <xsl:variable name="codecoverage.level" select="round($codecoverage.covered.lines div ($codecoverage.uncovered.lines + $codecoverage.covered.lines) * 100)" />

  <xsl:variable name="codecoverage.isfailed" select="$codecoverage.level &lt; $codecoverage.error.boundary" />
  <xsl:variable name="codecoverage.iswarning" select="$codecoverage.level &lt; $codecoverage.warning.boundary and $codecoverage.level &gt;= $codecoverage.error.boundary" />
  <xsl:variable name="codecoverage.issuccess" select="not($codecoverage.isfailed) and not($codecoverage.iswarning)" />

  <xsl:variable name="codecoverage.title.name" select="'Code Coverage'" />
  <xsl:variable name="codecoverage.title.data" select="concat($codecoverage.level, '%')" />

  <!-- Design variables -->
  <xsl:variable name="codecoverage.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$codecoverage.isfailed" />
      <xsl:with-param name="iswarning" select="$codecoverage.iswarning" />
      <xsl:with-param name="issuccess" select="$codecoverage.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$ncover.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$codecoverage.isfailed" />
        <xsl:with-param name="iswarning" select="$codecoverage.iswarning" />
        <xsl:with-param name="issuccess" select="$codecoverage.issuccess" />
        <xsl:with-param name="title" select="$codecoverage.title.name" />
        <xsl:with-param name="data" select="$codecoverage.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$codecoverage.content.class"/>
        </xsl:attribute>
        <xsl:call-template name="sectionContent" />
      </div>
    </div>
  </xsl:template>

  <!-- Templates -->
  <xsl:template name="sectionContent">
    <table>
      <tbody>
        <tr>
          <th class="label strong">
            <span>Covered lines</span>
          </th>
          <td class="data">
            <span><xsl:value-of select="$codecoverage.covered.lines"/></span>
          </td>
        </tr>
        <tr>
          <th class="label strong">
            <span>Uncovered lines</span>
          </th>
          <td class="data">
            <span><xsl:value-of select="$codecoverage.uncovered.lines"/></span>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

</xsl:stylesheet>