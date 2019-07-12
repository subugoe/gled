<?xml version="1.0" encoding="UTF-8" ?>
<!--


    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

        Developed by DSpace @ Lyncode <dspace@lyncode.com>

        >  http://www.loc.gov/standards/mets/mets.xsd
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:urn="http://www.d-nb.de/standards/urn/"
        xmlns:hdl="http://www.d-nb.de/standards/hdl/"
        xmlns:doi="http://www.d-nb.de/standards/doi/"
        xmlns:picaxml="info:srw/schema/5/picaXML-v1.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="info:srw/schema/5/picaXML-v1.0 http://www.oclcpica.org/xml/picaplus.xsd"
        xmlns:mets="http://www.loc.gov/METS/"
        xmlns:xlink="http://www.w3.org/TR/xlink/"
        version="1.0">

        <xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />

        <xsl:template match="/">
                <picaxml
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.lyncode.com/xoai"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns="info:srw/schema/5/picaXML-v1.0"
                xmlns:picaxml="info:srw/schema/5/picaXML-v1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="info:srw/schema/5/picaXML-v1.0 http://www.oclcpica.org/xml/picaplus.xsd">

                <!-- save doctype, division and file size as global variable -->
                <xsl:variable name="doctype"><xsl:value-of select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element[not(@name='version')]/doc:field/text()" /></xsl:variable>


                        <!-- Handle only doctype map_digi -->
                                <xsl:if test="//doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:field = 'map_digi'">


                                <!--###############################################-->
                <datafield>
                                <!-- possible type values: monograph, anthology, conference,  other
                                other is CD-ROM or DVD -->
                        <xsl:attribute name="tag">013H</xsl:attribute>
                        <subfield>
                                                                <xsl:attribute name="code">0</xsl:attribute>
                                                                <!--<xsl:variable name="type"><xsl:value-of select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:field/text()" /></xsl:variable>
                                                                <xsl:variable name="code">
                                                                        <xsl:choose>

                                                                                <xsl:when test="$doctype = 'map_digi'">
                                                                                        <xsl:text>F</xsl:text>
                                                                                </xsl:when>
                                                                        </xsl:choose>
                                                                </xsl:variable>
                                                                <xsl:value-of select="concat('O', $code, 'y')" />-->
				<xsl:text>kart</xsl:text>
                        </subfield>

            </datafield>
			
			<datafield>
                               
                        <xsl:attribute name="tag">002C</xsl:attribute>
                        <subfield>
                                 <xsl:attribute name="code">a</xsl:attribute>

                                                                <xsl:text>kartografisches Bild</xsl:text>
                         </subfield>                              
						<subfield>
                                 <xsl:attribute name="code">b</xsl:attribute>

                                   <xsl:text>cri</xsl:text>					
                        </subfield>

            </datafield>
			<datafield>
                               
                        <xsl:attribute name="tag">002D</xsl:attribute>
                        <subfield>
                                 <xsl:attribute name="code">a</xsl:attribute>

                                                                <xsl:text>Computermedien</xsl:text>
                         </subfield>                              
						<subfield>
                                 <xsl:attribute name="code">b</xsl:attribute>

                                   <xsl:text>c</xsl:text>					
                        </subfield>

            </datafield>
			<datafield>
                               
                        <xsl:attribute name="tag">002E</xsl:attribute>
                        <subfield>
                                 <xsl:attribute name="code">a</xsl:attribute>

                                                                <xsl:text>Online-Ressource</xsl:text>
                         </subfield>                              
						
            </datafield>

                 <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='ppn']">
                                <datafield>
                        <xsl:attribute name="tag">003@</xsl:attribute>
                         <subfield>
                        <xsl:attribute name="code">0</xsl:attribute>

                                                                <xsl:value-of select="doc:element/doc:field/text()"/>
                                                </subfield>
                                </datafield>
                 </xsl:for-each>


			<!-- DOI -->
             <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='doi']/doc:element/doc:field">


                         <datafield>
                        <xsl:attribute name="tag">004V</xsl:attribute>
                        <subfield>
                                                                <xsl:attribute name="code">0</xsl:attribute>
                                                                <xsl:value-of select="." />
                        </subfield>
                </datafield>
              </xsl:for-each>


                         <!-- uri: handle -->
                                <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']/doc:element/doc:field">
                                        <datafield>
                                                <xsl:attribute name="tag">017C</xsl:attribute>
                                                <xsl:attribute name="occurence">03</xsl:attribute>
                                                <subfield>
                                                        <xsl:attribute name="code">S</xsl:attribute>
                                                        <xsl:text>1</xsl:text>
                                                </subfield>
                                                <subfield>
                                                        <xsl:attribute name="code">a</xsl:attribute>
                                                        <xsl:value-of select="." />
                                                </subfield>
                                        </datafield>
				</xsl:for-each>



                        <!-- Language: GVK requires ISO-639-2 Bibliographic [ger] -->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element[@name='iso']/doc:element/doc:field[@name='value']">
                                <!-- do not export language "other" -->
                                <xsl:if test="not(. = 'other')">
                                        <datafield>
                                                <xsl:attribute name="tag">010@</xsl:attribute>
                                                <subfield>
                                                        <xsl:attribute name="code">a</xsl:attribute>
                                                                <xsl:value-of select="." />
                                                </subfield>
                                        </datafield>
                                </xsl:if>
                        </xsl:for-each>

                        <!-- date issued: 1100 = 011@ handle year only -->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element">

                                <xsl:if test="@name='issued'">
                                <xsl:variable name="date"><xsl:value-of select="doc:element/doc:field" /></xsl:variable>
                                        <datafield>
                                                <xsl:attribute name="tag">011@</xsl:attribute>
                                                <subfield>
                                                        <xsl:attribute name="code">r</xsl:attribute>
                                                        <xsl:choose>
                                                                <xsl:when test="contains($date, '-')">
                                                                        <xsl:value-of select="substring-before($date, '-')" />
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:value-of select="$date" />
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </subfield>
                                        </datafield>

                                </xsl:if>
								<xsl:if test="@name='available'">
                                <xsl:variable name="date"><xsl:value-of select="doc:element/doc:field" /></xsl:variable>
                                        <datafield>
                                                <xsl:attribute name="tag">011@</xsl:attribute>
                                                <subfield>
                                                        <xsl:attribute name="code">a</xsl:attribute>
                                                        <xsl:choose>
                                                                <xsl:when test="contains($date, '-')">
                                                                        <xsl:value-of select="substring-before($date, '-')" />
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:value-of select="$date" />
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </subfield>
												<subfield>
                                                        <xsl:attribute name="code">n</xsl:attribute>
                                                        <xsl:choose>
                                                                <xsl:when test="contains($date, '-')">
                                                                        <xsl:text>[</xsl:text><xsl:value-of select="substring-before($date, '-')" /><xsl:text>]</xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:value-of select="$date" />
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </subfield>
										</datafield>

                                </xsl:if>
								
                        </xsl:for-each>


					<!-- Country Code: XA-DE-NI; Mandatory for GVK-Import -->

                                <datafield>
                                        <xsl:attribute name="tag">019@</xsl:attribute>
                                        <subfield>
                                                <xsl:attribute name="code">a</xsl:attribute>
                                                <xsl:text>XA-DE</xsl:text>
                                        </subfield>
                                </datafield>

			

                        <!-- title: 021A $a; alternative $d + $h author -->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field">

                                <!-- And now the title -->

				<datafield>
                                        
                                                <xsl:attribute name="tag">021A</xsl:attribute>
                                                <subfield>
                                                        
							<xsl:attribute name="code">a</xsl:attribute>
                                                        <!--<xsl:value-of select="." />-->
							<xsl:if test="contains(., ';')">
								<xsl:value-of select="substring-before(substring-after(.,'; '), '/')" />
							</xsl:if>
							<xsl:if test="not(contains(., ';'))">
								<xsl:value-of select="substring-before(substring(.,17), '/')" />
							</xsl:if>
                                                </subfield>
					     <xsl:if test="../../doc:element[@name='alternative']">
                                                        <subfield>
                                                                <xsl:attribute name="code">d</xsl:attribute>
                                                                <xsl:value-of select="../../doc:element[@name='alternative']/doc:element/doc:field/text()" />
                                                        </subfield>
                                                </xsl:if>

                                                <subfield>
                                                        <xsl:attribute name="code">h</xsl:attribute>
                                                        <!-- mehrere authoren mit "und", "semikolon" ja nach Vorlage. Eckige Klammern sind hinzugefügte Daten, die nicht auf dem Cover stehen -->
                                                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field">
                                                                <xsl:variable name="person"><xsl:value-of select="." /></xsl:variable>
                                                                <xsl:value-of select="normalize-space(substring-after($person, ','))" /><xsl:text> </xsl:text><xsl:value-of select="substring-before($person, ',')" />
                                                                <xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>

                                                        </xsl:for-each>

                                               </subfield>
                                        </datafield>
                                
                        </xsl:for-each>

                        <!-- Beteiligte Person bei Karten 028C -->
                        <!-- If name contains "von" => subfield c: "von" !!!!! -->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field">
                                <datafield>
                                        <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                        <xsl:attribute name="tag">028C</xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                                <xsl:attribute name="tag">028C</xsl:attribute>
                                                                
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:variable name="author"><xsl:value-of select="." /></xsl:variable>
                                        <subfield>
                                        <xsl:attribute name="code">d</xsl:attribute>
                                                <xsl:value-of select="normalize-space(substring-after($author, ','))" />
                                        </subfield>

                                        <subfield>
                                                <xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:value-of select="normalize-space(substring-before($author, ','))" />
                                        </subfield>

                                </datafield>
                        </xsl:for-each>


                        <!-- Publisher and publisher place: $p Place, $n publisher name -->


                                                                        <xsl:if test="//doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field">
                                                                                <datafield>
                                                        <xsl:attribute name="tag">033A</xsl:attribute>
                                                                <subfield>
                                                                                <xsl:attribute name="code">p</xsl:attribute>
                                                                                <xsl:text>Göttingen</xsl:text>

                                                                </subfield>
                                                                <subfield>
                                                                                <xsl:attribute name="code">n</xsl:attribute>
                                                                                <xsl:text>Niedersächsische Staats- und Universitätsbibliothek</xsl:text>

                                                                </subfield>

                                                </datafield>
                                                                        </xsl:if>

                        <!-- extent: 4060 = 034D -->
                        <!-- O-Record only. File Size missing!!!
                                A-Record "a: value "Seiten" -->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element">
                                <xsl:if test="@name='extent'">

                                <datafield>
                                        <xsl:attribute name="tag">034D</xsl:attribute>
                                        <subfield>
                                                <xsl:attribute name="code">a</xsl:attribute>
                                                <xsl:text>Online-Ressource</xsl:text>
                                        </subfield>
                                </datafield>
                                </xsl:if>
                        </xsl:for-each>

                        <!-- relation.ispartofseries-->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='ispartofseries']">

				<datafield>
                        <xsl:attribute name="tag">036C</xsl:attribute>
                                <subfield>
                                <xsl:if test="contains(doc:element/doc:field/text(), ';')">
										<xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:value-of select="substring-before(doc:element/doc:field/text(), ';')" />
								</xsl:if>
								<xsl:if test="not(contains(doc:element/doc:field/text(), ';'))">
										<xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:value-of select="doc:element/doc:field/text()" />
								</xsl:if>
                                </subfield>
								<subfield>
									<xsl:attribute name="code">l</xsl:attribute>
										<xsl:value-of select="substring-after(doc:element/doc:field/text(), ';')" /><xsl:text> = </xsl:text>
										<xsl:value-of select="substring-before(//doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field/text(), ']')" /><xsl:text>]</xsl:text>
								</subfield>
                        </datafield>

                        </xsl:for-each>

                                                <!-- relation.volume-->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='volume']">
                        <datafield>
                        <xsl:attribute name="tag">036D</xsl:attribute>
                                <subfield>
                                <!--<xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:value-of select="doc:element/doc:field/text()" />-->
					<xsl:attribute name="code">l</xsl:attribute>
						<xsl:value-of select="substring-after(doc:element/doc:field/text(), ';')" />
                                </subfield>
				<subfield>
					<xsl:attribute name="code">X</xsl:attribute>
						<xsl:value-of select="substring-after(substring-before(//doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field/text(), ']'), 'Nr. ')" /><xsl:text>.</xsl:text>
						<xsl:value-of select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field/text()" />
				</subfield>
				<subfield>
					<xsl:attribute name="code">9</xsl:attribute>
						<xsl:text>101326097X</xsl:text>
				</subfield>
                        </datafield>
                        </xsl:for-each>
						
						

                        <!-- alternative title bei Karten Maßstab-->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element[@name='alternative']">
                        <datafield>
                        <xsl:attribute name="tag">035E</xsl:attribute>
                                <subfield>
                                <xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:value-of select="concat('1:', substring-after(doc:element/doc:field/text(), ':'))" />
                                </subfield>
                        </datafield>
                        </xsl:for-each>

                                                <!-- Koordinaten-->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element[@name='spatial']">
                        <datafield>
                        <xsl:attribute name="tag">035G</xsl:attribute>
                                <subfield>
                                <xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:value-of select="substring-before(doc:element/doc:field/text(), ' -')" />
                                </subfield>
								<subfield>
                                <xsl:attribute name="code">b</xsl:attribute>
                                        <xsl:value-of select="substring-before(substring-after(doc:element/doc:field/text(), ' - '), ' /')" />
                                </subfield>
								<subfield>
                                <xsl:attribute name="code">c</xsl:attribute>
                                        <xsl:value-of select="substring-before(substring-after(doc:element/doc:field/text(), ' / '), ' -')" />
                                </subfield>
								<subfield>
                                <xsl:attribute name="code">d</xsl:attribute>
                                       <xsl:if test="contains(doc:element/doc:field/text(), ' (Vorlage')">
					<xsl:value-of select="substring-before(substring-after(substring-after(doc:element/doc:field/text(), ' / '), ' - '), ' (Vorlage')" />
				       </xsl:if>
				       <xsl:if test="not(contains(doc:element/doc:field/text(), ' (Vorlage'))">
                                        <xsl:value-of select="substring-after(substring-after(doc:element/doc:field/text(), ' / '), ' - ')" />
                                       </xsl:if>
                                </subfield>
                        </datafield>
                        </xsl:for-each>
						
						<!-- Vorlage Koordinaten -->
                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element[@name='spatial']">
                        <datafield>
                        <xsl:attribute name="tag">035E</xsl:attribute>
                                <subfield>
                                <xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:text>In der Vorlage</xsl:text><xsl:value-of select="substring-after(substring-before(doc:element/doc:field/text(), ')'), 'Vorlage:')" />
                                </subfield>
                        </datafield>
                        </xsl:for-each>

                        <!-- Digitalisierungsangaben -->
                                                <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='source']">
                                                                                <datafield>
                                                        <xsl:attribute name="tag">009A</xsl:attribute>
                                                                <subfield>
                                                                                <xsl:attribute name="code">a</xsl:attribute>
                                                                                <xsl:value-of select="doc:element[@name='signature']/doc:element/doc:field/text()" />
                                                                </subfield>
																<subfield>
                                                                                <xsl:attribute name="code">b</xsl:attribute>
                                                                                
                                                                                                  <xsl:text>XA-DE</xsl:text>
                                                                                                                                                    
                                                                </subfield>
																<subfield>
                                                                                <xsl:attribute name="code">c</xsl:attribute>
                                                                                  <xsl:value-of select="doc:element[@name='owner']/doc:element/doc:field/text()" />
                                                                                 
                                                                </subfield>
                                        </datafield>
                                                </xsl:for-each>


                                                <!-- Subjects -->
                                                <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element[@name='ddc']/doc:element/doc:field">
                                                                                <datafield>
                                                        <xsl:attribute name="tag">0045F</xsl:attribute>
                                                                <subfield>
                                                                                <xsl:attribute name="code">a</xsl:attribute>
                                                                                <xsl:value-of select="." />

                                                                </subfield>
                                        </datafield>
                                                </xsl:for-each>
                                                <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element[@name='fid']">
                                                                                <datafield>
                                                        <xsl:attribute name="tag">0045V</xsl:attribute>
                                                                <subfield>
                                                                                <xsl:attribute name="code">a</xsl:attribute>
                                                                                <xsl:value-of select="doc:element/doc:field/text()" />

                                                                </subfield>
                                        </datafield>
                                                </xsl:for-each>
                                                <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element[@name='free']/doc:element/doc:field">
                                                                                <datafield>
                                                        <xsl:attribute name="tag">0045T</xsl:attribute>
                                                                <subfield>
                                                                                <xsl:attribute name="code">a</xsl:attribute>
                                                                                <xsl:value-of select="." />

                                                                </subfield>
                                        </datafield>
                                                </xsl:for-each>


                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element[@name='other']">

                                        <datafield>
                                        <xsl:attribute name="tag">209O</xsl:attribute>
                                        <xsl:attribute name="occurence"><xsl:value-of select="concat('0', position())" /></xsl:attribute>
                                                <subfield>
                                                <xsl:attribute name="code">a</xsl:attribute>
                                                        <xsl:value-of select="doc:element/doc:field" />
                                                </subfield>
                                        </datafield>

                        </xsl:for-each>

                        <!-- abstracts -->

                        <xsl:for-each select="//doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element">
                                <xsl:if test="contains(@name, 'abstract')">
                                        <datafield>
                                        <xsl:attribute name="tag">047I</xsl:attribute>
                                                <subfield>
                                                <xsl:attribute name="code">a</xsl:attribute>
                                                        <xsl:variable name="head"><xsl:value-of select="substring(normalize-space(doc:element/doc:field), 1, 597)" /></xsl:variable>
                                                        <xsl:variable name="tail"><xsl:value-of select="substring(normalize-space(doc:element/doc:field), 598, 620)" /></xsl:variable>
                                                        <xsl:value-of select="concat($head, substring-before($tail, ' '))"/>
                                                        <xsl:if test="string-length(/doc:element/doc:field &gt; 597)">
                                                                        <xsl:text>...</xsl:text>
                                                        </xsl:if>
                                                </subfield>
                                        </datafield>
                                </xsl:if>
                        </xsl:for-each>
                </xsl:if>

                </picaxml>
        </xsl:template>

</xsl:stylesheet>


