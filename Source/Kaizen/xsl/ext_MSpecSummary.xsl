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
	<!--<xsl:variable name="build.working.dir" select="//parameter[@name='$CCNetWorkingDirectory']/@value" />-->
	<xsl:variable name="is.failed.specs" select="count(//MSpec//assembly//specification[@status = 'failed']) &gt; 0" />
	<xsl:variable name="is.not.implemented.specs" select="count(//MSpec//assembly//specification[@status = 'not-implemented']) &gt; 0" />	
		  
	<!-- Main template -->
	  <xsl:template match="/">    			  
		  <xsl:call-template name="summary" />
	  </xsl:template>
 
	<!-- Summary template -->
  <xsl:template name="summary">
	 <div class="section">
			<xsl:call-template name="createTitle">
                <xsl:with-param name="isfailed" select="$is.failed.specs" />
                <xsl:with-param name="iswarning" select="$is.not.implemented.specs" />
                <xsl:with-param name="issuccess" select="not($is.not.implemented.specs) and not($is.failed.specs)" />
                <xsl:with-param name="title">MSpec summary</xsl:with-param>
                <xsl:with-param name="data"></xsl:with-param>
            </xsl:call-template>            

            <div class="section-content">
                <xsl:attribute name="class">
                    <xsl:call-template name="getSectionContentClass">
                        <xsl:with-param name="isfailed" select="$is.failed.specs" />
						<xsl:with-param name="iswarning" select="$is.not.implemented.specs" />
						<xsl:with-param name="issuccess" select="not($is.not.implemented.specs) and not($is.failed.specs)" />
                    </xsl:call-template>                    
                </xsl:attribute>
                <xsl:call-template name="sectionContent" />
            </div>
        </div><!-- section -->
  </xsl:template>

	<!-- Templates -->
	<xsl:template name="sectionContent">
		<table cellspacing="0" border="0">
            <tbody>
                <xsl:for-each select="//MSpec/assembly">
                    <tr>
                        <td class="strong" colspan="2">
                            <img class="buildLogIcon">
								<xsl:attribute name="src">
									<xsl:choose>
										<xsl:when test="$is.failed.specs = 'true'">
											<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/Error.png
										</xsl:when>
										<xsl:when test="$is.not.implemented.specs = 'true'">
											<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/Warning.png
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$applicationPath" />/Themes/Kaizen/images/ext/SuccessTrue.png
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</img>
                            <xsl:value-of select="./@name"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Concerns
                        </td>
                        <td class="strong">
                            <xsl:value-of select="count(.//concern)"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Contexts
                        </td>
                        <td class="strong">
                            <xsl:value-of select="count(.//context)"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Specifications
                        </td>
                        <td class="strong">
                            <xsl:value-of select="count(.//specification)"/>
                        </td>
                    </tr>
                    <tr class="msbuild-message-high">
                        <td>
                            <span class="indent-tree">Passed</span>
                        </td>
                        <td class="strong">
                            <xsl:value-of select="count(.//specification[@status = 'passed'])"/>
                        </td>
                    </tr>
                    <tr class="msbuild-message-high">
                        <td>
                            <span class="indent-tree">Failed</span>
                        </td>
                        <td class="strong">
                            <xsl:value-of select="count(.//specification[@status = 'failed'])"/>
                        </td>
                    </tr>
                    <tr class="msbuild-message-high">
                        <td>
							<span class="indent-tree">Not implemented</span>
                        </td>
                        <td class="strong">
                            <xsl:value-of select="count(.//specification[@status = 'not-implemented'])"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
	</xsl:template>
</xsl:stylesheet>
