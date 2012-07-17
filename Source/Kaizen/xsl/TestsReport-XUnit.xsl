<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/html4/strict.dtd">	
	<xsl:output method="html"/>	
	
	<xsl:include href="TestsSummary-XUnit.xsl" />
	
	<xsl:variable name="applicationPath" />
	<xsl:variable name="tests.root" select="cruisecontrol//build//assembly" />
		
	<xsl:template match="/">
		<xsl:call-template name="TestsSummary" />
		<xsl:call-template name="TestDetails" />
	</xsl:template>

	<xsl:template name="TestDetails">
		<xsl:call-template name="fixtures" />
  </xsl:template>
  
	<xsl:template name="display-time-second">
		<xsl:param name="value"/>
		<span class="time"><xsl:value-of select="format-number($value,'0.00')"/>s</span>
	</xsl:template>
  
	<xsl:template name="display-time">
		<xsl:param name="value"/>
		<span class="time"><xsl:value-of select="format-number($value*1000,'0.000')"/>ms</span>
	</xsl:template>
  
	<xsl:template name="display-percent">
		<xsl:param name="value"/>
		<xsl:value-of select="format-number($value,'0.00 %')"/>
	</xsl:template>
  
	<xsl:template name="display-memory">
		<xsl:param name="value"/>
		<xsl:variable name="kbvalue">
			<xsl:value-of select="$value * 0.0001"/>
		</xsl:variable>
		<xsl:value-of select="format-number($kbvalue,'0.00 Kb')"/>
	</xsl:template>
  
	<xsl:template name="underscore-replace">
		<xsl:param name="word"/>
		<xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="$word"/>
			<xsl:with-param name="replace" select="'_'"/>
			<xsl:with-param name="with" select="' '"/>
		</xsl:call-template>
	</xsl:template>
  
	<xsl:template name="setupTeardown-replace">
		<xsl:param name="word"/>
		<xsl:call-template name="replace-string">
			<xsl:with-param name="text">
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="$word"/>
					<xsl:with-param name="replace" select="'.TearDown'"/>
					<xsl:with-param name="with" select="''"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="replace" select="'.BaseSetup.'"/>
			<xsl:with-param name="with" select="''"/>
		</xsl:call-template>
	</xsl:template>
  
	<xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
		<xsl:when test="contains($text,$replace)">
			<xsl:value-of select="substring-before($text,$replace)"/>
			<xsl:value-of select="$with"/>
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="substring-after($text,$replace)"/>
				<xsl:with-param name="replace" select="$replace"/>
				<xsl:with-param name="with" select="$with"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
    </xsl:choose>
	</xsl:template>
	
  <xsl:template name="getName">
	  <xsl:param name="fixture" />
		
    <xsl:variable name="fixture.parent" select="$fixture/../.." />
		<xsl:variable name="fixture.name" select="$fixture/@name" />
		
		<xsl:choose>
			<xsl:when test="contains($fixture.name, '\') or contains($fixture.name, '.dll')">
			</xsl:when>
			<xsl:when test="name($fixture.parent) = 'assembly'">
				<xsl:value-of select="concat($fixture.parent/@name, '.', $fixture.name)"/>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="fixtures">
		<xsl:for-each select="//assembly[count(./class/test) > 0]">
			<xsl:variable name="tests.section.notrun.count" select="count(.//test[@result='Skip'])"/>
			<xsl:variable name="tests.section.run.count" select="count(.//test[@result='Pass'])"/>
			<xsl:variable name="tests.section.failure.count" select="count(.//test[@result='Fail'])"/>
			
			<xsl:variable name="tests.section.isfailed" select="$tests.section.failure.count > 0" />
			<xsl:variable name="tests.section.iswarning" select="$tests.section.notrun.count > 0" />
			<xsl:variable name="tests.section.issuccess" select="not ($tests.section.iswarning) and not ($tests.section.isfailed)" />
	
			<xsl:variable name="tests.section.title.data">
				<xsl:choose>
					<xsl:when test="$tests.section.isfailed">
						<xsl:value-of select="$tests.section.failure.count"/>
					</xsl:when>
					<xsl:when test="$tests.section.iswarning">
						<xsl:value-of select="$tests.section.notrun.count"/>
					</xsl:when>
					<xsl:when test="$tests.section.issuccess">
						<xsl:value-of select="$tests.section.run.count"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>	
			<xsl:variable name="tests.section.content.class">
				<xsl:call-template name="getSectionContentClass">
					<xsl:with-param name="isfailed" select="$tests.section.isfailed" />
					<xsl:with-param name="iswarning" select="$tests.section.iswarning" />
					<xsl:with-param name="issuccess" select="$tests.section.issuccess" />
				</xsl:call-template>
			</xsl:variable>
				
			<xsl:variable name="tests.section.name" select="@name"/>
			
			<div class="section">
				<xsl:call-template name="createTitle">
					<xsl:with-param name="isfailed" select="$tests.section.isfailed" />
					<xsl:with-param name="iswarning" select="$tests.section.iswarning" />
					<xsl:with-param name="issuccess" select="$tests.section.issuccess" />
					<xsl:with-param name="title" select="$tests.section.name" />
					<xsl:with-param name="data" select="$tests.section.title.data" />
				</xsl:call-template>
			
				<div class="section-content">
			        <xsl:attribute name="class">
						<xsl:value-of select="$tests.section.content.class"/>
					</xsl:attribute>
					
					<table>
						<xsl:call-template name="xunit2testfulldetail">
						  <xsl:with-param name="detailnodes" select=".//test"/>
						</xsl:call-template>
					</table>
		    </div>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="test">
		<tr>
			<td class="label strong" colspan="2">
				<xsl:call-template name="underscore-replace"><xsl:with-param name="word" select="@name"/></xsl:call-template>
			</td>
		</tr>
		<xsl:apply-templates select="class/test" />
		
	</xsl:template>
  
	<xsl:template match="test">
		<xsl:apply-templates select="*" />
	</xsl:template>
	
  <xsl:template match="test">
		<tr>
			<td>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="@result = 'Fail'">data failed-underline</xsl:when>
						<xsl:otherwise>data</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="xunit2testfulldetail">
    <xsl:param name="detailnodes"/>
	
	<tr><td class="label strong">Test</td><td class="label strong">Type</td><td class="label strong">Message</td><td class="label strong">Time</td></tr>
    <xsl:for-each select="$detailnodes">
      <xsl:if test="failure">
			  <tr><td class="data failed-underline failed-text"><xsl:value-of select="@name"/></td><td class="data failed-underline failed-text">Failure</td>
	    	<td class="data"><xsl:value-of select="failure//message"/></td>
			<td class="data"><xsl:value-of select="format-number($tests.time, '0.000')"/> seconds</td></tr>
        <tr><td class="data"><xsl:value-of select="failure//stack-trace"/></td></tr>
      </xsl:if>
      <xsl:if test="reason">
				<tr><td class="data"><xsl:value-of select="@name"/></td>
				<td class="data warning-text">Warning</td>
				<td class="data"><xsl:value-of select="reason//message"/></td>
				<td class="data">N/A</td></tr>
      </xsl:if>
	  <xsl:if test="@result = 'Pass'">
				<tr><td class="data"><xsl:value-of select="@name"/></td>
				<td class="data success-text">Pass</td>
				<td class="data">N/A</td>
				<td class="data"><xsl:value-of select="format-number($tests.time, '0.000')"/> seconds</td></tr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>