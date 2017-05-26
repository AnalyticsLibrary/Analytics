
COMMENT
***********************************************************
analyse B004
controle op negatieve kas per einde van enige periode
***********************************************************

COM - eerst tabel generalLeder relateren aan transactions om 
COM - rekeningomschrijvingen in het overzicht op te kunnen nemen
COM - en RGS labels te kunnen gebruiken
COM - let op: als er meerdere grootboekrekningen kas zijn, worden
COM - deze in dit script samengevoegd. 
COM - in dat geval kan een alternatief zijn om niet het RGS label
COM - te gebruiken maar om het filter op transactions per grootboekrekening
COM - uit te voeren. 

OPEN generalLedger
INDEX ON accID TO "generalLedger_on_accID"

OPEN transactions
DEFINE RELATION accID WITH generalLedger INDEX generalLedger_on_accID

COM - tranacties op rekeningen kas apart zetten

EXTRACT FIELDS ALL generalLedger.accDesc generalLedger.leadReference IF UPPER(SUBSTRING(generalLedger.leadReference 1 7)) = "BLIMKAS" TO scr01 OPEN 

COM - vervolgens bepalen welke periodes voorkomen
COM - zodat per periode een cumulatief saldo uitgerekend kan worden
COM - analyse verondersteld overigens dat beginbalans onderdeel is van
COM - van de transacties

OPEN transactions
SORT ON periodNumber TO scr02 OPEN 
SUMMARIZE ON periodNumber TO periods_table OPEN


COM - vervolgens door de tabel met periodes 'loopen'
COM - om per periode het cumulatief saldo te bepalen
COM - omdat in het subscript B004 wordt gegenereerd met APPEND moet deze voorafgaand
COM - aan het subscript worden verwijderd om te voorkomen dat deze bij meerdere
COM - keren uitvoeren, een omjuist beeld geeft.

DELETE FORMAT B004 OK
DELETE B004.fil OK

COUNT
ASSIGN v_total_periods = COUNT1
ASSIGN v_periods_done = 0

DO SCRIPT B004a WHILE v_periods_done < v_total_periods

OPEN B004

DEFINE FIELD a_negatief COMPUTED

	"ja" IF a_Amount < 0
	"nee"

EXPORT FIELDS a_negatief a_periode accID accDesc leadReference a_amount XLSX TO B004
