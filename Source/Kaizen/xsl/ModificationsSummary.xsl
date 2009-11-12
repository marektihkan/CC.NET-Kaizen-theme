<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="sourcecontrol.root" select="/cruisecontrol/modifications"/>
  <xsl:variable name="sourcecontrol.isavailable" select="count($sourcecontrol.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="modifications.root" select="$sourcecontrol.root" />
  <xsl:variable name="modifications.list" select="$modifications.root/modification" />

  <xsl:variable name="modifications.warning.boundary" select="15" />
  <xsl:variable name="modifications.error.boundary" select="35" />
  <xsl:variable name="modifications.level" select="count($modifications.list)" />

  <xsl:variable name="modifications.isfailed" select="$modifications.level &gt;= $modifications.error.boundary" />
  <xsl:variable name="modifications.iswarning" select="$modifications.level &gt;= $modifications.warning.boundary and $modifications.level &lt; $modifications.error.boundary" />
  <xsl:variable name="modifications.issuccess" select="not($modifications.isfailed) and not($modifications.iswarning)" />

  <xsl:variable name="modifications.title.name" select="'Modifications'" />
  <xsl:variable name="modifications.title.data" select="$modifications.level" />

  <!-- Design variables -->
  <xsl:variable name="modifications.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$modifications.isfailed" />
      <xsl:with-param name="iswarning" select="$modifications.iswarning" />
      <xsl:with-param name="issuccess" select="$modifications.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$sourcecontrol.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$modifications.isfailed" />
        <xsl:with-param name="iswarning" select="$modifications.iswarning" />
        <xsl:with-param name="issuccess" select="$modifications.issuccess" />
        <xsl:with-param name="title" select="$modifications.title.name" />
        <xsl:with-param name="data" select="$modifications.title.data" />
      </xsl:call-template>

      <xsl:if test="$modifications.level &gt; 0">
        <div class="section-content">
          <xsl:attribute name="class">
            <xsl:value-of select="$modifications.content.class"/>
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
        <xsl:apply-templates select="$modifications.list">
          <xsl:sort select="date" order="descending" data-type="text" />
        </xsl:apply-templates>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="modification">
    <tr>
      <td class="data">
        <span class="data-modification-type"><xsl:value-of select="@type"/></span>
      </td>
      <td class="data">
        <span class="data-modification-user"><xsl:value-of select="user"/></span>
      </td>
      <td class="data">
        <span class="data-modification-filename"><xsl:value-of select="filename"/></span>
      </td>
      <td class="data">
        <span class="data-modification-comment"><xsl:value-of select="comment"/></span>
      </td>
      <td class="data">
        <span class="data-modification-date"><xsl:value-of select="date"/></span>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>