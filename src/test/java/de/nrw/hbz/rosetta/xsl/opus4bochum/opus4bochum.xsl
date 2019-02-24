<xsl:stylesheet xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dnx="http://www.exlibrisgroup.com/dps/dnx"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="1.0">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding="UTF-8" />
  <xsl:template match="/">
    <dc:record xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:dcterms="http://purl.org/dc/terms/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <xsl:if test="//oai_dc:dc">
        <xsl:for-each select="//dc:title">
          <dc:title>
            <xsl:value-of select="." />
          </dc:title>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:alternative">
          <dc:title>
            <xsl:value-of select="." />
          </dc:title>
        </xsl:for-each>
        <xsl:for-each select="//dc:creator">
          <dc:creator>
            <xsl:value-of select="." />
          </dc:creator>
        </xsl:for-each>
        <xsl:for-each select="//dc:subject">
          <dc:subject>
            <xsl:value-of select="." />
          </dc:subject>
        </xsl:for-each>
        <xsl:for-each select="//dc:description">
          <dc:description>
            <xsl:value-of select="." />
          </dc:description>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:tableOfContents">
          <dc:description>
            <xsl:value-of select="." />
          </dc:description>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:abstract">
          <dc:description>
            <xsl:value-of select="." />
          </dc:description>
        </xsl:for-each>
        <xsl:for-each select="//dc:publisher">
          <dc:publisher>
            <xsl:value-of select="." />
          </dc:publisher>
        </xsl:for-each>
        <xsl:for-each select="//dc:contributor">
          <dc:contributor>
            <xsl:value-of select="." />
          </dc:contributor>
        </xsl:for-each>
        <xsl:for-each select="//dc:date">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:created">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:valid">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:available">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:issued">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:modified">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:dateAccepted">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:dateCopyrighted">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:dateSubmitted">
          <dc:date>
            <xsl:value-of select="." />
          </dc:date>
        </xsl:for-each>
        <xsl:for-each select="//dc:type">
          <dc:type>
            <xsl:value-of select="." />
          </dc:type>
        </xsl:for-each>
        <xsl:for-each select="//dc:format">
          <dc:format>
            <xsl:value-of select="." />
          </dc:format>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:extent">
          <dc:format>
            <xsl:value-of select="." />
          </dc:format>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:medium">
          <dc:format>
            <xsl:value-of select="." />
          </dc:format>
        </xsl:for-each>
        <xsl:variable name="idnr">
          <xsl:for-each select="//dc:identifier[1]">
            <xsl:variable name="pattern">docId/</xsl:variable>
            <xsl:value-of select="substring-after(., $pattern)" />
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="//dc:identifier[last()]">
          <dc:identifier>
            <xsl:choose>
              <xsl:when test="contains(.,&apos;pdf&apos;)">
                <xsl:variable name="filename">
                  <xsl:value-of select="substring-after(., $idnr)" />
                </xsl:variable>
                <xsl:variable name="replace">/opus4/frontdoor/deliver/index/docId/</xsl:variable>
                <xsl:variable name="domain">/deposit_storage/source_file_streams/hssrub/hss-opus.ub.ruhr-uni-bochum.de</xsl:variable>
                <xsl:variable name="suppl">/file</xsl:variable>
                <xsl:value-of select="concat($domain, $replace, $idnr, $suppl, $filename)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="filename">diss.pdf</xsl:variable>
                <xsl:variable name="domain">/deposit_storage/source_file_streams/hssrub/hss-opus.ub.ruhr-uni-bochum.de</xsl:variable>
                <xsl:variable name="replace">/opus4/frontdoor/deliver/index/docId/</xsl:variable>
                <xsl:variable name="suppl">/file/</xsl:variable>
                <xsl:value-of select="concat($domain, $replace, $idnr, $suppl, $filename)" />
              </xsl:otherwise>
            </xsl:choose>
          </dc:identifier>
          <dc:source>
            <xsl:choose>
              <xsl:when test="contains(.,&apos;pdf&apos;)">
                <xsl:value-of select="." />
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="filename">diss.pdf</xsl:variable>
                <xsl:variable name="domain">https://hss-opus.ub.ruhr-uni-bochum.de</xsl:variable>
                <xsl:variable name="replace">/opus4/frontdoor/deliver/index/docId/</xsl:variable>
                <xsl:variable name="suppl">/file/</xsl:variable>
                <xsl:value-of select="concat($domain, $replace, $idnr, $suppl, $filename)" />
              </xsl:otherwise>
            </xsl:choose>
          </dc:source>
        </xsl:for-each>
        <xsl:for-each select="//dc:source">
          <dc:source>
            <xsl:value-of select="." />
          </dc:source>
        </xsl:for-each>
        <xsl:for-each select="//dc:language">
          <dc:language>
            <xsl:value-of select="." />
          </dc:language>
        </xsl:for-each>
        <xsl:for-each select="//dc:relation">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:isVersionOf">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:hasVersion">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:isReplacedBy">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:replaces">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:isRequiredBy">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:requires">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:isPartOf">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:hasPart">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:isReferencedBy">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:references">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:isFormatOf">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:hasFormat">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:conformsTo">
          <dc:relation>
            <xsl:value-of select="." />
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each select="//dc:coverage">
          <dc:coverage>
            <xsl:value-of select="." />
          </dc:coverage>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:spatial">
          <dc:coverage>
            <xsl:value-of select="." />
          </dc:coverage>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:temporal">
          <dc:coverage>
            <xsl:value-of select="." />
          </dc:coverage>
        </xsl:for-each>
        <xsl:for-each select="//dc:rights">
          <dc:rights>
            <xsl:value-of select="." />
          </dc:rights>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:accessRights">
          <dc:rights>
            <xsl:value-of select="." />
          </dc:rights>
        </xsl:for-each>
        <xsl:for-each select="//dcterms:license">
          <dc:rights>
            <xsl:value-of select="." />
          </dc:rights>
        </xsl:for-each>
      </xsl:if>
    </dc:record>
  </xsl:template>
</xsl:stylesheet>