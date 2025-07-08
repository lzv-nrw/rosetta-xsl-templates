# Collection of XSL scripts for various OAI-PMH slangs

XSLT files and corresponding tests created within the context of LZV.nrw are published here.

## Instructions

Under the path src/test/java/de/nrw/hbz/rosetta/xsl the subdirectories have a structure like
```
...
xsl
├── institution_1
│   ├── institution_1.xml
│   ├── institution_1.xsl
│   ├── institution_1_result.xml
│   ├── set_1
│   │   ├── set_1.xml
│   │   ├── set_1.xsl
│   │   ├── set_1_result.xml
│   └── set_2
│       ├── set_2.xml
│       ├── set_2.xsl
│       └── set_2_result.xml
├── institution_2
│   ├── source_template.xml
│   ...
...
└── TestXslTransformations.java
```
The files `institution_x.xml`, `institution_x.xsl` and `institution_x_result.xml` here serve as templates.
The source metadata to be transformed should be inserted in `institution_x.xml` and the XSLT code for the transformation in `institution_x.xsl`. The result will be saved by the program itself in `institution_x_result.xml`. 
Afterwards, to perform a transformation, uncomment the corresponding test for the institution in the `TestXslTransformations.java` file and execute it.
The directory `set_x` contains an example transformation for a set with associated XSLT.


# Legacy
## Opus 4
1. <https://opus.bibliothek.fh-aachen.de/opus4/oai?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://pub.h-brs.de/oai?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://opus.bsz-bw.de/fhdo/oai?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://whge.opus.hbz-nrw.de/oai?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://opus4.kobv.de/opus4-rhein-waal/oai?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://publiscologne.th-koeln.de/oai?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://www.hs-owl.de/skim/opus/oai?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://repositorium.hs-ruhrwest.de/oai?verb=ListRecords&metadataPrefix=oai_dc>

## Opus 4 Bochum
1. <https://hss-opus.ub.ruhr-uni-bochum.de/opus4/oai?verb=ListRecords&metadataPrefix=oai_dc>

Example where Content is harvested with separate script, due to restrictions of Rosetta OAI-Harvester functionality 

## Eprints
1. <http://kups.ub.uni-koeln.de/cgi/oai2?verb=ListRecords&metadataPrefix=oai_dc>

## Various
1. <http://hydra.ub.ruhr-uni-bochum.de/oai/oai2.php?verb=ListRecords&metadataPrefix=oai_dc>

## Invenio
1. <http://juser.fz-juelich.de/oai2d?verb=ListRecords&metadataPrefix=oai_dc&set=OA>

## LibreCat
1. <https://pub.uni-bielefeld.de/oai?verb=ListRecords&metadataPrefix=oai_dc&set=open_access>


## Mycore
1. <http://duepublico.uni-duisburg-essen.de/servlets/OAIDataProvider?verb=ListRecords&metadataPrefix=oai_dc>
1. <https://ub-deposit.fernuni-hagen.de/servlets/OAIDataProvider?verb=ListRecords&metadataPrefix=oai_dc>
1. <http://elpub.bib.uni-wuppertal.de/servlets/OAIDataProvider?verb=ListRecords&metadataPrefix=oai_dc>

## Visual Library
1. <http://digitale-sammlungen.ulb.uni-bonn.de/oai?verb=ListRecords&metadataPrefix=oai_dc>

## Alfresco
1. <http://repositorium.uni-muenster.de/oai/miami?verb=ListRecords&metadataPrefix=oai_dc>