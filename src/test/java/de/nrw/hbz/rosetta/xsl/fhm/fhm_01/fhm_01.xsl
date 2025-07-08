<xsl:stylesheet xmlns:oai="http://www.openarchives.org/OAI/2.0/"
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
        <xsl:apply-templates select="//xMetaDiss:xMetaDiss" />
    </xsl:template>
    <xsl:template match="xMetaDiss:xMetaDiss">
        <mets:mets xmlns:mets="http://www.loc.gov/METS/">
            <!-- IE DMD Section -->
            <mets:dmdSec ID="ie-dmd">
                <mets:mdWrap MDTYPE="DC">
                    <mets:xmlData>
                        <dc:record xmlns:dc="http://purl.org/dc/elements/1.1/"
                                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                            <xsl:for-each select="//dc:title">
                                <dc:title>
                                    <xsl:value-of select="." />
                                </dc:title>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:creator/pc:person/pc:name[@type='nameUsedByThePerson']">
                                <xsl:if test="../ddb:ORCID">
                                    <dc:creator>
                                        <xsl:value-of select="concat('ORCID: ', ../ddb:ORCID)" />
                                    </dc:creator>
                                </xsl:if>
                                <dc:creator>
                                    <xsl:value-of select="concat(./pc:surName,', ', ./pc:foreName)" />
                                </dc:creator>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:creator/pc:person/pc:name[@otherNameType='organisation']">
                                <dc:contributor>
                                    <xsl:value-of select="concat('Körperschaft: ', ./pc:organisationName)" />
                                </dc:contributor>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:contributor">
                                <xsl:if test="./pc:person/ddb:ORCID">
                                    <dc:contributor>
                                        <xsl:value-of select="concat('ORCID: ', ./pc:person/ddb:ORCID)" />
                                    </dc:contributor>
                                </xsl:if>
                                <dc:contributor>
                                    <xsl:value-of select="concat('Herausgeber*in: ', ./pc:person//pc:name/pc:surName,', ', ./pc:person/pc:name/pc:foreName)" />
                                </dc:contributor>
                            </xsl:for-each>
                            <xsl:for-each select="//dcterms:issued">
                                <dcterms:created>
                                    <xsl:value-of select="." />
                                </dcterms:created>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:subject">
                                <dc:subject>
                                    <xsl:value-of select="." />
                                </dc:subject>
                            </xsl:for-each>
                            <xsl:for-each select="//dcterms:abstract">
                                <dcterms:abstract>
                                    <xsl:value-of select="." />
                                </dcterms:abstract>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:description">
                                <dc:description>
                                    <xsl:value-of select="." />
                                </dc:description>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:publisher">
                                <dc:publisher>
                                    <xsl:value-of select="./cc:universityOrInstitution/cc:name" />
                                </dc:publisher>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:date">
                                <dc:date>
                                    <xsl:value-of select="." />
                                </dc:date>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:type">
                                <dc:type>
                                    <xsl:value-of select="." />
                                </dc:type>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:identifier">
                                <dc:identifier>
                                    <xsl:choose>
                                        <xsl:when test="contains(./@xsi:type, 'urn:nbn')">
                                            <xsl:value-of select="concat('URN: ', .)" />
                                        </xsl:when>
                                        <xsl:when test="contains(./@xsi:type, 'DOI')">
                                            <xsl:value-of select="concat('DOI: ', .)" />
                                        </xsl:when>
                                        <xsl:when test="contains(./@xsi:type, 'URL')">
                                            <xsl:value-of select="concat('URL: ', .)" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="." />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </dc:identifier>
                            </xsl:for-each>
                            <xsl:for-each select="//dcterms:medium">
                                <dcterms:medium>
                                    <xsl:value-of select="." />
                                </dcterms:medium>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:language">
                                <dc:language>
                                    <xsl:value-of select="." />
                                </dc:language>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:coverage">
                                <dc:coverage>
                                    <xsl:value-of select="." />
                                </dc:coverage>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:format">
                                <dc:format>
                                    <xsl:value-of select="." />
                                </dc:format>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:relation">
                                <dc:relation>
                                    <xsl:value-of select="." />
                                </dc:relation>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:source">
                                <dc:source>
                                    <xsl:value-of select="." />
                                </dc:source>
                            </xsl:for-each>
                            <xsl:for-each select="//dc:rights">
                                <dc:rights>
                                    <xsl:value-of select="." />
                                </dc:rights>
                            </xsl:for-each>
                            <xsl:for-each select="//dcterms:isPartOf">
                                <dcterms:isPartOf>
                                    <xsl:value-of select="." />
                                </dcterms:isPartOf>
                            </xsl:for-each>
                            <xsl:for-each select="//dcterms:hasPart">
                                <dcterms:hasPart>
                                    <xsl:value-of select="." />
                                </dcterms:hasPart>
                            </xsl:for-each>
                            <xsl:for-each select="//ddb:transfer">
                                <dc:identifier>
                                    <xsl:value-of select="concat('URI: ',.)" />
                                </dc:identifier>
                            </xsl:for-each>
                            <xsl:for-each select="//ddb:identifier ">
                                <dc:identifier>
                                    <xsl:choose>
                                        <xsl:when test="contains(./@ddb:type, 'urn:nbn')">
                                            <xsl:value-of select="concat('URN: ', .)" />
                                        </xsl:when>
                                        <xsl:when test="contains(./@ddb:type, 'DOI')">
                                            <xsl:value-of select="concat('DOI: ', .)" />
                                        </xsl:when>
                                        <xsl:when test="contains(./@ddb:type, 'URL')">
                                            <xsl:value-of select="concat('URL: ', .)" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="." />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </dc:identifier>
                            </xsl:for-each>
                            <xsl:for-each select="//ddb:rights">
                                <dc:rights>
                                    <xsl:value-of select="./@ddb:kind" />
                                </dc:rights>
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
            <xsl:for-each select="//ddb:fileProperties">
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
                                                <xsl:value-of select="./@ddb:fileName" />
                                            </key>
                                            <key id="fileSizeBytes">
                                                <xsl:value-of select="./@ddb:fileSize" />
                                            </key>
                                            <key id="note">
                                                <xsl:value-of select="concat('Original File ID: ', ./@ddb:fileID)" />
                                            </key>
                                        </record>
                                    </section>
                                </dnx>
                            </mets:xmlData>
                        </mets:mdWrap>
                    </mets:techMD>
                </mets:amdSec>
            </xsl:for-each>
            <!-- mets:fileSec Section -->
            <mets:fileSec>
                <mets:fileGrp USE="VIEW"
                              ID="rep1"
                              ADMID="rep1-amd">
                    <xsl:choose>
                        <xsl:when test="count(//ddb:fileProperties) > 1">
                            <xsl:variable name="frontdoorLink"
                                          select="//ddb:identifier[@ddb:type='URL']" />
                            <xsl:variable name="frontdoorContent"
                                          select="document($frontdoorLink)" />
                            <xsl:for-each select="//ddb:fileProperties">
                                <xsl:variable name="position"
                                              select="position()" />
                                <xsl:variable name="fileName"
                                              select="./@ddb:fileName" />
                                <mets:file>
                                    <xsl:for-each select="$frontdoorContent/child::*/child::*/child::*">
                                        <xsl:if test="./name()='meta'">
                                            <xsl:if test="./@name='DC.identifier'">
                                                <xsl:if test="contains(./@content,$fileName)">
                                                    <xsl:attribute name="ID">
                                                        <xsl:value-of select="concat('fid', $position, '-1')" />
                                                    </xsl:attribute>
                                                    <xsl:attribute name="ADMID">
                                                        <xsl:value-of select="concat('fid', $position, '-1-amd')" />
                                                    </xsl:attribute>
                                                    <mets:FLocat>
                                                        <xsl:attribute name="LOCTYPE">
                                                            <xsl:text>URL</xsl:text>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="xlink:href">
                                                            <xsl:value-of select="./@content" />
                                                        </xsl:attribute>
                                                    </mets:FLocat>
                                                </xsl:if>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:for-each>
                                </mets:file>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="//ddb:transfer">
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
                                            <xsl:value-of select="." />
                                        </xsl:attribute>
                                    </mets:FLocat>
                                </mets:file>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </mets:fileGrp>
            </mets:fileSec>
        </mets:mets>
    </xsl:template>
</xsl:stylesheet>