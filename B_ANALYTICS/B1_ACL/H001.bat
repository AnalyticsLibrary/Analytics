COMMENT - uit header algemene informatie halen

OPEN HEADER
ASSIGN vBedrijf = companyName
ASSIGN vJaar = fiscalYear

COMMENT - transactions koppelen aan GeneralLedger om te bepalen wel RGS label per transctie is toegekend.

OPEN transactions

DEFINE FIELD bedrag COMPUTED 

 trLine_amnt IF trLine_amntTp = "D"
 trLine_amnt * -1

DEFINE FIELD btw_bedrag COMPUTED 

 vatAmnt IF vatAmntTp = "D"
 vatAmnt * -1

SORT periodNumber jrnTp custSupID  vatID IF MATCH(jrnTp "P" "S") AND (custSupID <> " ") AND (btw_bedrag <> 0.00) TO scr01 OPEN 

OPEN customersSuppliers
INDEX ON custSupID TO "cs_on_csID"
OPEN scr01
DEFINE RELATION custSupID WITH customersSuppliers INDEX cs_on_csID

SUMMARIZE ON periodNumber jrnTp custSupID customersSuppliers.custSupName AS 'custSupName' vatID OTHER customersSuppliers.taxRegistrationCountry AS 'taxRegistrationCountry' SUBTOTAL bedrag btw_bedrag  TO scr02 OPEN 

DEFINE FIELD percentage COMPUTED
	
	(btw_bedrag / bedrag) * 100.00 IF bedrag <> 0.00
	bedrag

 
EXTRACT FIELDS SUBSTRING("%vBedrijf%" 1 50) AS 'bedrijf' SUBSTRING("%vJaar%" 1 4) AS 'boekjaar' periodNumber jrnTp custSupID custSupName taxRegistrationCountry bedrag btw_bedrag  percentage  TO A001 OPEN

EXPORT FIELDS ALL XLSX TO A001

