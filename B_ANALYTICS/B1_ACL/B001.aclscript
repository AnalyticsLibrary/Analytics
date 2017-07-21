
COMMENT
***********************************************************
analyse B001 overzicht saldi per periode
Het script gaat voor alle grootboekrekeningen (eerste loop in 
script B001a) door alle periodes heen (tweede loop in B001b) en 
bepaalt cumulatieve saldi (voor balans) of periodesaldi (voor
(V&W). Niet ideaal voor performance maar levert wel het netste
overzicht op.
***********************************************************

COM - eerst tabel generalLeder relateren aan transactions om 
COM - rekeningomschrijvingen in het overzicht op te kunnen nemen
COM - grootboekrekening omschrijvingen en types te kunnen gebruiken. 

OPEN generalLedger
INDEX ON accID TO "generalLedger_on_accID"

OPEN transactions
DEFINE RELATION accID WITH generalLedger INDEX generalLedger_on_accID

COM - vervolgens bepalen welke periodes voorkomen
COM - zodat per periode een cumulatief saldo uitgerekend kan worden
COM - analyse verondersteld overigens dat beginbalans onderdeel is van
COM - van de transacties.
COM - indien een dataset meerdere jaren bevat, moet deze per jaar worden gedraaid
COM - om te voorkomen dat de cumulatieven voor de balans niet kloppen.
COM - De rest van dit script veronderstelt een dataset van 1 jaar en een beginbalans
COM - als onderdeel van de transacties. 

OPEN transactions
SORT ON VAL(periodNumber, 0) TO scr01 OPEN 
SUMMARIZE ON VAL(periodNumber, 0) AS "a_periode" TO periods_table OPEN

COUNT
ASSIGN v_total_periods = COUNT1
ASSIGN v_periods_done = 0

OPEN transactions
SORT ON accID To scr01 OPEN 
SUMMARIZE On accID TO accounts_table OPEN

COUNT
ASSIGN v_total_accounts = COUNT1
ASSIGN v_accounts_done = 0


COM - vervolgens door de tabel met periodes 'loopen'
COM - om per periode het cumulatief saldo te bepalen
COM - omdat in het subscript B001 wordt gegenereerd met APPEND moet deze voorafgaand
COM - aan het subscript worden verwijderd om te voorkomen dat deze bij meerdere
COM - keren uitvoeren, een omjuist beeld geeft.

DELETE FORMAT scr02 OK
DELETE scr02.fil OK

OPEN transactions
DEFINE FIELD a_periode COMPUTED VAL(periodNumber, 0)
SORT ON accID generalLedger.accDesc generalLedger.accTp TO scr01 OPEN 

DO SCRIPT B001a WHILE v_accounts_done < v_total_accounts

OPEN scr02
DEFINE FIELD per_ COMPUTED ZONED(a_periode, 2)
CROSSTAB ON accID accDesc COLUMNS per_ SUBTOTAL a_Amount TO "B001.FIL" OPEN

EXPORT FIELDS ALL XLSX TO B001
