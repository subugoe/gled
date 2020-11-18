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

    

	<!--<xsl:template match="/dri:document">
		<xsl:apply-templates />

	</xsl:template>
	
	<xsl:template match="dri:body" >
	   	
		<xsl:for-each select="//dri:reference[@type='DSpace Item']">
			<xsl:variable name="externalMetadataURL">
	            		<xsl:text>cocoon:/</xsl:text>
        	    		<xsl:value-of select="@url"/>
        		</xsl:variable>
			<xsl:apply-templates select="document($externalMetadataURL)" />
			
			
		</xsl:for-each>
	</xsl:template>
 -->
   

   <xsl:template match="/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim">
	<xsl:variable name="type"><xsl:value-of select="//dim:field[@element='type' and not(@qualifier)]"/></xsl:variable>
	<xsl:variable name="content_type"><xsl:value-of select="//dim:field[@element='description' and @qualifier='type']"/></xsl:variable>
	<xsl:variable name="id"><xsl:value-of select="substring-after(//mets:METS/@ID, 'hdl:')" /></xsl:variable>
		<xsl:choose>
		  
	 	    <!-- article, article_first, article_digi, conferencePaper_first -->
	 	    <xsl:when test="starts-with($type, 'article')">

	            <xsl:choose>
					<xsl:when test="$type='article'">
						<xsl:text>&#37;0 Journal article</xsl:text>
					</xsl:when> 					
					<xsl:otherwise>
						<xsl:text>&#37;0 Electronic article</xsl:text>
					</xsl:otherwise>
				</xsl:choose> 
				<xsl:call-template name="newline"/>  				
				<xsl:call-template name="authors" />
				<xsl:call-template name="title" />
				
				<xsl:call-template name="title_alternative" />
				<xsl:call-template name="doi" />
				<xsl:if test="not(contains($type, '_first'))">
					<xsl:call-template name="journal" />
					<xsl:call-template name="volume" />
					<xsl:call-template name="number" />
					<xsl:call-template name="pages" />
				</xsl:if>
				<xsl:call-template name="newline"/>
	        </xsl:when>
	        <!-- anthologyArticle, anthologyArticle_digi -->
		    <xsl:when test="($type='anthologyArticle')">

				<xsl:choose>
					<xsl:when test="$content_type='conference'">
						<xsl:text>&#37;0 Conference Paper</xsl:text>
					</xsl:when> 
					<xsl:otherwise>
						<xsl:text>&#37;0 Book Section</xsl:text>
					</xsl:otherwise>
				</xsl:choose>				
				<xsl:call-template name="newline"/>
				<xsl:call-template name="authors" />
				<xsl:call-template name="editors" />
				<xsl:call-template name="title" />
				<xsl:call-template name="title_alternative" />
				<xsl:call-template name="booktitle" />
				<xsl:call-template name="year"/>
				<xsl:call-template name="doi" />
	        </xsl:when>
	        <!-- anthology, anthology_first, anthology_digi, map_anth -->
	        <xsl:when test="starts-with($type, 'anthology') or ($type='map_anth')">
				<xsl:choose>
					<xsl:when test="$content_type='conference'">
						<xsl:text>&#37;0 Conference Proceedings</xsl:text>
					</xsl:when> 
					<xsl:when test="starts-with($type, 'map')">
						<xsl:text>&#37;0 Chart or Table</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#37;0 Electronic Book</xsl:text>
					</xsl:otherwise>
				</xsl:choose>					
				  <xsl:call-template name="newline"/>
				  <xsl:call-template name="editors" />
				  <xsl:call-template name="title" />
				  <xsl:call-template name="title_alternative" />
				  <xsl:call-template name="year"/>
					<xsl:call-template name="doi" />				  
			</xsl:when>
			<!-- monograph, monograph_first, monograph_digi, map_mono -->
			<xsl:when test="($type='monograph') or ($type='map_mono')">
				<xsl:choose>
					<xsl:when test="$content_type='thesis'">
						<xsl:text>&#37;0 Thesis</xsl:text>
						<xsl:call-template name="newline"/>
						<xsl:text>&#37;9 Dissertation</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($type, 'map')">
						<xsl:text>&#37;0 Chart or Table</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#37;0 Book</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				
				  <xsl:call-template name="newline"/>
				  <xsl:call-template name="authors" />
				  <xsl:call-template name="title" />
				  <xsl:call-template name="title_alternative" />
				  <xsl:call-template name="year"/>
				<xsl:call-template name="doi" />
			</xsl:when> 
		   
			</xsl:choose>
			<xsl:call-template name="publisher" />
			
			<!-- <xsl:call-template name="language"/> -->
			<xsl:call-template name="abstract"/>
			<xsl:call-template name="uri"/>
			<xsl:text>&#37;~  FID GEO-LEO e-docs</xsl:text>
			<xsl:call-template name="newline"/>
			<xsl:call-template name="newline"/>
	<!-- <xsl:copy-of select="dim:dim" /> -->

   </xsl:template>
       
    
    <xsl:template name="authors">
		<xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
				<xsl:text>&#37;A </xsl:text>
				<xsl:value-of select="." />	
				<xsl:call-template name="newline"/> 		       
			</xsl:for-each>			 
    </xsl:template>
    
    <xsl:template name="editors">
		<xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
				<xsl:text>&#37;E </xsl:text>
				<xsl:value-of select="." />	
				<xsl:call-template name="newline"/> 		       
			</xsl:for-each>			 
    </xsl:template>
    
    <xsl:template name="title">
      <xsl:text>&#37;T </xsl:text><xsl:value-of select="normalize-space(//dim:field[@element='title'])" />
      <xsl:call-template name="newline"/>
    </xsl:template>
    
    <xsl:template name="title_alternative">
		<xsl:for-each select="//dim:field[@element='title'][@qualifier='alternative']">
			  <xsl:text>&#37;O </xsl:text><xsl:value-of select="normalize-space(.)" />
			  <xsl:call-template name="newline"/>
      </xsl:for-each>
    </xsl:template>

    <xsl:template name="booktitle">
     <xsl:if test="//dim:field[@element='relation'][@qualifier='ispartof']">
      <xsl:text>&#37;B </xsl:text>
		<xsl:value-of select="//dim:field[@element='relation'][@qualifier='ispartof']" />
      <xsl:call-template name="newline"/>
     </xsl:if>
    </xsl:template>


    <xsl:template name="journal">
      <xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='journal']">
		  <xsl:text>&#37;J </xsl:text><xsl:value-of select="." />
		  <xsl:call-template name="newline"/>
       </xsl:for-each>
    </xsl:template>

    <xsl:template name="year">
      <xsl:text>&#37;D </xsl:text><xsl:value-of select="substring(dim:field[@element='date'][@qualifier='issued'], 1, 4)" />
	<xsl:call-template name="newline"/>	
    </xsl:template>

    <xsl:template name="abstract">
		<xsl:if test="//dim:field[@element='description'][@qualifier='abstract']">
		<xsl:text>&#37;X </xsl:text><xsl:value-of select="normalize-space(//dim:field[@element='description'][@qualifier='abstract'])" />
                <xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

    <xsl:template name="keywords">
		<xsl:if test="//dim:field[@element='subject' and not(@qualifier)]">
		<xsl:text>&#37;K </xsl:text><xsl:value-of select="normalize-space(dim:field[@element='subject'])" />
                <xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

    <xsl:template name="doi">
		<xsl:for-each select="//dim:field[@element='identifier'][@qualifier='doi']">
		<xsl:text>&#37;R </xsl:text><xsl:value-of select="." />
		<xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>

    <xsl:template name="language">
		<xsl:text>&#37;G </xsl:text><xsl:value-of select="//dim:field[@element='language'][@qualifier='iso']" />
                
                <xsl:call-template name="newline"/>
    </xsl:template>

    <xsl:template name="volume">
		<xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='volume']">
			<xsl:text>&#37;V </xsl:text><xsl:value-of select="." />
			<xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>

   <xsl:template name="number">
		<xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='issue']" >
		<xsl:text>&#37;N </xsl:text><xsl:value-of select="." />
		
		<xsl:call-template name="newline"/>
		</xsl:for-each>
    </xsl:template>
   <xsl:template name="isbn">
		<xsl:if test="//dim:field[@element='identifier'][@qualifier='isbn']" >
		<xsl:text>&#37;&#64; </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue']" />
		
		<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>


   <xsl:template name="pages">
		<xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='startpage']" >
		<xsl:text>&#37;P </xsl:text><xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='startpage']" />
		<xsl:text>-</xsl:text>
		</xsl:if>
	      
		<xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='endpage']" >
		<xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='endpage']" />
		
		<xsl:call-template name="newline"/>
		</xsl:if>

    </xsl:template>
    
    <xsl:template name="uri">
		<xsl:text>&#37;U </xsl:text><xsl:value-of select="//dim:field[@element='identifier'][@qualifier='uri']" />	
		<xsl:call-template name="newline"/>
    </xsl:template>

   <xsl:template name="publisher">
		<xsl:if test="//dim:field[@element='publisher']" >
		<xsl:text>&#37;I </xsl:text>
		<xsl:choose>
			<xsl:when test="contains(//dim:field[@element='publisher'], ',')">
				<xsl:value-of select="substring-before(//dim:field[@element='publisher'], ',')" />
				<xsl:text>&#37;C </xsl:text>
				<xsl:value-of select="normalize-space(substring-after(//dim:field[@element='publisher'], ','))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="//dim:field[@element='publisher']" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>


 
    <xsl:template name="newline">
<xsl:text>
</xsl:text>
    </xsl:template>

</xsl:stylesheet>

