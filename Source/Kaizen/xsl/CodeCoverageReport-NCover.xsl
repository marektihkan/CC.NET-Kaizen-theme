<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="CodeCoverageSummary-NCover.xsl" />

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$ncover.isavailable">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
    </xsl:if>
  </xsl:template>

  <!-- Content template -->
  <xsl:template name="content">
    <xsl:apply-templates select="$codecoverage.root" />
  </xsl:template>

  <xsl:template match="coverage[count(module) != 0]">
    <xsl:variable name="codecoverage.section.title.name" select="'Untested Code'" />
    <xsl:variable name="codecoverage.section.title.data" select="''" />
    
    <xsl:variable name="codecoverage.section.content.class">
      <xsl:call-template name="getSectionContentClass">
        <xsl:with-param name="isfailed" select="$codecoverage.isfailed" />
        <xsl:with-param name="iswarning" select="$codecoverage.iswarning" />
        <xsl:with-param name="issuccess" select="$codecoverage.issuccess" />
      </xsl:call-template>
    </xsl:variable>

    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$codecoverage.isfailed" />
        <xsl:with-param name="iswarning" select="$codecoverage.iswarning" />
        <xsl:with-param name="issuccess" select="$codecoverage.issuccess" />
        <xsl:with-param name="title" select="$codecoverage.section.title.name" />
        <xsl:with-param name="data" select="$codecoverage.section.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$codecoverage.section.content.class"/>
        </xsl:attribute>

        <table>
          <tbody>
            <xsl:apply-templates select="module/method[./seqpnt[@visitcount = 0]]"/>
          </tbody>
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="method">
    <tr>
      <td class="label strong">
        <span><xsl:value-of select="@class"/>.<xsl:value-of select="@name"/></span>
      </td>
    </tr>
    <tr>
      <td class="data">
        <xsl:apply-templates select="seqpnt[@visitcount = 0]"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="seqpnt">
    <xsl:if test="@line != 16707566">
      <p>
        <span>Line: <xsl:value-of select="@line"/></span>
      </p>
      <p>
        <span><xsl:value-of select="@document"/></span>
      </p>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>