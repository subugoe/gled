<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    Rendering specific to the item display page.

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights confman">

    <xsl:output indent="yes"/>

    <xsl:template name="itemSummaryView-DIM">
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <xsl:copy-of select="$SFXLink" />

        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
        <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
            <div class="license-info table">
                <p>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text>
                </p>
                <ul class="list-unstyled">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']" mode="simple"/>
                </ul>
            </div>
        </xsl:if>


    </xsl:template>

    <!-- An item rendered in the detailView pattern, the "full item record" view of a DSpace item in Manakin. -->
    <xsl:template name="itemDetailView-DIM">
        <!-- Output all of the metadata about the item from the metadata section -->
        <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                             mode="itemDetailView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h3>
                <div class="file-list">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE' or @USE='CC-LICENSE']">
                        <xsl:with-param name="context" select="."/>
                        <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']" mode="itemDetailView-DIM" />
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <div class="item-summary-view-metadata">

<xsl:choose>
				<xsl:when test="dim:field[@element='type'] = 'article' or dim:field[@element='type'] = 'article_first' or dim:field[@element='type'] = 'article_digi'">
					<xsl:call-template name="itemSummaryView-DIM-title"/>
					<xsl:call-template name="itemSummaryView-DIM-authors"/>
					<xsl:if test="dim:field[@element='type'][@qualifier='version'] = 'publishedVersion'">
					 <xsl:if test="not(contains(dim:field[@element='relation'][@qualifier='volume'], 'Mitteilungen der Deutschen Geophysikalischen'))">
					<i18n:text>xmlui.dri2xhtml.METS-1.0.item-journal</i18n:text>
					<xsl:call-template name="itemSummaryView-DIM-journal"/><xsl:call-template name="itemSummaryView-DIM-date"/>					<xsl:call-template name="itemSummaryView-DIM-volume"/>
					<xsl:call-template name="itemSummaryView-DIM-issue"/>: <xsl:call-template name="itemSummaryView-DIM-pages"/>
					</xsl:if>
					</xsl:if>
					<xsl:if test="dim:field[@element='type'][@qualifier='version'] = 'submittedVersion'">
					<xsl:text>Preprint</xsl:text><br />
					<xsl:call-template name="itemSummaryView-DIM-date"/>
					</xsl:if>
				</xsl:when>
				<!--<xsl:when test="dim:field[@element='type'] = 'monograph">
					
				</xsl:when>
				<xsl:when test="dim:field[@element='type'] = 'article_first'">
					
				</xsl:when>
				<xsl:when test="dim:field[@element='type'] = 'anthology">
					
				</xsl:when>
				<xsl:when test="dim:field[@element='type'] = 'anthologyArticle'">
					
				</xsl:when>-->
				<xsl:otherwise>
					<xsl:call-template name="itemSummaryView-DIM-title"/>
					<xsl:call-template name="itemSummaryView-DIM-authors"/>
					<xsl:call-template name="itemSummaryView-DIM-date"/>
					<xsl:call-template name="itemSummaryView-DIM-publisher"/>
					<xsl:call-template name="itemSummaryView-DIM-type"/>
					<xsl:call-template name="itemSummaryView-DIM-coverage"/>
					<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
					<xsl:call-template name="itemSummaryView-DIM-language"/>
					<xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
					<xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>
				</xsl:otherwise>
			</xsl:choose>



		<!--<xsl:call-template name="itemSummaryView-DIM-URI"/>-->
		<xsl:call-template name="itemSummaryView-DIM-DOI"/>
<xsl:if test="contains(dim:field[@element='relation' and @qualifier='ispartof'], 'http')">
                <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartof']">
                       <xsl:text>In: </xsl:text>
<a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>


                </xsl:for-each>
        </xsl:if>
	
	<xsl:call-template name="itemSummaryView-DIM-isversionof"/>

	    <!--<xsl:call-template name="itemSummaryView-DIM-URI"/>-->
	    <xsl:call-template name="itemSummaryView-DIM-isbasedon"/>
	<xsl:call-template name="itemSummaryView-DIM-isreplacedby"/>

	<xsl:if test="dim:field[@element='type'] = 'article' or dim:field[@element='type'] = 'article_first' or dim:field[@element='type'] = 'article_digi'">
		 <xsl:call-template name="citationarticle"/>
	</xsl:if>
	
	<xsl:if test="dim:field[@element='type'] = 'monograph' or dim:field[@element='type'] = 'monograph_first' or dim:field[@element='type'] = 'monograph_digi'">
                 <xsl:call-template name="citationmono"/>
        </xsl:if>

	<xsl:if test="dim:field[@element='type'] = 'anthology' or dim:field[@element='type'] = 'anthology_first' or dim:field[@element='type'] = 'anthology_digi'">
                <xsl:if test="not(contains(dim:field[@element='relation'][@qualifier='volume'], 'Zeitschrift für Geophysik'))">
                        <xsl:call-template name="citationantho"/>
                </xsl:if>
                <xsl:if test="contains(dim:field[@element='relation'][@qualifier='volume'], 'Zeitschrift für Geophysik')">
                        <xsl:call-template name="citationanthogeophysik"/>
                </xsl:if>
        </xsl:if>	

	 <xsl:if test="dim:field[@element='type'] = 'anthologyArticle' or dim:field[@element='type'] = 'anthologyArticle_digi' or dim:field[@element='type'] = 'anthologyArticle_first'">
                 <xsl:call-template name="citationanthoart"/>
        </xsl:if>

	 <xsl:if test="dim:field[@element='type'] = 'conferencePaper' or dim:field[@element='type'] = 'conference_first'">
                 <xsl:call-template name="citationconf"/>
        </xsl:if>
		
	<xsl:if test="dim:field[@element='type'] = 'map_digi' or dim:field[@element='type'] = 'map_mono' or dim:field[@element='type'] = 'map_anthology'">
                 <xsl:call-template name="citationmap"/>
        </xsl:if>

 	    <xsl:if test="dim:field[@element='type'] = 'map_digi' or dim:field[@element='type'] = 'map_mono' or dim:field[@element='type'] = 'map_anthology'">
		<span class="spacer">&#160;</span>
		<div class="maplink"><a href="https://e-docs.geo-leo.de/map">Zur Übersichtskarte</a></div>
	    </xsl:if>

          <!--  <xsl:call-template name="itemSummaryView-DIM-doi"/>-->
	    <span class="spacer">&#160;</span>
	    <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
            <td><xsl:call-template name="itemSummaryView-DIM-file-section" />
            <!--<xsl:if test="$ds_item_view_toggle_url != ''">
               <xsl:call-template name="itemSummaryView-show-full"/>
	    </xsl:if>--></td></tr></table>
            <xsl:call-template name="itemSummaryView-DIM-abstract"/>
		<xsl:call-template name="itemSummaryView-statistics"/>
		<xsl:call-template name="itemSummaryView-collections"/>
	    <xsl:call-template name="itemSummaryView-subjects"/>
	    <xsl:call-template name="display-rights"/>          

	<!--SocialMedia-Buttons-->      
        <!--<div id="socialmedia">
                        <xsl:text>Share on: </xsl:text>
                        <ul class="share-buttons">
				<li><a>
                                        <xsl:attribute name="href"><xsl:value-of select="concat('http://twitter.com/intent/tweet?text=', //dim:field[@element='title' and not(@qualifier)], '&amp;url=', //dim:field[@element='identifier' and @qualifier='uri']) "/></xsl:attribute>
                                <img src="{concat($theme-path,'images/twitter-16.png')}" title="Twitter"> </img>
                                </a></li>
                                <li><a>
                                        <xsl:attribute name="href"><xsl:value-of select="concat('http://www.mendeley.com/import/?url=', //dim:field[@element='identifier'][@qualifier='uri']) "/></xsl:attribute>
                                <img src="{concat($theme-path,'images/mendeley-16.png')}" title="Mendeley"> </img>
                                </a></li>
                                <li><a>
                                        <xsl:attribute name="href"><xsl:value-of select="concat('http://www.linkedin.com/shareArticle?url=', //dim:field[@element='identifier'][@qualifier='uri'], '&amp;title=', //dim:field[@element='title' and not(@qualifier)]) "/></xsl:attribute>
                                <img src="{concat($theme-path,'images/linkedin-16.png')}" title="LinkedIn"> </img>
                                </a></li>
                                <li><a>
                                        <xsl:attribute name="href"><xsl:value-of select="concat('http://www.bibsonomy.org/ShowBookmarkEntry?&amp;c=b&amp;jump=yes&amp;url=', //dim:field[@element='identifier'][@qualifier='uri'], '&amp;description=', //dim:field[@element='title' and not(@qualifier)]) "/></xsl:attribute>
                                <img src="{concat($theme-path,'images/bibsonomy-16.png')}" title="Bibsonomy"> </img>
                                </a></li>

                        </ul>
                </div>-->

    </div>
    </xsl:template>

