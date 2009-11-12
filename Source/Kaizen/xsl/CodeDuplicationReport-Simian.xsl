<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="CodeDuplicationSummary-Simian.xsl" />

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$simian.isavailable">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
    </xsl:if>
  </xsl:template>

  <!-- Content template -->
  <xsl:template name="content">
    <xsl:apply-templates select="$duplicatedcode.list" />
  </xsl:template>

  <xsl:template match="set">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$duplicatedcode.isfailed" />
        <xsl:with-param name="iswarning" select="$duplicatedcode.iswarning" />
        <xsl:with-param name="issuccess" select="$duplicatedcode.issuccess" />
        <xsl:with-param name="title">Duplicated Lines</xsl:with-param>
        <xsl:with-param name="data" select="./@lineCount" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$duplicatedcode.content.class"/>
        </xsl:attribute>
        <table>
          <thead>
            <tr>
              <td class="label">File name</td>
              <td class="label">From line</td>
              <td class="label">Thru line</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="data strong"><xsl:value-of select="./@lineCount"/> duplicated lines in</td>
              <td></td>
              <td></td>
            </tr>
            <xsl:for-each select="./block" >
              <tr>
                <td class="section-data"><xsl:value-of select="./@sourceFile"/></td>
                <td class="section-data"><xsl:value-of select="./@startLineNumber"/></td>
                <td class="section-data"><xsl:value-of select="./@endLineNumber"/></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>
    </div>
  </xsl:template>
  
</xsl:stylesheet>