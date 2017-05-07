<?xml version="1.0" encoding="UTF-8"?>

<!--
  BibTex.xsl

  Version: 1.0
 
  Date: 2017-05-05
 
-->


<xsl:stylesheet 
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim" 
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan" 
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:str="http://exslt.org/strings"
    xmlns:url="http://whatever/java/java.net.URLEncoder" 
    exclude-result-prefixes="xalan encoder i18n dri mets dim  xlink xsl str url">
    


    <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes" media-type="text/html; charset=UTF-8" />

    
	<xsl:strip-space elements="*" />
    <xsl:template match="@* | text()" />

    

	<xsl:template match="/dri:document">
		<xsl:apply-templates />

	</xsl:template>
	
	<xsl:template match="dri:body" >
	   	
		<xsl:for-each select="dri:div/dri:referenceSet/dri:reference[@type='DSpace Item']">
			<xsl:variable name="externalMetadataURL">
	            		<xsl:text>cocoon:/</xsl:text>
        	    		<xsl:value-of select="@url"/>
        		</xsl:variable>
			<xsl:apply-templates select="document($externalMetadataURL)" />
			
			
		</xsl:for-each>
	</xsl:template>

   

   <xsl:template match="/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim" name="data">
	<xsl:variable name="type"><xsl:value-of select="//dim:field[@element='type' and not(@qualifier)]"/></xsl:variable>
	<xsl:variable name="content_type"><xsl:value-of select="dim:field[@element='description' and @qualifier='type']"/></xsl:variable>
	<xsl:variable name="id"><xsl:value-of select="substring-after(//mets:METS/@ID, 'hdl:')" /></xsl:variable>

		<xsl:choose>
		  
	 	    <!-- article, article_first, article_digi, conferencePaper_first -->
	 	    <xsl:when test="starts-with($type, 'article') or contains($type, 'Paper') ">

				<!-- What is the TY for article not published in journal??? -->
				<xsl:choose>
					<xsl:when test="contains($type, 'Paper')">
						<xsl:text>TY - CPAPER</xsl:text>
					</xsl:when> 
					<xsl:otherwise>
						<xsl:text>TY - JOUR</xsl:text>
					</xsl:otherwise>
				</xsl:choose>	
			  <xsl:call-template name="newline"/>
			  <xsl:call-template name="authors" />
			  <xsl:call-template name="title" />
			  <xsl:call-template name="year"/>
			  <xsl:call-template name="volume" />
			  <xsl:call-template name="number" />
			  <xsl:call-template name="pages" />

			</xsl:when>
	        <!-- anthologyArticle, anthologyArticle_digi -->
		    <xsl:when test="($type='anthologyArticle') ">
				<xsl:text>TY - CHAP</xsl:text>
				
				<xsl:call-template name="newline"/>
				<xsl:call-template name="authors" />
				<xsl:call-template name="editors" />
				<xsl:call-template name="title" />
				<xsl:call-template name="booktitle" />
				<xsl:call-template name="year"/>
	        </xsl:when>
	        <xsl:when test="($type='anthologyArticle')">
				<xsl:choose>
					<xsl:when test="$content_type='conference'">
						<xsl:text>TY - CPAPER</xsl:text>
					</xsl:when> 
					<xsl:otherwise>
						<xsl:text>TY - CHAP</xsl:text>
					</xsl:otherwise>
				</xsl:choose>				
				<xsl:call-template name="newline"/>
				<xsl:call-template name="authors" />
				<xsl:call-template name="editors" />
				<xsl:call-template name="title" />
				<xsl:call-template name="booktitle" />
				<xsl:call-template name="year"/>
	        </xsl:when>
	        <!-- anthology, anthology_first, anthology_digi -->
	        <xsl:when test="($type='anthology') or ($type='map_anth')">
				<xsl:choose>
					<xsl:when test="$content_type='conference'">
						<xsl:text>TY - CONF</xsl:text>
					</xsl:when> 
					<xsl:when test="starts-with($type, 'map')">
						<xsl:text>TY - MAP</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>TY - BOOK</xsl:text>
					</xsl:otherwise>
				</xsl:choose>					
				
				  <xsl:call-template name="newline"/>
				  <xsl:call-template name="editors" />
				  <xsl:call-template name="title" />
				  <xsl:call-template name="year"/>
				  
			</xsl:when>
			<!-- monograph, monograph_first, monograph_digi -->
			<xsl:when test="($type='monograph') or ($type='map_mono')">
				<xsl:choose>
					<xsl:when test="$content_type='thesis'">
						<xsl:text>TY - THES</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($type, 'map')">
						<xsl:text>TY - MAP</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>TY - BOOK</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				
				
				  <xsl:call-template name="newline"/>
				  <xsl:call-template name="authors" />
				  <xsl:call-template name="title" />
				  <xsl:call-template name="year"/>
			</xsl:when>        
			</xsl:choose>
			
            <xsl:call-template name="publisher"/>   
                     
            <!-- <xsl:call-template name="language"/> -->
			<xsl:call-template name="abstract"/>
			<!-- <xsl:call-template name="keywords"/> -->
			<xsl:text>UR - </xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='uri']"/>
			<!-- <xsl:call-template name="language"/> -->
			<xsl:call-template name="newline"/>
			<xsl:text>ER -</xsl:text>
			<xsl:call-template name="newline"/>
			<xsl:call-template name="newline"/>
	<!-- <xsl:copy-of select="dim:dim" /> -->

   </xsl:template>
       


	<xsl:template name="authors">
		<xsl:for-each select="//dim:field[@element='contributor'][@qualifier='author']">
				<xsl:text>A1 - </xsl:text>
				<xsl:value-of select="." />
			      <xsl:call-template name="newline"/> 
			</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="editors">
		<xsl:for-each select="//dim:field[@element='contributor'][@qualifier='editor']">
				<xsl:text>ED - </xsl:text>
				<xsl:value-of select="." />
			      <xsl:call-template name="newline"/> 
			</xsl:for-each>
	</xsl:template>
    
    <xsl:template name="title">
      <xsl:text>T1 - </xsl:text><xsl:value-of select="normalize-space(//dim:field[@element='title'])" />
      <xsl:if test="//dim:field[@element='title'][@qualifier='alternative']">
		  <xsl:call-template name="newline"/>
		  <xsl:text>T1 - </xsl:text><xsl:value-of select="normalize-space(//dim:field[@element='title'][@qualifier='alternative'])" />
      </xsl:if>
      <xsl:call-template name="newline"/>
    </xsl:template>
    
    <xsl:template name="booktitle">
		<xsl:for-each select="//dim:field[@element='relation'][@qualifier='ispartof']">
		  <xsl:text>T2 - </xsl:text><xsl:value-of select="normalize-space(.)" />
		  <xsl:call-template name="newline"/>
      </xsl:for-each>
    </xsl:template>

    <xsl:template name="journal">
      <xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='journal']">
		  <xsl:text>JF - </xsl:text><xsl:value-of select="." />
		  <xsl:call-template name="newline"/>
       </xsl:for-each>
    </xsl:template>

    <xsl:template name="year">
      <xsl:text>Y1 - </xsl:text><xsl:value-of select="dim:field[@element='date'][@qualifier='issued']" />
		<xsl:call-template name="newline"/>	
    </xsl:template>

    <xsl:template name="abstract">
		<xsl:for-each select="//dim:field[@element='description'][@qualifier='abstract']">
		<xsl:text>N2 - </xsl:text><xsl:value-of select="normalize-space(.)" />
                <xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>

    <xsl:template name="keywords">
		<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		<!--<xsl:call-template name="tokenize">
			<xsl:with-param name="list"> -->
		<xsl:text>KW - </xsl:text>
				 <xsl:value-of select="dim:field[@element='subject' and not(@qualifier)]" /> 
		<!--	</xsl:with-param>
		</xsl:call-template> -->
                <xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>

    <xsl:template name="doi">
		<xsl:for-each select="dim:field[@element='identifier'][@qualifier='doi']" >
			<xsl:text>DO - </xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='doi']" />
			<xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>
