xquery version "3.0" ;

import module namespace aaelatin = "http://perseus.tufts.edu/catalog/dev/aaelatin" at "AAE-Latin.xqm" ;
import module namespace rdfgen = "http://perseus.tufts.edu/catalog/dev/rdfgen" at "rdfgen.xqm" ;

declare variable $file external;

rdfgen:serialize-authors-rdf(aaelatin:authors($file, 9000))