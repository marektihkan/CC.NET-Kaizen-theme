<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="CodeCoverageSummary-NCoverExplorer.xsl" />

  <xsl:variable name="codecoverage.report.types.moduleclass" select="'Module Class Summary'" />
  <xsl:variable name="codecoverage.report.types.moduleclassfunction" select="'Module Class Function Summary'" />
  <xsl:variable name="codecoverage.report.types.modulenamespace" select="'Module Namespace Summary'" />
  <xsl:variable name="codecoverage.report.types.namespace" select="'Namespace Summary'" />

  <xsl:variable name="codecoverage.report.type" select="$codecoverage.root/@reportTitle" />

  <xsl:variable name="codecoverage.section.headings.coverage">
    <xsl:choose>
      <xsl:when test="$codecoverage.report.type = $codecoverage.report.types.moduleclassfunction">Function Coverage</xsl:when>
      <xsl:otherwise>Coverage</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="codecoverage.section.headings.unvisited">
    <xsl:choose>
      <xsl:when test="$codecoverage.report.type = $codecoverage.report.types.moduleclassfunction">Unvisited Functions</xsl:when>
      <xsl:otherwise>Unvisited Sequences</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="codecoverage.section.threshold">
    <xsl:choose>
      <xsl:when test="$codecoverage.report.type = $codecoverage.report.types.moduleclassfunction">
        <xsl:value-of select="$codecoverage.root/project/@acceptableFunction" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$codecoverage.warning.boundary" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="codecoverage.section.warning.boundary" select="$codecoverage.section.threshold" />
  <xsl:variable name="codecoverage.section.error.boundary" select="$codecoverage.section.warning.boundary - 0.25 * $codecoverage.section.warning.boundary" />
  
  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$ncoverexplorer.isavailable">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
    </xsl:if>
  </xsl:template>

  <!-- Content template -->
  <xsl:template name="content">
    <xsl:if test="$codecoverage.report.type = $codecoverage.report.types.moduleclass or $codecoverage.report.type = $codecoverage.report.types.moduleclassfunction">
      <xsl:call-template name="classModuleReport" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="classModuleReport">
    <xsl:for-each select="$codecoverage.root/modules/module">
      <xsl:variable name="codecoverage.section.visited.percent" select="./@coverage" />
      <xsl:variable name="codecoverage.section.unvisited.percent" select="100 - $codecoverage.section.visited.percent" />
      <xsl:variable name="codecoverage.section.level" select="$codecoverage.section.visited.percent" />

      <xsl:variable name="codecoverage.section.title.name" select="./@name" />
      <xsl:variable name="codecoverage.section.title.data" select="concat(format-number($codecoverage.section.level, '0.0'), '%')" />

      <xsl:variable name="codecoverage.section.isfailed" select="$codecoverage.section.level &lt; $codecoverage.section.error.boundary" />
      <xsl:variable name="codecoverage.section.iswarning" select="$codecoverage.section.level &lt; $codecoverage.section.warning.boundary and $codecoverage.section.level &gt;= $codecoverage.section.error.boundary" />
      <xsl:variable name="codecoverage.section.issuccess" select="not($codecoverage.section.isfailed) and not($codecoverage.section.iswarning)" />

      <xsl:variable name="codecoverage.section.content.class">
        <xsl:call-template name="getSectionContentClass">
          <xsl:with-param name="isfailed" select="$codecoverage.section.isfailed" />
          <xsl:with-param name="iswarning" select="$codecoverage.section.iswarning" />
          <xsl:with-param name="issuccess" select="$codecoverage.section.issuccess" />
        </xsl:call-template>
      </xsl:variable>

      <div class="section">
        <xsl:call-template name="createTitle">
          <xsl:with-param name="isfailed" select="$codecoverage.section.isfailed" />
          <xsl:with-param name="iswarning" select="$codecoverage.section.iswarning" />
          <xsl:with-param name="issuccess" select="$codecoverage.section.issuccess" />
          <xsl:with-param name="title" select="$codecoverage.section.title.name" />
          <xsl:with-param name="data" select="$codecoverage.section.title.data" />
        </xsl:call-template>
        <div class="section-content">
          <xsl:attribute name="class">
            <xsl:value-of select="$codecoverage.section.content.class"/>
          </xsl:attribute>

          <table>
            <thead>
              <tr>
                <th class="label">Namespace / Class</th>
                <th class="label right">
                  <xsl:value-of select="$codecoverage.section.headings.unvisited" />
                </th>
                <th colspan="2" class="label left">
                  <xsl:value-of select="$codecoverage.section.headings.coverage" />
                </th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="./namespace">
                <xsl:call-template name="buildTableRow">
                  <xsl:with-param name="name" select="./@name" />
                  <xsl:with-param name="unvisited" select="./@unvisitedPoints" />
                  <xsl:with-param name="visited" select="./@coverage" />
                  <xsl:with-param name="name.class">data strong</xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="./class">
                  <xsl:call-template name="buildTableRow">
                    <xsl:with-param name="name" select="./@name" />
                    <xsl:with-param name="unvisited" select="./@unvisitedPoints" />
                    <xsl:with-param name="visited" select="./@coverage" />
                    <xsl:with-param name="name.class">data</xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="buildTableRow">
    <xsl:param name="name" />
    <xsl:param name="unvisited" />
    <xsl:param name="visited" />
    <xsl:param name="name.class"></xsl:param>
    
    <tr>
      <td>
        <xsl:attribute name="class">
          <xsl:value-of select="$name.class"/>
        </xsl:attribute>
        <xsl:value-of select="$name" />
      </td>
      <td class="data right">
        <xsl:value-of select="$unvisited" />
      </td>
      <td class="data right">
        <xsl:value-of select="concat(format-number($visited,'#0.0'), ' %')" />
      </td>
      <td>
        <xsl:call-template name="drawBar">
          <xsl:with-param name="percent" select="$visited" />
          <xsl:with-param name="threshold" select="$codecoverage.section.threshold" />
          <xsl:with-param name="scale">2</xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>