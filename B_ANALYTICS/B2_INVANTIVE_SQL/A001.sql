local remark Analyse A001

local remark Saldibalans per periode

local remark Voor gebruik met de Invantive XML Auditfile Financieel v3.2 driver.

select dtl.interface_url
,      dtl.company_name
,      dtl.fiscal_year_number
,      dtl.transaction_periodnumber
,      dtl.accid
,      dtl.accdesc
,      dtl.opening_balance
,      dtl.balance
,      coalesce(dtl.opening_balance, 0) + coalesce(dtl.balance, 0) total_balance
from   --
       -- De volgende selectie verzamelt de totalen. Aangezien er een cumulatief totaal
       -- nodig is (en voor balans inclusief openingstand) is er een relatie gelegd met 
       -- periods op kleiner dan/gelijk aan.
       --
       -- Dit kan op sommige andere database platforms opgelost worden met een sum()
       -- over (window).
       --
       ( select gat.interface_url
         ,      gat.company_name
         ,      gat.fiscal_year_number
         ,      prd.periodnumber transaction_periodnumber
         ,      gat.accid
         ,      gat.accdesc
         ,      obe.balance opening_balance
         ,      sum(tle.balance) balance
         from   generalledgeraccounts gat
         join   periods prd
         on     prd.interface_url = gat.interface_url
         left 
         outer
         join   transactionlines tle
         on     tle.accid                    = gat.accid
         and    tle.interface_url            = gat.interface_url
         and    tle.transaction_periodnumber <= prd.periodnumber
         left 
         outer 
         join   OpeningBalanceLines obe
         on     obe.interface_url = gat.interface_url
         and    obe.accid         = gat.accid
         group 
         by     gat.interface_url
         ,      gat.company_name
         ,      gat.fiscal_year_number
         ,      gat.accid
         ,      gat.accdesc
         ,      prd.periodnumber
         ,      obe.balance
       ) dtl
--
-- Laat standen met overal 0 achterwege.
--       
where  coalesce(dtl.opening_balance, 0) != 0
       or
       coalesce(dtl.balance, 0) != 0
order 
by     dtl.interface_url
,      dtl.company_name
,      dtl.fiscal_year_number
,      dtl.transaction_periodnumber
,      dtl.accid
,      dtl.accdesc

local export results as "C:\ws\Analytics\B_ANALYTICS\B2_INVANTIVE_SQL\A001.xlsx" format xlsx include headers include sql
