
COMMENT
************************************************************
H004 - voorbereiding voor aansluiting tussen administratie 
en de BTW aangifte gebruik makend van de RGS labels zoals
opgenomen in het entrypoint voor de OB-aangifte
************************************************************

COM gebruiker de mogelijkheid geven om aangifte frequentie in te stellen
COM uit commenten wat niet van toepassing

ASSIGN v_frequentie = "maand"
ASSIGN v_frequentie = "kwartaal"


COM - inlezen van xml bestand om link te bepalen tussen
COM - RGS labels en aangiftevelden. Dit XML bestand (arcroles.xml) is af
COM - komstig van http://www.nltaxonomie.nl/rgs/10.0/report/rgs/linkroles/rgs-mapping_ob-aangifte-2016.xml
COM - en wordt ingelezen als platte tekst 


IMPORT DELIMITED TO sr01 "sr01.fil" FROM "arcroles.xml" 0 SEPARATOR "^" QUALIFIER NONE CONSECUTIVE STARTLINE 1 FIELD "Field_1" C AT 1 DEC 0 WID 955 PIC "" AS "" 

COM - vervolgens worden hier de records uit gefilterd die de link tussen RGS en aangifte weer geven

EXTRACT FIELDS ALL IF FIND('xlink:type="arc"') = T TO arcroles OPEN  

COM - vervolgens veld aangifteveld aanmaken door parsen van het veld

DEFINE FIELD a_aangifteveld COMPUTED EXCLUDE(SPLIT(SPLIT(Field_1, 'xlink:to="', 2), '" xlink:from="',1), "bd-ob_")

COM - vervolgens veld rgs_label aanmaken door parsen van het veld (maximeren op 13 en 10 tekens)

DEFINE FIELD a_rgs_label COMPUTED SUBSTRING(SPLIT(SPLIT(Field_1, 'rgs-i_', 2), '" xlink',1) 1 13)

DEFINE FIELD a_rgs_label_10 COMPUTED SUBSTRING(a_rgs_label 1 10)

INDEX ON a_rgs_label TO arcroles_on_label_13
INDEX ON a_rgs_label TO arcroles_on_label_10

COM - vervolgens aangiftevelden koppelen aan grootboekrekeningen waarbij zowel gekeken wordt naar 10-teken label als 13-teken label

OPEN generalLedger
DEFINE RELATION leadReference WITH arcroles INDEX arcroles_on_label_13
DEFINE RELATION leadReference WITH arcroles INDEX arcroles_on_label_10

EXTRACT FIELDS ALL arcroles.a_aangifteveld arcroles.a_rgs_label TO a_generalLedger_arc OPEN

INDEX ON accID to a_generalLedger_arc_on_accID

COM - vervolgens transacties bepalen die volgens de arcroles horen bij velden in de  BTW aangifte

OPEN transactions
DEFINE RELATION accID WITH a_generalLedger_arc INDEX a_generalLedger_arc_on_accID

COM - velden aanmaken voor intelling

DEFINE FIELD periode COMPUTED ZONED(VAL(periodNumber, 0) 2)

DEFINE FIELD kwartaal COMPUTED 

 "Q1" IF MATCH(periodNumber "1" "2" "3")
 "Q2" IF MATCH(periodNumber "4" "5" "6")
 "Q3" IF MATCH(periodNumber "7" "8" "9")
 "Q4" IF MATCH(periodNumber "10" "11" "12" "13")
 "BB" IF MATCH(periodNumber "00")
 "X"

DEFINE FIELD bedrag COMPUTED 

 trLine_amnt * -1.00 IF trLine_amntTp = "C"
 trLine_amnt

COM - filter variabele aanmaken zodat output ongeacht aangiftefrequentie wordt gegenereerd.

IF v_frequentie = "maand" ASSIGN v_filter = "periode" 
IF v_frequentie = "kwartaal" ASSIGN v_filter = "kwartaal" 

SORT ON accID a_generalLedger_arc.accDesc a_generalLedger_arc.a_rgs_label a_generalLedger_arc.a_aangifteveld %v_filter% TO scr01 OPEN 

SUMMARIZE ON accID a_generalLedger_arc.accDesc a_generalLedger_arc.a_rgs_label a_generalLedger_arc.a_aangifteveld %v_filter% SUBTOTAL bedrag IF a_generalLedger_arc.a_aangifteveld <> "" TO aangiftetotalen OPEN 

COM - vervolgens crosstabulate uitvoeren om kolommen per aangifte periode te maken 

CROSSTAB ON accID accDesc a_rgs_label a_aangifteveld COLUMNS %v_frequentie% SUBTOTAL bedrag TO "H004.FIL" OPEN


