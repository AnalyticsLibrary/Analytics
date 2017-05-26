
COMMENT
***********************************************************
analyse A002
matrix van dagboek per grootboek
***********************************************************

COM - eerst tabel generalLedger relateren aan transactions

OPEN generalLedger
INDEX ON accID TO "generalLedger_on_accID"
OPEN transactions
DEFINE RELATION accID WITH generalLedger INDEX generalLedger_on_accID

COM - vervolgens veld aan maken bestaande uit periode en jaar zodat analyse
COM - ook werkt met bestand waarin meerdere jaren zijn opgenomen
COM - en bedrag-veld met het juiste teken

DEFINE FIELD a_Period COMPUTED a_fiscalYear + "_" + ZONED(VAL(periodNumber, 0), 2)

DEFINE FIELD a_Amount COMPUTED 

	trLine_amnt * -1 IF ALLTRIM(trLine_amntTp) = "C"
	trLine_amnt

COM - vervolgens crosstabulate om output te genereren

CROSSTAB ON accID generalLedger.accDesc COLUMNS a_Period SUBTOTAL a_Amount TO "A002.FIL" OPEN

EXTRACT FIELDS ALL XLSX TO A002



