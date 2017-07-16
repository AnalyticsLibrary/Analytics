
COMMENT
*******************************************************************************
* dit script bepaalt welke XAF bestanden in de actieve ACL DIRECTORY
* zijn opgeslagen en zal vervolgens een script opstarten waarmee de HEADER
* uitgelezen wordt. Op basis van de informatie in de header wordt het juiste 
* import-script opgestart (voor zover beschikbaar). 
*******************************************************************************
***** LET OP: als er meerdere xaf-bestanden in de directory zijn opgenomen, 
***** zullen deze automatisch acher elkaar ingelezen worden. Omdat de output
***** van de importscripts elke keer dezelfde namen heeft, zullen deze dus 
***** worden overschreven
*******************************************************************************

DIRECTORY "*.xaf" SUPPRESS TO table_list.fil 


OPEN table_list
COUNT
ASSIGN v_NumberTables = COUNT1
ASSIGN v_TablesDone = 0
CLOSE table_list


DO SCRIPT ACL_IMP_HEADER WHILE v_TablesDone < v_NumberTables
