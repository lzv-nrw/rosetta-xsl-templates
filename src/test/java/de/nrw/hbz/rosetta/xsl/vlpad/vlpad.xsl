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
	exclude-result-prefixes="xsl" version="1.0">
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
							<!-- map mods md into dc -->
							<xsl:apply-templates
								select="mets:dmdSec/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/*"
								mode="mods2dc" />
						</dc:record>
					</mets:xmlData>
				</mets:mdWrap>
			</mets:dmdSec>

			<!-- IE AMDMD Section -->
			<mets:amdSec ID="ie-amd">
				<mets:techMD ID="ie-amd-tech">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
						<mets:xmlData>
							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
								<section id="objectIdentifier" />
							</dnx>
						</mets:xmlData>
					</mets:mdWrap>
				</mets:techMD>
				<mets:rightsMD ID="ie-amd-rights">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
						<mets:xmlData>
							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
								<section id="accessRightsPolicy" />
							</dnx>
						</mets:xmlData>
					</mets:mdWrap>
				</mets:rightsMD>
				<mets:sourceMD ID="ie-amd-source">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
						<mets:xmlData>
							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx" />
						</mets:xmlData>
					</mets:mdWrap>
				</mets:sourceMD>
				<mets:sourceMD ID="ie-amd-source-MODS">
					<mets:mdWrap MDTYPE="MODS">
						<xsl:apply-templates
							select="mets:dmdSec[1]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData" />
					</mets:mdWrap>
				</mets:sourceMD>
				<mets:sourceMD ID="ie-amd-source-OTHER-1">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="xml">
						<mets:xmlData>
							<record>
								<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
								<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
							</record>
						</mets:xmlData>
					</mets:mdWrap>
				</mets:sourceMD>
				<mets:digiprovMD ID="ie-amd-digiprov">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
						<mets:xmlData>
							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx" />
						</mets:xmlData>
					</mets:mdWrap>
				</mets:digiprovMD>
			</mets:amdSec>
			<xsl:apply-templates select="mets:fileSec" />
		</mets:mets>
	</xsl:template>


	<!-- mods SECTION Copy original Data to admSec -->
	<xsl:template
		match="mets:dmdSec[1]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData">
		<mets:xmlData>
			<xsl:copy-of select="mods:mods" />
		</mets:xmlData>
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
	<xsl:template match="mets:fileSec/mets:fileGrp" mode="repres">
		<xsl:variable name="representationID"
			select="concat(&apos;rep&apos;, position(), &apos;-amd&apos;)" />
		<xsl:variable name="preservationType" select="./@USE" />	
		<mets:amdSec>
			<xsl:attribute name="ID">
                <xsl:value-of select="$representationID" />
              </xsl:attribute>
			<mets:techMD>
				<xsl:attribute name="ID">
                <xsl:value-of
					select="concat($representationID, &apos;_tech&apos;)" />
              </xsl:attribute>
				<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
					<mets:xmlData>
						<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
							<section id="generalRepCharacteristics">
								<record>
									<key id="label">
										<xsl:value-of select="$representationID" />
									</key>
										<xsl:choose>
											<xsl:when test="$preservationType = &apos;MAX&apos;">
            									<key id="preservationType">PRESERVATION_MASTER</key>
											</xsl:when>
											<xsl:when test="$preservationType = &apos;FULLTEXT&apos;">
            									<key id="preservationType">MODIFIED_MASTER</key>
											</xsl:when>
											<xsl:when test="$preservationType = &apos;MIN&apos;">
            									<key id="preservationType">DERIVATIVE_COPY</key>
            									<key id="representationEntityType"><xsl:value-of select="$preservationType"/></key>
            									<key id="RepresentationCode">LOW</key>
											</xsl:when>
											<xsl:when test="$preservationType = &apos;DEFAULT&apos;">
            									<key id="preservationType">DERIVATIVE_COPY</key>
            									<key id="representationEntityType"><xsl:value-of select="$preservationType"/></key>
            									<key id="RepresentationCode">MEDIUM</key>
											</xsl:when>
											<xsl:when test="$preservationType = &apos;FRONTIMAGE&apos;">
            									<key id="preservationType">DERIVATIVE_COPY</key>
            									<key id="representationEntityType"><xsl:value-of select="$preservationType"/></key>
            									<key id="RepresentationCode">LOW</key>
											</xsl:when>
											<xsl:when test="$preservationType = &apos;DOWNLOAD&apos;">
            									<key id="preservationType">DERIVATIVE_COPY</key>
            									<key id="representationEntityType"><xsl:value-of select="$preservationType"/></key>
            									<key id="RepresentationCode">MEDIUM</key>
											</xsl:when>
											<xsl:otherwise>
            									<key id="preservationType">DERIVATIVE_COPY</key>
            									<key id="representationEntityType">UNSPECIFIC</key>
            									<key id="RepresentationCode">MEDIUM</key>
											</xsl:otherwise>
										</xsl:choose>
									<key id="usageType">VIEW</key>
									<key id="RevisionNumber">1</key>
									<key id="DigitalOriginal">false</key>
								</record>
							</section>
						</dnx>
					</mets:xmlData>
				</mets:mdWrap>
			</mets:techMD>
		</mets:amdSec>
	</xsl:template>

	<!-- amdSec File specific Section -->
	<xsl:template match="mets:fileSec/mets:fileGrp" mode="file">
		<xsl:variable name="representationPos"
			select="position()" />
		<xsl:for-each select="mets:file">
		  <xsl:variable name="fileMIMEType" select="./@MIMETYPE" />
		  <xsl:variable name="filePos"
			select="position()" />
		<mets:amdSec>
			<xsl:attribute name="ID">
                <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $representationPos, &apos;-amd&apos;)" />
              </xsl:attribute>
			<mets:techMD>
				<xsl:attribute name="ID">
                <xsl:value-of
					select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $representationPos, &apos;-amd-tech&apos;)" />
              </xsl:attribute>
				<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
					<mets:xmlData>
						<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
							<section id="generalFileCharacteristics">
								<record>
									<key id="label">
										<xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $representationPos)" />
									</key>
									<key id="fileMIMEType">
										<xsl:value-of select="$fileMIMEType" />
									</key>
								</record>
							</section>
						</dnx>
					</mets:xmlData>
				</mets:mdWrap>
			</mets:techMD>
		</mets:amdSec>		
		</xsl:for-each>
	</xsl:template>

	<!-- mets:fileSec Section -->
	<xsl:template match="mets:fileSec">
		<xsl:apply-templates select="mets:fileGrp" mode="repres"/>
		<xsl:apply-templates select="mets:fileGrp" mode="file"/>
		<mets:fileSec>
			<xsl:for-each select="mets:fileGrp">
				<xsl:variable name="pos" select="position()" />
				<mets:fileGrp>
					<xsl:attribute name="USE">
	          		  <xsl:value-of select="&apos;VIEW&apos;" />
		            </xsl:attribute>
					<xsl:attribute name="ID">
	          		  <xsl:value-of
						select="concat(&apos;rep&apos;, $pos)" />
		            </xsl:attribute>
					<xsl:attribute name="ADMID">
	          		  <xsl:value-of
						select="concat(&apos;rep&apos;, $pos, &apos;-amd&apos;)" />
		            </xsl:attribute>
					<xsl:for-each select="mets:file">
                        <xsl:variable name="filePos">
                          <xsl:value-of select="position()" />
                        </xsl:variable>
                		<mets:file>
			              <xsl:attribute name="MIMETYPE">
	                        <xsl:value-of select="./@MIMETYPE" />
		                  </xsl:attribute>
			              <xsl:attribute name="ID">
	                        <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos)" />
		                  </xsl:attribute>
			              <xsl:attribute name="ADMID">
	                        <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos, &apos;-amd&apos;)" />
		                  </xsl:attribute>
			              <xsl:copy-of select="mets:FLocat" />
		                 </mets:file>
					</xsl:for-each>
				</mets:fileGrp>
			</xsl:for-each>
		</mets:fileSec>

		<xsl:for-each select="mets:fileGrp">
			<xsl:variable name="pos" select="position()" />
			<mets:structMap>
				<xsl:attribute name="TYPE">
		  <xsl:value-of select="&apos;PHYSICAL&apos;" />
		</xsl:attribute>
				<xsl:attribute name="ID">
		  <xsl:value-of
					select="concat(&apos;rep&apos;, $pos, &apos;-1&apos;)" />
		</xsl:attribute>
				<mets:div>
				<xsl:for-each select="./mets:file">
                <xsl:variable name="filePos" select="position()" />
					<mets:div>
						<xsl:attribute name="TYPE">
		  <xsl:value-of select="&apos;FILE&apos;" />
		</xsl:attribute>
						<xsl:attribute name="LABEL">
		  <xsl:value-of select="concat(.././@USE, &apos;-&apos;, $filePos)" />
		</xsl:attribute>
					<mets:fptr>
						<xsl:attribute name="FILEID">
		  <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos)" />
		</xsl:attribute>
					</mets:fptr>
				</mets:div>
				</xsl:for-each>
				</mets:div>
			</mets:structMap>
		</xsl:for-each>

		<xsl:for-each select="mets:fileGrp">
			<xsl:variable name="pos" select="position()" />
			<mets:structMap>
				<xsl:attribute name="TYPE">
		  <xsl:value-of select="&apos;LOGICAL&apos;" />
		</xsl:attribute>
				<xsl:attribute name="ID">
		  <xsl:value-of
					select="concat(&apos;rep&apos;, $pos, &apos;-2&apos;)" />
		</xsl:attribute>
				<mets:div>
				<xsl:for-each select="./mets:file">
                <xsl:variable name="filePos" select="position()" />
					<mets:div>
						<xsl:attribute name="TYPE">
		  <xsl:value-of select="&apos;FILE&apos;" />
		</xsl:attribute>
						<xsl:attribute name="LABEL">
		  <xsl:value-of select="concat(.././@USE, &apos;-&apos;, $filePos)" />
		</xsl:attribute>
					<mets:fptr>
						<xsl:attribute name="FILEID">
		  <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos)" />
		</xsl:attribute>
					</mets:fptr>
				</mets:div>
				</xsl:for-each>
				</mets:div>
			</mets:structMap>
		</xsl:for-each>
	</xsl:template>

	
	<!-- mods2DC SECTION generate DC from mods -->
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
	<xsl:template match="mods:titleInfo/mods:title"
		mode="mods2dc">
		<dc:title>
			<xsl:value-of select="." />
		</dc:title>
	</xsl:template>
	<xsl:template
		match="mods:name[@type=&apos;corporate&apos;]/mods:namePart"
		mode="mods2dc">
		<dc:creator>
			<xsl:value-of select="." />
		</dc:creator>
	</xsl:template>
	<xsl:template
		match="mods:name[@type=&apos;personal&apos;]/mods:displayForm"
		mode="mods2dc">
		<dc:creator>
			<xsl:value-of select="." />
		</dc:creator>
	</xsl:template>
	<xsl:template match="mods:typeOfResource" mode="mods2dc">
		<dc:type>
			<xsl:value-of select="." />
		</dc:type>
	</xsl:template>
	<xsl:template match="mods:originInfo/mods:publisher"
		mode="mods2dc">
		<dc:publisher>
			<xsl:value-of select="." />
		</dc:publisher>
	</xsl:template>
	<xsl:template
		match="mods:originInfo/mods:dateIssued[@keyDate = &apos;yes&apos;]"
		mode="mods2dc">
		<dc:date>
			<xsl:value-of select="." />
		</dc:date>
	</xsl:template>
	<xsl:template match="node()" mode="mods2dc">
		<xsl:apply-templates mode="mods2dc" />
	</xsl:template>

	<!-- mets:structMap PHYSICAL Section -->
	<xsl:template
		match="mets:structMap[@TYPE=&apos;PHYSICAL&apos;]">
		<mets:structMap>
			<xsl:attribute name="TYPE">
		  <xsl:value-of select="./@TYPE" />
		</xsl:attribute>
			<xsl:attribute name="ID">
		  <xsl:value-of
				select="concat(&apos;structMap-&apos;, ./@TYPE, &apos;-&apos;, position())" />
		</xsl:attribute>
			<mets:div>
				<xsl:apply-templates select="mets:div/mets:div"
					mode="phys" />
			</mets:div>
		</mets:structMap>
	</xsl:template>

	<!-- mets:structMap LOGICAL Section -->
	<xsl:template
		match="mets:structMap[@TYPE=&apos;LOGICAL&apos;]">
		<mets:structMap>
			<xsl:attribute name="TYPE">
		  <xsl:value-of select="./@TYPE" />
		</xsl:attribute>
			<xsl:attribute name="ID">
		  <xsl:value-of
				select="concat(&apos;structMap-&apos;, ./@TYPE, &apos;-&apos;, position())" />
		</xsl:attribute>
			<mets:div>
				<xsl:apply-templates select="mets:div/mets:div"
					mode="logic" />
			</mets:div>
		</mets:structMap>
	</xsl:template>

	<!-- Templates by default : do nothing -->
	<xsl:template match="@*|node()" />
</xsl:stylesheet>