<xsl:template name="citationmap">
        <xsl:variable name="authors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
        </xsl:if>
    </xsl:variable>

        <xsl:variable name="dateissued">
                <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
                <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='issued']/node(), 1,4)"/>
                </xsl:if>
    </xsl:variable>
        <xsl:variable name="citation">
                             <xsl:if test="dim:field[@element='relation'][@qualifier='volume']">
                            <xsl:copy-of select="dim:field[@element='relation'][@qualifier='volume'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
							<xsl:if test="dim:field[@element='publisher'][not(@qualifier)]">
                            <xsl:copy-of select="dim:field[@element='publisher'][not(@qualifier)][1]/node()"/><xsl:text>, </xsl:text>
                                </xsl:if>	
          </xsl:variable>
	<xsl:variable name="identifier">
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='identifier'][@qualifier='doi']">
				<xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                                  <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                                  <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                                  <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                                  <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
			      
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DOI: </xsl:text><xsl:if test="dim:field[@element='identifier'][@qualifier='uri']">
                                <xsl:choose>
                                <xsl:when test="contains(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi')">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][2]/node(), 'doi.org'))"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                        </xsl:choose>
    </xsl:variable>

        <div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, ', ', $dateissued, ': ', $citation, $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
</xsl:template>


<xsl:template name="citationconf">
        <xsl:variable name="authors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
        </xsl:if>
    </xsl:variable>

        <xsl:variable name="dateissued">
                <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
                <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='issued']/node(), 1,4)"/>
                </xsl:if>
    </xsl:variable>
                <xsl:variable name="title">
                <xsl:if test="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:copy-of select="dim:field[@element='title'][not(@qualifier)]/node()"/>
                                </xsl:if>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                            <xsl:text> - </xsl:text><xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']/node()"/>
                                </xsl:if>
    </xsl:variable>
        <xsl:variable name="citation">
                             <xsl:if test="dim:field[@element='identifier'][@qualifier='citation']">
                            <xsl:text>In: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='citation'][1]/node()"/><xsl:text>, </xsl:text>
                                </xsl:if>
          </xsl:variable>
	<xsl:variable name="identifier">
                        <xsl:choose>
			<xsl:when test="dim:field[@element='identifier'][@qualifier='doi']">
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DOI: </xsl:text><xsl:if test="dim:field[@element='identifier'][@qualifier='uri']">
                                <xsl:choose>
                                <xsl:when test="contains(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi')">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][2]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                        </xsl:choose>
    </xsl:variable>

        <div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, ', ', $dateissued, ': ', $title, '. ', $citation, $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
</xsl:template>


<xsl:template name="citationanthoart">
        <xsl:variable name="authors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
        </xsl:if>
    </xsl:variable>

        <xsl:variable name="dateissued">
                <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
                <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='issued']/node(), 1,4)"/>
                </xsl:if>
    </xsl:variable>
                <xsl:variable name="title">
                <xsl:if test="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:copy-of select="dim:field[@element='title'][not(@qualifier)]/node()"/>
                                </xsl:if>
				<xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                            <xsl:text> - </xsl:text><xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']/node()"/>
                                </xsl:if>
    </xsl:variable>
        <xsl:variable name="citation">
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='identifier'][@qualifier='citation']">
                            <xsl:text>In: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='citation'][1]/node()"/><xsl:text>, </xsl:text>
                                </xsl:when>
                            <xsl:otherwise>
                            <xsl:if test="dim:field[@element='relation'][@qualifier='ispartof']"><xsl:text>In: </xsl:text><xsl:copy-of select="dim:field[@element='relation'][@qualifier='ispartof'][1]/node()"/></xsl:if>
			
                                </xsl:otherwise>
                        </xsl:choose>
	 <xsl:if test="contains(dim:field[@element='relation'][@qualifier='ispartofseries'], ';')"><xsl:copy-of select="substring-before(dim:field[@element='relation'][@qualifier='ispartofseries'][1]/node(), ';')"/><xsl:text>, </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='relation'][@qualifier='ispartofseries'][1]/node(), ';')"/><xsl:text>, </xsl:text></xsl:if>
<xsl:if test="not(contains(dim:field[@element='relation'][@qualifier='ispartofseries'], ';'))"><xsl:copy-of select="dim:field[@element='relationi'][@qualifier='ispartofseries']/node()"/><xsl:text>, </xsl:text></xsl:if>
    </xsl:variable>
	<xsl:variable name="identifier">
                        <xsl:choose>
			<xsl:when test="dim:field[@element='identifier'][@qualifier='doi']">
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DOI: </xsl:text><xsl:if test="dim:field[@element='identifier'][@qualifier='uri']">
                                <xsl:choose>
                                <xsl:when test="contains(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi')">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][2]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                        </xsl:choose>
    </xsl:variable>

        <div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, ', ', $dateissued, ': ', $title, '. ', $citation, $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
</xsl:template>


<xsl:template name="citationantho">
        <xsl:variable name="authors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
        </xsl:if>
    </xsl:variable>
		<xsl:variable name="editors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='editor']">
							<xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='editor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
			<xsl:text> (Ed.)</xsl:text>
        </xsl:if>
    </xsl:variable>
        <xsl:variable name="dateissued">
                <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
                <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='issued']/node(), 1,4)"/>
                </xsl:if>
    </xsl:variable>
                <xsl:variable name="title">
                <xsl:if test="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:copy-of select="dim:field[@element='title'][not(@qualifier)]/node()"/>
                                </xsl:if>
				<xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                            <xsl:text> - </xsl:text><xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']/node()"/>
                                </xsl:if>
    </xsl:variable>
        <xsl:variable name="citation">
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='relation'][@qualifier='volume']">
                            <xsl:copy-of select="dim:field[@element='relation'][@qualifier='volume'][1]/node()"/><xsl:text>, </xsl:text>
                                </xsl:when>
                            <xsl:otherwise>
				<xsl:if test="dim:field[@element='relation'][@qualifier='ispartofseries']"><xsl:copy-of select="substring-before(dim:field[@element='relation'][@qualifier='ispartofseries'][1]/node(), ';')"/><xsl:text>, </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='relation'][@qualifier='ispartofseries'][1]/node(), ';')"/><xsl:text>, </xsl:text></xsl:if>
                                </xsl:otherwise>
                        </xsl:choose>
			<xsl:if test="dim:field[@element='format'][@qualifier='extent']">
                                <xsl:copy-of select="dim:field[@element='format'][@qualifier='extent'][1]/node()"/>
				<xsl:if test="contains(dim:field[@element='format'][@qualifier='extent'], 'S')">
				<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:if test="not(contains(dim:field[@element='format'][@qualifier='extent'], 'S'))">
                                <xsl:text> S., </xsl:text>
                                </xsl:if>
                        </xsl:if>
    </xsl:variable>
	<xsl:variable name="identifier">
                        <xsl:choose>
			<xsl:when test="dim:field[@element='identifier'][@qualifier='doi']">
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DOI: </xsl:text><xsl:if test="dim:field[@element='identifier'][@qualifier='uri']">
                                <xsl:choose>
                                <xsl:when test="contains(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi')">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][2]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                        </xsl:choose>
    </xsl:variable>

	<xsl:choose>
		<xsl:when test="contains(dim:field[@element='title'][not(@qualifier)], 'GMIT')">
	<div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, $editors, ', ', $dateissued, ': ', $citation, $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
		</xsl:when>
		<xsl:otherwise>
        <div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, $editors, ', ', $dateissued, ': ', $title, '. ', $citation, $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

		<xsl:template name="citationanthogeophysik">
        <xsl:variable name="authors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
        </xsl:if>
    </xsl:variable>
                <xsl:variable name="editors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='editor']">
                                                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='editor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        <xsl:text> (Ed.)</xsl:text>
        </xsl:if>
    </xsl:variable>
        <xsl:variable name="dateissued">
                <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
                <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='issued']/node(), 1,4)"/>
                </xsl:if>
    </xsl:variable>
                <xsl:variable name="title">
                <xsl:if test="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:copy-of select="dim:field[@element='title'][not(@qualifier)]/node()"/>
                                </xsl:if>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                            <xsl:text> - </xsl:text><xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']/node()"/>
                                </xsl:if>
    </xsl:variable>

	<xsl:variable name="identifier">
                        <xsl:choose>
			<xsl:when test="dim:field[@element='identifier'][@qualifier='doi']">
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DOI: </xsl:text><xsl:if test="dim:field[@element='identifier'][@qualifier='uri']">
                                <xsl:choose>
                                <xsl:when test="contains(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi')">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][2]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                        </xsl:choose>
    </xsl:variable>

        <div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, $editors, ', ', $dateissued, ': ', $title, '. ', $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
