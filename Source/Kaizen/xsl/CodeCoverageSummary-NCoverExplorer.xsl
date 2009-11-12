<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="ncoverexplorer.root" select="//coverageReport"/>
  <xsl:variable name="ncoverexplorer.isavailable" select="count($ncoverexplorer.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="codecoverage.root" select="$ncoverexplorer.root" />

  <xsl:variable name="codecoverage.visited.percent" select="$codecoverage.root/project/@functionCoverage" />
  <xsl:variable name="codecoverage.unvisited.percent" select="100 - $codecoverage.visited.percent" />
  <xsl:variable name="codecoverage.threshold" select="$codecoverage.root/project/@acceptable" />

  <xsl:variable name="codecoverage.warning.boundary" select="$codecoverage.threshold" />
  <xsl:variable name="codecoverage.error.boundary" select="$codecoverage.threshold - 0.25 * $codecoverage.threshold" />
  <xsl:variable name="codecoverage.level" select="$codecoverage.visited.percent" />

  <xsl:variable name="codecoverage.isfailed" select="$codecoverage.level &lt; $codecoverage.error.boundary" />
  <xsl:variable name="codecoverage.iswarning" select="$codecoverage.level &lt; $codecoverage.warning.boundary and $codecoverage.level &gt;= $codecoverage.error.boundary" />
  <xsl:variable name="codecoverage.issuccess" select="not($codecoverage.isfailed) and not($codecoverage.iswarning)" />

  <xsl:variable name="codecoverage.title.name" select="'Code Coverage'" />
  <xsl:variable name="codecoverage.title.data" select="concat(format-number($codecoverage.level, '0.0'), '%')" />

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
    <xsl:if test="$ncoverexplorer.isavailable">
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
      <thead>
        <tr>
          <th class="label">Module</th>
          <th class="label">Coverage %</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$codecoverage.root/modules/module">
          <xsl:call-template name="ModuleSummary" />
        </xsl:for-each>
      </tbody>
      <tfoot>
        <tr>
          <td class="label strong">Total</td>
          <td class="data strong">
            <xsl:value-of select="concat(format-number($codecoverage.level, '0.0'), '%')"/>
          </td>
          <td>
            <xsl:call-template name="drawBar">
              <xsl:with-param name="percent" select="$codecoverage.level" />
              <xsl:with-param name="threshold" select="$codecoverage.threshold" />
              <xsl:with-param name="scale">2</xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </tfoot>
    </table>

    <table>
      <tr>
        <td class="label strong">
          <span>Acceptance</span>
        </td>
        <td class="data strong">
          <span><xsl:value-of select="$codecoverage.threshold"/> %</span>
        </td>
      </tr>
      <tr>
        <td class="label strong">
          <span>Unvisited Sequence Points</span>
        </td>
        <td class="data strong">
          <span><xsl:value-of select="$codecoverage.root/project/@unvisitedPoints"/></span>
        </td>
      </tr>
      <tr>
        <td class="label strong">
          <span>Total Sequence Points</span>
        </td>
        <td class="data strong">
          <span><xsl:value-of select="$codecoverage.root/project/@sequencePoints"/></span>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="ModuleSummary">
    <xsl:variable name="codecoverage.module.visited.percent" select="./@coverage" />
    <xsl:variable name="codecoverage.module.unvisited.percent" select="100 - $codecoverage.module.visited.percent" />
    <xsl:variable name="codecoverage.module.level" select="$codecoverage.module.visited.percent" />

    <xsl:variable name="codecoverage.module.isfailed" select="$codecoverage.module.level &lt; $codecoverage.error.boundary" />
    <xsl:variable name="codecoverage.module.iswarning" select="$codecoverage.module.level &lt; $codecoverage.warning.boundary and $codecoverage.module.level &gt;= $codecoverage.error.boundary" />
    <xsl:variable name="codecoverage.module.issuccess" select="not($codecoverage.module.isfailed) and not($codecoverage.module.iswarning)" />

    <tr>
      <td class="data strong">
        <span><xsl:value-of select="@name"/></span>
      </td>
      <td class="data">
        <span><xsl:value-of select="format-number($codecoverage.module.level, '0.0')"/>%</span>
      </td>
      <td>
        <xsl:call-template name="drawBar">
          <xsl:with-param name="percent" select="$codecoverage.module.level" />
          <xsl:with-param name="threshold" select="$codecoverage.threshold" />
          <xsl:with-param name="scale">2</xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>