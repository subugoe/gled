<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.1">

	<xsl:param name="purl"/>
	<xsl:param name="query"/>
	<xsl:variable name="baseURL">https://e-docs.geo-leo.de</xsl:variable>
    	<xsl:variable name="handlePrefix">11858</xsl:variable>


	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="resolvedLPIs">
		<resolvedLPIs>
			<LPI>
				<requestedLPI>
                                <xsl:value-of select="concat($baseURL, '/resolvexml?', $query)"/>
                                </requestedLPI>
                                <service>GEO-LEO e-docs</service>
                                <servicehome><xsl:value-of select="$baseURL"/></servicehome>

		<xsl:choose>
			<!-- resolve only requests which starts with 'gldocs-' -->

	          <xsl:when test="contains($query, 'gldocs-')">
                    <xsl:variable name="lpi"><xsl:value-of select="substring-after($query, 'gldocs-')" /></xsl:variable>
                    <xsl:variable name="externalMetadataURL">
                    <xsl:text>cocoon:///metadata/handle/</xsl:text>
                    <xsl:value-of select="$lpi"/>
                    <xsl:text>/mets.xml</xsl:text>
                    </xsl:variable>
                    <xsl:choose>
			<xsl:when test="document($externalMetadataURL)">
				<url>
		                    <xsl:value-of select="concat($baseURL, '/handle/', $lpi)" />
				</url>
				<mime>text/html</mime>
                        	<version>1.0</version>
	                        <access>free</access>
       			</xsl:when>
        		<xsl:otherwise>
                        	<URL />
	                    </xsl:otherwise>
                     </xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<URL />
			</xsl:otherwise>
		</xsl:choose>

		
                 <xsl:apply-templates select="@*|node()"/> 
                          </LPI>
		</resolvedLPIs>
        </xsl:template>


</xsl:stylesheet>
