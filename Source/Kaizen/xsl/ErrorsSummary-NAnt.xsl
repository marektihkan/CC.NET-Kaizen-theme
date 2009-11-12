<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="nant.root" select="//buildresults"/>
  <xsl:variable name="nant.isavailable" select="count($nant.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="errors.list" select="$nant.root//message[(contains(text(), 'error')) or @level='Error']" />
  
  <xsl:variable name="errors.error.boundary" select="1" />
  <xsl:variable name="errors.level" select="count($errors.list)" />

  <xsl:variable name="errors.isfailed" select="$errors.level &gt;= $errors.error.boundary" />
  <xsl:variable name="errors.iswarning" select="false()" />
  <xsl:variable name="errors.issuccess" select="not($errors.isfailed) and not($errors.iswarning)" />

  <xsl:variable name="errors.title.name" select="'Errors'" />
  <xsl:variable name="errors.title.data" select="$errors.level" />

  <!-- Design variables -->
  <xsl:variable name="errors.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$errors.isfailed" />
      <xsl:with-param name="iswarning" select="$errors.iswarning" />
      <xsl:with-param name="issuccess" select="$errors.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$nant.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$errors.isfailed" />
        <xsl:with-param name="iswarning" select="$errors.iswarning" />
        <xsl:with-param name="issuccess" select="$errors.issuccess" />
        <xsl:with-param name="title" select="$errors.title.name" />
        <xsl:with-param name="data" select="$errors.title.data" />
      </xsl:call-template>

      <xsl:if test="$errors.level &gt; 0">
        <div class="section-content">
          <xsl:attribute name="class">
            <xsl:value-of select="$errors.content.class"/>
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
        <xsl:apply-templates select="$errors.list"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="message">
    <tr>
      <td class="data">
        <span class="data-error-message"><xsl:value-of select="text()"/></span>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>