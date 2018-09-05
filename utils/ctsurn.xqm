xquery version "3.0";

module namespace ctsurn = "http://perseus.tufts.edu/catalog/dev/ctsurn" ;

(: abstraction for CTS objects. :)

declare function ctsurn:object($cts-urn as xs:string)
as element()
{
    let $regex := "^urn:cts:([^:]+):([^.]*)\.?([^.]*)?\.?(.*?)?$"
    let $result := fn:analyze-string($cts-urn, $regex)
    return
        if ($result/fn:match) then
            $result/fn:match
        else
            error((), "not a cts urn: |" || $cts-urn || '|')
};

declare function ctsurn:valid-cts-urn-p($str as xs:string)
{
    let $regex := "^urn:cts:([^:]+):([^.]*)\.([^.]*)\.?(.*?)?$"
    let $result := fn:analyze-string($str, $regex)/fn:match
    return
        not(empty($result/fn:group[@nr = 1]) or empty($result/fn:group[@nr = 2]) or empty($result/fn:group[@nr = 3]))
};

declare function ctsurn:work($cts-object as element())
as xs:string
{
    xs:string($cts-object/fn:group[@nr = 3])
};

declare function ctsurn:edition($cts-object as element())
as xs:string
{
    xs:string($cts-object/fn:group[@nr = 4])
};

declare function ctsurn:namespace($cts-object as element())
as xs:string
{
    xs:string($cts-object/fn:group[@nr = 1])
};

declare function ctsurn:textgroup($cts-object as element())
as xs:string
{
    xs:string($cts-object/fn:group[@nr = 2])
};

