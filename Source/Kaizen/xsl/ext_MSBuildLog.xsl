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
	<xsl:include href="ext_MSBuildSummary.xsl" />


	<!-- Main template -->
	<xsl:template match="/">
		<xsl:call-template name="summary" >
			<xsl:with-param name="is.full.log" select="1" />
		</xsl:call-template>
		<xsl:call-template name="content" />
	</xsl:template>	
	
	<!-- Content template -->
	<xsl:template name="content">		
		<xsl:apply-templates select="//msbuild//project" />
	</xsl:template>
	
	<xsl:template name="log-settings">		
		<div>
			
		</div>
	</xsl:template>
	
	
<xsl:template match="//msbuild//project">
	<xsl:variable name="ErrorsCount" select="count(.//error[ancestor::project[position() = 1]	= current() ])" />
	<xsl:variable name="WarningsCount" select="count(.//warning[ancestor::project[position() = 1] = current() ])" />	
	
	<xsl:variable name="project.current.iserror" select="$ErrorsCount &gt; 0" />
	<xsl:variable name="project.current.iswarning" select="$WarningsCount &gt; 0" />

	<a name="{generate-id()}" />
	<div class="section">		
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$project.current.iserror" />
        <xsl:with-param name="iswarning" select="$project.current.iswarning" />
        <xsl:with-param name="issuccess" select="not($project.current.iswarning) and not($project.current.iserror)" />
        <xsl:with-param name="title">
			<xsl:call-template name="getFilenameFromPath">
				<xsl:with-param name="path" select="./@file" />
			</xsl:call-template>
		</xsl:with-param>
        <xsl:with-param name="data">
			<!-- display number of errors and warnings -->
			<xsl:if test="$ErrorsCount &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Error.png" title="errors" />
					<span><xsl:value-of select="$ErrorsCount" /></span>
				</div>
			</xsl:if>
			<xsl:if test="$WarningsCount &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Warning.png" title="warnings" />
					<span><xsl:value-of select="$WarningsCount" /></span>
				</div>
			</xsl:if>
			
			<!-- display how/hide messages icon/link -->
			<a href="#" class="msbuildHeaderIcon msbuildMessagesOn" title="Display all messages"> </a>
			
		</xsl:with-param>
		</xsl:call-template>
	  
		  <div class="section-content">
			<xsl:attribute name="class">
				<xsl:call-template name="getSectionContentClass">
					<xsl:with-param name="isfailed" select="$project.current.iserror" />
					<xsl:with-param name="iswarning" select="$project.current.iswarning" />
					<xsl:with-param name="issuccess" select="not($project.current.iswarning) and not($project.current.iserror)" />
				</xsl:call-template>
			</xsl:attribute>
			
			<table class="table-container">
				<xsl:apply-templates select="./*" />
			</table>
		  </div>		  
    </div><!-- section -->
  </xsl:template>	
    

	<xsl:template match="//msbuild//target">
		<tr class="msbuild-target">
			<td>
				<img src="{$applicationPath}/Themes/Kaizen/images/ext/ArrowRight22.png" title="Running target" class="buildLogIcon" />
				Executing target <xsl:value-of select="./@name" />
				<span title="Elased time" class="forceThin">
					(<xsl:value-of select="./@elapsedTime" />)
				</span>
			</td>
		</tr>
		<xsl:apply-templates select="./*[name() != 'project'] " />
		<xsl:for-each select="./*[name() = 'project'] ">
			<xsl:call-template name="projectBuildIndicator">
				<xsl:with-param name="project" select="." />
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="//msbuild//message">
		<tr class="msbuild-message-{./@level}">
			<td>
				<span class="message-text long-text">
					<xsl:attribute name="title">
							<xsl:value-of select="."/>
					</xsl:attribute><xsl:value-of select="." />
				</span>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="//msbuild//error">
		<tr class="msbuild-summary-failure">
			<td>				
				<span class="failed-text long-text">
					<xsl:attribute name="title">
							<xsl:value-of select="."/>
						</xsl:attribute>
						<img src="{$applicationPath}/Themes/Kaizen/images/ext/SuccessFalse.png" class="buildLogIcon" title="Error" />
						<xsl:value-of select="." />
				</span>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="//msbuild//warning">
		<tr class="msbuild-warning">
			<td>				
				<span class="warning-text long-text">
					<xsl:attribute name="title">
						<xsl:value-of select="."/>
					</xsl:attribute>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Warning.png" class="buildLogIcon" title="Warning" />
					<xsl:value-of select="." />
				</span>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="projectBuildIndicator">
		<xsl:param name="project" />
		<tr class="msbuild-project">
			<td>
				<img src="{$applicationPath}/Themes/Kaizen/images/ext/Package48.png" title="Building another project" class="buildLogIcon" />		
				Building project 
				
				<a href="#{generate-id($project)}" title="Jump to build results" class="regularHover">
					<!-- just the project filename -->
					<xsl:call-template name="getFilenameFromPath">
						<xsl:with-param name="path" select="$project/@file" />
					</xsl:call-template>
				</a>
				
				<span title="Elased time" class="forceThin">
					(<xsl:value-of select="./@elapsedTime" />)
				</span>
			</td>
		</tr>
	</xsl:template>
	
</xsl:stylesheet>
