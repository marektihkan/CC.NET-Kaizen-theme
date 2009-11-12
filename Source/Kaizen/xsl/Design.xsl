<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="Util.xsl" />

	<xsl:template name="createTitle">
		<xsl:param name="isfailed" />
		<xsl:param name="iswarning" />
		<xsl:param name="issuccess" />
		<xsl:param name="title" />
		<xsl:param name="data" />
		
		<h1 class="title">
			<xsl:choose>
				<xsl:when test="$isfailed">
					<xsl:attribute name="class">title failed</xsl:attribute>
				</xsl:when>
				<xsl:when test="$iswarning">
					<xsl:attribute name="class">title warning</xsl:attribute>
				</xsl:when>
				<xsl:when test="$issuccess">
					<xsl:attribute name="class">title success</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<span class="title"><xsl:value-of select="$title"/></span>
			<span class="title-data"><xsl:value-of select="$data"/></span>
		</h1>
	</xsl:template>

	<xsl:template name="getSectionContentClass">
		<xsl:param name="isfailed" />
		<xsl:param name="iswarning" />
		<xsl:param name="issuccess" />

		<xsl:choose>
			<xsl:when test="$isfailed">
				<xsl:variable name="result">section-content failed-light</xsl:variable>
				<xsl:value-of select="$result" />
			</xsl:when>
			<xsl:when test="$iswarning">
				<xsl:variable name="result">section-content warning-light</xsl:variable>
				<xsl:value-of select="$result" />
			</xsl:when>
			<xsl:when test="$issuccess">
				<xsl:variable name="result">section-content success-light</xsl:variable>
				<xsl:value-of select="$result" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="result">section-content</xsl:variable>
				<xsl:value-of select="$result" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template name="drawBar">
    <xsl:param name="percent" />
    <xsl:param name="threshold" />
    <xsl:param name="scale" />

    <xsl:variable name="diagram.height" select="$scale * 10" />
    <xsl:variable name="diagram.red.upperbound" select="$threshold - 0.25 * $threshold" />

    <xsl:variable name="diagram.table.length" select="100 * $scale" />
    <xsl:variable name="diagram.bar.length">
      <xsl:choose>
        <xsl:when test="format-number($scale * $percent, 0) = 0">1</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="format-number($scale * $percent, 0)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <table>
      <xsl:attribute name="width">
        <xsl:value-of select="$diagram.table.length"/>
      </xsl:attribute>
      <tr>
        <td>
          <xsl:attribute name="height">
            <xsl:value-of select="$diagram.height"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$percent &lt;= $diagram.red.upperbound">
              <xsl:attribute name="class">failed-light</xsl:attribute>
            </xsl:when>
            <xsl:when test="$percent &lt; $threshold and $percent &gt; $diagram.red.upperbound">
              <xsl:attribute name="class">warning-light</xsl:attribute>
            </xsl:when>
            <xsl:when test="$percent &gt;= $threshold and $percent &gt; $diagram.red.upperbound">
              <xsl:attribute name="class">success-light</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:attribute name="width">
            <xsl:value-of select="$diagram.bar.length"/>
          </xsl:attribute>
        </td>
        <td>
          <xsl:attribute name="height">
            <xsl:value-of select="$diagram.height"/>
          </xsl:attribute>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>