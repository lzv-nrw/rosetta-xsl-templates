<xsl:stylesheet xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:mix="http://www.loc.gov/mix/v20"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:dv="http://dfg-viewer.de/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:vl="http://visuallibrary.net/vl"
                xmlns:vls="http://semantics.de/vls"
                xmlns:marcxml="http://www.loc.gov/MARC21/slim"
                xmlns:epicur="urn:nbn:de:1111-2004033116"
                xmlns:zvdd="http://zvdd.gdz-cms.de/"
                xmlns:vlz="http://visuallibrary.net/vlz/1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xsl"
                version="1.0">
    <xsl:output method="xml"
                indent="yes"
                encoding="UTF-8" />
    <xsl:variable name="oai_id"
                  select="//oai:record/oai:header/oai:identifier" />
    <xsl:variable name="dmd_id"
                  select="concat('md',substring-after($oai_id,'de:'))" />
    <xsl:variable name="rel_dmd_id"
                  select="//mets:structMap/mets:div/mets:div/@DMDID" />
    <xsl:template match="/">
        <xsl:apply-templates select="." />
    </xsl:template>
    <xsl:template match="/">
        <mets:mets xmlns:mets="http://www.loc.gov/METS/">
            <mets:dmdSec ID="ie-dmd">
                <mets:mdWrap MDTYPE="DC">
                    <mets:xmlData>
                        <dc:record xmlns:dc="http://purl.org/dc/elements/1.1/"
                                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                            <!-- map mods md into dc -->
                            <xsl:apply-templates select="//mets:dmdSec/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/oai_dc:dc"
                                                 mode="mods2dc" />
                        </dc:record>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:dmdSec>
            <!-- IE AMD Section -->
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
                            <!-- copy dmdSec to sourceMD -->
                            <xsl:apply-templates select="//mets:dmdSec" />
                            <!-- copy fileSec to sourceMD -->
                            <xsl:apply-templates select="//mets:fileSec" />
                            <!-- copy structMap ID="physical" to sourceMD -->
                            <xsl:apply-templates select="//mets:structMap[@TYPE='physical']"
                                                 mode="structMap" />
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
            <xsl:apply-templates select="//mets:fileSec"
                                 mode="fileSec" />
        </mets:mets>
    </xsl:template>
    <!-- mods SECTION Copy original dmdSec Data to sourceMD/dmdSec -->
    <xsl:template match="mets:dmdSec">
        <xsl:copy-of select="." />
    </xsl:template>
    <!-- mods SECTION Copy original fileSec Data to sourceMD/admSec -->
    <xsl:template match="mets:fileSec">
        <xsl:copy-of select="." />
    </xsl:template>
    <!-- mods SECTION Copy original structMap Data to sourceMD/structMap -->
    <xsl:template match="mets:structMap[@TYPE='physical']"
                  mode="structMap">
        <xsl:copy-of select="." />
    </xsl:template>
    <!-- DVRights Section -->
    <xsl:template match="mets:amdSec/mets:rightsMD">
        <mets:rightsMD>
            <xsl:attribute name="ID">
                <xsl:value-of select="./@ID" />
            </xsl:attribute>
            <xsl:for-each select="mets:mdWrap">
                <xsl:attribute name="MIMETYPE">
                    <xsl:value-of select="./@MIMETYPE" />
                </xsl:attribute>
                <xsl:attribute name="MDTYPE">
                    <xsl:value-of select="./@MDTYPE" />
                </xsl:attribute>
                <xsl:attribute name="OTHERMDTYPE">
                    <xsl:value-of select="./@OTHERMDTYPE" />
                </xsl:attribute>
                <mets:mdWrap>
                    <xsl:copy-of select="mets:xmlData" />
                </mets:mdWrap>
            </xsl:for-each>
        </mets:rightsMD>
    </xsl:template>
    <!-- digiProv Section -->
    <xsl:template match="mets:amdSec/mets:digiprovMD">
        <mets:digiprovMD>
            <xsl:attribute name="ID">
                <xsl:value-of select="./@ID" />
            </xsl:attribute>
            <xsl:for-each select="mets:mdWrap">
                <xsl:attribute name="MIMETYPE">
                    <xsl:value-of select="./@MIMETYPE" />
                </xsl:attribute>
                <xsl:attribute name="MDTYPE">
                    <xsl:value-of select="./@MDTYPE" />
                </xsl:attribute>
                <xsl:attribute name="OTHERMDTYPE">
                    <xsl:value-of select="./@OTHERMDTYPE" />
                </xsl:attribute>
                <mets:mdWrap>
                    <xsl:copy-of select="mets:xmlData" />
                </mets:mdWrap>
            </xsl:for-each>
        </mets:digiprovMD>
    </xsl:template>
    <!-- amdSec Representation specific Section -->
    <xsl:template match="mets:fileSec"
                  mode="repres">
        <xsl:variable name="representationID"
                      select="concat('rep', position(), '-amd')" />
        <xsl:variable name="preservationType"
                      select="./@USE" />
        <mets:amdSec>
            <xsl:attribute name="ID">
                <xsl:value-of select="$representationID" />
            </xsl:attribute>
            <mets:techMD>
                <xsl:attribute name="ID">
                    <xsl:value-of select="concat($representationID, '-tech')" />
                </xsl:attribute>
                <mets:mdWrap MDTYPE="OTHER"
                             OTHERMDTYPE="dnx">
                    <mets:xmlData>
                        <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                            <section id="generalRepCharacteristics">
                                <record>
                                    <key id="preservationType">PRESERVATION_MASTER</key>
                                    <key id="representationEntityType">MASTER</key>
                                    <key id="usageType">VIEW</key>
                                </record>
                            </section>
                        </dnx>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:techMD>
        </mets:amdSec>
    </xsl:template>
    <!-- amdSec File specific Section -->
    <xsl:template match="mets:fileSec"
                  mode="file">
        <xsl:variable name="representationPos"
                      select="1" />
        <xsl:for-each select="./mets:fileGrp/mets:file">
            <xsl:variable name="fileMIMEType"
                          select="./@MIMETYPE" />
            <xsl:variable name="fileFixityType"
                          select="./@CHECKSUMTYPE" />
            <xsl:variable name="fileChecksum"
                          select="./@CHECKSUM" />
            <xsl:variable name="fileName"
                          select="./mets:FLocat/@xlink:href" />
            <xsl:variable name="filePos"
                          select="position()" />
            <xsl:variable name="fileID"
                          select="./@ID" />
            <xsl:variable name="fileSizeBytes"
                          select="./@SIZE" />
            <xsl:variable name="fileCreationDate"
                          select="./@CREATED" />
            <mets:amdSec>
                <xsl:attribute name="ID">
                    <xsl:value-of select="concat('fid', $filePos, '-', $representationPos, '-amd')" />
                </xsl:attribute>
                <mets:techMD>
                    <xsl:attribute name="ID">
                        <xsl:value-of select="concat('fid', $filePos, '-', $representationPos, '-amd-tech')" />
                    </xsl:attribute>
                    <mets:mdWrap MDTYPE="OTHER"
                                 OTHERMDTYPE="dnx">
                        <mets:xmlData>
                            <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                                <section id="generalFileCharacteristics">
                                    <record>
                                        <key id="fileOriginalPath">
                                            <xsl:choose>
                                                <xsl:when test="../@USE='MASTER' and $filePos=1">
                                                    <xsl:value-of select="$LabelMaster/FileLabel[@label=$fileID]" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$LabelAttachment/FileLabel[@label=$fileID]" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </key>
                                        <key id="fileMIMEType">
                                            <xsl:value-of select="$fileMIMEType" />
                                        </key>
                                        <xsl:if test="$fileSizeBytes">
                                            <key id="fileSizeBytes">
                                                <xsl:value-of select="$fileSizeBytes" />
                                            </key>
                                        </xsl:if>
                                        <xsl:if test="$fileCreationDate">
                                            <key id="fileCreationDate">
                                                <xsl:value-of select="$fileCreationDate" />
                                            </key>
                                        </xsl:if>
                                    </record>
                                </section>
                                <xsl:choose>
                                    <xsl:when test="$fileChecksum != ''">
                                        <section id="fileFixity">
                                            <record>
                                                <key id="fixityType">
                                                    <xsl:value-of select="$fileFixityType" />
                                                </key>
                                                <key id="fixityValue">
                                                    <xsl:value-of select="$fileChecksum" />
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
        </xsl:for-each>
    </xsl:template>
    <!-- mets:fileSec Section -->
    <xsl:template match="mets:fileSec"
                  mode="fileSec">
        <xsl:apply-templates select="."
                             mode="repres" />
        <xsl:apply-templates select="."
                             mode="file" />
        <mets:fileSec>
            <xsl:for-each select=".">
                <xsl:variable name="pos"
                              select="1" />
                <mets:fileGrp>
                    <xsl:attribute name="USE">
                        <xsl:value-of select="'VIEW'" />
                    </xsl:attribute>
                    <xsl:attribute name="ID">
                        <xsl:value-of select="concat('rep', $pos)" />
                    </xsl:attribute>
                    <xsl:attribute name="ADMID">
                        <xsl:value-of select="concat('rep', $pos, '-amd')" />
                    </xsl:attribute>
                    <xsl:for-each select="mets:fileGrp/mets:file">
                        <xsl:variable name="filePos">
                            <xsl:value-of select="position()" />
                        </xsl:variable>
                        <mets:file>
                            <xsl:attribute name="MIMETYPE">
                                <xsl:value-of select="./@MIMETYPE" />
                            </xsl:attribute>
                            <xsl:attribute name="ID">
                                <xsl:value-of select="concat('fid', $filePos, '-', $pos)" />
                            </xsl:attribute>
                            <xsl:attribute name="ADMID">
                                <xsl:value-of select="concat('fid', $filePos, '-', $pos, '-amd')" />
                            </xsl:attribute>
                            <mets:FLocat>
                                <xsl:attribute name="LOCTYPE">
                                    <xsl:value-of select="./mets:FLocat/@LOCTYPE" />
                                </xsl:attribute>
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="./mets:FLocat/@xlink:href" />
                                </xsl:attribute>
                            </mets:FLocat>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
            </xsl:for-each>
        </mets:fileSec>
        <!-- mets:structMap LOGICAL Section -->
        <xsl:for-each select=".">
            <xsl:variable name="pos"
                          select="1" />
            <mets:structMap>
                <xsl:attribute name="TYPE">
                    <xsl:value-of select="'LOGICAL'" />
                </xsl:attribute>
                <xsl:attribute name="ID">
                    <xsl:value-of select="concat('rep', $pos, '-1')" />
                </xsl:attribute>
                <mets:div>
                    <xsl:for-each select="./mets:fileGrp/mets:file">
                        <xsl:variable name="fileMIMEType"
                                      select="./@MIMETYPE" />
                        <xsl:variable name="fileID"
                                      select="./@ID" />
                        <xsl:variable name="filePos"
                                      select="position()" />
                        <mets:div>
                            <xsl:attribute name="TYPE">
                                <xsl:value-of select="'FILE'" />
                            </xsl:attribute>
                            <xsl:attribute name="LABEL">
                                <xsl:choose>
                                    <xsl:when test="../@USE='MASTER' and $filePos=1">
                                        <xsl:value-of select="$LabelMaster/FileLabel[@label=$fileID]" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$LabelAttachment/FileLabel[@label=$fileID]" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <mets:fptr>
                                <xsl:attribute name="FILEID">
                                    <xsl:value-of select="concat('fid', $filePos, '-', $pos)" />
                                </xsl:attribute>
                            </mets:fptr>
                        </mets:div>
                    </xsl:for-each>
                </mets:div>
            </mets:structMap>
        </xsl:for-each>
    </xsl:template>
    <!-- mods2DC SECTION generate DC from mods (Mapping) -->
    <xsl:template match="*"
                  mode="mods">
        <xsl:element name="mods:{name()}"
                     namespace="http://www.loc.gov/mods/v3">
            <xsl:copy-of select="namespace::*" />
            <xsl:apply-templates mode="mods" />
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*|text()"
                  mode="copy">
        <xsl:copy>
            <xsl:apply-templates mode="copy" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*"
                  mode="copy">
        <xsl:element name="{name()}">
            <xsl:apply-templates mode="copy" />
        </xsl:element>
    </xsl:template>
    <!-- DMD section - generate DC from mods -->
    <!-- Set mapping -->
    <xsl:template match="//mets:dmdSec/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/oai_dc:dc"
                  mode="mods2dc">
        <xsl:for-each select="./oai_dc:title">
            <dc:title>
                <xsl:value-of select="." />
            </dc:title>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:creator">
            <dc:creator>
                <xsl:value-of select="." />
            </dc:creator>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:contributor">
            <dc:contributor>
                <xsl:value-of select="." />
            </dc:contributor>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:subject">
            <dc:subject>
                <xsl:value-of select="." />
            </dc:subject>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:description">
            <dc:description>
                <xsl:value-of select="." />
            </dc:description>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:publisher">
            <dc:publisher>
                <xsl:value-of select="." />
            </dc:publisher>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:date">
            <dc:date>
                <xsl:value-of select="." />
            </dc:date>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:type">
            <dc:type>
                <xsl:value-of select="." />
            </dc:type>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:extent">
            <dcterms:extent>
                <xsl:value-of select="." />
            </dcterms:extent>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:identifier">
            <dc:identifier>
                <xsl:value-of select="." />
            </dc:identifier>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:language">
            <dc:language>
                <xsl:value-of select="." />
            </dc:language>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:coverage">
            <dc:coverage>
                <xsl:value-of select="." />
            </dc:coverage>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:format">
            <dc:format>
                <xsl:value-of select="." />
            </dc:format>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:relation">
            <dc:relation>
                <xsl:value-of select="." />
            </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:source">
            <dc:source>
                <xsl:value-of select="." />
            </dc:source>
        </xsl:for-each>
        <xsl:for-each select="./oai_dc:rights">
            <dc:rights>
                <xsl:value-of select="." />
            </dc:rights>
        </xsl:for-each>
    </xsl:template>
    <!-- </xsl:template> -->
    <xsl:template match="node()"
                  mode="mods2dc">
        <xsl:apply-templates mode="mods2dc" />
    </xsl:template>
    <!-- mets:structMap PHYSICAL Section -->
    <xsl:template match="mets:structMap[@TYPE='PHYSICAL']">
        <mets:structMap>
            <xsl:attribute name="TYPE">
                <xsl:value-of select="./@TYPE" />
            </xsl:attribute>
            <xsl:attribute name="ID">
                <xsl:value-of select="concat('structMap-', ./@TYPE, '-', position())" />
            </xsl:attribute>
            <mets:div>
                <xsl:apply-templates select="mets:div/mets:div"
                                     mode="phys" />
            </mets:div>
        </mets:structMap>
    </xsl:template>
    <!-- mets:structMap LOGICAL Section -->
    <xsl:template match="mets:structMap[@TYPE='LOGICAL']">
        <mets:structMap>
            <xsl:attribute name="TYPE">
                <xsl:value-of select="./@TYPE" />
            </xsl:attribute>
            <xsl:attribute name="ID">
                <xsl:value-of select="concat('structMap-', ./@TYPE, '-', position())" />
            </xsl:attribute>
            <mets:div>
                <xsl:apply-templates select="mets:div/mets:div"
                                     mode="logic" />
            </mets:div>
        </mets:structMap>
    </xsl:template>
    <!-- List file labels -->
    <!-- Master -->
    <xsl:variable name="LabelMaster">
        <xsl:for-each select="//mets:structMap/mets:div">
            <FileLabel label="{./mets:fptr/@FILEID}">
                <xsl:choose>
                    <xsl:when test="not(./@LABEL)">
                        <xsl:text>No label</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./@LABEL" />
                    </xsl:otherwise>
                </xsl:choose>
            </FileLabel>
        </xsl:for-each>
    </xsl:variable>
    <!-- Download -->
    <xsl:variable name="LabelAttachment">
        <xsl:for-each select="//mets:structMap/mets:div/mets:div">
            <FileLabel label="{./mets:fptr/@FILEID}">
                <xsl:choose>
                    <xsl:when test="not(./@LABEL)">
                        <xsl:text>No label</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./@LABEL" />
                    </xsl:otherwise>
                </xsl:choose>
            </FileLabel>
        </xsl:for-each>
    </xsl:variable>
    <!-- Templates by default : do nothing -->
    <xsl:template match="@*|node()" />
</xsl:stylesheet>