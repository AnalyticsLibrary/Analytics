
COM - met een loop door alle rekeningen 
COM - om vervolgens per rekening door alle periodes te lopen en subtotalen te bepalen

OPEN accounts_table
ASSIGN v_accounts_done = v_accounts_done + 1 
LOCATE RECORD v_accounts_done
ASSIGN v_account = accID


ASSIGN v_periods_done = 0

DO SCRIPT B001b WHILE v_periods_done < v_total_periods