</xsl:template>

 <xsl:template name="citationarticle">
        <xsl:variable name="authors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
        </xsl:if>
    </xsl:variable>
	<xsl:variable name="dateissued">
                <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
		<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='issued']/node(), 1,4)"/>
		</xsl:if>
    </xsl:variable>
		<xsl:variable name="title">
                <xsl:if test="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:copy-of select="dim:field[@element='title'][not(@qualifier)]/node()"/>
				</xsl:if>
		<xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                            <xsl:text> - </xsl:text><xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']/node()"/>
                                </xsl:if>
    </xsl:variable>
	<xsl:variable name="citation">
			<xsl:choose>
			    <xsl:when test="dim:field[@element='identifier'][@qualifier='citation']">
                            <xsl:text>In: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='citation'][1]/node()"/>
				</xsl:when>
			    <xsl:when test="dim:field[@element='bibliographicCitation'][@qualifier='journal']">
                            <xsl:text>In: </xsl:text><xsl:copy-of select="dim:field[@element='bibliographicCitation'][@qualifier='journal'][1]/node()"/>
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
					<xsl:text>, Band </xsl:text><xsl:copy-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume'][1]/node()"/>
				</xsl:if>
				 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue']">
                                        <xsl:text>, </xsl:text><xsl:copy-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue'][1]/node()"/>
                                </xsl:if>
				</xsl:when>
				<xsl:otherwise><xsl:if test="dim:field[@element='relation'][@qualifier='volume']">
                            <xsl:text>In: </xsl:text><xsl:copy-of select="substring-before(dim:field[@element='relation'][@qualifier='volume'][1]/node(), ';')"/><xsl:text>, </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='relation'][@qualifier='volume'][1]/node(), ';')"/></xsl:if>
                                </xsl:otherwise>
			</xsl:choose>	
    </xsl:variable>
	<xsl:variable name="identifier">
                        <xsl:choose>
				<xsl:when test="dim:field[@element='identifier'][@qualifier='doi']">
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                                  <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                                  <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DOI: </xsl:text><xsl:if test="dim:field[@element='identifier'][@qualifier='uri']">
                                <xsl:choose>
                                <xsl:when test="contains(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi')">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][2]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                        </xsl:choose>
    </xsl:variable>

		 <xsl:variable name="pages">
                            <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                            <xsl:text>: </xsl:text><xsl:copy-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage'][1]/node()"/>
                                </xsl:if>
                            <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                            <xsl:text> - </xsl:text><xsl:copy-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage'][1]/node()"/>
				<xsl:text>, </xsl:text>
                                </xsl:if>
    </xsl:variable>

	<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage'] and not(dim:field[@element='identifier'][@qualifier='citation'])">
        <div class="citation">
		<span id="citation"><xsl:value-of select="concat($authors, ', ', $dateissued, ': ', $title, '. ', $citation, $pages, $identifier)"/></span>
		<xsl:text> </xsl:text>
		<a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
	</xsl:if>
	<xsl:if test="not(dim:field[@element='bibliographicCitation'][@qualifier='firstPage']) or dim:field[@element='identifier'][@qualifier='citation']">
	<div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, ', ', $dateissued, ': ', $title, '. ', $citation, ', ', $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
	</xsl:if>

</xsl:template>

<xsl:template name="citationmono">
        <xsl:variable name="authors">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author'] and not(contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus'))">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
			<xsl:text>, </xsl:text>
        </xsl:if>
	<xsl:if test="dim:field[@element='contributor'][@qualifier='author'] and contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus')">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:text>Unbekannter Autor</xsl:text>
                                </span>
                            </xsl:for-each>
				<xsl:text>, </xsl:text>
        </xsl:if>
      <xsl:if test="dim:field[@element='contributor'][@qualifier='editor'] and contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus')">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='editor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
				<xsl:text> (Hrsg.), </xsl:text>
        </xsl:if>      
	 <xsl:if test="dim:field[@element='contributor'][@qualifier='other'] and contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus')">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='other']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='other']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                                <xsl:text> (Mitw.), </xsl:text>
        </xsl:if>
    </xsl:variable>
        <xsl:variable name="dateissued">
                <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
                <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='issued']/node(), 1,4)"/>
                </xsl:if>
    </xsl:variable>
   <xsl:variable name="datecreated">
                <xsl:if test="dim:field[@element='date'][@qualifier='created']">
                <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='created']/node(), 1,4)"/>
                </xsl:if>
    </xsl:variable>
                <xsl:variable name="title">
                <xsl:if test="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:copy-of select="dim:field[@element='title'][not(@qualifier)]/node()"/>
                                </xsl:if>
		<xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                            <xsl:text> - </xsl:text><xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']/node()"/>
                                </xsl:if>
    </xsl:variable>
        <xsl:variable name="citation">
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='relation'][@qualifier='volume']">
                            <xsl:copy-of select="dim:field[@element='relation'][@qualifier='volume'][1]/node()"/><xsl:text>, </xsl:text>
                                </xsl:when>
				<xsl:when test="dim:field[@element='relation'][@qualifier='ispartofseries']"><xsl:copy-of select="substring-before(dim:field[@element='relation'][@qualifier='ispartofseries'][1]/node(), ';')"/><xsl:text>, </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='relation'][@qualifier='ispartofseries'][1]/node(), ';')"/><xsl:text>, </xsl:text></xsl:when>
                            <xsl:otherwise>
                            <xsl:if test="dim:field[@element='publisher'][not(@qualifier)]"><xsl:copy-of select="dim:field[@element='publisher'][not(@qualifier)][1]/node()"/><xsl:text>, </xsl:text></xsl:if>
                                </xsl:otherwise>

                        </xsl:choose>
			<xsl:if test="dim:field[@element='format'][@qualifier='extent']">
                                <xsl:copy-of select="dim:field[@element='format'][@qualifier='extent'][1]/node()"/>
                                <xsl:if test="contains(dim:field[@element='format'][@qualifier='extent'], 'S')">
                                <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:if test="not(contains(dim:field[@element='format'][@qualifier='extent'], 'S'))">
                                <xsl:text> S., </xsl:text>
                                </xsl:if>
                        </xsl:if>

    </xsl:variable>
	<xsl:variable name="identifier">
                        <xsl:choose>
			<xsl:when test="dim:field[@element='identifier'][@qualifier='doi']">
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                            <xsl:text>DOI: </xsl:text><xsl:copy-of select="substring-after(dim:field[@element='identifier'][@qualifier='doi'][1]/node(), 'doi.org/')"/><xsl:text>. </xsl:text>
                                </xsl:if>
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DOI: </xsl:text><xsl:if test="dim:field[@element='identifier'][@qualifier='uri']">
                                <xsl:choose>
                                <xsl:when test="contains(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi')">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][1]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(dim:field[@element='identifier'][@qualifier='uri'][2]/node(), 'doi.org/'))"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                        </xsl:choose>
    </xsl:variable>
