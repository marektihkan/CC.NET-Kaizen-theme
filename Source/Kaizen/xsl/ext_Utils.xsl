<?xml version="1.0" encoding="UTF-8"?>
<!--
Template version 1.0
by sinnerinc

History:
# 2012-02-14: 
	Initial version
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" />

  <!-- after: http://stackoverflow.com/questions/14527/xslt-reverse-find-in-a-string -->
  <xsl:template name="getFilenameFromPath">
		<xsl:param name="path"/>
		  <xsl:choose>
			<xsl:when test="contains($path, '\')">
			<xsl:call-template name="getFilenameFromPath">
			  <xsl:with-param name="path" select="substring-after($path, '\')" />
			</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="$path"/>
			</xsl:otherwise>
		  </xsl:choose>
</xsl:template>


<xsl:template name="forLoop">
	<xsl:param name="i" />
	<xsl:param name="count" />	
	<xsl:param name="printValue" />		
	<xsl:if test="$i &lt;= $count">
		<xsl:copy-of select="$printValue"/>		
	</xsl:if> 
	<!--begin_: RepeatTheLoopUntilFinished-->
	<xsl:if test="$i &lt;= $count">
		<xsl:call-template name="forLoop">
			<xsl:with-param name="i">
				<xsl:value-of select="$i + 1"/>
			</xsl:with-param>
			<xsl:with-param name="count">
				<xsl:value-of select="$count"/>
			</xsl:with-param>
			<xsl:with-param name="printValue" select="$printValue" />
		</xsl:call-template>
	</xsl:if> 
</xsl:template>

</xsl:stylesheet>