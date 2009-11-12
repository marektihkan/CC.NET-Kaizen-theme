<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="BuilderLogSummary-NAnt.xsl" />

  <xsl:variable name="builderlog.section.targets.total" select="count($builderlog.root/target[duration &gt; 1000])" />
  <xsl:variable name="builderlog.section.warning.boundary" select="$builderlog.level div $builderlog.section.targets.total * 2" />
  
  
  <!-- Main template -->
  <xsl:template match="/">
    <script language="javascript">
      function openDialog(activator) {
        var messageScreen = $(activator).next('.dialog').dialog({
          autoOpen: false,
          modal: true,
          title: 'Messages',
          width: 700,
          height: 400,
          resizable: true
        });
        messageScreen.dialog('open');
      }
      $(document).ready(function() {
        $('.section-content .message-link').click(function() {
          openDialog(this);
        });
      });
    </script>
    
    
    <xsl:if test="$nant.isavailable">
      <xsl:call-template name="summary" />
      <xsl:call-template name="content" />
    </xsl:if>
  </xsl:template>

  <!-- Content template -->
  <xsl:template name="content">
    <xsl:apply-templates select="$builderlog.root/target" />
  </xsl:template>

  <xsl:template match="target">
    <xsl:variable name="builderlog.section.level" select="duration" />


    <xsl:variable name="builderlog.section.isfailed" select="false()" />
    <xsl:variable name="builderlog.section.iswarning" select="$builderlog.section.level &gt;= $builderlog.section.warning.boundary" />
    <xsl:variable name="builderlog.section.issuccess" select="not($builderlog.section.isfailed) and not($builderlog.section.iswarning)" />

    <xsl:variable name="builderlog.section.content.class">
      <xsl:call-template name="getSectionContentClass">
        <xsl:with-param name="isfailed" select="$builderlog.section.isfailed" />
        <xsl:with-param name="iswarning" select="$builderlog.section.iswarning" />
        <xsl:with-param name="issuccess" select="$builderlog.section.issuccess" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="builderlog.section.title.name" select="@name" />
    <xsl:variable name="builderlog.section.title.data">
      <xsl:call-template name="convertMillisecondsToDuration">
        <xsl:with-param name="convertable" select="duration" />
      </xsl:call-template>
    </xsl:variable>
    
    <div class="section">
      <xsl:call-template name="createTitle">
        <xsl:with-param name="isfailed" select="$builderlog.section.isfailed" />
        <xsl:with-param name="iswarning" select="$builderlog.section.iswarning" />
        <xsl:with-param name="issuccess" select="$builderlog.section.issuccess" />
        <xsl:with-param name="title" select="$builderlog.section.title.name" />
        <xsl:with-param name="data" select="$builderlog.section.title.data" />
      </xsl:call-template>
      
      <xsl:if test="count(task) &gt; 0">
        <div class="section-content">
          <xsl:attribute name="class">
            <xsl:value-of select="$builderlog.section.content.class"/>
          </xsl:attribute>
          
          <table>
            <thead>
              <tr>
                <th class="label strong even-columns-3">Task</th>
                <th class="label strong even-columns-3">Duration</th>
                <th class="label strong even-columns-3"></th>
              </tr>
            </thead>
            <tbody>
              <xsl:apply-templates select="task" />
            </tbody>  
          </table>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="task">
    <tr>
      <td class="data strong">
        <xsl:value-of select="@name" />
      </td>
      <td class="data">
        <xsl:call-template name="convertMillisecondsToDuration">
          <xsl:with-param name="convertable" select="duration" />
        </xsl:call-template>
      </td>
      <xsl:choose>
        <xsl:when test="count(message) &gt; 0">
          <td class="data strong">
            <a class="message-link">
              <span>
                Messages (<xsl:value-of select="count(message)" />)
              </span>
            </a>
            <div class="dialog">
              <xsl:for-each select="message">
                <p class="left">
                  <xsl:value-of select="node()"/>
                </p>
              </xsl:for-each>
            </div>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td></td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
  </xsl:template>

</xsl:stylesheet>