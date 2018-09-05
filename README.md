# Perseus Authority Data
This repository contains metadata about authors, works, and expressions in the Perseus Catalog, derived from the AAE spreadsheets and then hand-corrected.


The repository includes a few utilities for re-generating the metadata from the AAE spreadsheets.

## How to Use these Data

- Generate a knowledge base with basic RDFS inferences: 

infer --rdfs=efrbroo.rdf expressions.rdf.xml manifestations.rdf.xml works-greek.rdf.xml authors-greek.rdf.xml works-latin.rdf.xml authors-latin.rdf.xml > pcat.nt

Load pcat.nt into a triple store. E.g., for Fuseki:

s-delete http://localhost:3030/perseus_catalog default
s-post http://localhost:3030/perseus_catalog default pcat.nt

## How to Recreate these Data from the AAE spreadsheet
  * 	Download the Google Spreadsheet as xlsx
  * 	Convert it to xls format (can use Excel for this)
  * 	Use Oxygen to import the Greek worksheet as GreekAuthors.xml
  * 	Use Oxygen to import the Latin worksheet as LatinAuthors.xml
  * 	Use saxon and xqueries to generate the files:
    * 	java -cp saxon9he.jar net.sf.saxon.Query -q:"greek-works-from-aae.xq" -o:works-greek.rdf.xml file="AAE-Greek.xml" \!indent=yes 
    * 	java -cp saxon9he.jar net.sf.saxon.Query -q:"greek-authors-from-aae.xq" -o:authors-greek.rdf.xml file="AAE-Greek.xml" \!indent=yes
    * 	java -cp saxon9he.jar net.sf.saxon.Query -q:"latin-works-from-aae.xq" -o:works-latin.rdf.xml file="AAE-Latin.xml" \!indent=yes
    * 	java -cp saxon9he.jar net.sf.saxon.Query -q:"latin-authors-from-aae.xq" -o:authors-latin.rdf.xml file="AAE-Latin.xml" \!indent=yes
  * 	Validate the files using riot:
      * 	riot --validate works-greek.rdf.xml
      * 	riot --validate authors-greek.rdf.xml
      * 	riot --validate works-latin.rdf.xml
      * 	riot --validate authors-latin.rdf.xml

## How to Recreate the Expression and Manifestation Data from MODS
	* java -cp saxon9he.jar net.sf.saxon.Query -q:"expressions-from-mods.xq" -o:expressions.rdf.xml collection="mods" \!indent=yes 
	* java -cp saxon9he.jar net.sf.saxon.Query -q:"manifestations-from-mods.xq" -o:manifestations.rdf.xml collection="mods" \!indent=yes 	

