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
	<xsl:variable name="source_path"
		select="&apos;src/resources&apos;" />
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
			</mets:dmdSec>
			<xsl:apply-templates select="mets:fileSec"
				mode="rep" />
			<xsl:apply-templates
				select="mets:dmdSec/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods"
				mode="ie" />
			<xsl:apply-templates
				select="mets:fileSec[mets:fileGrp]" />
			<!-- Select which fileSecs will be represented by its own structMap -->
			<xsl:apply-templates select="mets:structMap">
				<xsl:with-param name="rep_num" select="6" />
			</xsl:apply-templates>
		</mets:mets>
	</xsl:template>
	<!-- File/Representation section -->
	<xsl:template match="mets:fileSec" mode="rep">
		<xsl:for-each select="mets:fileGrp">
			<xsl:variable name="group" select="./@USE" />
			<xsl:variable name="pos" select="position()" />
			<xsl:if test="position()=2">
				<mets:amdSec>
					<xsl:attribute name="ID">
            <xsl:value-of
						select="concat(&apos;rep&apos;, $pos, &apos;-amd&apos;)" />
          </xsl:attribute>
					<mets:techMD>
						<xsl:attribute name="ID">
              <xsl:value-of
							select="concat(&apos;rep&apos;, $pos, &apos;-amd-tech&apos;)" />
            </xsl:attribute>
						<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
							<mets:xmlData>
								<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
									<section id="generalRepCharacteristics">
										<record>
											<key id="label">
												<xsl:choose>
													<xsl:when test="$group = &apos;MAX&apos;">
														TIFs
													</xsl:when>
													<xsl:otherwise>
														JPGs
													</xsl:otherwise>
												</xsl:choose>
											</key>
											<key id="preservationType">
												<xsl:choose>
													<xsl:when test="$group = &apos;MAX&apos;">
														PRESERVATION_MASTER
													</xsl:when>
													<xsl:otherwise>
														DERIVATIVE_COPY
													</xsl:otherwise>
												</xsl:choose>
											</key>
											<key id="usageType">VIEW</key>
											<key id="RevisionNumber">1</key>
											<key id="DigitalOriginal">true</key>
										</record>
									</section>
								</dnx>
							</mets:xmlData>
						</mets:mdWrap>
					</mets:techMD>
				</mets:amdSec>
				<xsl:apply-templates select="mets:file"
					mode="rep">
					<xsl:with-param name="repp" select="$pos" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="mets:file" mode="rep">
		<xsl:param name="repp" select="&apos;1&apos;" />
		<xsl:variable name="pos" select="position()" />
		<xsl:variable name="id" select="@ID" />
		<xsl:variable name="group"
			select="ancestor::mets:fileGrp/@USE/." />
		<mets:amdSec>
			<xsl:attribute name="ID">
        <xsl:value-of
				select="concat(&apos;fid&apos;, $pos, &apos;-&apos;, $repp, &apos;-amd&apos;)" />
      </xsl:attribute>
			<mets:techMD>
				<xsl:attribute name="ID">
          <xsl:value-of
					select="concat(&apos;fid&apos;, $pos, &apos;-&apos;, $repp, &apos;-amd-tech&apos;)" />
        </xsl:attribute>
				<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
					<mets:xmlData>
						<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
							<section id="generalFileCharacteristics">
								<record>
									<key id="label">
										<xsl:value-of select="@ID" />
									</key>
									<key id="fileMIMEType">
										<xsl:choose>
											<xsl:when test="$group = &apos;MAX&apos;">
												image/tiff
											</xsl:when>
											<xsl:otherwise>
												image/jpeg
											</xsl:otherwise>
										</xsl:choose>
									</key>
								</record>
							</section>
						</dnx>
					</mets:xmlData>
				</mets:mdWrap>
			</mets:techMD>
		</mets:amdSec>
	</xsl:template>

	<!-- Source MD, Access Right Policy -->
	<xsl:template match="mets:dmdSec/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods" mode="ie">
		<mets:amdSec ID="ie-amd">
			<!-- section will be created by Rosetta (but the wrong way, i.e. without 
				ID) -->
			<!-- Rosetta will add the OAI identifier to this section -->
			<mets:techMD ID="ie-amd-tech">
				<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
					<mets:xmlData>
						<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
							<section id="objectIdentifier" />
						</dnx>
					</mets:xmlData>
				</mets:mdWrap>
			</mets:techMD>
			<!-- if not defined here, Rosetta takes the AR policy configured in the 
				Material flow -->
			<mets:rightsMD ID="ie-amd-rights">
				<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
					<mets:xmlData>
						<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
							<section id="accessRightsPolicy" />
							<!-- <section id="accessRightsPolicy"> <record> <key id="policyId">1161</key> 
								<key id="policyDescription">USB Staff user only</key> </record> </section> -->
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
			<xsl:if
				test="/OAI-PMH/GetRecord/record/metadata/mets:mets/mets:amdSec/mets:rightsMD/mets:mdWrap[@OTHERMDTYPE = &apos;DVRIGHTS&apos;]">
				<mets:sourceMD ID="ie-amd-source-1">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="DVRIGHTS">
						<xsl:apply-templates
							select="//mets:mets/mets:amdSec/mets:rightsMD/mets:mdWrap[@OTHERMDTYPE = &apos;DVRIGHTS&apos;]/*"
							mode="copy" />
					</mets:mdWrap>
				</mets:sourceMD>
			</xsl:if>
			<xsl:if
				test="/OAI-PMH/GetRecord/record/metadata/mets:mets/mets:amdSec/mets:digiprovMD/mets:mdWrap[@OTHERMDTYPE = &apos;DVLINKS&apos;]">
				<mets:sourceMD ID="ie-amd-source-2">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="DVLINKS">
						<xsl:apply-templates
							select="//mets:mets/mets:amdSec/mets:digiprovMD/mets:mdWrap[@OTHERMDTYPE = &apos;DVLINKS&apos;]/*"
							mode="copy" />
					</mets:mdWrap>
				</mets:sourceMD>
			</xsl:if>
			<mets:sourceMD ID="ie-amd-source-MODS">
				<mets:mdWrap MDTYPE="MODS">
					<mets:xmlData>
						<xsl:apply-templates select="." mode="copy" />
					</mets:xmlData>
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
			<!-- section will be created by Rosetta (but the wrong way, i.e. without 
				ID) -->
			<mets:digiprovMD ID="ie-amd-digiprov">
				<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
					<mets:xmlData>
						<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx" />
					</mets:xmlData>
				</mets:mdWrap>
			</mets:digiprovMD>
		</mets:amdSec>
	</xsl:template>

	<!-- File Section -->
	<xsl:template match="mets:fileSec">
		<xsl:element name="{name()}">
			<xsl:for-each select="mets:fileGrp">
				<xsl:variable name="group" select="./@USE" />
				<xsl:if test="$group = &apos;MAX&apos;">
					<xsl:variable name="repp" select="position()" />
					<xsl:element name="{name()}">
						<xsl:attribute name="USE">VIEW</xsl:attribute>
						<xsl:attribute name="ID">
              <xsl:value-of
							select="concat(&apos;rep&apos;, $repp)" />
            </xsl:attribute>
						<xsl:attribute name="ADMID">
              <xsl:value-of
							select="concat(&apos;rep&apos;, $repp, &apos;-amd&apos;)" />
            </xsl:attribute>
						<xsl:apply-templates select="*" mode="file">
							<xsl:with-param name="repp" select="$repp" />
						</xsl:apply-templates>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mets:file" mode="file">
		<xsl:param name="repp" select="&apos;1&apos;" />
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@ID|*" mode="file">
				<xsl:with-param name="repp" select="$repp" />
				<xsl:with-param name="pos" select="position()" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template
		match="mets:file/@*[local-name() = &apos;ID&apos;]" mode="file">
		<xsl:param name="pos" select="." />
		<xsl:param name="repp" select="&apos;1&apos;" />
		<xsl:attribute name="ID">
      <xsl:value-of
			select="concat(&apos;fid&apos;, $pos, &apos;-&apos;, $repp)" />
    </xsl:attribute>
		<xsl:attribute name="ADMID">
      <xsl:value-of
			select="concat(&apos;fid&apos;, $pos, &apos;-&apos;,$repp,&apos;-amd&apos;)" />
    </xsl:attribute>
	</xsl:template>
	<xsl:template match="mets:FLocat/@xlin:href" mode="file">
		<xsl:variable name="group"
			select="ancestor::mets:fileGrp/@USE/." />
		<xsl:attribute name="xlin:href">
      <xsl:variable name="CONTENTdm_ID"
			select="substring-after(.,&apos;CISOPTR=&apos;)" />
      <xsl:choose>
        <xsl:when test="$group = &apos;DEFAULT&apos;">
          <xsl:value-of select="." />
        </xsl:when>
        <xsl:when test="$group = &apos;MAX&apos;">
          <xsl:value-of select="." />
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
	</xsl:template>
	<xsl:template match="@*|text()" mode="file">
		<xsl:copy>
			<xsl:value-of select="." />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*" mode="file">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*|node()"
				mode="file" />
		</xsl:element>
	</xsl:template>

