<?xml version="1.0" encoding="UTF-8"?>
<!--
Template version 1.0
by sinnerinc

History:
# 2012-02-14: 
	Initial version
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="html"/>
 <xsl:include href="Design.xsl" />
 
	<!-- summary data -->
	<xsl:key name="stylecop-warnings-filescount" match="Violation" use="@Source" />
	<xsl:variable name="build.working.dir" select="//parameter[@name='$CCNetWorkingDirectory']/@value" />
	<xsl:variable name="build.working.dir.length" select="string-length($build.working.dir) + 2" /><!-- +2 to accomodate for 0-based index and \ character -->
	
	<!-- Tool specific variables -->
	<xsl:variable name="stylecop.root" select="//StyleCopViolations"/>	
	<xsl:variable name="stylecop.warnings.total" select="count($stylecop.root/Violation)" />
	
	<!-- section variables -->
	<xsl:variable name="stylecopanalysis.isfailed" select="$stylecop.warnings.total &gt; 100" />
	<xsl:variable name="stylecopanalysis.iswarning" select="$stylecop.warnings.total &gt; 0 and $stylecop.warnings.total &lt; 100" />
	<xsl:variable name="stylecopanalysis.issuccess" select="not($stylecopanalysis.isfailed) and not($stylecopanalysis.iswarning)" />
 
	<xsl:variable name="stylecopanalysis.title.name" select="'StyleCop Report'" />
	<xsl:variable name="stylecopanalysis.title.data" select="$stylecop.warnings.total"/>

	<!-- Design variables -->
  <xsl:variable name="stylecopanalysis.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$stylecopanalysis.isfailed" />
      <xsl:with-param name="iswarning" select="$stylecopanalysis.iswarning" />
      <xsl:with-param name="issuccess" select="$stylecopanalysis.issuccess" />
    </xsl:call-template>
  </xsl:variable>
 
   <!-- Main template -->
  <xsl:template match="/">    		
      <xsl:call-template name="summary" />
  </xsl:template>
 
	<!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">		
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$stylecopanalysis.isfailed" />
        <xsl:with-param name="iswarning" select="$stylecopanalysis.iswarning" />
        <xsl:with-param name="issuccess" select="$stylecopanalysis.issuccess" />
        <xsl:with-param name="title" select="$stylecopanalysis.title.name" />
        <xsl:with-param name="data" select="$stylecopanalysis.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$stylecopanalysis.content.class"/>
        </xsl:attribute>
        <xsl:call-template name="sectionContent" />
      </div>
    </div>
  </xsl:template>
  
  <!-- Templates -->
  <xsl:template name="sectionContent">
	<table>      
      <tbody>        
        <tr> 
			<td class="data strong">Warnings</td>          
			<td class="data strong">
			<xsl:choose>
              <xsl:when test="$stylecop.warnings.total &gt; 0">
                <span class="failed-text"><xsl:value-of select="$stylecop.warnings.total" /></span>
              </xsl:when>
              <xsl:otherwise>
                <span class="success-text"><xsl:value-of select="$stylecop.warnings.total" /></span>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
		<tr>
			<td class="data strong">Base path</td>
			<td class="data strong">
				<xsl:value-of select="$build.working.dir" />
			</td>
		</tr>
		<tr>
			<td class="data strong">Files with warnings</td>          
			<td class="data strong">				
				<xsl:choose>
					<xsl:when test="$stylecop.warnings.total &gt; 0">
						<span class="failed-text"><xsl:value-of select="count($stylecop.root/Violation[generate-id(.) = generate-id(key('stylecop-warnings-filescount', @Source)[1])])" /></span>
					</xsl:when>
					<xsl:otherwise>
						<span class="success-text"><xsl:value-of select="count($stylecop.root/Violation[generate-id(.) = generate-id(key('stylecop-warnings-filescount', @Source)[1])])" /></span>
					</xsl:otherwise>
            </xsl:choose>
			</td>
		</tr>
      </tbody>
    </table>
  </xsl:template>
</xsl:stylesheet>