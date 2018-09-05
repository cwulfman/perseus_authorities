xquery version "3.0" ;

module namespace aaegreek = "http://perseus.tufts.edu/catalog/dev/aaegreek" ;

import module namespace rdfgen = "http://perseus.tufts.edu/catalog/dev/rdfgen" at "rdfgen.xqm" ;


(:~
    Converts string like "1891.001" to "tlg1891.tlg001"
:)
declare function aaegreek:tlg-prefix($idstring) {
    let $tokens := tokenize($idstring, '\.')
    return
        "tlg" || $tokens[1] || ".tlg" || $tokens[2]
};

declare function aaegreek:authors($file, $index as xs:integer) {
    let $all-authors :=
     for $row in doc($file)//row
     let $viaf := normalize-space($row/VIAF_URI)
     let $label := normalize-space($row/LC_or_VIAF_AUTHOR_NAME)
     group by $viaf
     order by $label[1]
     return
        <author
            viaf="{$viaf[1]}"
            label="{$label[1]}"/>
    for $a at $n in $all-authors
    order by $a/@label
    return
        <author
            n="{$index + $n}"
            viaf="{$a/@viaf}"
            label="{$a/@label}"/>
};

declare function aaegreek:works($file) {
    for $row in doc($file)//row
    let $workTitle := normalize-space($row/WORK_TITLE)
    (: generate author reference :)
    let $author-viaf := normalize-space($row/VIAF_URI)
    (: generate an entry for each TLG :)
    for $i in tokenize($row/TLG_, ",")
    where not($i = ('n.a.', 'none', 'no', '', 'uncertain', 'various'))
    let $tlg-prefix := aaegreek:tlg-prefix(normalize-space($i))
    let $tokens := tokenize($tlg-prefix, '/.')
    let $textgroup := $tokens[1]
    let $work := $tokens[2]
    let $textgroup-urn := string-join(('urn', 'cts', 'greekLit', $textgroup), ':')
    let $ctsurn := string-join(($textgroup-urn, $work), '.')
    return
        <work
            ctsurn="{$ctsurn}"
            author="{$author-viaf}"
            textgroup="{$textgroup-urn}"
            label="{$workTitle}" />
};