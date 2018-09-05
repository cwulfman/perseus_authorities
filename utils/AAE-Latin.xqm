xquery version "3.0" ;

module namespace aaelatin = "http://perseus.tufts.edu/catalog/dev/aaelatin" ;

import module namespace rdfgen = "http://perseus.tufts.edu/catalog/dev/rdfgen" at "rdfgen.xqm" ;

(: utility functions :)

declare function aaelatin:padleft($str as xs:string, $padchar as xs:string, $len as xs:integer) as xs:string
{
    if (string-length($str) >= $len)
    then
        $str
    else
        aaelatin:padleft(concat($padchar, $str), $padchar, $len)
};

declare function aaelatin:phi-id($idstring as xs:string) {
    let $tokens := tokenize($idstring, '\.')
    return
        if (count($tokens) = 2) then
            "phi" || aaelatin:padleft($tokens[1], "0", 4) || ".phi" || aaelatin:padleft($tokens[2], "0", 3)
        else
            "NNNNnnnnnn"
};

declare function aaelatin:stoa-id($idstring as xs:string) as xs:string
{
    string-join((tokenize($idstring, '-')), '.')
};

declare function aaelatin:phi-id-of($row) as xs:string?
{
    if ($row/PHI_ and not(empty($row/PHI_)) and not($row/PHI_/text() = "none"))
    then
        normalize-space($row/PHI_[1])
    else
        ()
};

declare function aaelatin:stoa-id-of($row) as xs:string?
{
    if ($row/STOA_ and not(empty($row/STOA_)) and not($row/STOA_/text() = "none"))
    then
        normalize-space($row/STOA_[1])
    else
        ()
};

declare function aaelatin:ctsurn-of($row as element()) as xs:string
{
    let $prefix := "urn:cts:latinLit:"
    return
        if ($row/PHI_ and not(empty($row/PHI_)) and not($row/PHI_/text() = "none"))
        then
            concat($prefix, aaelatin:phi-id(normalize-space($row/PHI_[1])))
        else
            if ($row/STOA_ and not(empty($row/STOA_)) and not($row/STOA_/text() = "none"))
            then
                concat($prefix, aaelatin:stoa-id(normalize-space($row/STOA_[1])))
            else
                "XXXXXXXXX"
};

declare function aaelatin:textgroup-of($ctsurn as xs:string) as xs:string?
{
    let $textgroup := tokenize(tokenize($ctsurn, ':')[4], '\.')[1]
    return
        if ($textgroup) then
            concat('urn:cts:latinLit:', $textgroup)
        else
            ()
};


declare function aaelatin:authors($latin-file, $index as xs:integer) {
    let $all-authors :=
        for $row in doc($latin-file)//row
        let $viaf := normalize-space($row/VIAF_URI)
        let $label := normalize-space($row/LC_NAME_TITLE_or_VIAF_AUTHOR_NAME)
        group by $viaf
        order by $label[1]
        return
            <author viaf="{$viaf[1]}" label="{$label[1]}"/>
    for $a at $n in $all-authors
    order by $a/@label
    return
        <author
            n="{$index + $n}"
            viaf="{$a/@viaf}"
            label="{$a/@label}"/>
};

declare function aaelatin:works($latin-file) {
    for $row at $n in doc($latin-file)//row[not(empty(WORK_TITLE))]
    let $ctsurn := aaelatin:ctsurn-of($row)
    let $author-viaf := normalize-space($row/VIAF_URI)
    let $label := normalize-space($row/WORK_TITLE)
    let $phi_id := 
        if (aaelatin:phi-id-of($row)) then
            aaelatin:phi-id-of($row)
        else ()
    let $stoa_id := 
        if (aaelatin:stoa-id-of($row)) then
            aaelatin:stoa-id-of($row)
        else ()
    return
        <work
            ctsurn="{$ctsurn}"
            author="{$author-viaf}"
            phi_id="{$phi_id}"
            stoa_id="{$stoa_id}"
            textgroup="{aaelatin:textgroup-of($ctsurn)}"
            label="{$label}"/>
};