<xsl:if test="not(contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus'))">
        <div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, $dateissued, ': ', $title, '. ', $citation, $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
</xsl:if>
<xsl:if test="contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus')">
        <div class="citation">
                <span id="citation"><xsl:value-of select="concat($authors, $datecreated, ': ', $title, '. ', $citation, $identifier)"/></span>
                <xsl:text> </xsl:text>
                <a href="#" onclick="copyToClipboard('#citation')" title="Copy to Clipboard"><i class="fa fa-clipboard"></i></a>
        </div>
</xsl:if>
</xsl:template>


    <xsl:template name="itemSummaryView-DIM-isversionof">
	<div>        
		<xsl:if test="dim:field[@element='relation'][@qualifier='isversionof']">
                <xsl:for-each select="dim:field[@element='relation'][@qualifier='isversionof']">
                   <i18n:text>xmlui.dri2xhtml.METS-1.0.item-isversionof</i18n:text>   
		   <a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                   </a>
                </xsl:for-each>
        </xsl:if>
	</div>	
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-title">
        <xsl:choose>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                <h2 class="page-header first-page-header">
                    <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                </h2>
                <div class="simple-item-view-other">
                    <p class="lead">
                        <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:if test="not(position() = 1)">
                                <xsl:value-of select="./node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                    <xsl:text>; </xsl:text>
                                    <br/>
                                </xsl:if>
                            </xsl:if>

                        </xsl:for-each>
                    </p>
                </div>
            </xsl:when>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                <h2 class="page-header first-page-header">
                    <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                </h2>
		<xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
			<p class="subtitle"><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></p>
		</xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <h2 class="page-header first-page-header">
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-thumbnail">
        <div class="thumbnail">
            <xsl:choose>
                <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                    <xsl:variable name="src">
                        <xsl:choose>
                            <xsl:when test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]">
                                <xsl:value-of
                                        select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                        select="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>


<!--                    <img alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$src"/>
                        </xsl:attribute>
                    </img> -->

                        <img alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$src"/>
                        </xsl:attribute>
                    </img>

                </xsl:when>
                <xsl:otherwise>
                    <img alt="Thumbnail">
                        <xsl:attribute name="data-src">
                            <xsl:text>holder.js/100%x</xsl:text>
                            <xsl:value-of select="$thumbnail.maxheight"/>
                            <xsl:text>/text:No Thumbnail</xsl:text>
                        </xsl:attribute>
                    </img>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

<!--   <xsl:template name="itemSummaryView-DIM-toc">
        <xsl:if test="dim:field[@element='description' and @qualifier='tableofcontents']">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-toc</i18n:text></h5>
                <div style="margin-bottom: 1.5em;">
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='tableofcontents']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                        <xsl:value-of select="node()" disable-output-escaping="yes"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='tableofcontents']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                    </xsl:for-each>
	                  <xsl:if test="count(dim:field[@element='description' and @qualifier='tableofcontents']) &gt; 1">
                        <div class="spacer">&#160;</div>
                    </xsl:if>
                </div>
            </div>
        </xsl:if>
    </xsl:template>-->



<!--    <xsl:template name="itemSummaryView-DIM-abstract">
        <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h5>
                <div style="margin-bottom: 1.5em;">
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                        <xsl:value-of select="node()" disable-output-escaping="yes"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                        <div class="spacer">&#160;</div>
                    </xsl:if>
                </div>
            </div>
        </xsl:if>
    </xsl:template>-->

