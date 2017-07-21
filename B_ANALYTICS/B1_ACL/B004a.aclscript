
COM - beginnen met record van periode die moet worden geanalyseerd
COM - te bepalen door teller op te hogen met 1
COM - en in de periode-tabel de betreffend regel te localiseren


OPEN periods_table
ASSIGN v_periods_done = v_periods_done + 1 
LOCATE RECORD v_periods_done
ASSIGN v_period = periodNumber

OPEN scr01
SUMMARIZE ON accID accDesc leadReference  SUBTOTAL a_Amount IF periodNumber <= v_period TO scr02 OPEN 

EXTRACT FIELDS "%v_period%" AS "a_periode" accID accDesc leadReference a_Amount TO B004 APPEND
