
COMMENT
***********************************************************
analyse B011
Controle op consistentie in boekingen van inkoopfacturen
per relatie
***********************************************************

COM - eerst tabel customerSuppliers relateren aan transactions om 
COM - namen van de relaties in het overzicht op te kunnen nemen
COM - idem tabel generalLeder voor rekeningomschrijvingenb
COM - transacties filteren op alleen inkoopboek

OPEN generalLedger
INDEX ON accID TO "generalLedger_on_accID"

OPEN customersSuppliers
INDEX ON custSupID TO "customerSuppliers_on_ID"

OPEN transactions
EXTRACT FIELDS ALL IF jrnTp = "P" TO scr01 OPEN 
DEFINE RELATION custSupID WITH customersSuppliers INDEX customerSuppliers_on_ID
DEFINE RELATION accID WITH generalLedger INDEX generalLedger_on_accID


COM - Omdat het custSupID niet altijd op dezelfde wijze in het auditfile wordt opgenomen
COM - dient eerst geverifieerd te worden hoe dit in het onderhavige geval is verwerkt
COM - de rest van dit script veronderstelt dat custSupID op elke regel van de boeking
COM - is opgenomen. 

COM - bepaal de waarde van de boeking met juiste teken

DEFINE FIELD a_Amount COMPUTED 

	trLine_amnt * -1 IF ALLTRIM(trLine_amntTp) = "C"
	trLine_amnt

COM - vervolgens sorteren en intellen op relatie type en nummer en grootboekrekening

SORT ON custSupID customersSuppliers.custSupName accID generalLedger.accDesc TO scr02 OPEN 

SUMMARIZE ON custSupID customersSuppliers.custSupName accID generalLedger.accDesc SUBTOTAL trLine_amnt TO scr03 OPEN 

EXPORT FIELDS ALL XLSX TO B011