<xsl:template name="itemSummaryView-DIM-abstract">
 <ul class="nav nav-tabs" id="myTab" style="margin-bottom: 0px;">
            <xsl:if test="//dim:field[@element='description'][@qualifier='abstract']">
                <li class="active"><a data-target="#abstract" data-toggle="tab" style="cursor: pointer;font-weight:bold;font-size:small;"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></a></li>
            </xsl:if>
            <xsl:if test="//dim:field[@element='description'][@qualifier='tableofcontents']">
                <li>
                    <xsl:if test="not(//dim:field[@element='description'][@qualifier='abstract'])"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
                    <a data-target="#toc" data-toggle="tab" style="cursor: pointer;font-weight:bold;font-size:small;"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-toc</i18n:text></a>
                </li>
            </xsl:if>
        </ul>
        
		<div class="tab-content" style="border-bottom: 1px solid #ddd;margin-bottom: 20px;border-right: 1px solid #ddd;border-left: 1px solid #ddd;padding: 20px;">
            <div id="abstract">
                <xsl:attribute name="class"><xsl:text>tab-pane </xsl:text>
					<xsl:if test="//dim:field[@element='description'][@qualifier='abstract']"><xsl:text> active</xsl:text></xsl:if>
                </xsl:attribute>
                <xsl:for-each select="//dim:field[@element='description'][@qualifier='abstract']">
                    <xsl:choose>
                            <xsl:when test="node()">
                                      <xsl:value-of select="node()" disable-output-escaping="yes"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                </xsl:for-each>

            </div>
            <div id="toc">
                <xsl:attribute name="class"><xsl:text>tab-pane</xsl:text>
                    <xsl:if test="//dim:field[@element='description'][@qualifier='tableofcontents'] and not(//dim:field[@element='description'][@qualifier='abstract'])"><xsl:text> active</xsl:text></xsl:if>
                </xsl:attribute>
                 <xsl:for-each select="dim:field[@element='description' and @qualifier='tableofcontents']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                          <xsl:value-of select="node()" disable-output-escaping="yes"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='tableofcontents']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                    </xsl:for-each>
			</div>
			</div>
  </xsl:template>

    <xsl:template name="itemSummaryView-DIM-authors">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='author'] and not(contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus'))">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or dim:field[@element='contributor' and descendant::text()]">
            <div class="simple-item-view-authors item-page-field-wrapper table">
                <!--<h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text></h5>-->
                <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                            <div><xsl:call-template name="itemSummaryView-DIM-authors-entry" /></div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <div><xsl:call-template name="itemSummaryView-DIM-authors-entry" /></div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <div><xsl:call-template name="itemSummaryView-DIM-authors-entry" /><i18n:text>xmlui.dri2xhtml.METS-1.0-editor</i18n:text></div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
            </xsl:if>
        <xsl:if test="dim:field[@element='contributor'][@qualifier='author'] and contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus')">
  <div class="simple-item-view-authors item-page-field-wrapper table">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:text>Unbekannter Autor</xsl:text>
                                </span>
                            </xsl:for-each><br /></div>
        </xsl:if>
      <xsl:if test="dim:field[@element='contributor'][@qualifier='editor'] and contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus')">
                <div class="simple-item-view-authors item-page-field-wrapper table">            
		<xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='editor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
          <xsl:text> (Hrsg.)</xsl:text><br /></div>
        </xsl:if> 
	 <xsl:if test="dim:field[@element='contributor'][@qualifier='other'] and contains(dim:field[@element='relation'][@qualifier='volume'], 'Codex Montanus')">
<div class="simple-item-view-authors item-page-field-wrapper table">               
             <xsl:for-each select="dim:field[@element='contributor'][@qualifier='other']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='other']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                                <xsl:text> (Mitw.)</xsl:text><br /></div>
        </xsl:if>
  
    </xsl:template>

<xsl:template name="itemSummaryView-DIM-publisher">
<div>        <xsl:if test="dim:field[@element='publisher']">
                <!--<h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text></h5>-->
		<xsl:for-each select="dim:field[@element='publisher']">
			<xsl:copy-of select="./node()"/>
		</xsl:for-each>
        </xsl:if>
</div>    
</xsl:template>

<xsl:template name="itemSummaryView-DIM-isreplacedby">
<div>        <xsl:if test="dim:field[@element='relation' and @qualifier='isreplacedby']">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-isreplacedby</i18n:text>
                <xsl:for-each select="dim:field[@element='relation'][@qualifier='isreplacedby']">
                        <a>
                        <xsl:attribute name="href">
                        <xsl:copy-of select="./node()"/>
                        </xsl:attribute>
                        <xsl:copy-of select="./node()"/>
                        </a>
                </xsl:for-each>
        </xsl:if>
</div>
</xsl:template>


<xsl:template name="itemSummaryView-DIM-isbasedon">
<div>        <xsl:if test="dim:field[@element='description' and @qualifier='isbasedon']">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-isbasedon</i18n:text>
                <xsl:for-each select="dim:field[@element='description'][@qualifier='isbasedon']">
        		<a>                
			<xsl:attribute name="href">
			<xsl:copy-of select="./node()"/>
			</xsl:attribute>
			<xsl:copy-of select="./node()"/>
			</a>
                </xsl:for-each>
        </xsl:if>
</div>
</xsl:template>

<xsl:template name="itemSummaryView-DIM-type">
<div>   
	<xsl:if test="contains(dim:field[@element='relation'][@qualifier='volume'], 'Berliner geowissenschaftliche Abhandlungen. Reihe A')">
	<xsl:for-each select="dim:field[@element='type'][not(@qualifier)]">
                        <xsl:text>Sammelbandbeitrag, digitalisiert</xsl:text>
                </xsl:for-each>
	</xsl:if>
	<xsl:if test="not(contains(dim:field[@element='relation'][@qualifier='volume'], 'Berliner geowissenschaftliche Abhandlungen. Reihe A'))">     
	<xsl:if test="dim:field[@element='type'][not(@qualifier)]">
                <xsl:for-each select="dim:field[@element='type'][not(@qualifier)]">
			<i18n:text><xsl:copy-of select="."/></i18n:text>
                </xsl:for-each>
        </xsl:if>
	</xsl:if>
</div>
</xsl:template>

<xsl:template name="itemSummaryView-DIM-coverage">
<div>        <xsl:if test="dim:field[@element='coverage' and @qualifier='spatial']">
                <!--<h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text></h5>-->
                <xsl:for-each select="dim:field[@element='coverage' and @qualifier='spatial']">
                        <xsl:text>Koordinaten: </xsl:text><xsl:copy-of select="."/>
                </xsl:for-each>
        </xsl:if>
</div>
</xsl:template>


<xsl:template name="itemSummaryView-DIM-typeVersion">
<div>        <xsl:if test="dim:field[@element='type' and @qualifier='version']">
                <xsl:for-each select="dim:field[@element='type' and @qualifier='version']">
			<i18n:text><xsl:copy-of select="."/></i18n:text>
                </xsl:for-each>
        </xsl:if>
</div>
</xsl:template>


<xsl:template name="itemSummaryView-DIM-language">
<div>        <xsl:if test="dim:field[@element='language' and @qualifier='iso']">
                <xsl:for-each select="dim:field[@element='language' and @qualifier='iso']">
                        <i18n:text><xsl:copy-of select="."/></i18n:text>
                </xsl:for-each>
        </xsl:if>
</div>
</xsl:template>



<xsl:template name="itemSummaryView-DIM-relationIsPartOf">
<div>        <xsl:if test="dim:field[@element='relation' and @qualifier='ispartof']">
                <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartof']">
                        <xsl:copy-of select="."/>
                </xsl:for-each>
        </xsl:if>
</div>    
</xsl:template>


<xsl:template name="itemSummaryView-DIM-descriptionSponsor">
<div>        <xsl:if test="dim:field[@element='description' and @qualifier='sponsorship']">
                <xsl:for-each select="dim:field[@element='description' and @qualifier='sponsorship']">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-sponsorship</i18n:text><xsl:copy-of select="./node()"/>
                </xsl:for-each>
        </xsl:if>
</div>    
</xsl:template>

<xsl:template name="itemSummaryView-DIM-journal">
        <xsl:if test="dim:field[@element='bibliographicCitation' and @qualifier='journal']">
                <xsl:for-each select="dim:field[@element='bibliographicCitation' and @qualifier='journal']">
                        <xsl:copy-of select="./node()"/><xsl:text>, </xsl:text>
                </xsl:for-each>
        </xsl:if>
</xsl:template>

<xsl:template name="itemSummaryView-DIM-volume">
        <xsl:if test="dim:field[@element='bibliographicCitation' and @qualifier='volume']">
                <xsl:for-each select="dim:field[@element='bibliographicCitation' and @qualifier='volume']">
                        <xsl:copy-of select="./node()"/>
                </xsl:for-each>
        </xsl:if>
</xsl:template>

<xsl:template name="itemSummaryView-DIM-issue">
        <xsl:if test="dim:field[@element='bibliographicCitation' and @qualifier='issue']">
                <xsl:for-each select="dim:field[@element='bibliographicCitation' and @qualifier='issue']">
                        <xsl:text>, </xsl:text><xsl:copy-of select="./node()"/>
                </xsl:for-each>
        </xsl:if>
</xsl:template>

<xsl:template name="itemSummaryView-DIM-pages">
        <xsl:if test="dim:field[@element='bibliographicCitation' and @qualifier='firstPage']">
                <xsl:for-each select="dim:field[@element='bibliographicCitation' and @qualifier='firstPage']">
                        <xsl:text> </xsl:text><xsl:copy-of select="./node()"/>
                </xsl:for-each>
			</xsl:if>
			<xsl:text> - </xsl:text>
			<xsl:if test="dim:field[@element='bibliographicCitation' and @qualifier='lastPage']">
                <xsl:for-each select="dim:field[@element='bibliographicCitation' and @qualifier='lastPage']">
                        <xsl:copy-of select="./node()"/>
                </xsl:for-each>
			</xsl:if>
</xsl:template>



    <xsl:template name="itemSummaryView-DIM-authors-entry">
       
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="node()"/>
                <xsl:if test="starts-with(@authority, '0000-')">
<a target="_blank" href="{concat('//orcid.org/',@authority)}" title="ORCID">
<img src="/themes/Mirage2/images/ORCIDiD_icon16x16.png" alt="ORCIDiD" style="margin:4px;"/>
</a>
                </xsl:if>
    </xsl:template>

<xsl:template name="itemSummaryView-DIM-URI">
       <xsl:if test="dim:field[@element='identifier' and @qualifier='uri' and descendant::text()]">
	<xsl:if test="not(contains(dim:field[@element='identifier' and @qualifier='doi'], 'fidgeo'))">
          <div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                        <xsl:if test="starts-with(./node(), 'http://resolver') or starts-with(./node(), 'http://hdl')">
			<i18n:text>xmlui.dri2xhtml.METS-1.0.citation-link</i18n:text>
			<a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
	</xsl:if>
    </xsl:template>

	  <xsl:template name="itemSummaryView-DIM-DOI">
       <xsl:choose>
	<xsl:when test="dim:field[@element='identifier' and @qualifier='otherdoi' and descendant::text()]">

                <div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                     <xsl:text>DOI: </xsl:text>
                        <a>
                        <xsl:attribute name="href">
                                <xsl:copy-of select="concat('https://doi.org/', dim:field[@element='identifier'][@qualifier='otherdoi'][1]/node())"/>
                        </xsl:attribute>
                        <xsl:copy-of select="dim:field[@element='identifier'][@qualifier='otherdoi'][1]/node()"/>
                        </a>
                </span>
            </div>
        </xsl:when>
	<!-- when identifier.doi does not start with 10.23689/fidgeo show that as url like otherdoi -->
	<xsl:when test="dim:field[@element='identifier' and @qualifier='doi' and descendant::text()]">

                <div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                     <xsl:text>DOI: </xsl:text>
                        <a>
                        <xsl:attribute name="href">
                                <xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                                <xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/>
				</xsl:if>
				<xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                                <xsl:copy-of select="concat('https://doi.org/', dim:field[@element='identifier'][@qualifier='doi'][1]/node())"/>
                                </xsl:if>
                        </xsl:attribute>
				<xsl:if test="contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org')">
                                <xsl:copy-of select="dim:field[@element='identifier'][@qualifier='doi'][1]/node()"/>
                                </xsl:if>
                                <xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], 'doi.org'))">
                                <xsl:copy-of select="concat('https://doi.org/', dim:field[@element='identifier'][@qualifier='doi'][1]/node())"/>
                                </xsl:if>
                        </a>
                </span>
		<span><br />
			<xsl:if test="not(contains(dim:field[@element='identifier'][@qualifier='doi'], '10.23689'))">
                                        <xsl:if test="contains(dim:field[@element='identifier' and @qualifier='uri']/node(), 'resolver.sub')">
			<xsl:text>Persistent URL: </xsl:text>
			<a>
				<xsl:attribute name="href">
						<xsl:copy-of select="dim:field[@element='identifier'][@qualifier='uri']/node()"/>
				</xsl:attribute>
				<xsl:copy-of select="dim:field[@element='identifier'][@qualifier='uri']/node()"/>
			</a>
			</xsl:if>
			</xsl:if>
		</span>
            </div>
        </xsl:when>

	<xsl:when test="dim:field[@element='identifier' and @qualifier='uri' and descendant::text()]">

                <div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                     <xsl:text>DOI: </xsl:text>
			<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                        <xsl:if test="starts-with(./node(), 'http://dx') or starts-with(./node(), 'http://doi')">
			<a>
                        <xsl:attribute name="href">
                                <xsl:copy-of select="concat('https://doi.org/', substring-after(./node(), 'doi.org/'))"/>
                        </xsl:attribute>
                        <xsl:copy-of select="concat('https://doi.org/', substring-after(./node(), 'doi.org/'))"/>
			</a>
			</xsl:if>
			</xsl:for-each>
                </span>
            </div>
        </xsl:when>
	</xsl:choose>
    </xsl:template>


