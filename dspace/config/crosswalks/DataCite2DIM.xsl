<?xml version="1.0"?>
<xsl:stylesheet
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                xmlns:ds="http://datacite.org/schema/kernel-3" 
		xmlns:ds2="http://datacite.org/schema/kernel-2.2"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"    
                version="1.0">
                
<xsl:output indent="yes" method="xml" />   

<xsl:template match="@* | text()" />              

<xsl:template match="/ds2:resource">
    <dim:dim>
        <xsl:apply-templates />
    </dim:dim>
</xsl:template>


<xsl:template match="/ds:resource"> 
    <dim:dim>  
        <xsl:apply-templates />
    </dim:dim>
</xsl:template>    
           
<xsl:template match="ds2:language">
    <dim:field element="language" qualifier="iso" mdschema="dc">
        <xsl:value-of select="." />
    </dim:field>
</xsl:template>

<xsl:template match="ds:language">
    <dim:field element="language" qualifier="iso" mdschema="dc">
        <xsl:value-of select="." />
    </dim:field>
</xsl:template>

<xsl:template match="ds2:titles/ds2:title">
        <dim:field element="title" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>


<xsl:template match="ds:titles/ds:title">
        <dim:field element="title" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<xsl:template match="ds2:titles/ds2:title[@titleType='Subtitle']">
        <dim:field element="title" qualifier="alternative" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<xsl:template match="ds:titles/ds:title[@titleType='Subtitle']">
        <dim:field element="title" qualifier="alternative" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>    
    
<xsl:template match="ds2:creators">
    <xsl:for-each select="ds2:creator/ds2:creatorName">
        <dim:field element="contributor" qualifier="author" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
    </xsl:for-each>
</xsl:template>

<xsl:template match="ds:creators">
    <xsl:for-each select="ds:creator/ds:creatorName">
        <dim:field element="contributor" qualifier="author" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
    </xsl:for-each>
</xsl:template>

<xsl:template match="ds2:publisher">
        <dim:field element="publisher" mdschema="dc">
            <xsl:value-of select="substring-before(., ',')" />
        </dim:field>
        <dim:field element="publishedIn" mdschema="dc">
            <xsl:value-of select="substring-after(., ', ')" />
        </dim:field>
</xsl:template>

<xsl:template match="ds:publisher">
        <dim:field element="publisher" mdschema="dc">
            <xsl:value-of select="substring-before(., ',')" />
        </dim:field>
	<dim:field element="publishedIn" mdschema="dc">
            <xsl:value-of select="substring-after(., ', ')" />
        </dim:field>
</xsl:template>

<xsl:template match="ds2:identifier[@identifierType='DOI']">
        <dim:field element="identifier" qualifier="doi" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<xsl:template match="ds:identifier[@identifierType='DOI']">
	<dim:field element="identifier" qualifier="doi" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<xsl:template match="ds2:identifier[@identifierType='issn']">
        <dim:field element="identifier" qualifier="issn" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<xsl:template match="ds:identifier[@identifierType='issn']">
        <dim:field element="identifier" qualifier="issn" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<xsl:template match="ds2:publicationYear">
    <dim:field element="date" qualifier="issued" mdschema="dc">
        <xsl:value-of select="." />
    </dim:field>
</xsl:template>

<xsl:template match="ds:publicationYear">
    <dim:field element="date" qualifier="issued" mdschema="dc">
        <xsl:value-of select="." />
    </dim:field>
</xsl:template>

<!--<xsl:template match="ds:subjects">
    <xsl:for-each select="ds:subject">
        <dim:field element="subject" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
    </xsl:for-each>
</xsl:template>-->

<xsl:template match="ds2:contributors">
    <xsl:for-each select="ds2:contributor[@contributorType='Editor']/ds2:contributorName">
        <dim:field element="contributor" qualifier="editor" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
    </xsl:for-each>
</xsl:template>

<xsl:template match="ds:contributors">
    <xsl:for-each select="ds:contributor[@contributorType='Editor']/ds:contributorName">
        <dim:field element="contributor" qualifier="editor" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
    </xsl:for-each>
</xsl:template>

<xsl:template match="ds2:relatedIdentifiers/ds2:relatedIdentifier[@relatedIdentifierType='ISSN'][@relationType='IsPartOf']">
        <dim:field element="relation" qualifier="issn" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<xsl:template match="ds:relatedIdentifiers/ds:relatedIdentifier[@relatedIdentifierType='ISSN'][@relationType='IsPartOf']">
        <dim:field element="relation" qualifier="issn" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>

<!--<xsl:template match="ds:relatedIdentifiers/ds:relatedIdentifier[@relatedIdentifierType='DOI'][@relationType='IsPartOf']">
        <dim:field element="relation" qualifier="doi" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
</xsl:template>-->

<xsl:template match="ds2:descriptions">
    <xsl:for-each select="ds2:description[@descriptionType='Abstract']">
        <dim:field element="description" qualifier="abstract" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
    </xsl:for-each>
<!--Funktioniert für ASJ-->
    <xsl:for-each select="ds2:description[@descriptionType='SeriesInformation']">
        <dim:field element="relation" qualifier="journal" mdschema="dc">
            <xsl:value-of select="substring-before(., ';')" />
        </dim:field>
        <dim:field element="relation" qualifier="volume" mdschema="dc">
            <xsl:value-of select="substring-before(., ',')" />
        </dim:field>
        <dim:field element="bibliographicCitation" qualifier="volume" mdschema="dc">
            <xsl:value-of select="substring-after(substring-before(., ','), 'Vol. ')" />
        </dim:field>
    </xsl:for-each>
</xsl:template>

<xsl:template match="ds:descriptions">
    <xsl:for-each select="ds:description[@descriptionType='Abstract']">
        <dim:field element="description" qualifier="abstract" mdschema="dc">
            <xsl:value-of select="." />
        </dim:field>
    </xsl:for-each>
<!--Funktioniert für ASJ-->
    <xsl:for-each select="ds:description[@descriptionType='SeriesInformation']">
        <dim:field element="relation" qualifier="journal" mdschema="dc">
            <xsl:value-of select="substring-before(., ';')" />
        </dim:field>
	<dim:field element="relation" qualifier="volume" mdschema="dc">
            <xsl:value-of select="substring-before(., ',')" />
        </dim:field>
	<dim:field element="bibliographicCitation" qualifier="volume" mdschema="dc">
            <xsl:value-of select="substring-after(substring-before(., ','), 'Vol. ')" />
        </dim:field>
    </xsl:for-each>
</xsl:template>



</xsl:stylesheet>



