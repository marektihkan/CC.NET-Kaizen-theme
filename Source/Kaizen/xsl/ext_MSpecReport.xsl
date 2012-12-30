<?xml version="1.0"?>
<!--
Template version 1.0
by sinnerinc

History:
# 2012-02-14: 
	Initial version
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>
	<xsl:include href="ext_MSpecSummary.xsl" />


	<!-- Main template -->
	<xsl:template match="/">
		<xsl:call-template name="summary" >
			<xsl:with-param name="is.full.log" select="1" />
		</xsl:call-template>
		<xsl:call-template name="content" />
	</xsl:template>	
	
	<!-- Content template -->
	<xsl:template name="content">		
		<xsl:apply-templates select="//MSpec//assembly" />
	</xsl:template>
	
<xsl:template match="//MSpec//assembly">
	<xsl:variable name="FailuresCount" select="count(.//specification[@status = 'failed'])" />
	<xsl:variable name="NotImplementedCount" select="count(.//specification[@status = 'not-implemented'])" />	
	
	<xsl:variable name="context.current.iserror" select="$FailuresCount &gt; 0" />
	<xsl:variable name="context.current.iswarning" select="$NotImplementedCount &gt; 0" />

	<a name="{generate-id()}" />
	<div class="section">		
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$context.current.iserror" />
        <xsl:with-param name="iswarning" select="$context.current.iswarning" />
        <xsl:with-param name="issuccess" select="not($context.current.iswarning) and not($context.current.iserror)" />
        <xsl:with-param name="title">
			<xsl:value-of select="./@name"/>
		</xsl:with-param>
        <xsl:with-param name="data">
			<!-- display number of errors and warnings -->
			<xsl:if test="$FailuresCount &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Error.png" title="failures" />
					<span><xsl:value-of select="$FailuresCount" /></span>
				</div>
			</xsl:if>
			<xsl:if test="$NotImplementedCount &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Warning.png" title="not implemented" />
					<span><xsl:value-of select="$NotImplementedCount" /></span>
				</div>
			</xsl:if>
			<a class="expandAllRules">			
				<img src="{$applicationPath}/Themes/Kaizen/images/ext/Expand.png" title="Expand/collapse all" style="width: 28px; height: 28px; margin:0;" class="collapsed" />
			</a>
		</xsl:with-param>
		</xsl:call-template>
	  
		  <div class="section-content">
			<xsl:attribute name="class">
				<xsl:call-template name="getSectionContentClass">
					<xsl:with-param name="isfailed" select="$context.current.iserror" />
					<xsl:with-param name="iswarning" select="$context.current.iswarning" />
					<xsl:with-param name="issuccess" select="not($context.current.iswarning) and not($context.current.iserror)" />
				</xsl:call-template>
			</xsl:attribute>
			
			<table cellspacing="0" cellpadding="0">
				<xsl:apply-templates select="./concern" />
			</table>
		  </div>		  
    </div><!-- section -->
  </xsl:template>
  
	<xsl:template match="//MSpec//concern">		
		<xsl:if test="./@name != ''">
			<tr class="msbuild-target">
				<td>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/ArrowRight22.png" title="Concern" class="buildLogIcon" />
					Concern: <xsl:value-of select="./@name" />
				</td>
			</tr>
		</xsl:if>
	
		<xsl:apply-templates select="./context" />
	</xsl:template>
	
	<xsl:template match="//MSpec//context">				
		<tr class="msbuild-project">
			<td class="mspec-context-name">
				<p>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Package48.png" title="Context name" class="buildLogIcon" />
					<xsl:value-of select="./@name" />
				</p>
			</td>
		</tr>
	
		<xsl:apply-templates select="./specification" />
	</xsl:template>
	
	<xsl:template match="//MSpec//specification">				
		<xsl:variable name="specification.id" select="generate-id()" />
		
		<tr>			
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="./@status = 'failed'">
						msbuild-summary-failure
					</xsl:when>
					<xsl:when test="./@status = 'not-implemented'">
					</xsl:when>
					<xsl:otherwise>
						msbuild-summary-success
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<td>
				<span class="indent-tree">					
					<img class="buildLogIcon">
						<xsl:attribute name="src">
							<xsl:choose>
								<xsl:when test="./@status = 'failed'">
									<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/Error.png
								</xsl:when>
								<xsl:when test="./@status = 'not-implemented'">
									<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/Warning.png
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/SuccessTrue.png
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</img>
				</span>
				
				it <xsl:value-of select="./@name" />
			</td>
			<td>
				<xsl:if test="./@status = 'failed'">
					<a href="#" class="expandRule" title="Expand/collapse switch" ref="{$specification.id}"> </a>
				</xsl:if>	
			</td>
		</tr>
		
		<xsl:if test="./@status = 'failed'">		
			<tr>
				<td class="contentCell" colspan="2">
					<div class="innerWrapper inner-rule-description indent-tree" id="{$specification.id}">													
						<p><strong><xsl:value-of select="./error/message" /></strong></p>
						<p class="stacktrace">
							<xsl:value-of select="./error/stack-trace" />
						</p>
					</div><!-- innerWrapper -->
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
  </xsl:stylesheet>