<!--
    <xsl:template name="language">
		<xsl:text></xsl:text><xsl:value-of select="dim:field[@element='language'][@qualifier='iso']" />
                
                <xsl:call-template name="newline"/>
    </xsl:template>
-->
    <xsl:template name="volume">
		<xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='volume']" >
			<xsl:text>VL - </xsl:text><xsl:value-of select="." />			
			<xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>

   <xsl:template name="number">
		<xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='issue']" >
			<xsl:text>IS - </xsl:text><xsl:value-of select="." />		
			<xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>


   <xsl:template name="isbn">
		<xsl:if test="dim:field[@element='identifier'][@qualifier='isbn']" >
			<xsl:text>SN - </xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='isbn']" />			
			<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

   <xsl:template name="issn">
	
                <xsl:if test="dim:field[@element='relation'][@qualifier='eISSN']" >
					<xsl:text>SN - </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='eISSN']" />
					<xsl:call-template name="newline"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='relation'][@qualifier='pISSN']" >
					<xsl:text>SN - </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='pISSN']" />
					<xsl:call-template name="newline"/>
                </xsl:if>

		<xsl:if test="dim:field[@element='relation'][@qualifier='issn']" >
                <xsl:text>SN - </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='issn']" />
                <xsl:call-template name="newline"/>
                </xsl:if>
    </xsl:template>


   <xsl:template name="pages">
		<xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" >
			<xsl:text>SP - </xsl:text><xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" />
			<xsl:call-template name="newline"/>
		</xsl:if>
	      
		<xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" >
			<xsl:text>EP - </xsl:text>
			<xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" />	
			<xsl:call-template name="newline"/>
		</xsl:if>

    </xsl:template>

   <xsl:template name="publisher">
		<xsl:if test="//dim:field[@element='publisher']" >
			<xsl:text>PB - </xsl:text>
			<xsl:choose>
				<xsl:when test="contains(//dim:field[@element='publisher'], ',')">
					<xsl:value-of select="substring-before(//dim:field[@element='publisher'], ',')" />
					<xsl:call-template name="newline"/>
					<xsl:text>CY - </xsl:text><xsl:value-of select="normalize-space(substring-after(//dim:field[@element='publisher'], ','))" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//dim:field[@element='publisher']" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>
    
    <xsl:template name="uri">
			<xsl:text>UR - </xsl:text>
			<xsl:value-of select="//dim:field[@element='identifier'][@qualifier='uri']" />
			<xsl:call-template name="newline"/>
    </xsl:template>


 
    <xsl:template name="newline">
<xsl:text>
</xsl:text>
    </xsl:template>

  <xsl:template name="tokenize">
    <xsl:param name="list" />
    <xsl:variable name="newlist" select="concat(normalize-space($list), ';')" />
     <xsl:variable name="first" select="substring-before($newlist, ';')" />
     <xsl:variable name="remaining" select="substring-after($newlist, ';')" />
     <xsl:text>KW - </xsl:text><xsl:value-of select="$first" />
     <xsl:if test="$remaining">
         <xsl:call-template name="tokenize">
             <xsl:with-param name="list" select="$remaining" />
         </xsl:call-template>
     </xsl:if>
 </xsl:template>


</xsl:stylesheet>
