<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="simian.root" select="//simian"/>
  <xsl:variable name="simian.version" select="$simian.root/@version" />
  <xsl:variable name="simian.isavailable" select="count($simian.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="duplicatedcode.root" select="$simian.root//check" />
  <xsl:variable name="duplicatedcode.summary" select="$duplicatedcode.root/summary" />
  <xsl:variable name="duplicatedcode.list" select="$duplicatedcode.root/set" />

  <xsl:variable name="duplicatedcode.lines.total" select="$duplicatedcode.summary/@totalSignificantLineCount" />
  <xsl:variable name="duplicatedcode.lines" select="$duplicatedcode.summary/@duplicateLineCount" />
  
  <xsl:variable name="duplicatedcode.warning.boundary" select="3" />
  <xsl:variable name="duplicatedcode.error.boundary" select="7" />
  <xsl:variable name="duplicatedcode.level" select="$duplicatedcode.lines div $duplicatedcode.lines.total * 100" />

  <xsl:variable name="duplicatedcode.isfailed" select="$duplicatedcode.level &gt;= $duplicatedcode.error.boundary" />
  <xsl:variable name="duplicatedcode.iswarning" select="$duplicatedcode.level &gt;= $duplicatedcode.warning.boundary and $duplicatedcode.level &lt; $duplicatedcode.error.boundary" />
  <xsl:variable name="duplicatedcode.issuccess" select="not($duplicatedcode.isfailed) and not($duplicatedcode.iswarning)" />

  <xsl:variable name="duplicatedcode.title.name" select="'Code Duplication'" />
  <xsl:variable name="duplicatedcode.title.data" select="concat(format-number($duplicatedcode.level, '0.0'), '%')" />

  <!-- Design variables -->
  <xsl:variable name="duplicatedcode.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$duplicatedcode.isfailed" />
      <xsl:with-param name="iswarning" select="$duplicatedcode.iswarning" />
      <xsl:with-param name="issuccess" select="$duplicatedcode.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$simian.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$duplicatedcode.isfailed" />
        <xsl:with-param name="iswarning" select="$duplicatedcode.iswarning" />
        <xsl:with-param name="issuccess" select="$duplicatedcode.issuccess" />
        <xsl:with-param name="title" select="$duplicatedcode.title.name" />
        <xsl:with-param name="data" select="$duplicatedcode.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$duplicatedcode.content.class"/>
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
          <td class="label strong">Duplicated Files</td>
          <td class="data strong">
            <span clas="data-duplicatedcode-files"><xsl:value-of select="$duplicatedcode.summary/@duplicateFileCount"/></span>
          </td>
        </tr>
        <tr>
          <td class="label strong">Duplicated Lines</td>
          <td class="data strong">
            <span class="data-duplicatedcode-lines"><xsl:value-of select="$duplicatedcode.summary/@duplicateLineCount"/></span>
          </td>
        </tr>
        <tr>
          <td class="label">Duplicated Blocks</td>
          <td class="data">
            <span class="data-duplicatedcode-blocks"><xsl:value-of select="$duplicatedcode.summary/@duplicateBlockCount"/></span>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

</xsl:stylesheet>