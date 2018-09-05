xquery version "3.0" ;

module namespace rdfgen = "http://perseus.tufts.edu/catalog/dev/rdfgen" ;
import module namespace ctsurn = "http://perseus.tufts.edu/catalog/dev/ctsurn" at "ctsurn.xqm" ;



declare function rdfgen:author-rdf($author) {
    <efrbroo:F10_Person
        xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:owl="http://www.w3.org/2002/07/owl#"
        rdf:about="http://catalog.perseus.org/people/{$author/@n}">
        <rdfs:label>{normalize-space(xs:string($author/@label))}</rdfs:label>
        <owl:sameAs rdf:resource="http://viaf.org/viaf/{$author/@viaf}"/>
    </efrbroo:F10_Person>
};

declare function rdfgen:work-rdf($work) {
    <efrbroo:F15_Complex_Work
        xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        rdf:about="{xs:string($work/@ctsurn)}">
        <rdfs:label>{normalize-space(xs:string($work/@label))}</rdfs:label>
        <efrbroo:P149_is_identified_by>{xs:string($work/@ctsurn)}</efrbroo:P149_is_identified_by>
        <efrbroo:R10i_is_member_of rdf:resource="{$work/@textgroup}"/>
        { if ($work/@tlg) then
            <efrbroo:P149_is_identified_by>{xs:string($work/@tlg)}</efrbroo:P149_is_identified_by>
          else () }
        { if ($work/@phi) then
            <efrbroo:P149_is_identified_by>{xs:string($work/@phi)}</efrbroo:P149_is_identified_by>
          else () }
        { if ($work/@stoa) then
            <efrbroo:P149_is_identified_by>{xs:string($work/@stoa)}</efrbroo:P149_is_identified_by>
          else () }
        { if ($work/@author) then
          <efrbroo:R16i_initiated_by>
            <efrbroo:F27_Work_Conception>
                <efrbroo:P14_carried_out_by
                    rdf:resource="http://www.viaf.org/viaf/{$work/@author}"/>
            </efrbroo:F27_Work_Conception>
          </efrbroo:R16i_initiated_by>
          else ()
        }
</efrbroo:F15_Complex_Work>
};

declare function rdfgen:expression-rdf($expression) {
    if (ctsurn:valid-cts-urn-p($expression/@ctsurn)) then
        let $ctsurn := ctsurn:object($expression/@ctsurn)
        let $workid := string-join((ctsurn:textgroup($ctsurn), ctsurn:work($ctsurn)), '.')
        let $workurn := string-join(('urn', 'cts', ctsurn:namespace($ctsurn), $workid), ':')
        return
        <efrbroo:F22_Self_Contained_Expression
            xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            rdf:about="{$expression/@ctsurn}">
            <rdfs:label>{xs:string($expression/@ctsurn)}</rdfs:label>
            <efrbroo:P149_is_identified_by>{xs:string($expression/@ctsurn)}</efrbroo:P149_is_identified_by>
            <efrbroo:R9i_realises>
                <efrbroo:F1_Work>
                    <efrbroo:R10i_is_member_of
                        rdf:resource="{$workurn}"/>
                </efrbroo:F1_Work>
            </efrbroo:R9i_realises>
        </efrbroo:F22_Self_Contained_Expression>
     else ()
};

declare function rdfgen:manifestation-rdf($manifestation) {
    <efrbroo:F3_Manifestation_Product_Type
        xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        rdf:about="http://www.worldcat.org/oclc/{$manifestation/@oclc}">
        {
            for $work in $manifestation/work
            for $expr in $work/expression
            return
              <efrbroo:CLR6_should_carry>
               <efrbroo:F24_Publication_Expression>
                     <efrbroo:P165_incorporates rdf:resource="{$expr/@id}"/>
               </efrbroo:F24_Publication_Expression>
              </efrbroo:CLR6_should_carry>
        }
    </efrbroo:F3_Manifestation_Product_Type>
};

declare function rdfgen:serialize-works-rdf($works) {
<rdf:RDF
         xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:owl="http://www.w3.org/2002/07/owl#">

         { for $w in $works return rdfgen:work-rdf($w) }     
</rdf:RDF>
};

declare function rdfgen:serialize-authors-rdf($authors) {
<rdf:RDF
         xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:owl="http://www.w3.org/2002/07/owl#">

         { for $a in $authors return rdfgen:author-rdf($a) }         
</rdf:RDF>
};


declare function rdfgen:serialize-expressions-rdf($expressions) {
<rdf:RDF
         xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:owl="http://www.w3.org/2002/07/owl#">
         { for $e in $expressions return rdfgen:expression-rdf($e) }   
</rdf:RDF>
};


declare function rdfgen:serialize-manifestations-rdf($manifestations) {
<rdf:RDF
         xmlns:efrbroo="http://erlangen-crm.org/efrbroo/"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:owl="http://www.w3.org/2002/07/owl#">
         { for $m in $manifestations return rdfgen:manifestation-rdf($m) }
</rdf:RDF>
};
