<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="_templateSummary.xsl" />

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$_tool_.isavailable">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
    </xsl:if>
  </xsl:template>

  <!-- Content template -->
  <xsl:template name="content">
    
  </xsl:template>

</xsl:stylesheet>
