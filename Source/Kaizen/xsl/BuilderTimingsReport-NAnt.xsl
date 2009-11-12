<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html"/>
	<xsl:include href="Design.xsl" />
	
  <xsl:param name="applicationPath"/>

  <xsl:template match="/">
		<xsl:variable name="build.timings.total">
			<xsl:call-template name="replaceFromString">
			    <xsl:with-param name="text" select="sum(//build/@buildtime)" />
			    <xsl:with-param name="replace">:</xsl:with-param>
			    <xsl:with-param name="with"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="build.timings.isfailed" select="$build.timings.total > 1000" />
		<xsl:variable name="build.timings.iswarning" select="$build.timings.total > 500" />
		<xsl:variable name="build.timings.issuccess" select="not ($build.timings.isfailed) and not ($build.timings.iswarning)" />
		<xsl:variable name="build.timings.content.class">
			<xsl:call-template name="getSectionContentClass">
				<xsl:with-param name="isfailed" select="$build.timings.isfailed" />
				<xsl:with-param name="iswarning" select="$build.timings.iswarning" />
				<xsl:with-param name="issuccess" select="$build.timings.issuccess" />
			</xsl:call-template>
		</xsl:variable>
	
		<div class="section">
			<xsl:call-template name="createTitle">
				<xsl:with-param name="isfailed" select="$build.timings.isfailed" />
				<xsl:with-param name="iswarning" select="$build.timings.iswarning" />
				<xsl:with-param name="issuccess" select="$build.timings.issuccess" />
				<xsl:with-param name="title">Build Timings</xsl:with-param>
				<xsl:with-param name="data" select="//build/@buildtime" />
			</xsl:call-template>
			
			<div class="section-content">
				<xsl:attribute name="class">
					<xsl:value-of select="$build.timings.content.class"/>
				</xsl:attribute>
				
				<xsl:variable name="buildresults" select="//build/buildresults" />
				<xsl:choose>
					<xsl:when test="count($buildresults) > 0">
						<xsl:apply-templates select="$buildresults" />
					</xsl:when>
					<xsl:otherwise>
						<table>
							<tr>
								<td class="data strong">
									Log does not contain any Xml output from NAnt.
								</td>
							</tr>
							<tr>
								<td>
									Please make sure that NAnt is executed using the XmlLogger (use the argument: <b>-logger:NAnt.Core.XmlLogger</b>).
								</td>
							</tr>
						</table>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="buildresults">
		<table>
			<xsl:apply-templates select="//target">
				<xsl:sort select="duration" order="descending" data-type="number" />				
			</xsl:apply-templates>
		</table>
	</xsl:template>
	
	<xsl:template match="target">
		<tr>		
			<td valign="top" class="label strong">
				<xsl:for-each select="ancestor::target"><xsl:value-of select="@name" /> / </xsl:for-each>
				<xsl:value-of select="@name" />
			</td>
			<td valign="top" class="data strong right">
				<xsl:apply-templates select="duration" />
			</td>
		</tr>
		<tr>
			<td class="data">
				<ul>
					<xsl:apply-templates select="task">
						<xsl:sort select="duration" order="descending" data-type="number" />				
					</xsl:apply-templates>
				</ul>
			</td>
			<td></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="task">
		<li><xsl:value-of select="@name" /> - <xsl:apply-templates select="duration" /></li>
	</xsl:template>

	<xsl:template match="duration">
		<xsl:variable name="hours" select="floor(node() div 3600000)" />
		<xsl:variable name="minutes" select="floor((node() mod 3600000) div 60000)" />
		<xsl:variable name="seconds" select="(node() mod 60000) div 1000" />
		<xsl:if test="$hours > 0"><xsl:value-of select="$hours" />:</xsl:if>
		<xsl:value-of select="format-number($minutes,'00')" />:<xsl:value-of select="format-number($seconds,'00.00')"/>
	</xsl:template>
</xsl:stylesheet>