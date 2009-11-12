<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="DesignAnalysisSummary-FxCop.xsl" />

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$fxcop.isavailable">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
    </xsl:if>
  </xsl:template>

  <!-- Content template -->
  <xsl:template name="content">
    <xsl:for-each select="$designanalysis.root/Targets//Modules/Module">

      <xsl:variable name="designanalysis.section.errors.total" select="count(.//Issue[@Level='Error'])" />
      <xsl:variable name="designanalysis.section.criticalerrors.total" select="count(.//Issue[@Level='CriticalError'])" />
      <xsl:variable name="designanalysis.section.error.level" select="$designanalysis.section.errors.total + $designanalysis.section.criticalerrors.total" />
      <xsl:variable name="designanalysis.section.warning.level" select="count(.//Issue[@Level='CriticalWarning'])" />

      <xsl:variable name="designanalysis.section.isfailed" select="$designanalysis.section.error.level &gt;= $designanalysis.error.boundary" />
      <xsl:variable name="designanalysis.section.iswarning" select="$designanalysis.section.warning.level &gt;= $designanalysis.warning.boundary" />
      <xsl:variable name="designanalysis.section.issuccess" select="not($designanalysis.section.isfailed) and not($designanalysis.section.iswarning)" />

      <xsl:variable name="designanalysis.section.title" select="@Name" />
      <xsl:variable name="designanalysis.section.title.data">
        <xsl:choose>
          <xsl:when test="$designanalysis.section.isfailed">
            <xsl:value-of select="$designanalysis.section.error.level"/>
          </xsl:when>
          <xsl:when test="$designanalysis.section.iswarning">
            <xsl:value-of select="$designanalysis.section.warning.level"/>
          </xsl:when>
          <xsl:when test="$designanalysis.section.issuccess">
            <xsl:value-of select="count(.//Issue[@Level='Warning'])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="designanalysis.section.content.class">
        <xsl:call-template name="getSectionContentClass">
          <xsl:with-param name="isfailed" select="$designanalysis.section.isfailed" />
          <xsl:with-param name="iswarning" select="$designanalysis.section.iswarning" />
          <xsl:with-param name="issuccess" select="$designanalysis.section.issuccess" />
        </xsl:call-template>
      </xsl:variable>

      <div class="section">
        <xsl:call-template name="createTitle">
          <xsl:with-param name="isfailed" select="$designanalysis.section.isfailed" />
          <xsl:with-param name="iswarning" select="$designanalysis.section.iswarning" />
          <xsl:with-param name="issuccess" select="$designanalysis.section.issuccess" />
          <xsl:with-param name="title" select="$designanalysis.section.title" />
          <xsl:with-param name="data" select="$designanalysis.section.title.data" />
        </xsl:call-template>
        <div class="section-content">
          <xsl:attribute name="class">
            <xsl:value-of select="$designanalysis.section.content.class"/>
          </xsl:attribute>

          <table>
            <xsl:apply-templates select="."/>
          </table>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="//FxCopReport//*">
    <xsl:variable name="designanalysis.section.messages.total" select="count(.//Message[@Status='Active'])"/>

    <xsl:if test="$designanalysis.section.messages.total &gt; 0">
      <xsl:apply-templates select=".//Message" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="//FxCopReport//Message">
    <xsl:variable name="designanalysis.section.rulename" select="@TypeName"/>

    <tr class="tooltip-owner">
      <td class="label strong" width="140" valign="top">
        <xsl:value-of select="./Issue/@Level" /> (<xsl:value-of select="./Issue/@Certainty" />)
      </td>
      <td class="data" valign="top">
        <span><xsl:value-of select="./Issue/text()" /></span>
        <xsl:apply-templates select="$fxcop.root/Rules/Rule[@TypeName=$designanalysis.section.rulename]" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="//FxCopReport//Rule">
    <div class="tooltip">
      <p>
        <strong>
          <xsl:value-of select="Name" /> (<xsl:value-of select="@Category" />)
        </strong>
      </p>
      <p>
        <xsl:value-of select="Description" />
      </p>
    </div>
  </xsl:template>
  
  
</xsl:stylesheet>