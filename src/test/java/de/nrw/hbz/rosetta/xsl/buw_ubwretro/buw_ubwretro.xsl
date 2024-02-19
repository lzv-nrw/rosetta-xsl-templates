<xsl:stylesheet xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:mets="http://www.loc.gov/METS/" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mix="http://www.loc.gov/mix/v20" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dv="http://dfg-viewer.de/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vl="http://visuallibrary.net/vl" xmlns:vls="http://semantics.de/vls" xmlns:marcxml="http://www.loc.gov/MARC21/slim" xmlns:epicur="urn:nbn:de:1111-2004033116" xmlns:zvdd="http://zvdd.gdz-cms.de/" xmlns:vlz="http://visuallibrary.net/vlz/1.0" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xsl" version="1.0">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:variable name="oai_id" select="//oai:record/oai:header/oai:identifier"/>
	<xsl:variable name="dmd_id" select="concat(&apos;md&apos;,substring-after($oai_id,&apos;de:&apos;))"/>
	<xsl:variable name="rel_dmd_id" select="//mets:structMap/mets:div/mets:div/@DMDID"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//mets:mets"/>
	</xsl:template>
	<xsl:template match="//mets:mets">
		<mets:mets xmlns:mets="http://www.loc.gov/METS/">
			<mets:dmdSec ID="ie-dmd">
				<mets:mdWrap MDTYPE="DC">
					<mets:xmlData>
						<dc:record xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<!-- map mods md into dc -->
							<xsl:apply-templates select="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods" mode="mods2dc"/>
							<xsl:if test="mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@TYPE=&apos;multivolume_work&apos;">
								<xsl:if test="mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@DMDID=$dmd_id">
									<xsl:apply-templates select="mets:dmdSec[not(@ID=$dmd_id)]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/*" mode="mods2dc"/>
								</xsl:if>
							</xsl:if>
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
								<section id="objectIdentifier"/>
								<xsl:if test="mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@TYPE=&apos;multivolume_work&apos; and $dmd_id=mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@DMDID">
									<section id="IERelationship">
										<xsl:for-each select="mets:structMap/mets:div/mets:div">
											<record>
												<key id="relationshipType">STRUCTURAL</key>
												<key id="relationshipSubType">HAS_PART</key>
												<key id="relatedObjectIdentifierType">METS_FILE</key>
												<key id="relatedObjectIdentifierValue">
													<xsl:value-of select="concat(&apos;child_&apos;, position(), &apos;.xml&apos;)"/>
												</key>
												<key id="relatedObjectSequence">
													<xsl:value-of select="position()"/>
												</key>
											</record>
										</xsl:for-each>
									</section>
								</xsl:if>
							</dnx>
						</mets:xmlData>
					</mets:mdWrap>
				</mets:techMD>
				<mets:rightsMD ID="ie-amd-rights">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
						<mets:xmlData>
							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
								<section id="accessRightsPolicy">
									<xsl:if test="mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@TYPE=&apos;multivolume_work&apos; and $dmd_id=mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@DMDID">
										<record>
											<key id="policyId">30661</key>
										</record>
									</xsl:if>
								</section>
							</dnx>
						</mets:xmlData>
					</mets:mdWrap>
				</mets:rightsMD>
				<mets:sourceMD ID="ie-amd-source-MODS">
					<mets:mdWrap MDTYPE="MODS">
						<mets:xmlData>
							<!-- sourceMD/dmdSec -->
							<xsl:apply-templates select="mets:dmdSec"/>
							<!-- sourceMD/admSec -->
							<xsl:apply-templates select="mets:amdSec"/>
							<!-- structMap ID="PHYSICAL" -->
							<xsl:apply-templates select="mets:structMap[@TYPE=&apos;PHYSICAL&apos;]" mode="structMapPhysical"/>							
							<!-- structMap ID="LOGICAL" -->
							<xsl:apply-templates select="mets:structMap[@TYPE=&apos;LOGICAL&apos;]" mode="structMapLogical"/>
							<!-- structLink -->
							<xsl:apply-templates select="mets:structLink" mode="structLink"/>							
						</mets:xmlData>
					</mets:mdWrap>
				</mets:sourceMD>
				<mets:digiprovMD ID="ie-amd-digiprov">
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
						<mets:xmlData>
							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx"/>
						</mets:xmlData>
					</mets:mdWrap>
				</mets:digiprovMD>
			</mets:amdSec>
			<xsl:if test="mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@TYPE=&apos;multivolume_work&apos;">
				<xsl:if test="not(mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@DMDID=$dmd_id)">
					<xsl:apply-templates select="mets:fileSec" mode="fileSec"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/@TYPE=&apos;multivolume_work&apos;)">
				<xsl:apply-templates select="mets:fileSec" mode="fileSec"/>
			</xsl:if>
		</mets:mets>
	</xsl:template>
	<!-- mods SECTION Copy original dmdSec Data to sourceMD/dmdSec -->
	<xsl:template match="mets:dmdSec">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- mods SECTION Copy original amdSec Data to sourceMD/admSec -->
	<xsl:template match="mets:amdSec">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- mods SECTION Copy original physical structMap Data to sourceMD/structMap -->
	<xsl:template match="mets:structMap[@TYPE=&apos;PHYSICAL&apos;]" mode="structMapPhysical">
		<xsl:copy-of select="."/>
	</xsl:template>	
	<!-- mods SECTION Copy original logical structMap Data to sourceMD/structMap -->
	<xsl:template match="mets:structMap[@TYPE=&apos;LOGICAL&apos;]" mode="structMapLogical">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- mods SECTION Copy original structLink Data to sourceMD/structMap -->
	<xsl:template match="mets:structLink" mode="structLink">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- DVRights Section -->
	<xsl:template match="mets:amdSec/mets:rightsMD">
		<mets:rightsMD>
			<xsl:attribute name="ID">
				<xsl:value-of select="./@ID"/>
			</xsl:attribute>
			<xsl:for-each select="mets:mdWrap">
				<xsl:attribute name="MIMETYPE">
					<xsl:value-of select="./@MIMETYPE"/>
				</xsl:attribute>
				<xsl:attribute name="MDTYPE">
					<xsl:value-of select="./@MDTYPE"/>
				</xsl:attribute>
				<xsl:attribute name="OTHERMDTYPE">
					<xsl:value-of select="./@OTHERMDTYPE"/>
				</xsl:attribute>
				<mets:mdWrap>
					<xsl:copy-of select="mets:xmlData"/>
				</mets:mdWrap>
			</xsl:for-each>
		</mets:rightsMD>
	</xsl:template>
	<!-- digiProv Section -->
	<xsl:template match="mets:amdSec/mets:digiprovMD">
		<mets:digiprovMD>
			<xsl:attribute name="ID">
				<xsl:value-of select="./@ID"/>
			</xsl:attribute>
			<xsl:for-each select="mets:mdWrap">
				<xsl:attribute name="MIMETYPE">
					<xsl:value-of select="./@MIMETYPE"/>
				</xsl:attribute>
				<xsl:attribute name="MDTYPE">
					<xsl:value-of select="./@MDTYPE"/>
				</xsl:attribute>
				<xsl:attribute name="OTHERMDTYPE">
					<xsl:value-of select="./@OTHERMDTYPE"/>
				</xsl:attribute>
				<mets:mdWrap>
					<xsl:copy-of select="mets:xmlData"/>
				</mets:mdWrap>
			</xsl:for-each>
		</mets:digiprovMD>
	</xsl:template>
	<!-- amdSec Representation specific Section -->
	<xsl:template match="mets:fileSec/mets:fileGrp" mode="repres">
		<xsl:variable name="representationID" select="concat(&apos;rep&apos;, position(), &apos;-amd&apos;)"/>
		<xsl:variable name="preservationType" select="./@USE"/>
		<mets:amdSec>
			<xsl:attribute name="ID">
				<xsl:value-of select="$representationID"/>
			</xsl:attribute>
			<mets:techMD>
				<xsl:attribute name="ID">
					<xsl:value-of select="concat($representationID, &apos;-tech&apos;)"/>
				</xsl:attribute>
				<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
					<mets:xmlData>
						<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
							<section id="generalRepCharacteristics">
								<record>
									<xsl:choose>
										<xsl:when test="$preservationType = &apos;MASTER&apos;">
											<key id="label">TIFF</key>
											<key id="preservationType">PRESERVATION_MASTER</key>
											<key id="representationEntityType">
												<xsl:value-of select="$preservationType"/>
											</key>
										</xsl:when>
										<xsl:when test="$preservationType = &apos;DOWNLOAD&apos;">
											<key id="label">PDF</key>
											<key id="preservationType">MODIFIED_MASTER</key>
											<key id="representationEntityType">
												<xsl:value-of select="$preservationType"/>
											</key>
										</xsl:when>
										<xsl:when test="$preservationType = &apos;FULLTEXT&apos;">
											<key id="label">XML</key>
											<key id="preservationType">MODIFIED_MASTER_02</key>
											<key id="representationEntityType">
												<xsl:value-of select="$preservationType"/>
											</key>
										</xsl:when>
										<xsl:otherwise>
											<key id="preservationType">DERIVATIVE_COPY</key>
											<key id="representationEntityType">UNSPECIFIC</key>
											<key id="RepresentationCode">MEDIUM</key>
										</xsl:otherwise>
									</xsl:choose>
									<key id="usageType">VIEW</key>
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
		<xsl:variable name="representationPos" select="position()"/>
		<xsl:for-each select="mets:file">
			<xsl:variable name="fileMIMEType" select="./@MIMETYPE"/>
			<xsl:variable name="fileFixityType" select="./@CHECKSUMTYPE"/>
			<xsl:variable name="fileChecksum" select="./@CHECKSUM"/>
			<xsl:variable name="fileName" select="./mets:FLocat/@xlink:href"/>
			<xsl:variable name="filePos" select="position()"/>
			<xsl:variable name="fileID" select="./@ID"/>
			<xsl:variable name="fileSizeBytes" select="./@SIZE"/>
			<xsl:variable name="fileCreationDate" select="./@CREATED"/>
			<mets:amdSec>
				<xsl:attribute name="ID">
					<xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $representationPos, &apos;-amd&apos;)"/>
				</xsl:attribute>
				<mets:techMD>
					<xsl:attribute name="ID">
						<xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $representationPos, &apos;-amd-tech&apos;)"/>
					</xsl:attribute>
					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
						<mets:xmlData>
							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
								<section id="generalFileCharacteristics">
									<record>
										<key id="label">
											<xsl:choose>
												<xsl:when test="$fileMIMEType = &quot;application/pdf&quot;">
													<xsl:value-of select="$LabelPDF/PDFLabel[@label=$fileID]"/>
												</xsl:when>
												<xsl:when test="$fileMIMEType = &quot;image/tiff&quot;">
													<xsl:value-of select="$LabelTIFF/TIFFLabel[@label=$fileID]"/>
												</xsl:when>
												<xsl:when test="$fileMIMEType = &quot;text/xml&quot;">
													<xsl:value-of select="$LabelFR/FRLabel[@label=$fileID]"/>
												</xsl:when>
											</xsl:choose>
										</key>
										<key id="fileOriginalName">
											<xsl:value-of select="$fileName"/>
										</key>
										<key id="fileMIMEType">
											<xsl:value-of select="$fileMIMEType"/>			
										</key>
										<key id="note">
											<xsl:value-of select="$fileID"/>
										</key>
										<xsl:if test="$fileSizeBytes">
											<key id="fileSizeBytes">
												<xsl:value-of select="$fileSizeBytes"/>
											</key>
										</xsl:if>
										<xsl:if test="$fileCreationDate">
											<key id="fileCreationDate">
												<xsl:value-of select="$fileCreationDate"/>
											</key>
										</xsl:if>
									</record>
								</section>
								<xsl:choose>
									<xsl:when test="$fileChecksum != &apos;&apos;">
										<section id="fileFixity">
											<record>
												<key id="fixityType">
													<xsl:value-of select="$fileFixityType"/>
												</key>
												<key id="fixityValue">
													<xsl:value-of select="$fileChecksum"/>
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
	<xsl:template match="mets:fileSec" mode="fileSec">
		<xsl:apply-templates select="mets:fileGrp" mode="repres"/>
		<xsl:apply-templates select="mets:fileGrp" mode="file"/>
		<mets:fileSec>
			<xsl:for-each select="mets:fileGrp">
				<xsl:variable name="pos" select="position()"/>
				<mets:fileGrp>
					<xsl:attribute name="USE">
						<xsl:value-of select="&apos;VIEW&apos;"/>
					</xsl:attribute>
					<xsl:attribute name="ID">
						<xsl:value-of select="concat(&apos;rep&apos;, $pos)"/>
					</xsl:attribute>
					<xsl:attribute name="ADMID">
						<xsl:value-of select="concat(&apos;rep&apos;, $pos, &apos;-amd&apos;)"/>
					</xsl:attribute>
					<xsl:for-each select="mets:file">
						<xsl:variable name="filePos">
							<xsl:value-of select="position()"/>
						</xsl:variable>
						<mets:file>
							<xsl:attribute name="MIMETYPE">
								<xsl:value-of select="./@MIMETYPE"/>
							</xsl:attribute>
							<xsl:attribute name="ID">
								<xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos)"/>
							</xsl:attribute>
							<xsl:attribute name="ADMID">
								<xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos, &apos;-amd&apos;)"/>
							</xsl:attribute>
							<xsl:copy-of select="mets:FLocat" copy-namespaces="no"/>
						</mets:file>
					</xsl:for-each>
				</mets:fileGrp>
			</xsl:for-each>
		</mets:fileSec>
		<!-- mets:structMap LOGICAL Section -->
		<xsl:for-each select="mets:fileGrp">
			<xsl:variable name="pos" select="position()"/>
			<mets:structMap>
				<xsl:attribute name="TYPE">
					<xsl:value-of select="&apos;LOGICAL&apos;"/>
				</xsl:attribute>
				<xsl:attribute name="ID">
					<xsl:value-of select="concat(&apos;rep&apos;, $pos, &apos;-1&apos;)"/>
				</xsl:attribute>
				<mets:div>
					<xsl:for-each select="./mets:file">
						<xsl:variable name="fileMIMEType" select="./@MIMETYPE"/>
						<xsl:variable name="fileID" select="./@ID"/>
						<xsl:variable name="filePos" select="position()"/>
						<mets:div>
							<xsl:attribute name="TYPE">
								<xsl:value-of select="&apos;FILE&apos;"/>
							</xsl:attribute>
							<xsl:attribute name="LABEL">
								<xsl:choose>
									<xsl:when test="$fileMIMEType = &quot;application/pdf&quot;">
										<xsl:value-of select="$LabelPDF/PDFLabel[@label=$fileID]"/>
									</xsl:when>
									<xsl:when test="$fileMIMEType = &quot;image/tiff&quot;">
										<xsl:value-of select="$LabelTIFF/TIFFLabel[@label=$fileID]"/>
									</xsl:when>
									<xsl:when test="$fileMIMEType = &quot;text/xml&quot;">
										<xsl:value-of select="$LabelFR/FRLabel[@label=$fileID]"/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<mets:fptr>
								<xsl:attribute name="FILEID">
									<xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos)"/>
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
		<xsl:element name="mods:{name()}" namespace="http://www.loc.gov/mods/v3">
			<xsl:copy-of select="namespace::*"/>
			<xsl:apply-templates mode="mods"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*|text()" mode="copy">
		<xsl:copy>
			<xsl:apply-templates mode="copy"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*" mode="copy">
		<xsl:element name="{name()}">
			<xsl:apply-templates mode="copy"/>
		</xsl:element>
	</xsl:template>
	
	<!-- DMD section - generate DC from mods -->
	<!-- Set mapping -->
	<xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods" mode="mods2dc">
		
		<!-- Title -->
		<!-- If mods:titleInfo has attribute type="alternative" map to dcterms:alternative -->
		<!-- else map to dc:title -->
		<xsl:choose>
			<xsl:when test="./mods:titleInfo">
				<xsl:for-each select="./mods:titleInfo">
					<xsl:choose>
						<xsl:when test="./@type=&apos;alternative&apos;">
							<dcterms:alternative>
								<xsl:value-of select="./mods:title"/>
							</dcterms:alternative>
						</xsl:when>
						<xsl:otherwise>
							<!-- Check if mods:subTitle exist. If yes, connect with title -->
							<xsl:choose>
								<xsl:when test="./mods:subTitle">
									<dc:title>
										<xsl:value-of select="concat(./mods:title,&apos; : &apos;,./mods:subTitle)"/>
									</dc:title>
								</xsl:when>
								<xsl:otherwise>
									<dc:title>
										<xsl:value-of select="./mods:title"/>
									</dc:title>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>			
				</xsl:for-each>		
			</xsl:when>
			<!-- If mods:titleInfo does not exist, get title from the mods:number element -->
			<xsl:otherwise>
				<dc:title>
					<xsl:value-of select="./mods:part[@type=&apos;host&apos;]/mods:detail/mods:number"/>
				</dc:title>
