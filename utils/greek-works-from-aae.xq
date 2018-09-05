xquery version "3.0" ;

import module namespace aaegreek = "http://perseus.tufts.edu/catalog/dev/aaegreek" at "AAE-Greek.xqm" ;
import module namespace rdfgen = "http://perseus.tufts.edu/catalog/dev/rdfgen" at "rdfgen.xqm" ;

declare variable $file external;

rdfgen:serialize-works-rdf(aaegreek:works($file))