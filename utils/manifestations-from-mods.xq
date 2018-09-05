xquery version "3.0";

import module namespace rdfgen = "http://perseus.tufts.edu/catalog/dev/rdfgen" at "rdfgen.xqm" ;
declare namespace mods = "http://www.loc.gov/mods/v3";
declare variable $collection external;

declare function local:manifestations($collection) {
    for $mods at $n in collection($collection)//mods:mods
    let $oclc := normalize-space($mods/mods:identifier[@type = 'oclc'][1])
    return
        <manifestation
            n="{$n}"
            oclc="{$oclc}">
            {
                for $work in $mods//mods:relatedItem[@otherType = 'work']
                let $wid := xs:string($work/mods:identifier[@type = 'ctsurn'][1])
                return
                    <work
                        id="{$wid}">
                        {
                            for $expr in $work/mods:relatedItem[@otherType = 'expression']/mods:identifier[@type = 'ctsurn']
                            return
                                <expression
                                    id="{normalize-space($expr)}"/>
                        }
                    </work>
            }
        </manifestation>
};


rdfgen:serialize-manifestations-rdf(local:manifestations($collection))