<!-- 				<dc:title>
					<xsl:value-of select="//mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div/mets:div/@LABEL"/>
				</dc:title>	 -->		
			</xsl:otherwise>
		</xsl:choose>
 
		<!-- Creator / Conrtibutor -->
		<!-- Differentiate between creator and contributor via the role -->
		<xsl:for-each select="./mods:name[@type=&apos;personal&apos;]/mods:displayForm">
			<!-- Store value of mods:roleTerm in variable -->
			<xsl:variable name="role" select="../mods:role/mods:roleTerm"/>
			<xsl:choose>
				<xsl:when test="$role=&apos;arc&apos; or $role=&apos;art&apos; or $role=&apos;aus&apos; or $role=&apos;aut&apos; or $role=&apos;cmp&apos;">
					<dc:creator>
						<xsl:value-of select="."/>
					</dc:creator>
				</xsl:when>
				<xsl:when test="$role=&apos;com&apos; or $role=&apos;cre&apos; or $role=&apos;ctg&apos; or $role=&apos;lyr&apos; or $role=&apos;pht&apos;">
					<dc:creator>
						<xsl:value-of select="."/>
					</dc:creator>
				</xsl:when>
				<xsl:otherwise>
					<dc:contributor>
						<xsl:value-of select="."/>
					</dc:contributor>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- Description -->
		<xsl:for-each select="./mods:originInfo/mods:edition">
			<dc:description>
				<xsl:value-of select="."/>
			</dc:description>
		</xsl:for-each>
		<!-- All mods:note except with attribute type="citation/reference" -->
		<xsl:for-each select="./mods:note[not(@type=&apos;citation/reference&apos;)]">
			<dc:description>
				<xsl:value-of select="."/>
			</dc:description>
		</xsl:for-each>		

		<!-- Date -->
		<!-- Get mods:dateIssued value from element mods:originInfo with attribute eventType="publication" -->
		<!-- If multivolume_work, choose mods:dateIssued without attribute, else choose mods:dateIssued with attribute "encoding=w3cdtf"-->
		<xsl:choose>
		<xsl:when test="//mets:structMap[@TYPE=&quot;LOGICAL&quot;]/mets:div/@TYPE=&quot;multivolume_work&quot; and //mets:structMap[@TYPE=&quot;LOGICAL&quot;]/mets:div/@DMDID=$dmd_id">
			<xsl:for-each select="./mods:originInfo[@eventType=&apos;publication&apos;]/mods:dateIssued[not(@*)]">
				<dc:date>
					<xsl:value-of select="."/>
				</dc:date>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="./mods:originInfo[@eventType=&apos;publication&apos;]/mods:dateIssued[@*]">
				<dc:date>
					<xsl:value-of select="."/>
				</dc:date>
			</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
		<!-- map other date information to dcterms:issued -->
		<!-- Get mods:dateIssued value from element mods:originInfo without attribute eventType="publication" -->
		<xsl:for-each select="./mods:originInfo[not(@eventType=&apos;publication&apos;)]/mods:dateIssued">			
			<dcterms:issued>
				<xsl:value-of select="."/>
			</dcterms:issued>				
		</xsl:for-each>	
		
		<!-- Publisher -->
		<xsl:for-each select="./mods:originInfo/mods:publisher">
			<dc:publisher>
				<xsl:value-of select="."/>
			</dc:publisher>
		</xsl:for-each>		
		
		<!-- Type -->
		<xsl:for-each select="./mods:typeOfResource">
			<dc:type>
				<xsl:value-of select="."/>
			</dc:type>
		</xsl:for-each>		
		<xsl:for-each select="./mods:genre">
			<dc:type>
				<xsl:value-of select="."/>
			</dc:type>
		</xsl:for-each>			
		<xsl:for-each select="./mods:originInfo/mods:issuance">
			<dc:type>
				<xsl:value-of select="."/>
			</dc:type>
		</xsl:for-each>	

		<!-- Language -->
		<xsl:for-each select="./mods:language/mods:languageTerm">
			<dc:language>
				<xsl:value-of select="."/>
			</dc:language>
		</xsl:for-each>	
		
		<!-- Format -->
		<xsl:for-each select="./mods:physicalDescription/child::*">	
			<dc:format>
				<xsl:value-of select="."/>
			</dc:format>
		</xsl:for-each>	
		
		<!-- Subject -->
		<xsl:for-each select="./mods:subject/child::*">	
			<!-- Test if child of subject has a child too -->
			<xsl:choose>
				<xsl:when test="./child::*">
					<dc:subject>
						<xsl:value-of select="./child::*"/>
					</dc:subject>
				</xsl:when>
				<xsl:otherwise>
					<dc:subject>
						<xsl:value-of select="."/>
					</dc:subject>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>	
		<xsl:for-each select="./mods:classification">	
			<xsl:choose>
				<xsl:when test="./@authority=&apos;ddc&apos;">
					<dc:subject>
						<xsl:value-of select="concat(&apos;DDC: &apos;,.)"/>
					</dc:subject>
					<xsl:if test="./@displayLabel">
						<dc:subject>
							<xsl:value-of select="./@displayLabel"/>
						</dc:subject>					
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<dc:subject>
						<xsl:value-of select="."/>
					</dc:subject>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>	
		
		<!-- Identifier -->
		<xsl:for-each select="./mods:identifier[not(@type=&apos;hbz-idn&apos;)]">	
			<xsl:choose>
				<xsl:when test="./@type = &apos;urn&apos;">
					<xsl:if test="contains(., &apos;urn:nbn:de:&apos;)">
						<dc:identifier>
							<xsl:value-of select="."/>
						</dc:identifier>
						<dc:identifier>
							<xsl:value-of select="concat(&apos;https://nbn-resolving.org/&apos;,.)"/>
						</dc:identifier>
					</xsl:if>					
				</xsl:when>
				<xsl:when test="./@type = &apos;doi&apos;">
					<dc:identifier>
						<xsl:value-of select="concat(./@type,&apos;:&apos;,.)"/>
					</dc:identifier>
					<dc:identifier>
						<xsl:value-of select="concat(&apos;https://doi.org/&apos;,.)"/>
					</dc:identifier>						
				</xsl:when>
				<xsl:when test="./@type = &apos;eki&apos;">
					<dc:identifier>
						<xsl:value-of select="concat(./@type,&apos;:&apos;,.)"/>
					</dc:identifier>					
				</xsl:when>				
				<xsl:otherwise>
					<dc:identifier>
						<xsl:value-of select="."/>
					</dc:identifier>
				</xsl:otherwise>					
			</xsl:choose>		
		</xsl:for-each>
		<xsl:for-each select="./mods:note[@type=&apos;citation/reference&apos;]">
			<dc:identifier>
				<xsl:value-of select="."/>
			</dc:identifier>
		</xsl:for-each>	
		<xsl:for-each select="./mods:recordInfo/mods:recordIdentifier">	
			<dc:identifier>
				<xsl:value-of select="."/>
			</dc:identifier>
		</xsl:for-each>			

		<!-- Rights -->
		<xsl:for-each select="./mods:accessCondition">	
			<dc:rights>
				<xsl:value-of select="."/>
			</dc:rights>
			<xsl:if test="./@xlink:href">
				<dc:rights>
					<xsl:value-of select="./@xlink:href"/>
				</dc:rights>		
			</xsl:if>
		</xsl:for-each>
		
		<!-- Relation -->
		<xsl:for-each select="./mods:relatedItem[@type=&quot;host&quot; or @type=&quot;series&quot;]/mods:identifier">	
			<dc:relation>
				<xsl:value-of select="."/>
			</dc:relation>		
		</xsl:for-each>	
		<xsl:for-each select="./mods:identifier[@type=&apos;hbz-idn&apos;]">
			<dc:relation>
				<xsl:value-of select="."/>
			</dc:relation>	
		</xsl:for-each>

		<!-- isPartOf -->
		<!-- Get title and HT-Number from relatedItem with attribute type="host" -->
		<xsl:for-each select="./mods:relatedItem[@type=&apos;host&apos;]/mods:titleInfo[not(@type=&quot;alternative&quot;)]">	
			<xsl:choose>
				<xsl:when test="./mods:subTitle">
						<dcterms:isPartOf>
							<xsl:value-of select="concat(./mods:title, &apos; : &apos;, ./mods:subTitle)"/>
						</dcterms:isPartOf>
				</xsl:when>
				<xsl:otherwise>
					<dcterms:isPartOf>
						<xsl:value-of select="./mods:title"/> 
					</dcterms:isPartOf>				
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:for-each>
		<xsl:for-each select="./mods:relatedItem[@type=&apos;host&apos;]/mods:recordInfo/mods:recordIdentifier[@source=&quot;ubwretro&quot;]">	
			<dcterms:isPartOf>
				<xsl:value-of select="."/>
			</dcterms:isPartOf>		
		</xsl:for-each>	

		<!-- Get title and HT-Number from relatedItem with attribute type="series" -->
		<xsl:for-each select="./mods:relatedItem[@type=&apos;series&apos;]/mods:titleInfo[not(@type=&quot;alternative&quot;)]">	
			<xsl:choose>
				<xsl:when test="./mods:subTitle">
						<dcterms:isPartOf>
							<xsl:value-of select="concat(./mods:title, &apos; : &apos;, ./mods:subTitle)"/>
						</dcterms:isPartOf>
				</xsl:when>
				<xsl:otherwise>
					<dcterms:isPartOf>
						<xsl:value-of select="./mods:title"/> 
					</dcterms:isPartOf>				
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:for-each>
		<xsl:for-each select="./mods:relatedItem[@type=&apos;series&apos;]/mods:recordInfo/mods:recordIdentifier[@source=&quot;hbz&quot;]">	
			<dcterms:isPartOf>
				<xsl:value-of select="."/>
			</dcterms:isPartOf>		
		</xsl:for-each>		
		

		<!-- hasPart -->
		<!-- Get title from structMap -->
		<xsl:for-each select="//mets:structMap[@TYPE=&quot;LOGICAL&quot;]/mets:div/mets:div">
			<xsl:if test="../@TYPE=&quot;multivolume_work&quot; and ../@DMDID=$dmd_id">
				<dcterms:hasPart>
					<xsl:value-of select="./@LABEL"/>
				</dcterms:hasPart>		
			</xsl:if>	
		</xsl:for-each>			
	</xsl:template>

	<!-- </xsl:template> -->
	<xsl:template match="node()" mode="mods2dc">
		<xsl:apply-templates mode="mods2dc"/>
	</xsl:template>
	
	<!-- mets:structMap PHYSICAL Section -->
	<xsl:template match="mets:structMap[@TYPE=&apos;PHYSICAL&apos;]">
		<mets:structMap>
			<xsl:attribute name="TYPE">
				<xsl:value-of select="./@TYPE"/>
			</xsl:attribute>
			<xsl:attribute name="ID">
				<xsl:value-of select="concat(&apos;structMap-&apos;, ./@TYPE, &apos;-&apos;, position())"/>
			</xsl:attribute>
			<mets:div>
				<xsl:apply-templates select="mets:div/mets:div" mode="phys"/>
			</mets:div>
		</mets:structMap>
	</xsl:template>
	
	<!-- mets:structMap LOGICAL Section -->
	<xsl:template match="mets:structMap[@TYPE=&apos;LOGICAL&apos;]">
		<mets:structMap>
			<xsl:attribute name="TYPE">
				<xsl:value-of select="./@TYPE"/>
			</xsl:attribute>
			<xsl:attribute name="ID">
				<xsl:value-of select="concat(&apos;structMap-&apos;, ./@TYPE, &apos;-&apos;, position())"/>
			</xsl:attribute>
			<mets:div>
				<xsl:apply-templates select="mets:div/mets:div" mode="logic"/>
			</mets:div>
		</mets:structMap>
	</xsl:template>
	
	<!--  List file labels -->
	<!-- Differentiate between book and multivolumework -->
	<!-- PDFs -->
	<xsl:variable name="LabelPDF">
		<xsl:for-each select="//mets:structMap[@TYPE=&apos;LOGICAL&apos;]/mets:div">
			<xsl:choose>
				<xsl:when test="./@TYPE=&apos;multivolume_work&apos;">
					<PDFLabel label="{./mets:div/mets:fptr/@FILEID}">
						<xsl:value-of select="./@LABEL"/>
					</PDFLabel>
				</xsl:when>
				<xsl:otherwise>
					<PDFLabel label="{./mets:fptr/@FILEID}">
						<xsl:value-of select="./@LABEL"/>
					</PDFLabel>				
				</xsl:otherwise>		
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<!-- TIFFs -->
	<xsl:variable name="LabelTIFF">		
		<xsl:for-each select="//mets:structMap[@TYPE=&apos;PHYSICAL&apos;]/mets:div/mets:div">
			<TIFFLabel label="{./mets:fptr[1]/@FILEID}">
				<xsl:value-of select="@LABEL"/>
			</TIFFLabel>
		</xsl:for-each>
	</xsl:variable>
	<!-- FRs -->
	<xsl:variable name="LabelFR">		
		<xsl:for-each select="//mets:structMap[@TYPE=&apos;PHYSICAL&apos;]/mets:div/mets:div">
			<FRLabel label="{./mets:fptr[2]/@FILEID}">
				<xsl:value-of select="@LABEL"/>
			</FRLabel>
		</xsl:for-each>
	</xsl:variable>
	<!-- Templates by default : do nothing -->
	<xsl:template match="@*|node()"/>
</xsl:stylesheet>