<!--    <xsl:template name="itemSummaryView-DIM-URI">
       <xsl:if test="dim:field[@element='identifier' and @qualifier='uri' and descendant::text()]">
	  
	  <div class="simple-item-view-uri item-page-field-wrapper table">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>
                <span>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                        <xsl:if test="starts-with(./node(), 'http://dx')">
			<a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
			</xsl:if>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>-->

    <!--<xsl:template name="itemSummaryView-DIM-doi">
        <xsl:if test="dim:field[@element='identifier' and @qualifier='doi' and descendant::text()]">
            <div class="simple-item-view-uri item-page-field-wrapper table">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-doi</i18n:text>
                <span>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
                        <a>
                            <xsl:attribute name="href">-->
                               <!-- <xsl:copy-of select="./node()"/>-->
		<!--		<xsl:value-of select="concat('http://dx.doi.org/', node())"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>-->

    <xsl:template name="itemSummaryView-DIM-date">
        <xsl:if test="dim:field[@element='date' and @qualifier='issued' and descendant::text()]">
            <!--<div class="simple-item-view-date word-break item-page-field-wrapper table">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>-->
                
                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                    <xsl:copy-of select="substring(./node(),1,4)"/>
                    <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                        <br/>
                    </xsl:if>
                </xsl:for-each><br/>
            <!--</div>-->
        </xsl:if>
	<xsl:if test="dim:field[@element='date' and @qualifier='printIssued' and descendant::text()]">
            <!--<div class="simple-item-view-date word-break item-page-field-wrapper table">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>-->
		
                <xsl:for-each select="dim:field[@element='date' and @qualifier='printIssued']">
                    <xsl:copy-of select="substring(./node(),1,4)"/>
                    <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='printIssued']) != 0">
                        <br/>
                    </xsl:if>
                </xsl:for-each>
		<xsl:text> (Erscheinungsjahr der gedruckten Vorlage) </xsl:text><br/>
            <!--</div>-->
        </xsl:if>
	<xsl:if test="dim:field[@element='date' and @qualifier='created' and descendant::text()]">
            <!--<div class="simple-item-view-date word-break item-page-field-wrapper table">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>-->

                <xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
                    <xsl:copy-of select="substring(./node(),1,4)"/>
                    <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
                        <br/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text> (Entstehungsjahr der Originalvorlage) </xsl:text>
            <!--</div>-->
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-show-full">
        <div class="simple-item-view-show-full item-page-field-wrapper table">
            <h5>
                <i18n:text>xmlui.mirage2.itemSummaryView.MetaData</i18n:text>
            </h5>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
            </a>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-collections">
        <xsl:if test="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']">
            <div class="simple-item-view-collections item-page-field-wrapper table">
                <h5>
                    <i18n:text>xmlui.mirage2.itemSummaryView.Collections</i18n:text>
                </h5>
                <xsl:apply-templates select="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']/dri:reference"/>
            </div>
        </xsl:if>
    </xsl:template>

<xsl:template name="itemSummaryView-statistics">
            <div class="simple-item-view-collections item-page-field-wrapper table" style="margin-bottom: 1.5em;">
		 <h5>
                    <i18n:text>Statistik:</i18n:text>
                </h5>

