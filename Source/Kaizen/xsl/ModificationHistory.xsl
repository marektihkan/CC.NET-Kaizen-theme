<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
	<xsl:output method="html"/>
	
	<xsl:include href="Design.xsl" />
	    
  <xsl:param name="applicationPath"/>
  <xsl:param name="onlyShowBuildsWithModifications"/>

  <xsl:template match="/">
	  <div class="section">
		  <xsl:call-template name="createTitle">
			  <xsl:with-param name="title">Modifications History</xsl:with-param>
		  </xsl:call-template>
	  </div>
  	        
	  <xsl:for-each select="//Build">
		  <xsl:sort select="@BuildDate" order="descending" data-type="text" />
			   <xsl:call-template name="ShowBuildRow" />
	  </xsl:for-each>
  </xsl:template>

  <xsl:template name="ShowBuildRow">

	  <xsl:if test="count(modifications/modification)>0 or ( (count(modifications/modification)=0 and $onlyShowBuildsWithModifications=false() ))">

		  <xsl:variable name="history.modifications.title" select="concat(@Label, ' (', @BuildDate, ')')" />
		  <xsl:variable name="history.modifications.count" select="count(modifications/modification)" />
		  <xsl:variable name="history.modifications.isfailed" select="not(@Success = 'True')" />
		  <xsl:variable name="history.modifications.issuccess" select="@Success = 'True'" />
  		
		  <xsl:variable name="history.modifications.section.content.class">
			  <xsl:call-template name="getSectionContentClass">
				  <xsl:with-param name="isfailed" select="$history.modifications.isfailed" />
				  <xsl:with-param name="iswarning" select="false" />
				  <xsl:with-param name="issuccess" select="$history.modifications.issuccess" />
			  </xsl:call-template>
		  </xsl:variable>
  		

		  <div class="section">
			  <xsl:call-template name="createTitle">
				  <xsl:with-param name="isfailed" select="$history.modifications.isfailed" />
				  <xsl:with-param name="iswarning" select="false" />
				  <xsl:with-param name="issuccess" select="$history.modifications.issuccess" />
				  <xsl:with-param name="title" select="$history.modifications.title" />
				  <xsl:with-param name="data" select="$history.modifications.count" />
			  </xsl:call-template>
  			
			  <xsl:if test="count(modifications/modification)>0">
				  <div class="section-content">
					  <xsl:attribute name="class">
						  <xsl:value-of select="$history.modifications.section.content.class"/>
					  </xsl:attribute>
  					
					  <table> 						
						  <tr>                                                        
							  <td class="label strong">Action</td>                                                                           
							  <td class="label strong">User</td>                                                                                   
							  <td class="label strong">Comment</td>
							  <td class="label strong">File</td>
						  </tr>
						  <xsl:for-each select="modifications/modification">
							  <tr>                                                        
								  <td class="data"><xsl:value-of select="@type"/></td>                                                                           
								  <td class="data strong"><xsl:value-of select="user"/></td>                                                                                   
								  <td class="data strong"><xsl:value-of select="comment"/></td>
								  <td class="data"><xsl:value-of select="project"/></td>
							  </tr>
						  </xsl:for-each>
					  </table>
				  </div>
			  </xsl:if>
		  </div>
	  </xsl:if>
  </xsl:template>
</xsl:stylesheet>