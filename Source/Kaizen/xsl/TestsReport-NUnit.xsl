<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/html4/strict.dtd">	
	<xsl:output method="html"/>	
	
	<xsl:include href="TestsSummary-NUnit.xsl" />
	
	<xsl:variable name="applicationPath" />
	<xsl:variable name="tests.root" select="cruisecontrol//test-results" />
		
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
			<xsl:when test="name($fixture.parent) = 'test-suite'">
				<xsl:variable name="fixture.name.part">				
					<xsl:call-template name="getName">
						<xsl:with-param name="fixture" select="$fixture.parent" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$fixture.name.part = ''">
						<xsl:value-of select="$fixture.name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($fixture.name.part, '.', $fixture.name)"/>
					</xsl:otherwise>
				</xsl:choose> 
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="fixtures">
		<xsl:for-each select="//test-suite[count(./results/test-suite/results/test-case) > 0]">
			<xsl:variable name="tests.section.notrun.count" select="count(.//test-case[@executed='False'])"/>
			<xsl:variable name="tests.section.run.count" select="count(.//test-case[@executed='True'])"/>
			<xsl:variable name="tests.section.failure.count" select="count(.//test-case[@success='False'])"/>
			
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
				
			<xsl:variable name="tests.section.name">
				<xsl:call-template name="getName">
					<xsl:with-param name="fixture" select="." />
				</xsl:call-template>
			</xsl:variable>	
			
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
						<xsl:apply-templates select="./results/test-suite" />
					</table>
		    </div>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="test-suite">
		<tr>
			<td class="label strong" colspan="2">
				<xsl:call-template name="underscore-replace"><xsl:with-param name="word" select="@name"/></xsl:call-template>
			</td>
		</tr>
		<xsl:apply-templates select="results/test-case" />
		
	</xsl:template>
  
	<xsl:template match="test-case">
		<xsl:apply-templates select="*" />
	</xsl:template>
	
  <xsl:template match="test-case">
		<tr>
			<td>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="@success = 'False'">data failed-underline</xsl:when>
						<xsl:otherwise>data</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:call-template name="setupTeardown-replace">
					<xsl:with-param name="word">
						<xsl:call-template name="underscore-replace">
							<xsl:with-param name="word">
								<xsl:value-of select="substring-after(substring-after(@name, ../../@name), '.')"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td class="data" width="60">
				<xsl:value-of select="format-number(@time, '0.000')"/> s
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>