<!-- Struct section PHYSICAL -->
	<xsl:template
		match="mets:structMap[@TYPE=&apos;PHYSICAL&apos;]">
		<xsl:param name="rep_num" />
		<xsl:element name="{name()}">
			<xsl:attribute name="ID">
        <xsl:value-of
				select="concat(&apos;rep&apos;, $rep_num, &apos;-&apos;, position())" />
      </xsl:attribute>
			<xsl:attribute name="TYPE">PHYSICAL</xsl:attribute>
			<xsl:apply-templates select="mets:div"
				mode="struc">
				<xsl:with-param name="rep_num" select="$rep_num" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mets:structMap/mets:div" mode="struc">
		<xsl:param name="rep_num" />
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@LABEL" mode="copy" />
			<xsl:apply-templates select="mets:div"
				mode="struc">
				<xsl:with-param name="rep_num" select="$rep_num" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mets:structMap/mets:div//mets:div"
		mode="struc">
		<xsl:param name="rep_num" />
		<xsl:element name="{name()}">
			<xsl:attribute name="LABEL">
		        <xsl:value-of select="@LABEL" />
      		</xsl:attribute>
			<xsl:attribute name="TYPE">
		        <xsl:value-of select="@TYPE" />
			</xsl:attribute>
			<xsl:attribute name="ORDER">
		        <xsl:value-of select="@ORDER" />
      		</xsl:attribute>
			<xsl:apply-templates select="mets:fptr"
				mode="struc">
				<xsl:with-param name="pos" select="position()" />
				<xsl:with-param name="rep_num" select="$rep_num" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mets:fptr" mode="struc">
		<xsl:param name="rep_num" />
		<xsl:param name="pos" select="." />
		<xsl:if test="position()=1">
			<xsl:element name="{name()}">
				<xsl:attribute name="FILEID">
          <xsl:value-of
					select="concat(&apos;fid&apos;, $pos, &apos;-&apos;, $rep_num)" />
        </xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>

