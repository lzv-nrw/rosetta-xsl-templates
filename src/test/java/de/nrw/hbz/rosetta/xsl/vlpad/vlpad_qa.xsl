<xsl:stylesheet
	xmlns:oai="http://www.openarchives.org/OAI/2.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:mix="http://www.loc.gov/mix/v20"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:xlin="http://www.w3.org/1999/xlink"
	xmlns:dv="http://dfg-viewer.de/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:vl="http://visuallibrary.net/vl"
	xmlns:vls="http://semantics.de/vls"
	xmlns:marcxml="http://www.loc.gov/MARC21/slim"
	xmlns:epicur="urn:nbn:de:1111-2004033116"
	xmlns:zvdd="http://zvdd.gdz-cms.de/"
	xmlns:vlz="http://visuallibrary.net/vlz/1.0"	
	exclude-result-prefixes="xsl" version="1.0" >
	<xsl:output method="xml" indent="yes" encoding="UTF-8" />
	<xsl:variable name="oai_id" select="//oai:identifier" />
	<xsl:template match="/">
		<xsl:apply-templates select="//mets:mets" />
	</xsl:template>

	<xsl:template match="//mets:mets">
		<mets:mets xmlns:mets="http://www.loc.gov/METS/">
			<mets:dmdSec ID="ie-dmd">
				<mets:mdWrap MDTYPE="DC">
					<mets:xmlData>
						<dc:record xmlns:dc="http://purl.org/dc/elements/1.1/"
							xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<dc:identifier>
								<xsl:value-of select="$oai_id" />
							</dc:identifier>
							<xsl:apply-templates
								select="mets:dmdSec/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/*"
								mode="md" />
							
						</dc:record>
					</mets:xmlData>
				</mets:mdWrap>
				<mets:mdWrap MDTYPE="MODS">
     				<xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData" />
				</mets:mdWrap>
			</mets:dmdSec>
			<xsl:apply-templates select="mets:fileSec" />
			<xsl:apply-templates select="mets:structMap" />
			<xsl:apply-templates select="mets:structLink" />
		</mets:mets>
	</xsl:template>


    <!-- mods SECTION Copy original Data -->
	<xsl:template match="mets:dmdSec/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData">
		<mets:xmlData>
     		<xsl:copy-of select="mods:mods" />
		</mets:xmlData>
	</xsl:template>

	<!-- mets:fileSec Section -->
	<xsl:template match="mets:fileSec">
		<mets:fileSec>
		<xsl:for-each select="mets:fileGrp">
		  <mets:fileGrp>
		    <xsl:attribute name="USE">
			  <xsl:value-of select="./@USE" />
		    </xsl:attribute>
            <xsl:copy-of select="mets:file" />
		  </mets:fileGrp>
		</xsl:for-each>
		</mets:fileSec>
	</xsl:template>

<!-- mods2DC SECTION generate DC from mods-->
	<xsl:template match="*" mode="mods">
		<xsl:element name="mods:{name()}"
			namespace="http://www.loc.gov/mods/v3">
			<xsl:copy-of select="namespace::*" />
			<xsl:apply-templates mode="mods" />
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*|text()" mode="copy">
		<xsl:copy>
			<xsl:apply-templates mode="copy" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*" mode="copy">
		<xsl:element name="{name()}">
			<xsl:apply-templates mode="copy" />
		</xsl:element>
	</xsl:template>
	<!-- MD section -->
	<xsl:template match="mods:titleInfo/mods:title" mode="md">
		<dc:title>
			<xsl:value-of select="." />
		</dc:title>
	</xsl:template>
	<xsl:template
		match="mods:name[@type=&apos;corporate&apos;]/mods:namePart" mode="md">
		<dc:creator>
			<xsl:value-of select="." />
		</dc:creator>
	</xsl:template>
	<xsl:template
		match="mods:name[@type=&apos;personal&apos;]/mods:displayForm"
		mode="md">
		<dc:creator>
			<xsl:value-of select="." />
		</dc:creator>
	</xsl:template>
	<xsl:template match="mods:typeOfResource" mode="md">
		<dc:type>
			<xsl:value-of select="." />
		</dc:type>
	</xsl:template>
	<xsl:template match="mods:originInfo/mods:publisher"
		mode="md">
		<dc:publisher>
			<xsl:value-of select="." />
		</dc:publisher>
	</xsl:template>
	<xsl:template
		match="mods:originInfo/mods:dateIssued[@keyDate = &apos;yes&apos;]"
		mode="md">
		<dc:date>
			<xsl:value-of select="." />
		</dc:date>
	</xsl:template>
	<xsl:template match="node()" mode="md">
		<xsl:apply-templates mode="md" />
	</xsl:template>

	<!-- mets:structMap Section -->
	<xsl:template match="mets:structMap">
	  <mets:structMap>
	    <xsl:attribute name="TYPE">
		  <xsl:value-of select="./@TYPE" />
		</xsl:attribute>
        <xsl:copy-of select="mets:div" />
	  </mets:structMap>	
	</xsl:template>

	<!-- mets:structLink Section -->
	<xsl:template match="mets:structLink">
	  <mets:structLink>
        <xsl:copy-of select="mets:smLink" />
	  </mets:structLink>	
	</xsl:template>

	<!-- Templates by default : do nothing -->
	<xsl:template match="@*|node()" />
</xsl:stylesheet>