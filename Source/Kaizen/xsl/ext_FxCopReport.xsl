<?xml version="1.0" encoding="utf-8"?>
<!--
Template version 1.0
by sinnerinc

History:
# 2012-02-14: 
	Initial version
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:param name="applicationPath" select="'.'" />
  <xsl:include href="DesignAnalysisSummary-FxCop.xsl" />

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$fxcop.isavailable">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
    </xsl:if>
  </xsl:template>

  <!-- Content template -->
  <xsl:template name="content">
    <xsl:for-each select="$designanalysis.root/Targets//Modules/Module">

      <xsl:variable name="designanalysis.section.errors.total" select="count(.//Issue[@Level='Error'])" />
      <xsl:variable name="designanalysis.section.criticalerrors.total" select="count(.//Issue[@Level='CriticalError'])" />
	  <xsl:variable name="designanalysis.section.criticalwarnings.total" select="count(.//Issue[@Level='CriticalWarning'])" />
	  <xsl:variable name="designanalysis.section.warnings.total" select="count(.//Issue[@Level='Warning'])" />
	  
      <xsl:variable name="designanalysis.section.error.level" select="$designanalysis.section.errors.total + $designanalysis.section.criticalerrors.total" />
      <xsl:variable name="designanalysis.section.warning.level" select="count(.//Issue[@Level='CriticalWarning'])" />

      <xsl:variable name="designanalysis.section.isfailed" select="$designanalysis.section.error.level &gt;= $designanalysis.error.boundary" />
      <xsl:variable name="designanalysis.section.iswarning" select="$designanalysis.section.warning.level &gt;= $designanalysis.warning.boundary" />
      <xsl:variable name="designanalysis.section.issuccess" select="not($designanalysis.section.isfailed) and not($designanalysis.section.iswarning)" />

      <xsl:variable name="designanalysis.section.title" select="@Name" />
      
      <xsl:variable name="designanalysis.section.content.class">
        <xsl:call-template name="getSectionContentClass">
          <xsl:with-param name="isfailed" select="$designanalysis.section.isfailed" />
          <xsl:with-param name="iswarning" select="$designanalysis.section.iswarning" />
          <xsl:with-param name="issuccess" select="$designanalysis.section.issuccess" />
        </xsl:call-template>
      </xsl:variable>

      <div class="section">
        <xsl:call-template name="createTitle">
          <xsl:with-param name="isfailed" select="$designanalysis.section.isfailed" />
          <xsl:with-param name="iswarning" select="$designanalysis.section.iswarning" />
          <xsl:with-param name="issuccess" select="$designanalysis.section.issuccess" />
          <xsl:with-param name="title" select="$designanalysis.section.title" />          

		  <xsl:with-param name="data">
		  
			<xsl:if test="$designanalysis.section.criticalerrors.total &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/CriticalError.png" title="Critical errors" />
					<span><xsl:value-of select="$designanalysis.section.criticalerrors.total" /></span>
				</div>
			</xsl:if>
			<xsl:if test="$designanalysis.section.errors.total &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Error.png" title="Errors" />
					<span><xsl:value-of select="$designanalysis.section.errors.total" /></span>
				</div>
			</xsl:if>
			<xsl:if test="$designanalysis.section.criticalwarnings.total &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/CriticalWarning.png" title="Critical warnings" />
					<span><xsl:value-of select="$designanalysis.section.criticalwarnings.total" /></span>
				</div>
			</xsl:if>
			<xsl:if test="$designanalysis.section.warnings.total &gt; 0">
				<div>
					<img src="{$applicationPath}/Themes/Kaizen/images/ext/Warning.png" title="Warnings" />
					<span><xsl:value-of select="$designanalysis.section.warnings.total" /></span>
				</div>
			</xsl:if>
			
			<a class="expandAllRules" ref="{$designanalysis.section.title}">
				<img src="{$applicationPath}/Themes/Kaizen/images/ext/Expand.png" title="Expand/collapse all" style="width: 28px; height: 28px; margin:0;" class="collapsed" />
			</a>
		  </xsl:with-param>
        </xsl:call-template>
        <div class="section-content">
          <xsl:attribute name="class">
            <xsl:value-of select="$designanalysis.section.content.class"/>
          </xsl:attribute>

		  <!-- // MAIN TABLE WITH RESULTS -->
          <table cellpadding="2" cellspacing="0">
            <xsl:apply-templates select="."/>
          </table>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="//FxCopReport//*">
    <xsl:variable name="designanalysis.section.messages.total" select="count(.//Message[@Status='Active'])"/>

    <xsl:if test="$designanalysis.section.messages.total &gt; 0">
      <xsl:apply-templates select=".//Message[Issue/@Level='CriticalError']" />
      <xsl:apply-templates select=".//Message[Issue/@Level='Error']" />
      <xsl:apply-templates select=".//Message[Issue/@Level='CriticalWarning']" />
      <xsl:apply-templates select=".//Message[Issue/@Level='Warning']" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="//FxCopReport//Message">
    <!-- // Select proper rule // -->
	<xsl:variable name="rule.check.id" select="@CheckId" />
	<xsl:variable name="rule.name" select="$fxcop.root/Rules/Rule[@CheckId = $rule.check.id]/Name" />
	<xsl:variable name="rule.category" select="$fxcop.root/Rules/Rule[@CheckId = $rule.check.id]/@Category" />
	<xsl:variable name="rule.description" select="$fxcop.root/Rules/Rule[@CheckId = $rule.check.id]/Description" />
	<xsl:variable name="rule.url" select="$fxcop.root/Rules/Rule[@CheckId = $rule.check.id]/Url" />
	<xsl:variable name="rule.file.name" select="$fxcop.root/Rules/Rule[@CheckId = $rule.check.id]/File/@Name" />
	<xsl:variable name="rule.file.version" select="$fxcop.root/Rules/Rule[@CheckId = $rule.check.id]/File/@Version" />
	<xsl:variable name="message.id" select="generate-id()" />

    <tr class="oddRow">
		<xsl:if test="position() mod 2 = 0">
			<!-- overwrite oddRow with evenRow -->
		   <xsl:attribute name="class">evenRow</xsl:attribute>
		</xsl:if>
	<!-- // Image indicating error type // -->
      <td valign="top" width="30">
			
	        <img>
			<xsl:attribute name="src">
				<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/<xsl:value-of select="./Issue/@Level" />.png
			</xsl:attribute>
			
			<xsl:attribute name="title">
				<xsl:value-of select="./Issue/@Level" />
			</xsl:attribute>
		</img> 
	</td>
	
	<!-- // Desciption of the problem // -->
	<td>
			<div class="fxcop-breaking-reason">
				<xsl:value-of select="../../../../@Name" /> -	<xsl:value-of select="../../@Name" />
			</div>			
			
			<a href="{$rule.url}" target="_blank" class="regularHover">
				<xsl:value-of select="$rule.check.id" />: <xsl:value-of select="$rule.name" /> 
			</a>
			<span class="fxcopUsageCategory"> (<xsl:value-of select="$rule.category" />)</span>
			
	</td>
	
	<!-- // Certainty of the problem // -->
	<td valign="top" class="certaintyCell">
		<span title="Certainty">
			(<xsl:value-of select="./Issue/@Certainty" />%)
		</span>
		<a href="#" class="expandRule" title="Expand/collapse switch" ref="{$message.id}"> </a>
     </td>
	</tr>
	
	<!-- // inner table with details // -->
	<tr>	
		<xsl:if test="position() mod 2 = 0">
		   <xsl:attribute name="class">oddRow</xsl:attribute>
		</xsl:if>
		<td></td>
		<td colspan="2" class="contentCell">
			<div class="innerWrapper" id="{$message.id}">
				<table cellpadding="5" cellspacing="0" width="100%" class="inner-rule-description">	
					<xsl:if test="./Issue/@File != ''">
						<tr>
							<td valign="top">
								<b>Found at:</b>
							</td>
							<td>
								<xsl:if test="./Issue/@Path">
									<xsl:value-of select="./Issue/@Path" />\<strong><xsl:value-of select="./Issue/@File" /></strong> at line <xsl:value-of select="./Issue/@Line" />
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
					
					<tr>
						<td valign="top">
							<b>Resolution:</b><br />
							<span>
								<xsl:attribute name="class">
									<xsl:value-of select="@FixCategory" />
								</xsl:attribute>
								
								<xsl:value-of select="@FixCategory" />
							</span>
						</td>
						<td valign="top">
							<xsl:value-of select="./Issue" />
						</td>
					</tr>	
					
					<tr>
						<td valign="top">
							<b>Description:</b>
						</td>
						<td valign="top">
							<xsl:value-of select="$rule.description" />
						</td>
					</tr>
					
					<tr>
						<td valign="top">
							<b>Rule File:</b>
						</td>
						<td valign="top">
							<xsl:value-of select="$rule.file.name" /> Version: <xsl:value-of select="$rule.file.version" />
						</td>
					</tr>
				</table>
			</div><!-- innerWrapper -->
		</td>
    </tr>
  </xsl:template> 
  
</xsl:stylesheet>