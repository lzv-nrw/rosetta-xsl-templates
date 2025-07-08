<xsl:stylesheet xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:xoai="http://www.lyncode.com/xoai"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xMetaDiss="http://www.d-nb.de/standards/xmetadissplus/"
                xmlns:pc="http://www.d-nb.de/standards/pc/"
                xmlns:cc="http://www.d-nb.de/standards/cc/"
                xmlns:ddb="http://www.d-nb.de/standards/ddb/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xsl"
                version="1.0">
    <xsl:output method="xml"
                indent="yes"
                encoding="UTF-8" />
    <xsl:template match="/">
        <xsl:apply-templates select="//xoai:metadata" />
    </xsl:template>
    <xsl:template match="xoai:metadata">
        <mets:mets xmlns:mets="http://www.loc.gov/METS/">
            <!-- IE DMD Section -->
            <mets:dmdSec ID="ie-dmd">
                <mets:mdWrap MDTYPE="DC">
                    <mets:xmlData>
                        <dc:record xmlns:dc="http://purl.org/dc/elements/1.1/"
                                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                            <xsl:for-each select="//xoai:element[@name='date']/xoai:element[@name='issued']/xoai:element/xoai:field">
                                <dc:date>
                                    <xsl:value-of select="." />
                                </dc:date>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='description']/xoai:element[@name='tableofcontents']/xoai:element/xoai:field">
                                <dc:description>
                                    <xsl:value-of select="." />
                                </dc:description>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='identifier']/xoai:element[@name='uri']/xoai:element/xoai:field">
                                <dc:identifier>
                                    <xsl:value-of select="." />
                                </dc:identifier>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='language']/xoai:element/xoai:element/xoai:field">
                                <dc:language>
                                    <xsl:value-of select="." />
                                </dc:language>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='publisher']/xoai:element/xoai:field">
                                <dc:publisher>
                                    <xsl:value-of select="." />
                                </dc:publisher>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='subject']/xoai:element[@name='ddc']/xoai:field">
                                <dc:publisher>
                                    <xsl:value-of select="concat('DDC: ',.)" />
                                </dc:publisher>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='title']/xoai:element/xoai:field">
                                <dc:title>
                                    <xsl:value-of select="." />
                                </dc:title>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='type']/xoai:element[@name='none']/xoai:field">
                                <dc:type>
                                    <xsl:value-of select="." />
                                </dc:type>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='type']/xoai:element[@name='publicationtype']/xoai:element[@name='none']/xoai:field">
                                <dc:type>
                                    <xsl:value-of select="." />
                                </dc:type>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='accessRights']/xoai:element/xoai:field">
                                <dc:rights>
                                    <xsl:value-of select="." />
                                </dc:rights>
                            </xsl:for-each>
                            <xsl:for-each select="//xoai:element[@name='eldorado']/xoai:element[@name='dnb']/xoai:element[@name='zdberstkatid']//xoai:element/xoai:field">
                                <dc:identifier>
                                    <xsl:value-of select="concat('[ZDB-ID]',.)" />
                                </dc:identifier>
                            </xsl:for-each>
                        </dc:record>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:dmdSec>
            <!-- IE AMDMD Section -->
            <mets:amdSec ID="ie-amd">
                <mets:techMD ID="ie-amd-tech">
                    <mets:mdWrap MDTYPE="OTHER"
                                 OTHERMDTYPE="dnx">
                        <mets:xmlData>
                            <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                                <section id="objectIdentifier" />
                            </dnx>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:techMD>
                <mets:rightsMD ID="ie-amd-rights">
                    <mets:mdWrap MDTYPE="OTHER"
                                 OTHERMDTYPE="dnx">
                        <mets:xmlData>
                            <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                                <section id="accessRightsPolicy" />
                            </dnx>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:rightsMD>
                <mets:sourceMD ID="ie-amd-source-OTHER">
                    <mets:mdWrap MDTYPE="OTHER"
                                 OTHERMDTYPE="Text">
                        <mets:xmlData>
                            <!-- copy / to sourceMD -->
                            <xsl:copy-of select="//oai:record" />
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:sourceMD>
                <mets:digiprovMD ID="ie-amd-digiprov">
                    <mets:mdWrap MDTYPE="OTHER"
                                 OTHERMDTYPE="dnx">
                        <mets:xmlData>
                            <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx" />
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:digiprovMD>
            </mets:amdSec>
            <!-- amdSec Representation specific Section -->
            <mets:amdSec ID="rep1-amd">
                <mets:techMD ID="rep1-amd-tech">
                    <mets:mdWrap MDTYPE="OTHER"
                                 OTHERMDTYPE="dnx">
                        <mets:xmlData>
                            <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                                <section id="generalRepCharacteristics">
                                    <record>
                                        <key id="preservationType">PRESERVATION_MASTER</key>
                                        <key id="usageType">VIEW</key>
                                    </record>
                                </section>
                            </dnx>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:techMD>
            </mets:amdSec>
            <!-- amdSec File specific Section -->
            <xsl:for-each select="//xoai:element[@name='bundles']/xoai:element[@name='bundle']">
                <xsl:if test="./xoai:field='ORIGINAL' or ./xoai:field='LICENSE'">
                    <xsl:variable name="filePos"
                                  select="position()" />
                    <mets:amdSec>
                        <xsl:attribute name="ID">
                            <xsl:value-of select="concat('fid', position(), '-1', '-amd')" />
                        </xsl:attribute>
                        <mets:techMD>
                            <xsl:attribute name="ID">
                                <xsl:value-of select="concat('fid', position(), '-1', '-amd-tech')" />
                            </xsl:attribute>
                            <mets:mdWrap MDTYPE="OTHER"
                                         OTHERMDTYPE="dnx">
                                <mets:xmlData>
                                    <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                                        <section id="generalFileCharacteristics">
                                            <record>
                                                <key id="fileOriginalName">
                                                    <xsl:value-of select="./xoai:element/xoai:element/xoai:field[@name='originalName']" />
                                                </key>
                                                <key id="fileSizeBytes">
                                                    <xsl:value-of select="./xoai:element/xoai:element/xoai:field[@name='size']" />
                                                </key>
                                                <key id="fileMIMEType">
                                                    <xsl:value-of select="./xoai:element/xoai:element/xoai:field[@name='format']" />
                                                </key>
                                            </record>
                                        </section>
                                        <xsl:choose>
                                            <xsl:when test="./xoai:element/xoai:element/xoai:field[@name='checksum']">
                                                <section id="fileFixity">
                                                    <record>
                                                        <key id="fixityType">
                                                            <xsl:value-of select="./xoai:element/xoai:element/xoai:field[@name='checksumAlgorithm']" />
                                                        </key>
                                                        <key id="fixityValue">
                                                            <xsl:value-of select="./xoai:element/xoai:element/xoai:field[@name='checksum']" />
                                                        </key>
                                                    </record>
                                                </section>
                                            </xsl:when>
                                        </xsl:choose>
                                    </dnx>
                                </mets:xmlData>
                            </mets:mdWrap>
                        </mets:techMD>
                    </mets:amdSec>
                </xsl:if>
            </xsl:for-each>
            <!-- mets:fileSec Section -->
            <mets:fileSec>
                <mets:fileGrp USE="VIEW"
                              ID="rep1"
                              ADMID="rep1-amd">
                    <xsl:for-each select="//xoai:element[@name='bundles']/xoai:element[@name='bundle']">
                        <xsl:if test="./xoai:field='ORIGINAL' or ./xoai:field='LICENSE'">
                            <mets:file>
                                <xsl:attribute name="ID">
                                    <xsl:value-of select="concat('fid', position(), '-1')" />
                                </xsl:attribute>
                                <xsl:attribute name="ADMID">
                                    <xsl:value-of select="concat('fid', position(), '-1-amd')" />
                                </xsl:attribute>
                                <mets:FLocat>
                                    <xsl:attribute name="LOCTYPE">
                                        <xsl:text>URL</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="xlink:href">
                                        <xsl:value-of select="./xoai:element/xoai:element/xoai:field[@name='url']" />
                                    </xsl:attribute>
                                </mets:FLocat>
                            </mets:file>
                        </xsl:if>
                    </xsl:for-each>
                </mets:fileGrp>
            </mets:fileSec>
        </mets:mets>
    </xsl:template>
</xsl:stylesheet>