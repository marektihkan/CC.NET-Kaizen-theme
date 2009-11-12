<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Design.xsl" />

  <!-- Tool specific variables -->
  <xsl:variable name="nant.root" select="/cruisecontrol/build/buildresults"/>
  <xsl:variable name="nant.isavailable" select="count($nant.root) &gt; 0" />

  <!-- Section variables -->
  <xsl:variable name="builderlog.root" select="$nant.root" />

  <xsl:variable name="builderlog.warning.boundary" select="420000" />
  <xsl:variable name="builderlog.error.boundary" select="600000" />
  <xsl:variable name="builderlog.level" select="$builderlog.root/duration" />

  <xsl:variable name="builderlog.isfailed" select="$builderlog.level &gt;= $builderlog.error.boundary or count($builderlog.root/failure) &gt; 0" />
  <xsl:variable name="builderlog.iswarning" select="$builderlog.level &gt;= $builderlog.warning.boundary and $builderlog.level &lt; $builderlog.error.boundary" />
  <xsl:variable name="builderlog.issuccess" select="not($builderlog.isfailed) and not($builderlog.iswarning)" />

  <xsl:variable name="builderlog.title.name" select="'Builder Log'" />
  <xsl:variable name="builderlog.title.data">
    <xsl:call-template name="convertMillisecondsToDuration">
      <xsl:with-param name="convertable" select="$builderlog.level" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Design variables -->
  <xsl:variable name="builderlog.content.class">
    <xsl:call-template name="getSectionContentClass">
      <xsl:with-param name="isfailed" select="$builderlog.isfailed" />
      <xsl:with-param name="iswarning" select="$builderlog.iswarning" />
      <xsl:with-param name="issuccess" select="$builderlog.issuccess" />
    </xsl:call-template>
  </xsl:variable>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:if test="$nant.isavailable">
      <xsl:call-template name="summary" />
    </xsl:if>
  </xsl:template>

  <!-- Summary template -->
  <xsl:template name="summary">
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$builderlog.isfailed" />
        <xsl:with-param name="iswarning" select="$builderlog.iswarning" />
        <xsl:with-param name="issuccess" select="$builderlog.issuccess" />
        <xsl:with-param name="title" select="$builderlog.title.name" />
        <xsl:with-param name="data" select="$builderlog.title.data" />
      </xsl:call-template>
      <div class="section-content">
        <xsl:attribute name="class">
          <xsl:value-of select="$builderlog.content.class"/>
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
          <th class="label strong even-columns-4">
            <span>Maximum target duration</span>
          </th>
          <td class="data strong even-columns-4 right">
            <span>
              <xsl:call-template name="convertMillisecondsToDuration">
                <xsl:with-param name="convertable">
                  <xsl:call-template name="maximumNumericValue">
                    <xsl:with-param name="values" select="$builderlog.root/target/duration" />
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </span>
          </td>
          <th class="label strong even-columns-4">
            <span>
              Targets total
            </span>
          </th>
          <td class="data even-columns-4 right">
            <span>
              <xsl:value-of select="count($builderlog.root/target)" />
            </span>
          </td>
        </tr>
        <tr>
          <th class="label strong even-columns-4">
            <span>
              Messages total
            </span>
          </th>
          <td class="data even-columns-4 right">
            <span>
              <xsl:value-of select="count($builderlog.root//message)" />
            </span>
          </td>
          <th class="label strong even-columns-4">
            <span>
              Tasks total
            </span>
          </th>
          <td class="data even-columns-4 right">
            <span>
              <xsl:value-of select="count($builderlog.root/target//task)" />
            </span>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="convertMillisecondsToDuration">
    <xsl:param name="convertable" />
    
    <xsl:variable name="hours" select="floor($convertable div 3600000)" />
    <xsl:variable name="minutes" select="floor(($convertable mod 3600000) div 60000)" />
    <xsl:variable name="seconds" select="($convertable mod 60000) div 1000" />
    <xsl:if test="$hours > 0">
      <xsl:value-of select="$hours" />:
    </xsl:if>
    <xsl:value-of select="format-number($minutes,'00')" />:<xsl:value-of select="format-number($seconds,'00.00')"/>
  </xsl:template>

  <xsl:template name="maximumNumericValue">
    <xsl:param name="values" />

    <xsl:for-each select="$values">
      <xsl:sort select="." data-type="number" order="descending"/>

      <xsl:if test="position() = 1">
        <xsl:value-of select="."/>
      </xsl:if>
    </xsl:for-each>    
  </xsl:template>
  
</xsl:stylesheet>