<xsl:if test="contains(dim:field[@element='identifier'][@qualifier='uri'], 'gldocs')">
<xsl:variable name="statlink"><xsl:value-of select="concat('https://e-docs.geo-leo.de/handle/', substring-after(//dim:field[@element='identifier'][@qualifier='uri'], 'gldocs-'), '/statistics')" /></xsl:variable>
<a href="{$statlink}"><i18n:text>xmlui.statistics.link</i18n:text></a>
</xsl:if>
<xsl:if test="contains(dim:field[@element='identifier'][@qualifier='uri'], 'handle')">
<xsl:variable name="statlink"><xsl:value-of select="concat('https://e-docs.geo-leo.de/handle/', substring-after(//dim:field[@element='identifier'][@qualifier='uri'], 'handle.net/'), '/statistics')" /></xsl:variable>
<a href="{$statlink}"><i18n:text>xmlui.statistics.link</i18n:text></a>
</xsl:if>
           </div>
    </xsl:template>


   <xsl:template name="itemSummaryView-subjects">
	 <xsl:if test="dim:field[@element='subject' and @qualifier='free'] or dim:field[@element='subject' and @qualifier='gokverbal']">
	    <div class="simple-item-view-collections item-page-field-wrapper table" style="margin-bottom: 1.5em;">
                <h5>
			<i18n:text>xmlui.mirage2.itemSummaryView.Subjects</i18n:text>
		</h5>
                <xsl:for-each select="dim:field[@element='subject' and @qualifier='free']">
                        <a><xsl:attribute name="href"><xsl:value-of select="concat('https://e-docs.geo-leo.de/browse?type=subject', '&amp;value=', ./node())"/></xsl:attribute><xsl:value-of select="./node()"/></a><br/>
                </xsl:for-each>
		<xsl:for-each select="dim:field[@element='subject' and @qualifier='gokverbal']">
                        <a><xsl:attribute name="href"><xsl:value-of select="concat('https://e-docs.geo-leo.de/browse?type=subject', '&amp;value=', ./node())"/></xsl:attribute><xsl:value-of select="./node()"/></a><br/>
                </xsl:for-each>
	   </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="itemSummaryView-DIM-file-section">
	<xsl:param name="hrefexport" />
        <xsl:choose>
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <div class="item-page-field-wrapper table word-break">
                    <h5>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                    </h5>

                    <xsl:variable name="label-1">
                            <xsl:choose>
                                <xsl:when test="confman:getProperty('mirage2.item-view.bitstream.href.label.1')">
                                    <xsl:value-of select="confman:getProperty('mirage2.item-view.bitstream.href.label.1')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>label</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="label-2">
                            <xsl:choose>
                                <xsl:when test="confman:getProperty('mirage2.item-view.bitstream.href.label.2')">
                                    <xsl:value-of select="confman:getProperty('mirage2.item-view.bitstream.href.label.2')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>title</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:variable>

                    <xsl:for-each select="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
		<xsl:if test="not(contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href, 'alteversion')) and not(contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href, 'alteVersion'))">
			<xsl:call-template name="itemSummaryView-DIM-file-section-entry">
                            <xsl:with-param name="href" select="mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                            <xsl:with-param name="mimetype" select="@MIMETYPE" />
                            <xsl:with-param name="label-1" select="$label-1" />
                            <xsl:with-param name="label-2" select="$label-2" />
                            <xsl:with-param name="title" select="mets:FLocat[@LOCTYPE='URL']/@xlink:title" />
                            <xsl:with-param name="label" select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" />
                            <xsl:with-param name="size" select="@SIZE" />
                        </xsl:call-template>
			</xsl:if>
                    </xsl:for-each>
                </div>
		<!--Metadaten-Export-->
	        <div class="metadataexport"><h5><i18n:text>xmlui.metadata.export</i18n:text></h5>
        	        <a><xsl:attribute name="href"><xsl:value-of select="concat('/endnote/handle/11858/', substring-after(dim:field[@element='identifier'][@qualifier='uri'], '11858/'))"/></xsl:attribute><xsl:text>Endnote</xsl:text></a><br/>
                	<a><xsl:attribute name="href"><xsl:value-of select="concat('/bibtex/handle/11858/', substring-after(dim:field[@element='identifier'][@qualifier='uri'], '11858/')) "/></xsl:attribute><xsl:text>BibTex</xsl:text></a><br/>
                	<a><xsl:attribute name="href"><xsl:value-of select="concat('/ris/handle/11858/', substring-after(dim:field[@element='identifier'][@qualifier='uri'], '11858/')) "/></xsl:attribute><xsl:text>RIS</xsl:text></a>
        	</div>

            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="//mets:fileSec/mets:fileGrp[@USE='ORE']" mode="itemSummaryView-DIM" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-file-section-entry">
        <xsl:param name="href" />
	<!--<xsl:param name="download" />-->
        <xsl:param name="mimetype" />
        <xsl:param name="label-1" />
        <xsl:param name="label-2" />
        <xsl:param name="title" />
        <xsl:param name="label" />
        <xsl:param name="size" />
        <div>

            <a>

                <xsl:attribute name="href">
                    <xsl:value-of select="$href"/>
                </xsl:attribute>
		<!--<xsl:attribute name="download">
                </xsl:attribute>-->

                <xsl:call-template name="getFileIcon">
                    <xsl:with-param name="mimetype">
                        <xsl:value-of select="substring-before($mimetype,'/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="contains($label-1, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-1, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before($mimetype,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains($mimetype,';')">
                                        <xsl:value-of select="substring-before(substring-after($mimetype,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> (</xsl:text>
                <xsl:choose>
                    <xsl:when test="$size &lt; 1024">
                        <xsl:value-of select="$size"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024">
                        <xsl:value-of select="substring(string($size div 1024),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024 * 1024">
                        <xsl:value-of select="substring(string($size div (1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(string($size div (1024 * 1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>)</xsl:text>
            </a><br/>

       <!--Google-Viewer Link-->
        <!--     <a target="_blank" href="http://docs.google.com/viewer?url=http://geoleo-docker.sub.uni-goettingen.de{mets:FLocat[@LOCTYPE='URL']/@xlink:href}">Google View</a><br/>-->

	<!--Metadaten-Export-->
<!--	<div class="metadataexport"><h5><i18n:text>xmlui.metadata.export</i18n:text></h5>
		<a><xsl:attribute name="href"><xsl:value-of select="concat('/endnote/handle/11858/', substring-before(substring-after($href, '11858/'), '/')) "/></xsl:attribute><xsl:text>Endnote</xsl:text></a><br/>
		<a><xsl:attribute name="href"><xsl:value-of select="concat('/bibtex/handle/11858/', substring-before(substring-after($href, '11858/'), '/')) "/></xsl:attribute><xsl:text>BibTex</xsl:text></a><br/>
		<a><xsl:attribute name="href"><xsl:value-of select="concat('/ris/handle/11858/', substring-before(substring-after($href, '11858/'), '/')) "/></xsl:attribute><xsl:text>RIS</xsl:text></a>
	</div>-->
	</div>
    </xsl:template>

    <xsl:template match="dim:dim" mode="itemDetailView-DIM">
        <xsl:call-template name="itemSummaryView-DIM-title"/>
        <div class="ds-table-responsive">
            <table class="ds-includeSet-table detailtable table table-striped table-hover">
                <xsl:apply-templates mode="itemDetailView-DIM"/>
            </table>
        </div>

        <span class="Z3988">
            <xsl:attribute name="title">
                 <xsl:call-template name="renderCOinS"/>
            </xsl:attribute>
            &#xFEFF; <!-- non-breaking space to force separating the end tag -->
        </span>
        <xsl:copy-of select="$SFXLink" />
    </xsl:template>

    <xsl:template match="dim:field" mode="itemDetailView-DIM">
            <tr>
                <xsl:attribute name="class">
                    <xsl:text>ds-table-row </xsl:text>
                    <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                    <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
                </xsl:attribute>
                <td class="label-cell">
                    <xsl:value-of select="./@mdschema"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@element"/>
                    <xsl:if test="./@qualifier">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="./@qualifier"/>
                    </xsl:if>
                </td>
            <td class="word-break">
              <xsl:copy-of select="./node()"/>
            </td>
                <td><xsl:value-of select="./@language"/></td>
            </tr>
    </xsl:template>

    <!-- don't render the item-view-toggle automatically in the summary view, only when it gets called -->
    <xsl:template match="dri:p[contains(@rend , 'item-view-toggle') and
        (preceding-sibling::dri:referenceSet[@type = 'summaryView'] or following-sibling::dri:referenceSet[@type = 'summaryView'])]">
    </xsl:template>

    <!-- don't render the head on the item view page -->
    <xsl:template match="dri:div[@n='item-view']/dri:head" priority="5">
    </xsl:template>

   <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:choose>
                <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                    <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!-- Otherwise, iterate over and display all of them -->
                <xsl:otherwise>
                    <xsl:apply-templates select="mets:file">
                     	<!--Do not sort any more bitstream order can be changed-->
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

   <xsl:template match="mets:fileGrp[@USE='LICENSE']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:apply-templates select="mets:file">
                        <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <div class="file-wrapper row">
            <div class="col-xs-6 col-sm-3">
                <div class="thumbnail">
                    <a class="image-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                    mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img alt="Thumbnail">
                                    <xsl:attribute name="data-src">
                                        <xsl:text>holder.js/100%x</xsl:text>
                                        <xsl:value-of select="$thumbnail.maxheight"/>
                                        <xsl:text>/text:No Thumbnail</xsl:text>
                                    </xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </div>
            </div>

            <div class="col-xs-6 col-sm-7">
                <dl class="file-metadata dl-horizontal">
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:attribute name="title">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:attribute>
                        <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 30, 5)"/>
                    </dd>
                <!-- File size always comes in bytes and thus needs conversion -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:choose>
                            <xsl:when test="@SIZE &lt; 1024">
                                <xsl:value-of select="@SIZE"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </dd>
                <!-- Lookup File Type description in local messages.xml based on MIME Type.
         In the original DSpace, this would get resolved to an application via
         the Bitstream Registry, but we are constrained by the capabilities of METS
         and can't really pass that info through. -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(@MIMETYPE,';')">
                                <xsl:value-of select="substring-before(substring-after(@MIMETYPE,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:with-param>
                        </xsl:call-template>
                    </dd>
                <!-- Display the contents of 'Description' only if bitstream contains a description -->
                <xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
                        <dt>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
                            <xsl:text>:</xsl:text>
                        </dt>
                        <dd class="word-break">
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                            </xsl:attribute>
                            <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 30, 5)"/>
                        </dd>
                </xsl:if>
                </dl>

            </div>

            <!--<div class="file-link col-xs-6 col-xs-offset-6 col-sm-2 col-sm-offset-0">
                <xsl:choose>
                    <xsl:when test="@ADMID">
                        <xsl:call-template name="display-rights"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="view-open"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>-->
        </div>

