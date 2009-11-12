<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="cruisecontrol.root" select="/cruisecontrol"/>
  <xsl:variable name="cruisecontrol.isavailable" select="true()" />

  <!-- Section variables -->
  <xsl:variable name="buildinfo.root" select="$cruisecontrol.root" />

  <xsl:variable name="buildinfo.isfailed" select="count($buildinfo.root/build/@error) &gt; 0" />
  <xsl:variable name="buildinfo.iswarning" select="count($buildinfo.root/exception) &gt; 0" />
  <xsl:variable name="buildinfo.issuccess" select="not($buildinfo.isfailed) and not($buildinfo.iswarning)" />

  <xsl:variable name="buildinfo.title.name">
    <xsl:choose>
      <xsl:when test="$buildinfo.isfailed">BUILD FAILED</xsl:when>
      <xsl:when test="$buildinfo.iswarning">BUILD EXCEPTION</xsl:when>
      <xsl:when test="$buildinfo.issuccess">BUILD SUCCEEDED</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="buildinfo.title.data" select="''" />

  <xsl:variable name="buildinfo.modification.list" select="$buildinfo.root/modifications/modification"/>

  <!-- Design variables -->
  <xsl:variable name="buildinfo.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$buildinfo.isfailed" />
      <xsl:with-param name="iswarning" select="$buildinfo.iswarning" />
      <xsl:with-param name="issuccess" select="$buildinfo.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$cruisecontrol.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$buildinfo.isfailed" />
        <xsl:with-param name="iswarning" select="$buildinfo.iswarning" />
        <xsl:with-param name="issuccess" select="$buildinfo.issuccess" />
        <xsl:with-param name="title" select="$buildinfo.title.name" />
        <xsl:with-param name="data" select="$buildinfo.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$buildinfo.content.class"/>
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
          <td class="label strong">Project</td>
          <td class="data strong">
            <span class="data-buildinfo-project-name"><xsl:value-of select="$buildinfo.root/@project"/></span>
          </td>
        </tr>
        <tr>
          <td class="label strong">Date of build</td>
          <td class="data strong">
            <span class="data-buildinfo-build-date"><xsl:value-of select="$buildinfo.root/build/@date"/></span>
          </td>
        </tr>
        <tr>
          <td class="label strong">Running time</td>
          <td class="data strong">
            <span class="data-buildinfo-build-running-time"><xsl:value-of select="$buildinfo.root/build/@buildtime"/></span>
          </td>
        </tr>
        <tr>
          <td class="label">Integration Request</td>
          <td class="data">
            <span class="data-buildinfo-build-request"><xsl:value-of select="$buildinfo.root/request" /></span>
          </td>
        </tr>
        <xsl:apply-templates select="$buildinfo.modification.list">
          <xsl:sort select="date" order="descending" data-type="text" />
        </xsl:apply-templates>
        <xsl:if test="$buildinfo.iswarning">
          <tr>
            <td class="label strong" valign="top">Error Message</td>
            <td class="data">
              <span class="data-buildinfo-error-message"><xsl:value-of select="$buildinfo.root/exception"/></span>
            </td>
          </tr>
        </xsl:if>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="/cruisecontrol/modifications/modification">
    <xsl:if test="position() = 1">
      <tr>
        <td class="label">Last changed:</td>
        <td class="data">
          <span class="data-buildinfo-modifications-date"><xsl:value-of select="date"/></span>
        </td>
      </tr>
      <tr>
        <td class="label" valign="top">Last log entry:</td>
        <td class="data">
            <span class="data-buildinfo-modifications-comment"><xsl:value-of select="comment"/></span>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>