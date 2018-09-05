xquery version "3.0";

import module namespace rdfgen = "http://perseus.tufts.edu/catalog/dev/rdfgen" at "rdfgen.xqm" ;
declare namespace mods = "http://www.loc.gov/mods/v3";
declare variable $collection external;

declare function local:expressions($collection) {
    for $ctsurn at $n in
    distinct-values(collection($collection)//mods:relatedItem[@otherType = 'expression']/mods:identifier[@type = 'ctsurn'])
    return
        <expression n="{$n}" ctsurn="{normalize-space($ctsurn)}"/>
};

rdfgen:serialize-expressions-rdf(local:expressions($collection))