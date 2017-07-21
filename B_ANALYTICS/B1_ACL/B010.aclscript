
COMMENT
***********************************************************
analyse B010
Controle op boekingen die buiten de periode-grenzen zijn
geboekt
***********************************************************

COM - eerst tabel generalLeder relateren aan transactions om 
COM - rekeningomschrijvingen in het overzicht op te kunnen nemen
COM - idem tabel periods (waarbij een sleutel wordt aan gemaakt
COM - op basis van jaar + periode in geval een auditfile meerdere
COM - jaren bestrijkt)

OPEN generalLedger
INDEX ON accID TO "generalLedger_on_accID"

OPEN periods
DEFINE FIELD KEY COMPUTED SUBSTRING((ALLTRIM(a_fiscalYear) + "_" + ALLTRIM(periodNumber)) 1 7)
INDEX ON KEY TO periods_on_key

OPEN transactions
DEFINE FIELD KEY COMPUTED SUBSTRING((ALLTRIM(a_fiscalYear) + "_" + ALLTRIM(periodNumber)) 1 7)
DEFINE RELATION KEY WITH periods INDEX periods_on_key
DEFINE RELATION accID WITH generalLedger INDEX generalLedger_on_accID

COM - vervolgens filteren op boekingen waarvan de transactiedatum voor de start van de periode
COM - ligt of na de einddatum van de periode. Tevens wordt periode 0 buiten beschouwing gelaten
COM - voor het overzicht wordt hier een apart veld voor aan gemaakt. 
COM - overigens kunnen auditfiles diverse datum-velden hebben. In onderstaande voorbeeld is uit
COM - gegaan van trDt maar een alternatief zou kunnen zijn effDate

DEFINE FIELD a_buiten_periode COMPUTED
	
	"ja" IF trDt < periods.startDatePeriod AND periodNumber <> "0"
	"ja" IF trDt > periods.endDatePeriod AND periodNumber <> "0"
	""
 
DEFINE FIELD a_Amount COMPUTED 

	trLine_amnt * -1 IF ALLTRIM(trLine_amntTp) = "C"
	trLine_amnt

EXTRACT FIELDS a_buiten_periode  a_fiscalYear  jrnID  journal_desc  jrnTp  transaction_nr  trLine_nr  transaction_desc  periodNumber  a_buiten_periode  trDt  effDate  periods.startDatePeriod  periods.endDatePeriod  accID  docRef  trLine_desc  custSupID  invRef a_Amount vatID  vatPerc  vatAmnt  vatAmntTp IF a_buiten_periode = "ja"  TO "B010" OPEN


EXPORT FIELDS ALL XLSX TO B010


