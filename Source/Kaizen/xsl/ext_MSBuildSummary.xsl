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
	<xsl:include href="ext_Utils.xsl" />
	<xsl:include href="Design.xsl" />
	<xsl:param name="applicationPath" select="'.'" />

	<!-- variables -->
	<xsl:variable name="build.working.dir" select="//parameter[@name='$CCNetWorkingDirectory']/@value" />
	<xsl:variable name="build.working.dir.length" select="string-length($build.working.dir) + 2" /><!-- +2 to accomodate for 0-based index and \ character -->	
	<xsl:variable name="msbuild.all.builds.successful" select="count(//msbuild[@success ='false']) = 0" />
		  
	<!-- Main template -->
	  <xsl:template match="/">    			  
		  <xsl:call-template name="summary" />
	  </xsl:template>
 
	<!-- Summary template -->
  <xsl:template name="summary">
	<xsl:param name="is.full.log" />
	
    <div class="section">		
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="not($msbuild.all.builds.successful)" />
        <xsl:with-param name="iswarning" select="0" />
        <xsl:with-param name="issuccess" select="$msbuild.all.builds.successful" />
        <xsl:with-param name="title">MSBuild summary</xsl:with-param>
        <xsl:with-param name="data"></xsl:with-param>
      </xsl:call-template>
	  
		  <div class="section-content">
			<xsl:attribute name="class">
				<xsl:call-template name="getSectionContentClass">
					<xsl:with-param name="isfailed" select="not($msbuild.all.builds.successful)" />
					<xsl:with-param name="iswarning" select="0" />
					<xsl:with-param name="issuccess" select="$msbuild.all.builds.successful" />
				</xsl:call-template>
			</xsl:attribute>
			<xsl:call-template name="sectionContent">
				<xsl:with-param name="shouldPrintLinks" select="$is.full.log" />
			</xsl:call-template>
		  </div>		  
    </div><!-- section -->
  </xsl:template>

	<!-- Templates -->
	<xsl:template name="sectionContent">
		<xsl:param name="shouldPrintLinks" />
		
		<table cellspacing="0">
		  <tbody>
				<tr>
					<td  class="strong">MSBuild tasks count:</td>
					<td class="strong">
						<xsl:value-of select="count(//msbuild)" />
						<xsl:if test="not($msbuild.all.builds.successful)">
							<span class="failed-text"> (including <xsl:value-of select="count(//msbuild[@success ='false'])" /> failed)</span>
						</xsl:if>
					</td>
				</tr>
				<xsl:for-each select="//msbuild/project">					
					<xsl:call-template name="printSubProjects">
						<xsl:with-param name="project" select="." />
						<xsl:with-param name="depth" select="0" />
						<xsl:with-param name="shouldPrintLinks" select="$shouldPrintLinks" />						
					</xsl:call-template>
				</xsl:for-each>
		  </tbody>
		</table>
	</xsl:template>
	
	<xsl:template name="printSubProjects">
		<xsl:param name="project" />
		<xsl:param name="depth" />
		<xsl:param name="shouldPrintLinks" />
		
		<tr class="msbuild-summary-success">			
			<xsl:if test="./@success = 'false' ">
				<xsl:attribute name="class">
					msbuild-summary-failure
				</xsl:attribute>
			</xsl:if>
			<td colspan="2">
				<!-- indenting -->
				<xsl:call-template name="forLoop">
					<xsl:with-param name="i">1</xsl:with-param>
					<xsl:with-param name="count" select="$depth" />
					<xsl:with-param name="printValue">
						<span class="indent-tree"></span>
					</xsl:with-param>
				</xsl:call-template> 
				
				<!-- icon so that it looks little nicer -->
				<img class="buildLogIcon">
					<xsl:attribute name="src">
						<xsl:choose>
							<xsl:when test="not($project/@success = 'true')">
								<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/SuccessFalse.png
							</xsl:when>
							<xsl:when test="count($project//warning[ancestor::project[position() = 1] = $project ]) &gt; 0">
								<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/Warning.png
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/SuccessTrue.png
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:attribute name="title">
						Build succeeded: <xsl:value-of select="./@success" />
					</xsl:attribute>
				</img> 
				
				<!-- if we're in "full log mode" (report) then provide links for easier navigation -->
				<xsl:choose>
					<xsl:when test="$shouldPrintLinks">
						<a href="#{generate-id($project)}" title="{./@file}" class="regularHover">
							<!-- just the project filename -->
							<xsl:call-template name="getFilenameFromPath">
								<xsl:with-param name="path" select="./@file" />
							</xsl:call-template>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<span title="{./@file}">
							<!-- just the project filename -->
							<xsl:call-template name="getFilenameFromPath">
								<xsl:with-param name="path" select="./@file" />
							</xsl:call-template>
						</span>
					</xsl:otherwise>
				</xsl:choose>					
					
				<span title="Elased time" class="forceThin">
					(<xsl:value-of select="./@elapsedTime" />)
				</span>
			</td>
		</tr>
		<xsl:for-each select="current()/target/project">
			<xsl:call-template name="printSubProjects">
				<xsl:with-param name="project" select="." />
				<xsl:with-param name="depth" select="$depth + 1" />
				<xsl:with-param name="shouldPrintLinks" select="$shouldPrintLinks" />
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
