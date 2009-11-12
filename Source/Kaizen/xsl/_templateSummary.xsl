<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="_tool_.root" select="_value_"/>
  <xsl:variable name="_tool_.version" select="_value_" />
  <xsl:variable name="_tool_.isavailable" select="_value_" />
  
  <!-- Section variables -->
  <xsl:variable name="_contentname_.root" select="_value_" />
  
  <xsl:variable name="_contentname_.warning.boundary" select="_value_" />
  <xsl:variable name="_contentname_.error.boundary" select="_value_" />
  <xsl:variable name="_contentname_.level" select="_value_" />
  
  <xsl:variable name="_contentname_.isfailed" select="$_contentname_.level &gt;= $_contentname_.error.boundary" />
  <xsl:variable name="_contentname_.iswarning" select="$_contentname_.level &gt;= $_contentname_.warning.boundary and $_contentname_.level &lt; $_contentname_.error.boundary" />
  <xsl:variable name="_contentname_.issuccess" select="not($_contentname_.isfailed) and not($_contentname_.iswarning)" />

  <xsl:variable name="_contentname_.title.name" select="_value_" />
  <xsl:variable name="_contentname_.title.data" select="_value_" />
  
  <!-- Design variables -->
  <xsl:variable name="_contentname_.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$_contentname_.isfailed" />
      <xsl:with-param name="iswarning" select="$_contentname_.iswarning" />
      <xsl:with-param name="issuccess" select="$_contentname_.issuccess" />
    </xsl:call-template>
  </xsl:variable>
  
  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$_tool_.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$_contentname_.isfailed" />
        <xsl:with-param name="iswarning" select="$_contentname_.iswarning" />
        <xsl:with-param name="issuccess" select="$_contentname_.issuccess" />
        <xsl:with-param name="title" select="$_contentname_.title.name" />
        <xsl:with-param name="data" select="$_contentname_.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$_contentname_.content.class"/>
        </xsl:attribute>
        <xsl:call-template name="sectionContent" />
      </div>
    </div>
  </xsl:template>
  
  <!-- Templates -->
  <xsl:template name="sectionContent">
    
  </xsl:template>
  
</xsl:stylesheet>