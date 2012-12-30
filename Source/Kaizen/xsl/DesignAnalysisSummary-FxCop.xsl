<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="fxcop.root" select="//FxCopReport"/>
  <xsl:variable name="fxcop.version" select="$fxcop.root/@Version" />
  <xsl:variable name="fxcop.isavailable" select="count($fxcop.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="designanalysis.root" select="$fxcop.root" />
  
  <xsl:variable name="designanalysis.warning.boundary" select="1" />
  <xsl:variable name="designanalysis.error.boundary" select="1" />
  
  <xsl:variable name="designanalysis.issues.total" select="count($designanalysis.root//Issue)" />
  
  <xsl:variable name="designanalysis.warning.level" select="count($designanalysis.root//Issue[@Level='CriticalWarning'])" />

  <xsl:variable name="designanalysis.errors.total" select="count($designanalysis.root//Issue[@Level='Error'])" />
  <xsl:variable name="designanalysis.criticalerrors.total" select="count($designanalysis.root//Issue[@Level='CriticalError'])" />
  <xsl:variable name="designanalysis.error.level" select="$designanalysis.errors.total + $designanalysis.criticalerrors.total" />

  <xsl:variable name="designanalysis.isfailed" select="$designanalysis.error.level &gt;= $designanalysis.error.boundary" />
  <xsl:variable name="designanalysis.iswarning" select="$designanalysis.warning.level &gt;= $designanalysis.warning.boundary" />
  <xsl:variable name="designanalysis.issuccess" select="not($designanalysis.isfailed) and not($designanalysis.iswarning)" />

  <xsl:variable name="designanalysis.title.name" select="'FxCop Report'" />
  <xsl:variable name="designanalysis.title.data">
    <xsl:choose>
      <xsl:when test="$designanalysis.isfailed">
        <xsl:value-of select="$designanalysis.error.level"/>
      </xsl:when>
      <xsl:when test="$designanalysis.iswarning">
        <xsl:value-of select="$designanalysis.warning.level"/>
      </xsl:when>
      <xsl:when test="$designanalysis.issuccess">
        <xsl:value-of select="count($designanalysis.root//Issue[@Level='Warning'])"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- Design variables -->
  <xsl:variable name="designanalysis.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$designanalysis.isfailed" />
      <xsl:with-param name="iswarning" select="$designanalysis.iswarning" />
      <xsl:with-param name="issuccess" select="$designanalysis.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$fxcop.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$designanalysis.isfailed" />
        <xsl:with-param name="iswarning" select="$designanalysis.iswarning" />
        <xsl:with-param name="issuccess" select="$designanalysis.issuccess" />
        <xsl:with-param name="title" select="$designanalysis.title.name" />
        <xsl:with-param name="data" select="$designanalysis.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$designanalysis.content.class"/>
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
          <td>Module</td>
          <td>Warnings</td>
          <td>Critical Warnings</td>
          <td>Errors</td>
          <td>Critical Errors</td>
          <td>Total</td>
        </tr>
      </thead>
      <tbody>
        <xsl:call-template name="ModulesSummary" />
      </tbody>
      <tfoot>
        <tr>
          <td class="label strong">Total</td>
          <td class="data strong"><xsl:value-of select="count($designanalysis.root//Issue[@Level='Warning'])" /></td>
          <td class="data strong"><xsl:value-of select="count($designanalysis.root//Issue[@Level='CriticalWarning'])" /></td>
          <td class="data strong"><xsl:value-of select="count($designanalysis.root//Issue[@Level='Error'])" /></td>
          <td class="data strong"><xsl:value-of select="count($designanalysis.root//Issue[@Level='CriticalError'])" /></td>
          <td class="data strong">
            <xsl:choose>
              <xsl:when test="$designanalysis.issues.total &gt; 0">
                <span class="failed-text"><xsl:value-of select="$designanalysis.issues.total" /></span>
              </xsl:when>
              <xsl:otherwise>
                <span class="success-text"><xsl:value-of select="$designanalysis.issues.total" /></span>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </tfoot>
    </table>
  </xsl:template>

  <xsl:template match="Targets">
    <xsl:apply-templates select="Target" />
  </xsl:template>

  <xsl:template match="Target">
    <xsl:apply-templates select="Modules" />
  </xsl:template>

  <xsl:template name="ModulesSummary">
    <xsl:call-template name="ModuleSummary">
      <xsl:with-param name="modules" select="$designanalysis.root/Targets/Target/Modules"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ModuleSummary">
    <xsl:param name="modules"/>

    <xsl:for-each select="$modules/Module">
      <xsl:variable name="All" select="count(.//Issue)" />
      <xsl:variable name="CriticalErrors" select="count(.//Issue[@Level='CriticalError'])" />
      <xsl:variable name="Errors" select="count(.//Issue[@Level='Error'])" />
      <xsl:variable name="CriticalWarnings" select="count(.//Issue[@Level='CriticalWarning'])" />
      <xsl:variable name="Warnings" select="count(.//Issue[@Level='Warning'])" />

      <tr>
        <td class="label"><xsl:value-of select="@Name" /></td>
        <td class="data"><xsl:value-of select="$Warnings" /></td>
        <td class="data"><xsl:value-of select="$CriticalWarnings" /></td>
        <td class="data"><xsl:value-of select="$Errors" /></td>
        <td class="data"><xsl:value-of select="$CriticalErrors" /></td>
        <td class="data strong">
          <xsl:if test="$All &gt; 0">
            <span class="failed-text">
              <xsl:value-of select="$All" />
            </span>
          </xsl:if>
          <xsl:if test="$All &lt;= 0">
            <span class="success-text">
              <xsl:value-of select="$All" />
            </span>
          </xsl:if>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>