
COMMENT
***********************************************************
analyse B003
controle op afboekingen van debiteuren via andere dagboeken
dan bank of verkoop/inkoop
***********************************************************

COM - eerst tabel generalLeder relateren aan transactions om 
COM - rekeningomschrijvingen in het overzicht op te kunnen nemen
COM - en RGS labels te kunnen gebruiken


OPEN generalLedger
INDEX ON accID TO "generalLedger_on_accID"

OPEN transactions
DEFINE RELATION accID WITH generalLedger INDEX generalLedger_on_accID

COM - tranacties op rekeningen debiteuren en crediteuren apart zetten

EXTRACT FIELDS ALL generalLedger.accDesc generalLedger.leadReference IF UPPER(SUBSTRING(generalLedger.leadReference 1 10)) = "BVORDEBHAD" OR UPPER(SUBSTRING(generalLedger.leadReference 1 10)) = "BSCHCREHAC" TO scr01 OPEN 

COM - vervolgens bepalen wat de afwijkende grootboeken zijn. Let hierbij op, de jrnTp velden
COM - bevatten niet altijd standaard waardes. Uitgangspunt is echter dat een crediteuren-rekening
COM - alleen geraakt wordt door inkoopboek ("P") en bankboek ("B") en debiteuren alleen door 
COM - verkoopboek ("S") en bank. 

DEFINE FIELD a_afwijkend_dagboek COMPUTED
	
	"nee" IF UPPER(SUBSTRING(leadReference 1 10)) = "BVORDEBHAD" AND jrnTp = "B"
	"nee" IF UPPER(SUBSTRING(leadReference 1 10)) = "BVORDEBHAD" AND jrnTp = "S"
	"nee" IF UPPER(SUBSTRING(leadReference 1 10)) = "BSCHCREHAC" AND jrnTp = "B"
	"nee" IF UPPER(SUBSTRING(leadReference 1 10)) = "BSCHCREHAC" AND jrnTp = "P"
	"ja"
 
DEFINE FIELD a_Amount COMPUTED 

	trLine_amnt * -1 IF ALLTRIM(trLine_amntTp) = "C"
	trLine_amnt

EXTRACT FIELDS a_afwijkend_dagboek  a_fiscalYear  jrnID  journal_desc  jrnTp  transaction_nr  trLine_nr  transaction_desc  periodNumber  a_buiten_periode  trDt  effDate   accID accDesc leadReference docRef  trLine_desc  custSupID  invRef a_Amount vatID  vatPerc  vatAmnt  vatAmntTp IF a_afwijkend_dagboek = "ja" TO "B010" OPEN


EXPORT FIELDS ALL XLSX TO B003


