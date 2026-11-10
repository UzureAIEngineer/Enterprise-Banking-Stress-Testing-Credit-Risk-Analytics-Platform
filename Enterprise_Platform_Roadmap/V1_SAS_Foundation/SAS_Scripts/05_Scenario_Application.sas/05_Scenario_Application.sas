/*============================================================*/
/* Phase IV - Scenario Application                            */
/*============================================================*/

proc sql;

create table stress.portfolio_scenario as

select
      a.*
    , b.Scenario_ID
    , b.Scenario_Name
    , b.GDP_Growth
    , b.Unemployment_Rate
    , b.Interest_Rate
    , b.HPI_Change

from stress.portfolio_dpd as a

cross join stress.scenario_master as b
;

quit;

proc sql;

select count(*) as Total_Records
from stress.portfolio_scenario;

quit;


proc freq data=stress.portfolio_scenario;

tables Scenario_Name;

run;

proc contents data=stress.portfolio_scenario;
run;

proc print data=stress.portfolio_scenario(obs=20);
run;