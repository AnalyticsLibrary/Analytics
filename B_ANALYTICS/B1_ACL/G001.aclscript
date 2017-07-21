
COMMENT
***********************************************************
analyse G001
matrix Cijferbeoordeling ingehouden loonbelasting in relatie
tot bruto belongingscomponenten
***********************************************************

COMMENT - uit header algemene informatie halen

OPEN HEADER
ASSIGN vBedrijf = companyName
ASSIGN vJaar = fiscalYear

COMMENT - transactions koppelen aan GeneralLedger om te bepalen wel RGS label per transctie is toegekend.

OPEN GeneralLedger
INDEX ON accID TO "GL_on_AccID"
OPEN transactions
DEFINE RELATION accID WITH GeneralLedger INDEX GL_on_AccID

COMMENT - velden aanmaken die noodzakelijk zijn voor de analyse

DEFINE FIELD bedrag COMPUTED 

 trLine_amnt IF trLine_amntTp = "D"
 trLine_amnt * -1.00

DEFINE FIELD periode COMPUTED SUBSTRING(DATE(trDt) 1 4)+ "-" + ZONED(VAL(periodNumber, 0) 2)

COMMENT - overzicht van in auditfile voorkomende periodes genereren

SORT ON periode to scr01 OPEN
SUMMARIZE ON periode to periodebestand

COMMENT - bedragen per periode berekenen voor loonheffing en lonen

GROUP
SUMMARIZE ON periode SUBTOTAL bedrag IF MATCH(GeneralLedger.leadReference "BSchLheAfb") AND bedrag < 0 TO loonheffing
SUMMARIZE ON periode SUBTOTAL bedrag IF MATCH(GeneralLedger.leadReference "WPerLesTep" "WPerLesLon" "WPerLesOwe" "WPerLesOnr" "WPerLesGra" "WPerLesLin" "WPerLesOnu" "WPerLesOlr") TO lonen
END

COMMENT - berekende bedragen koppelen aan periodes

OPEN loonheffing
INDEX ON periode TO "loonheffing_on_periode"

OPEN lonen
INDEX ON periode TO "lonen_on_periode"

OPEN periodebestand
DEFINE RELATION periode WITH loonheffing INDEX loonheffing_on_periode
DEFINE RELATION periode WITH lonen INDEX lonen_on_periode

EXTRACT FIELDS periode lonen.bedrag AS 'lonen' loonheffing.bedrag AS 'loonheffing' TO scr01 OPEN 

COMMENT - ratio berkenen

DEFINE FIELD percentage COMPUTED

 (loonheffing * -1.00) / lonen * 100.00 IF lonen <> 0 
 100.00
 
EXTRACT FIELDS SUBSTRING("%vBedrijf%" 1 50) AS 'bedrijf' SUBSTRING("%vJaar%" 1 4) AS 'boekjaar' periode lonen loonheffing percentage TO G001 OPEN

EXPORT FIELDS ALL XLSX TO G001

