
OPEN periods_table
ASSIGN v_periods_done = v_periods_done + 1 
LOCATE RECORD v_periods_done
ASSIGN v_period = a_periode


OPEN scr01

SUMMARIZE ON accID generalLedger.accDesc SUBTOTAL a_Amount OTHER %v_period% AS "a_periode" IF a_periode <= v_period AND generalLedger.accTp = "B" AND accID = "%v_account%" TO scr02 APPEND

SUMMARIZE ON accID generalLedger.accDesc SUBTOTAL a_Amount OTHER %v_period% AS "a_periode" IF a_periode  = v_period AND generalLedger.accTp = "P" AND accID = "%v_account%" TO scr02 APPEND

