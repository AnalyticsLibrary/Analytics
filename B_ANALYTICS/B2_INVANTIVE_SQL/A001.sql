local remark Analyse A001

local remark Saldibalans per periode

select tle.interface_url
,      tle.transaction_periodnumber
,      gat.accid
,      gat.accdesc
,      sum(amnt) amnt
from   transactionlines tle
join   generalledgeraccounts gat
on     gat.accid = tle.accid
and    gat.interface_url = tle.interface_url
group 
by    tle.interface_url
,     tle.transaction_periodnumber
,     gat.accid
,     gat.accdesc

local export results as "c:\temp\A001.xlsx" format xlsx include headers include sql