<!-- Struct section LOGICAL -->
	<xsl:template
		match="mets:structMap[@TYPE=&apos;LOGICAL&apos;]">
		<xsl:param name="rep_num" />
		<xsl:element name="{name()}">
			<xsl:attribute name="ID">
        <xsl:value-of
				select="concat(&apos;rep&apos;, $rep_num, &apos;-&apos;, position())" />
      </xsl:attribute>
			<xsl:attribute name="TYPE">LOGICAL</xsl:attribute>
			<xsl:apply-templates select="mets:div"
				mode="struc">
				<xsl:with-param name="rep_num" select="$rep_num" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mets:structMap/mets:div" mode="struc">
		<xsl:param name="rep_num" />
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@LABEL" mode="copy" />
			<xsl:apply-templates select="mets:div"
				mode="struc">
				<xsl:with-param name="rep_num" select="$rep_num" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mets:structMap/mets:div//mets:div"
		mode="struc">
		<xsl:param name="rep_num" />
		<xsl:element name="{name()}">
			<xsl:attribute name="LABEL">
		        <xsl:value-of select="@LABEL" />
      		</xsl:attribute>
			<xsl:attribute name="TYPE">
		        <xsl:value-of select="@TYPE" />
			</xsl:attribute>
			<xsl:attribute name="ORDER">
		        <xsl:value-of select="@ORDER" />
      		</xsl:attribute>
			<xsl:apply-templates select="mets:fptr"
				mode="struc">
				<xsl:with-param name="pos" select="position()" />
				<xsl:with-param name="rep_num" select="$rep_num" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mets:fptr" mode="struc">
		<xsl:param name="rep_num" />
		<xsl:param name="pos" select="." />
		<xsl:if test="position()=1">
			<xsl:element name="{name()}">
				<xsl:attribute name="FILEID">
          <xsl:value-of
					select="concat(&apos;fid&apos;, $pos, &apos;-&apos;, $rep_num)" />
        </xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>

<!-- mods SECTION -->
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
	<!-- Templates by default : do nothing -->
	<xsl:template match="@*|node()" />
</xsl:stylesheet>