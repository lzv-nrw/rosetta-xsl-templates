/*******************************************************************************
 * Copyright 2019 hbz
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 ******************************************************************************/

package de.nrw.hbz.rosetta.xsl;

import java.io.InputStream;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;

/**
 * 
 * @author Jan Schnasse
 *
 */
public class TestXslTransformations {

	@Test
	public void testOpus4() {
		/**
		 * Example call for:
		 * <ul>
		 * <li>https://opus.bibliothek.fh-aachen.de/opus4/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://pub.h-brs.de/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://opus.bsz-bw.de/fhdo/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://whge.opus.hbz-nrw.de/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://opus4.kobv.de/opus4-rhein-waal/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://publiscologne.th-koeln.de/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://www.hs-owl.de/skim/opus/oai
		 * <li>https://repositorium.hs-ruhrwest.de/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://hss-opus.ub.ruhr-uni-bochum.de/opus4/oai?verb=ListRecords&metadataPrefix=oai_dc
		 * </ul>
		 */
		test("opus4");
	}

	@Test
	public void testEprints() {
		/**
		 * Example call for:
		 * <ul>
		 * <li>http://kups.ub.uni-koeln.de/cgi/oai2?verb=ListRecords&metadataPrefix=oai_dc
		 * </ul>
		 */
		test("eprints");
	}

	@Test
	public void testHydra() {
		/**
		 * Example call for:
		 * <ul>
		 * <li>http://hydra.ub.ruhr-uni-bochum.de/oai/oai2.php?verb=ListRecords&metadataPrefix=oai_dc
		 * </ul>
		 */
		test("hydra");
	}

	@Test
	public void invenio() {
		/**
		 * Example call for:
		 * <ul>
		 * <li>http://juser.fz-juelich.de/oai2d?verb=ListRecords&metadataPrefix=oai_dc&set=OA
		 * </ul>
		 */
		test("invenio");
	}
	
	@Test
	public void mycore() {
		/**
		 * Example call for:
		 * <ul>
		 * <li>http://duepublico.uni-duisburg-essen.de/servlets/OAIDataProvider?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>https://ub-deposit.fernuni-hagen.de/servlets/OAIDataProvider?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>http://elpub.bib.uni-wuppertal.de/servlets/OAIDataProvider?verb=ListRecords&metadataPrefix=oai_dc
		 * <li>
		 * </ul>
		 */
		test("mycore");
	}
	
	@Test
	public void vlBielefeld() {
		/**
		 * https://pub.uni-bielefeld.de/oai?verb=ListRecords&metadataPrefix=oai_dc&set=open_access
		 */
		test("vlBielefeld");
	}
	
	@Test
	public void vlBonn() {
		/**
		 * http://digitale-sammlungen.ulb.uni-bonn.de/oai?verb=ListRecords&metadataPrefix=oai_dc
		 */
		test("vlBonn");
	}
	
	@Test
	public void alfresco() {
		/**
		 * http://repositorium.uni-muenster.de/oai/miami?verb=ListRecords&metadataPrefix=oai_dc
		 */
		test("alfresco");
	}

	public void test(String name) {
		String path = "de/nrw/hbz/rosetta/xsl/" + name + "/" + name;
		InputStream xml = Thread.currentThread().getContextClassLoader().getResourceAsStream(path + ".xml");
		InputStream xsl = Thread.currentThread().getContextClassLoader().getResourceAsStream(path + ".xsl");
		xsl(xml, new StreamSource(xsl));
	}

	public void xsl(InputStream xml, Source xsl) {
		try {
			TransformerFactory factory = TransformerFactory.newInstance();
			Templates template = factory.newTemplates(xsl);
			Transformer xformer = template.newTransformer();
			Source source = new StreamSource(xml);
			Result result = new StreamResult(System.out);
			xformer.transform(source, result);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

}
