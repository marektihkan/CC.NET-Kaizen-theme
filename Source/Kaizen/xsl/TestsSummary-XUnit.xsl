<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html"/>

	<xsl:include href="Design.xsl" />
	
  <xsl:variable name="tests.result.list" select="//assembly"/>
  <xsl:variable name="tests.suite.list" select="$tests.result.list/class"/>
  <xsl:variable name="tests.case.list" select="$tests.suite.list/results/test-case"/>
  <xsl:variable name="tests.case.count" select="sum($tests.result.list/@total)"/>
  <xsl:variable name="tests.failure.list" select="$tests.suite.list/test[@result='Fail']"/>
  <xsl:variable name="tests.notrun.list" select="$tests.suite.list/test[@result='Skip']"/>
    
  <xsl:variable name="tests.time" select="sum($tests.result.list/@time)"/>
  <xsl:variable name="tests.notrun.count" select="sum($tests.result.list/@skipped)"/>
  <xsl:variable name="tests.run.count" select="$tests.case.count - $tests.notrun.count"/>
	<xsl:variable name="tests.failure.count" select="sum($tests.result.list/@failed)"/>
    
	<xsl:variable name="tests.isfailed" select="$tests.failure.count &gt; 0" />
	<xsl:variable name="tests.iswarning" select="$tests.notrun.count &gt; 0 or $tests.run.count = 0" />
	<xsl:variable name="tests.issuccess" select="$tests.failure.count = 0 and $tests.run.count &gt; 0" />
	
	
  <xsl:template match="/">
	  <xsl:if test="($tests.result.list)">
	    <xsl:call-template name="TestsSummary" />
		</xsl:if>
  </xsl:template>

	<xsl:template name="TestsSummary">
		<xsl:variable name="tests.title.data">
			<xsl:choose>
				<xsl:when test="$tests.isfailed">
					<xsl:value-of select="$tests.failure.count"/>
				</xsl:when>
				<xsl:when test="$tests.iswarning">
					<xsl:value-of select="$tests.notrun.count"/>
				</xsl:when>
				<xsl:when test="$tests.issuccess">
					<xsl:value-of select="$tests.run.count"/>
				</xsl:when>		
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tests.section.content.class">
			<xsl:call-template name="getSectionContentClass">
				<xsl:with-param name="isfailed" select="$tests.isfailed" />
				<xsl:with-param name="iswarning" select="$tests.iswarning" />
				<xsl:with-param name="issuccess" select="$tests.issuccess" />
			</xsl:call-template>
		</xsl:variable>
		
		<div class="section">
			<xsl:call-template name="createTitle">
				<xsl:with-param name="isfailed" select="$tests.isfailed" />
				<xsl:with-param name="iswarning" select="$tests.iswarning" />
				<xsl:with-param name="issuccess" select="$tests.issuccess" />
				<xsl:with-param name="title">Tests</xsl:with-param>
				<xsl:with-param name="data" select="$tests.title.data" />
			</xsl:call-template>
			
			<div class="section-content">
		        <xsl:attribute name="class">
					<xsl:value-of select="$tests.section.content.class"/>
				</xsl:attribute>
					
				<table>
					<tr>
            <td colspan="2">
							<table>
  					    <tr>
									<td class="label strong">Tests run</td>
									<td class="data strong"><xsl:value-of select="$tests.run.count"/></td>
						    </tr>
						    <tr>
									<td class="label strong">Failures</td>
									<td class="data strong"><xsl:value-of select="$tests.failure.count"/></td>
						    </tr>
						    <tr>
									<td>Not run</td>
									<td><xsl:value-of select="$tests.notrun.count"/></td>
								</tr>
								<tr>
									<td class="label strong">Time</td>
									<td class="data strong"><xsl:value-of select="format-number($tests.time, '0.000')"/> seconds</td>
								</tr>
							</table>
	          </td>
	        </tr>

					<xsl:if test="$tests.isfailed or $tests.iswarning">
						<tr>
							<td class="label strong">Log</td>
						</tr>
						<xsl:apply-templates select="$tests.failure.list"/>
						<xsl:apply-templates select="$tests.notrun.list"/>
					</xsl:if>

	        <tr><td></td></tr>

          <xsl:if test="$tests.isfailed">
            <tr>
              <td class="label strong">
                Failures and Errors (<xsl:value-of select="$tests.failure.count"/>)
              </td>
            </tr>
            <xsl:call-template name="xunit2testdetail">
              <xsl:with-param name="detailnodes" select="//assembly/class/test[.//failure]"/>
            </xsl:call-template>
            <tr><td></td></tr>
          </xsl:if>
	            
          <xsl:if test="$tests.iswarning">
            <tr>
              <td class="label strong">
                Warnings (<xsl:value-of select="$tests.notrun.count"/>)
              </td>
            </tr>
            <xsl:call-template name="xunit2testdetail">
              <xsl:with-param name="detailnodes" select="//assembly/class/test[.//reason]"/>
            </xsl:call-template>
            <tr><td></td></tr>
          </xsl:if>
        </table>
			</div>
		</div>
	</xsl:template>
	
  <xsl:template match="error">
    <tr>
      <td class="label strong">Error</td>
    </tr>
		<tr>
      <td class="data"><xsl:value-of select="../@name"/></td>
    </tr>
  </xsl:template>

  <xsl:template match="failure">
		<tr>
      <td class="label strong failed-underline failed-text">Failure</td>
    </tr>
		<tr>
      <td class="data failed-underline failed-text"><xsl:value-of select="../@name"/></td>
    </tr>
  </xsl:template>
    
  <xsl:template match="reason">
		<tr>
      <td class="label strong warning-text">Warning</td>
    </tr>
		<tr>
      <td class="data"><xsl:value-of select="../@name"/></td>
    </tr>
  </xsl:template>
  
  <xsl:template name="xunit2testdetail">
    <xsl:param name="detailnodes"/>
	
	<tr><td class="label strong">Test</td><td class="label strong">Type</td><td class="label strong">Message</td><td class="label strong">Time</td></tr>
    <xsl:for-each select="$detailnodes">
      <xsl:if test="failure">
			  <tr><td class="data failed-underline failed-text"><xsl:value-of select="@name"/></td>
			  <td class="data failed-underline failed-text">Failure</td>
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
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="br-replace">
    <xsl:param name="word"/>
    
    <xsl:variable name="cr">
      <xsl:text>
        <!-- </xsl:text> on next line on purpose to get newline -->
      </xsl:text>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="contains($word,$cr)">
        <xsl:value-of select="substring-before($word,$cr)"/>
        <br/>
        <xsl:call-template name="br-replace">
          <xsl:with-param name="word" select="substring-after($word,$cr)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$word"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>