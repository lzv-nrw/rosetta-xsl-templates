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
		InputStream xml = Thread.currentThread().getContextClassLoader().getResourceAsStream("de/nrw/hbz/rosetta/xsl/opus4/opus4.xml");
		InputStream xsl = Thread.currentThread().getContextClassLoader().getResourceAsStream("de/nrw/hbz/rosetta/xsl/opus4/opus4.xsl");
		xsl(xml, new StreamSource(xsl));
	}
	
	@Test
	public void testEprints() {
		InputStream xml = Thread.currentThread().getContextClassLoader().getResourceAsStream("de/nrw/hbz/rosetta/xsl/eprints/eprints.xml");
		InputStream xsl = Thread.currentThread().getContextClassLoader().getResourceAsStream("de/nrw/hbz/rosetta/xsl/eprints/eprints.xsl");
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
