<?xml version="1.0" encoding="UTF-8"?>
<!--
Template version 1.0
by sinnerinc

History:
# 2012-02-14: 
	Initial version
# 2012-12-30:
	Limiting number of files/warnings per file displayed (https://github.com/sinnerinc/CC.NET-Kaizen-theme/issues/1)
-->

<!-- Designed by Yves Tremblay of ProgiNet Inc. and SBG International Inc. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" />
  <xsl:param name="applicationPath" select="'.'" />
  <xsl:include href="ext_Utils.xsl" />
  <xsl:include href="ext_StyleCopSummary.xsl" />
  
 <xsl:variable name="unique.source" select="$stylecop.root/Violation[not(@Source = preceding-sibling::Violation/@Source)]" />
 <xsl:variable name="limit.filesToDisplay" select="0" />
 <xsl:variable name="limit.violationsToDisplayPerFile" select="0" />
  
  <!-- Main template -->
  <xsl:template match="/">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
  </xsl:template>
  

   <!-- Content template -->
  <xsl:template name="content">
		<xsl:for-each select="$unique.source">
			<xsl:if test="($limit.filesToDisplay = 0) or (not(position() > $limit.filesToDisplay))">
				<xsl:variable name="source" select="./@Source"/>
				<xsl:variable name="stylecop.filesection.title">
					<xsl:call-template name="getFilenameFromPath">
						<xsl:with-param name="path" select="substring(./@Source, $build.working.dir.length)"/>
					</xsl:call-template>
				</xsl:variable>
				
				<div class="section">
					<xsl:call-template name="createTitle">
					  <xsl:with-param name="isfailed" select="1" />
					  <xsl:with-param name="iswarning" select="0" />
					  <xsl:with-param name="issuccess" select="0" />
					  <xsl:with-param name="title" select="$stylecop.filesection.title" />
					  <xsl:with-param name="data">					
						<div>
							<img src="{$applicationPath}/Themes/Kaizen/images/ext/Warning.png" title="Warnings" />
							<span><xsl:value-of select="count(//Violation[@Source=$source])" /></span>
						</div>
						<a class="expandAllRules" ref="{$stylecop.filesection.title}">
							<img src="{$applicationPath}/Themes/Kaizen/images/ext/Expand.png" title="Expand/collapse all" style="width: 28px; height: 28px; margin:0;" class="collapsed" />
						</a>
					  </xsl:with-param>
					</xsl:call-template>
				
					<div class="section-content">
					  <xsl:attribute name="class">section-content failed-light</xsl:attribute>

					  <!-- // MAIN TABLE WITH RESULTS -->
					  <table cellpadding="2" cellspacing="0">
						<xsl:call-template name="print-module-error-list">
						  <xsl:with-param name="source" select="$source"/>
						</xsl:call-template>
					  </table>
					</div>			
				</div>	
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
  
  <xsl:template name="print-module-error-list">    
    <xsl:param name="source" />
	
	<tr>		
		<td colspan="3" class="stylecop-filename-report">
			Warnings for: <strong><span title="{$source}"><xsl:value-of select="substring($source, $build.working.dir.length)"/></span></strong>
		</td>
	</tr>
	
	
	<xsl:for-each select='$stylecop.root/Violation[@Source = $source]'>
		<xsl:if test="($limit.violationsToDisplayPerFile = 0) or (not(position() > $limit.violationsToDisplayPerFile))">
              <xsl:variable name="message.id" select="generate-id()" />
              <xsl:variable name="rule.id" select="@RuleId" />
              <xsl:variable name="rule.rule" select="@Rule" />
              <xsl:variable name="rule.namespace" select="@RuleNamespace" />
              <xsl:variable name="section" select="@Section" />

              <tr class="oddRow">
				<xsl:if test="position() mod 2 = 0">
					<!-- overwrite oddRow with evenRow -->
				   <xsl:attribute name="class">evenRow</xsl:attribute>
				</xsl:if>
				
				<td valign="top" width="30">			
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/warning.png" title="Warning" />
				</td>
                <td>
					<strong>
						<xsl:value-of select="text()" />
					</strong>
                </td>
				<td class="lineNumberCell">
					<span title="Line number">
						(<xsl:value-of select="@LineNumber" />)
					</span>
					<a href="#" class="expandRule" title="Expand/collapse switch" ref="{$message.id}"> </a>
                </td>
              </tr>
              <tr>
				<xsl:if test="position() mod 2 = 0">
				   <xsl:attribute name="class">oddRow</xsl:attribute>
				</xsl:if>
				<td></td>
				<td colspan="2" class="contentCell">
					<div class="innerWrapper" id="{$message.id}">
						<table cellpadding="5" cellspacing="0" width="100%" class="inner-rule-description">	
							<tr><td><b>Rule:</b></td><td><xsl:value-of select="$rule.rule" /></td></tr>
							<tr><td><b>Rule ID:</b></td>
								<td>
								<a><xsl:attribute name="href">http://stylecop.soyuz5.com/<xsl:value-of select="$rule.id" />.html</xsl:attribute>
								<xsl:attribute name="target">_blank</xsl:attribute>
								<xsl:value-of select="$rule.id" /></a>
								</td>
							</tr>
							<tr><td><b>Rule Namespace:</b></td><td><xsl:value-of select="$rule.namespace" /></td></tr>
							<tr><td><b>Section:</b></td><td><xsl:value-of select="$section" /></td></tr>
						</table>
                  </div>
                </td>
              </tr>
			</xsl:if>
		</xsl:for-each>
	
  </xsl:template>
</xsl:stylesheet>