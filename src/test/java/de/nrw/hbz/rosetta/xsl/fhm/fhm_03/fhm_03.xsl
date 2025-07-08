<xsl:stylesheet xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:str="http://exslt.org/strings"
                exclude-result-prefixes="xsl"
                version="1.0">
    <xsl:output method="xml"
                indent="yes"
                encoding="UTF-8" />
    <xsl:template match="/">
        <xsl:apply-templates select="//oai_dc:dc" />
    </xsl:template>
    <xsl:template name="replace-string">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="with" />
        <xsl:choose>
            <xsl:when test="contains($text,$replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$with" />
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="text"
                                    select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace"
                                    select="$replace" />
                    <xsl:with-param name="with"
                                    select="$with" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//oai_dc:dc">
        <mets:mets xmlns:mets="http://www.loc.gov/METS/">
            <!-- IE DMD Section -->
            <mets:dmdSec ID="ie-dmd">
                <mets:mdWrap MDTYPE="DC">
                    <mets:xmlData>
                        <dc:record xmlns:dc="http://purl.org/dc/elements/1.1/"
                                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                            <xsl:for-each select="./dc:title">
                                <dc:title>
                                    <xsl:value-of select="." />
                                </dc:title>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:creator">
                                <dc:creator>
                                    <xsl:value-of select="." />
                                </dc:creator>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:contributor">
                                <dc:contributor>
                                    <xsl:value-of select="." />
                                </dc:contributor>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:subject">
                                <dc:subject>
                                    <xsl:value-of select="." />
                                </dc:subject>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:description">
                                <dc:description>
                                    <xsl:value-of select="." />
                                </dc:description>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:publisher">
                                <dc:publisher>
                                    <xsl:value-of select="." />
                                </dc:publisher>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:date">
                                <dc:date>
                                    <xsl:value-of select="." />
                                </dc:date>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:type">
                                <dc:type>
                                    <xsl:value-of select="." />
                                </dc:type>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:format">
                                <dc:format>
                                    <xsl:value-of select="." />
                                </dc:format>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:identifier">
                                <dc:identifier>
                                    <xsl:value-of select="." />
                                </dc:identifier>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:language">
                                <dc:language>
                                    <xsl:value-of select="." />
                                </dc:language>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:relation">
                                <dc:relation>
                                    <xsl:value-of select="." />
                                </dc:relation>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:rights">
                                <dc:rights>
                                    <xsl:value-of select="." />
                                </dc:rights>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:source">
                                <dc:source>
                                    <xsl:value-of select="." />
                                </dc:source>
                            </xsl:for-each>
                            <xsl:for-each select="./dc:source">
                                <xsl:if test="contains(. , 'Nursing History')">
                                    <!-- First replace any semicolon by backslash and store in variable -->
                                    <xsl:variable name="replaceSemicolon">
                                        <xsl:call-template name="replace-string">
                                            <xsl:with-param name="text"
                                                            select="." />
                                            <xsl:with-param name="replace"
                                                            select="'; '" />
                                            <xsl:with-param name="with"
                                                            select="'\'" />
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <!-- replace any colon from variable by slash and store in variable -->
                                    <!-- <xsl:variable name="replaceColon">											<xsl:call-template name="replace-string">											  <xsl:with-param name="text" select="$replaceSemicolon"/>											  <xsl:with-param name="replace" select="&quot;): &quot;" />											  <xsl:with-param name="with" select="&quot;)/&quot;"/>											</xsl:call-template>										</xsl:variable> -->
                                    <xsl:variable name="isPartOf"
                                                  select="$replaceSemicolon" />
                                    <dc:collection>
                                        <xsl:value-of select="$isPartOf" />
                                    </dc:collection>
                                </xsl:if>
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
                                        <key id="DigitalOriginal">true</key>
                                    </record>
                                </section>
                            </dnx>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:techMD>
            </mets:amdSec>
            <!-- mets:fileSec Section -->
            <mets:fileSec>
                <mets:fileGrp USE="VIEW"
                              ID="rep1"
                              ADMID="rep1-amd">
                    <xsl:for-each select="//dc:relation">
                        <xsl:if test="contains(., 'article/view')">
                            <xsl:variable name="filePos"
                                          select="position()" />
                            <xsl:if test="../dc:format[$filePos]!='text/html'">
                                <mets:file>
                                    <xsl:attribute name="ID">
                                        <xsl:value-of select="concat('fid', position(), '-1')" />
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
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </mets:fileGrp>
            </mets:fileSec>
            <!-- mets:structMap LOGICAL Section -->
            <mets:structMap>
                <xsl:attribute name="TYPE">
                    <xsl:value-of select="'LOGICAL'" />
                </xsl:attribute>
                <xsl:attribute name="ID">
                    <xsl:value-of select="'rep1-1'" />
                </xsl:attribute>
                <mets:div>
                    <xsl:for-each select="//dc:relation">
                        <xsl:if test="contains(., 'article/view')">
                            <xsl:variable name="filePos"
                                          select="position()" />
                            <xsl:if test="not(../dc:format[$filePos]='text/html')">
                                <mets:div>
                                    <xsl:attribute name="TYPE">
                                        <xsl:value-of select="'FILE'" />
                                    </xsl:attribute>
                                    <mets:fptr>
                                        <xsl:attribute name="FILEID">
                                            <xsl:value-of select="concat('fid', $filePos, '-', 1)" />
                                        </xsl:attribute>
                                    </mets:fptr>
                                </mets:div>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </mets:div>
            </mets:structMap>
        </mets:mets>
    </xsl:template>
</xsl:stylesheet>