</xsl:template>

    <xsl:template name="view-open">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
            </xsl:attribute>
            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
        </a>
    </xsl:template>

    <xsl:template name="display-rights">
        <xsl:variable name="file_id" select="jstring:replaceAll(jstring:replaceAll(string(@ADMID), '_METSRIGHTS', ''), 'rightsMD_', '')"/>
        <xsl:variable name="rights_declaration" select="../../../mets:amdSec/mets:rightsMD[@ID = concat('rightsMD_', $file_id, '_METSRIGHTS')]/mets:mdWrap/mets:xmlData/rights:RightsDeclarationMD"/>
        <xsl:variable name="rights_context" select="$rights_declaration/rights:Context"/>
        <xsl:variable name="users">
            <xsl:for-each select="$rights_declaration/*">
                <xsl:value-of select="rights:UserName"/>
                <xsl:choose>
                    <xsl:when test="rights:UserName/@USERTYPE = 'GROUP'">
                       <xsl:text> (group)</xsl:text>
                    </xsl:when>
                    <xsl:when test="rights:UserName/@USERTYPE = 'INDIVIDUAL'">
                       <xsl:text> (individual)</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <!--<xsl:choose>
            <xsl:when test="not ($rights_context/@CONTEXTCLASS = 'GENERAL PUBLIC') and ($rights_context/rights:Permissions/@DISPLAY = 'true')">
                <a href="{mets:FLocat[@LOCTYPE='URL']/@xlink:href}">
                    <img width="64" height="64" src="{concat($theme-path,'/images/Crystal_Clear_action_lock3_64px.png')}" title="Read access available for {$users}"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="view-open"/>
            </xsl:otherwise>
        </xsl:choose>-->

	
	<xsl:choose>
                        <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC 1.0'">
                                                        <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 1.0" style="float:left;margin-right:10px;"/>
                                <a href="https://creativecommons.org/licenses/by-nc/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC 2.0'">
                                                                        <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 2.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 2.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 2.5" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-NC 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 3.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 4.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 4.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 1.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by/1.0/" style="font-size:20px">
                                <xsl:text>CC BY 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 2.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by/2.0/" style="font-size:20px">
                                <xsl:text>CC BY 2.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 2.5" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by/2.5/" style="font-size:20px">
                                <xsl:text>CC BY 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 3.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by/3.0/" style="font-size:20px">
                                <xsl:text>CC BY 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY 4.0'">
				<xsl:if test="not(contains(dim:field[@element='title'], 'GMIT'))">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 4.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by/4.0/" style="font-size:20px">
                                <xsl:text>CC BY 4.0</xsl:text>
                                </a>
				</xsl:if>
				 <xsl:if test="contains(dim:field[@element='title'], 'GMIT')">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 4.0" style="float:left;margin-right:10px;" />
                                                                <a href="https://creativecommons.org/licenses/by/4.0/" style="font-size:20px">
                                <xsl:text>CC BY 4.0</xsl:text>
                                </a><xsl:text> (gilt nicht für enthaltene Werbung)</xsl:text>
                                </xsl:if>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-SA 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 1.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-sa/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-SA 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-SA 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 2.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-sa/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-SA 2.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-SA 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 2.5" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-sa/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-SA 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-SA 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 3.0" style="float:left;margin-right:10px;"/>
                                <a href="https://creativecommons.org/licenses/by-sa/3.0/" style="font-size:20px">
                                <xsl:text> CC BY-SA 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-SA 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 4.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-sa/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-SA 4.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-ND 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 1.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nd/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-ND 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 2.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nd/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 2.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-ND 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 2.5" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nd/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-ND 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-ND 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 3.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nd/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-ND 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 4.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nd/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 4.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-ND 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
1.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-nd/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-ND 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
2.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-nd/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 2.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-ND 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
2.5" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-nd/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-ND 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
3.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-nd/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-ND 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
4.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-nd/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 4.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-SA 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
1.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-sa/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-SA 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
2.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 2.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-SA 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
2.5" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-sa/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-SA 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
3.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC BY-NC-SA 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
4.0" style="float:left;margin-right:10px;"/>
                                                                <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 4.0</xsl:text>
                                </a>
                        </xsl:when>
			<xsl:when test="contains(dim:field[@element='rights'], 'der Rechte durch die VG')">
                               <div><xsl:text>Wahrnehmung der Rechte durch die VG (Verwertungsgesellschaft) Wort (§ 51 VGG (Verwertungsgesellschaftengesetz)).</xsl:text></div>
                        </xsl:when>
			<xsl:when test="starts-with(dim:field[@element='rights'], 'This is an open access article under the terms')">
                               <div><xsl:copy-of select="dim:field[@element='rights']/node()"/></div>
                        </xsl:when>
			<xsl:when test="dim:field[@element='rights'] = 'CC::CC Public Domain Mark 1.0'">
                               <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-mark.png" alt="Public Domain Mark 1.0" style="float:left;margin-right:10px;"/>
                                <a href="https://creativecommons.org/publicdomain/mark/1.0/" style="font-size:20px">CC Public Domain Mark 1.0</a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'CC::CC0 1.0 Universal Public Domain Dedication'">
                                
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-zero.png" alt="Universal Public Domain Dedication" style="float:left;margin-right:10px;"/>
                                <a href="https://creativecommons.org/publicdomain/zero/1.0/" style="font-size:20px">CC Zero</a>
                        </xsl:when>
			 <xsl:otherwise>
                               <div><a href="https://e-docs.geo-leo.de/rights">GEO-LEO e-docs Lizenz</a></div>
                        </xsl:otherwise>



                </xsl:choose>



		



    </xsl:template>

    <xsl:template name="getFileIcon">
        <xsl:param name="mimetype"/>
	<i class="fa fa-file-pdf-o"></i>
            <!--<i aria-hidden="true">
                <xsl:attribute name="class">
                <xsl:text>glyphicon </xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href,'isAllowed=n')">
                        <xsl:text> glyphicon-lock</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> glyphicon-file</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
            </i>
        <xsl:text> </xsl:text>-->
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='CC-LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license_text']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></a></li>
    </xsl:template>

    <!--
    File Type Mapping template

    This maps format MIME Types to human friendly File Type descriptions.
    Essentially, it looks for a corresponding 'key' in your messages.xml of this
    format: xmlui.dri2xhtml.mimetype.{MIME Type}

    (e.g.) <message key="xmlui.dri2xhtml.mimetype.application/pdf">PDF</message>

    If a key is found, the translated value is displayed as the File Type (e.g. PDF)
    If a key is NOT found, the MIME Type is displayed by default (e.g. application/pdf)
    -->
    <xsl:template name="getFileTypeDesc">
        <xsl:param name="mimetype"/>

        <!--Build full key name for MIME type (format: xmlui.dri2xhtml.mimetype.{MIME type})-->
        <xsl:variable name="mimetype-key">xmlui.dri2xhtml.mimetype.<xsl:value-of select='$mimetype'/></xsl:variable>

        <!--Lookup the MIME Type's key in messages.xml language file.  If not found, just display MIME Type-->
        <i18n:text i18n:key="{$mimetype-key}"><xsl:value-of select="$mimetype"/></i18n:text>
    </xsl:template>


</xsl:stylesheet>
