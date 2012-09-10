<?xml version="1.0"?>
<!--
Template version 1.0
by sinnerinc

History:
# 2012-02-14: 
	Initial version
-->

<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html"/>

   <xsl:template match="/">    
	<h1 class="title">
		<span class="title">Console output</span>
	</h1>
	
	<div class="section-content">
		
			<!--<xsl:apply-templates select="//message"/>-->
			
			
			<xsl:for-each select="//*">
					<!--<xsl:value-of select="text()"/>-->
					<xsl:choose>
						<xsl:when test="name() = 'warning' ">
							<pre class="log-warning"><xsl:value-of select="text()"/></pre>
						</xsl:when>
						<xsl:when test="name() = 'message' ">
							<pre class="log-message"><xsl:value-of select="text()"/></pre>
						</xsl:when>
						<xsl:when test="name() ='error' ">
							<pre class="log-error"><xsl:value-of select="text()"/></pre>
						</xsl:when>
						<xsl:when test="name() = 'target' ">
							<pre class="log-target">Target: <xsl:value-of select="./@name"/> (took: <xsl:value-of select="./@elapsedTime"/>)</pre>
						</xsl:when>
						<xsl:when test="name() = 'project' ">							
							<xsl:variable name="parentNodeName" select="name(current()/parent::node())" />
							<xsl:if test="$parentNodeName = 'msbuild' or $parentNodeName = 'target' ">
								<pre class="log-project">Building project: <xsl:value-of select="./@file"/> (took: <xsl:value-of select="./@elapsedTime"/>)</pre>
							</xsl:if>
						</xsl:when>
						
						<xsl:otherwise>
						</xsl:otherwise>
						</xsl:choose>					
			</xsl:for-each>
		
	</div>
   </xsl:template>

   <xsl:template match="//message">
		
		<pre class="log"><xsl:value-of select="text()"/></pre>
   </xsl:template>

</xsl:stylesheet>