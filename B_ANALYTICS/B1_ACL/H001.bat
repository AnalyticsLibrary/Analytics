COMMENT
***********************************************************
analyse H001
BTW percentages per relatie
***********************************************************


OPEN transactions

COM eerst velden aanmaken voor bedragen met de juiste tekens

DEFINE FIELD a_Amount COMPUTED 

 trLine_amnt IF trLine_amntTp = "D"
 trLine_amnt * -1

DEFINE FIELD a_VAT_Amount COMPUTED 

 vatAmnt IF vatAmntTp = "D"
 vatAmnt * -1

COM vervolgens sorteren op relatie en alleen dagboeken inkoop en verkoop 
COM bewaren 
 
SORT a_fiscalYear a_companyName periodNumber jrnTp custSupID  vatID IF MATCH(jrnTp "P" "S") AND (custSupID <> " ") AND (a_VAT_Amount <> 0.00) TO scr01 OPEN 

COM vervolgens relatie leggen tussen relaties en transacties om naam van relatie
COM en landcode toe te kunnen voegen

OPEN customersSuppliers
INDEX ON custSupID TO "cs_on_csID"
OPEN scr01
DEFINE RELATION custSupID WITH customersSuppliers INDEX cs_on_csID

COM vervolgens intellen op relatie

SUMMARIZE ON periodNumber jrnTp custSupID customersSuppliers.custSupName AS 'custSupName' vatID OTHER a_fiscalYear a_companyName customersSuppliers.taxRegistrationCountry AS 'taxRegistrationCountry' SUBTOTAL a_Amount a_VAT_Amount  TO scr02 OPEN 

COM effectief BTW percentage per relatie berekenenen. 
COM als geen grondslag is opgenomen, dan default 100% opnemen.

DEFINE FIELD percentage COMPUTED
	
	(a_VAT_Amount / a_Amount) * 100.00 IF a_Amount <> 0.00
	100.00

COM export genereren.  
 
EXTRACT a_fiscalYear a_companyName periodNumber jrnTp custSupID custSupName taxRegistrationCountry a_Amount a_VAT_Amount percentage  TO H001 OPEN

EXPORT FIELDS ALL XLSX TO H001