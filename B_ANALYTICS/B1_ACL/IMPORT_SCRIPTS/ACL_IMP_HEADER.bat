COMMENT
*******************************************************************************
* dit script importeert relevante velden uit de header van het audit
* om vast te stellen uit welk bronstysteeem het auditfile afkomstig is. 
* Vervolgens wordt door dit script het juiste importscript uitgevoerd.
*******************************************************************************

SET SAFETY OFF
CLOSE PRIM SEC
SET FOLDER /Tables/B0_Input

DateFormat = "YYYY-MM-DD"
SET DATE DateFormat

COM - eerst de naam van het auditfile achterhalen en in een variabele opnemen
COM - vervolgens relevante velden uit de header importeren en in een tussenbestand stoppen

ASSIGN v_TablesDone = v_TablesDone + 1

DIRECTORY "*.xaf" SUPPRESS TO table_list.fil 
OPEN table_list
ASSIGN v_InputFile = ALLTRIM(File_Name)

IMPORT XML TO scr01 "scr01.fil" FROM "%v_InputFile%" FIELD "productID" C AT 1 DEC 0 WID 49 PIC "" AS "" RULE "/auditfile/header/productID/text()" FIELD "softwareDesc" C AT 50 DEC 0 WID 50 PIC "" AS "" RULE "/auditfile/header/softwareDesc/text()" FIELD "fiscalYear" C AT 100 DEC 0 WID 10 PIC "" AS "" RULE "/auditfile/header/fiscalYear/text()" FIELD "productVersion" C AT 110 DEC 0 WID 20 PIC "" AS "" RULE "/auditfile/header/productVersion/text()" FIELD "softwareVersion" C AT 130 DEC 0 WID 20 PIC "" AS "" RULE "/auditfile/header/softwareVersion/text()"

COMMENT
*******************************************************************************
* vervolgens waarden uit het tussenbestand opnemen in variabelen let op: 
* bronsysteem en versie kunnen onder 2 verschillende namen voorkomen in het auditfile.
* om te voorkomen dat 'oude' variabelen ten onrechte worden gebruikt, worden
* deze eerst leeg gemaakt. 
*******************************************************************************

DELETE v_Year OK
DELETE v_ProductID OK 
DELETE v_Version OK 

ASSIGN v_Year = fiscalYear
ASSIGN v_ProductID = productID IF productID <> "" 
ASSIGN v_ProductID = softwareDesc IF softwareDesc <> ""
ASSIGN v_Version = productVersion
ASSIGN v_Version = softwareVersion IF softwareVersion <> ""


COMMENT
********************************************************************************
* Vervolgens op basis de opgebouwde variabelen bepalen welk inleescript moet
* moet worden opgestart. Het inleesscript zorgt voor het inlezen van de verschillende
* tabellen en het omvormen tot de juiste namen (zoals in de auditfile standaard) 
* en het appenden van de verschillende auditfiles zodat analyses eventueel over 
* meerdere jaren tegelijk kunnen worden gedraaid.
*********************************************************************************
****** LET OP: vooralsnog alleen het importscript voor de standaard auditfile 
****** opgenomen. Afwijkende naamgeving die door sommige pakketten wordt 
****** gehanteerd in de opbouw van een auditfile wordt nog niet ondersteund
****** en moet dus aangepast worden in het importscript
*********************************************************************************

DO SCRIPT ACL_IMP_STANDAARD



COMMENT
****************************************************************
* Verwijder opgebouwde tussenbestanden
****************************************************************

DELETE FORMAT scr01 OK
DELETE scr01.fil OK
