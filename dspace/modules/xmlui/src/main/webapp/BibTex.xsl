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
    

    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" media-type="text/html; charset=UTF-8" />

    
    <xsl:strip-space elements="*" />

    <xsl:template match="@* | text()" />

	<!--<xsl:template match="/dri:document">
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
	</xsl:template> -->

   

   <xsl:template match="/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim" name="data">
	<xsl:variable name="type"><xsl:value-of select="dim:field[@element='type' and not(@qualifier)]"/></xsl:variable>
	<xsl:variable name="id"><xsl:value-of select="substring-after(//mets:METS/@ID, 'hdl:')" /></xsl:variable>
		<xsl:choose>
		    <!-- article, article_first, article_digi, conferencePaper_first -->
	 	    <xsl:when test="starts-with($type, 'article') or (contains($type, 'Paper'))">
		      <xsl:text>&#64;article&#123;</xsl:text><xsl:value-of select="concat('gledocs_', translate($id, '/', '_'))" />
		      <xsl:text>,</xsl:text>
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
				<xsl:text>&#64;incollection&#123;</xsl:text><xsl:value-of select="concat('gledocs_', translate($id, '/', '_'))" />
				<xsl:text>,</xsl:text>
				<xsl:call-template name="newline"/>
				<xsl:call-template name="authors" />
				<xsl:call-template name="editors" />
				<xsl:call-template name="title" />
				<xsl:call-template name="booktitle" />
				<xsl:call-template name="year"/>
	        </xsl:when>
	        <!-- anthology, anthology_first, anthology_digi -->
	        <xsl:when test="starts-with($type, 'anthology') or ($type='map_anth')">
				<xsl:choose>
					<xsl:when test="starts-with($type, 'map')">
						<xsl:text>&#64;misc&#123;</xsl:text><xsl:value-of select="concat('gledocs_', translate($id, '/', '_'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#64;book&#123;</xsl:text><xsl:value-of select="concat('gledocs_', translate($id, '/', '_'))" />
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:text>,</xsl:text>
				  <xsl:call-template name="newline"/>
				  <xsl:call-template name="editors" />
				  <xsl:call-template name="title" />
				  <xsl:call-template name="year"/>
				  
			</xsl:when>
			<!-- monograph, monograph_first, monograph_digi -->
			<xsl:when test="($type='monograph') or ($type='map_mono') or ($type='map_digi')">
				<xsl:choose>
					<xsl:when test="starts-with($type, 'map')">
						<xsl:text>&#64;misc&#123;</xsl:text><xsl:value-of select="concat('gledocs_', translate($id, '/', '_'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#64;book&#123;</xsl:text><xsl:value-of select="concat('gledocs_', translate($id, '/', '_'))" />
				</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
				  <xsl:call-template name="newline"/>
				  <xsl:call-template name="authors" />
				  <xsl:call-template name="title" />
				  <xsl:call-template name="year"/>
			</xsl:when>
			</xsl:choose> 
			<xsl:choose>
				<xsl:when test="contains($type, '_first')">
					<xsl:text>publisher = &#123;</xsl:text>FIG GEO-LEO e-docs<xsl:text>&#125;,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="publisher" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="newline"/>
			<xsl:call-template name="series" />
			<xsl:call-template name="abstract" />
			<!-- <xsl:call-template name="language" /> -->
			<!-- uri has to be the last data -->
			<xsl:call-template name="uri" />
			<xsl:text>&#125;</xsl:text>
			<xsl:call-template name="newline"/>
			<xsl:call-template name="newline"/>
	<!-- <xsl:copy-of select="dim:dim" /> -->

   </xsl:template>
       
    
    <xsl:template name="authors">
		<xsl:text>author = &#123;</xsl:text>
		<xsl:for-each select="//dim:field[@element='contributor'][@qualifier='author']">
			<xsl:value-of select="normalize-space(.)" />
			<xsl:if test="position() != last()">
				<xsl:text> and </xsl:text>
			</xsl:if>			         
		</xsl:for-each>
		<xsl:text>&#125;,</xsl:text>
		<xsl:call-template name="newline"/>
	</xsl:template>
	
	<xsl:template name="editors">
		<xsl:text>editor = &#123;</xsl:text>
		<xsl:for-each select="//dim:field[@element='contributor'][@qualifier='editor']">
			<xsl:value-of select="normalize-space(.)" />
			<xsl:if test="position() != last()">
				<xsl:text> and </xsl:text>
			</xsl:if>			         
		</xsl:for-each>
		<xsl:text>&#125;,</xsl:text>
		<xsl:call-template name="newline"/>
	</xsl:template>
    
    <xsl:template name="title">
      <xsl:text>title = &#123;</xsl:text><xsl:value-of select="normalize-space(dim:field[@element='title'])" /><xsl:text>&#125;,</xsl:text>
      <xsl:call-template name="newline"/>
    </xsl:template>

    <xsl:template name="booktitle">
      <xsl:text>booktitle = &#123;</xsl:text>
	  <xsl:for-each select="//dim:field[@element='relation'][@qualifier='ispartof']">
		<xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
	  <xsl:text>&#125;,</xsl:text>
	  <xsl:call-template name="newline"/>
    </xsl:template>

	<xsl:template name="series">
		<xsl:for-each select="//dim:field[@element='relation'][@qualifier='ispartofseries']"> 
			<xsl:text>series = &#123;</xsl:text>
				<xsl:value-of select="." />
			<xsl:text>&#125;,</xsl:text>
			<xsl:call-template name="newline"/>	
		</xsl:for-each>
	</xsl:template>

    <xsl:template name="journal">
		<xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='journal']"> 
			 <xsl:text>journal = &#123;</xsl:text>
				<xsl:value-of select="." />
			  <xsl:text>&#125;,</xsl:text>
			  <xsl:call-template name="newline"/>	
		</xsl:for-each>
    </xsl:template>

    <xsl:template name="year">
      <xsl:text>year = &#123;</xsl:text><xsl:value-of select="//dim:field[@element='date'][@qualifier='issued']" /><xsl:text>&#125;,</xsl:text>
      <xsl:call-template name="newline"/>
    </xsl:template>

    <xsl:template name="abstract">
		<xsl:if test="//dim:field[@element='description'][@qualifier='abstract']">
			<xsl:text>abstract = &#123;</xsl:text><xsl:value-of select="normalize-space(//dim:field[@element='description'][@qualifier='abstract'][1])" /><xsl:text>&#125;,</xsl:text>
			<xsl:call-template name="newline"/>	
		</xsl:if>
    </xsl:template>

	<xsl:template name="keywords">
		<xsl:if test="dim:field[@element='subject' and not(@qualifier)]">
			<xsl:text>keywords = &#123;</xsl:text><xsl:value-of select="dim:field[@element='subject']" /><xsl:text>&#125;,</xsl:text>
            <xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>
    
    <xsl:template name="doi">
		<xsl:if test="dim:field[@element='identifier'][@qualifier='doi']" >
			<xsl:text>doi = &#123;</xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='doi']" />
			<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

    <xsl:template name="language">
		<xsl:text>language = &#123;</xsl:text><xsl:value-of select="//dim:field[@element='language'][@qualifier='iso']" />
                <xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
    </xsl:template>

    <xsl:template name="volume">
		<xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='volume']" >
			<xsl:text>volume = &#123;</xsl:text><xsl:value-of select="." />
			<xsl:text>&#125;,</xsl:text>
			<xsl:call-template name="newline"/>	
		</xsl:for-each>
    </xsl:template>

   <xsl:template name="number">
		<xsl:for-each select="//dim:field[@element='bibliographicCitation'][@qualifier='issue']" >
			<xsl:text>number = &#123;</xsl:text><xsl:value-of select="." />
			<xsl:text>&#125;,</xsl:text>
			<xsl:call-template name="newline"/>	
		</xsl:for-each >
    </xsl:template>

   <xsl:template name="uri">
		<xsl:for-each select="//dim:field[@element='identifier'][@qualifier='uri']" >
			<xsl:text>note = &#123; &#92;url &#123;</xsl:text><xsl:value-of select="." />
			<xsl:text>&#125;&#125;,</xsl:text>
			<xsl:call-template name="newline"/>	
		</xsl:for-each >
    </xsl:template>

   <xsl:template name="isbn">
		<xsl:if test="dim:field[@element='identifier'][@qualifier='isbn']" >
		<xsl:text>isbn = &#123;</xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='isbn']" />
		<xsl:text>&#125;,</xsl:text>
		<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>


   <xsl:template name="pages">
		<xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" >
		<xsl:text>pages = &#123;</xsl:text><xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" />
			<xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" >
               			 <xsl:text>-</xsl:text>
                		<xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" />
			</xsl:if>
	      
  		<xsl:text>&#125;,</xsl:text>		
		<xsl:call-template name="newline"/>
		</xsl:if>

    </xsl:template>

   <xsl:template name="publisher">
		<xsl:for-each select="//dim:field[@element='publisher']" >
			<xsl:text>publisher = &#123;</xsl:text><xsl:value-of select="." /><xsl:text>&#125;,</xsl:text>
			<xsl:call-template name="newline"/>	
		</xsl:for-each>
    </xsl:template>


 
    <xsl:template name="newline">
<xsl:text>
</xsl:text>
    </xsl:template>

</xsl:stylesheet>
