/************************************************************************/
/* Program Name : Portfolio_Stress_Reporting.sas                        */
/* Project      : Banking Stress Testing Framework                      */
/* Phase        : VIII - Portfolio Stress Reporting                     */
/************************************************************************/


/*---------------------------------------------------------------------*/
/* Step 1 - Create Executive Summary Dataset                           */
/*---------------------------------------------------------------------*/

proc sql;

create table stress.ecl_summary as

select

       Scenario_Name

     , count(*)                                    as Account_Count

     , sum(EAD)                                    as Total_Exposure
              format=comma20.2

     , sum(Base_ECL)                               as Total_Base_ECL
              format=comma20.2

     , sum(Stressed_ECL)                           as Total_Stressed_ECL
              format=comma20.2

     , sum(Incremental_Stress_Loss)                as Incremental_Stress_Loss
              format=comma20.2

from stress.portfolio_ecl

group by Scenario_Name

order by Scenario_Name
;

quit;


/*---------------------------------------------------------------------*/
/* Step 2 - Summary Validation                                         */
/*---------------------------------------------------------------------*/

proc print data=stress.ecl_summary noobs;

title "Executive Stress Testing Summary";

run;


/*---------------------------------------------------------------------*/
/* Step 3 - Scenario Ranking                                           */
/*---------------------------------------------------------------------*/

proc sort
     data=stress.ecl_summary
     out=work.scenario_ranking;

     by descending Incremental_Stress_Loss;

run;

proc print data=work.scenario_ranking noobs;

title "Scenario Ranking By Stress Loss";

run;


/*---------------------------------------------------------------------*/
/* Step 4 - Product Level Summary                                      */
/*---------------------------------------------------------------------*/

proc sql;

create table stress.product_ecl_summary as

select

       Scenario_Name

     , Product_Type

     , count(*)                    as Account_Count

     , sum(EAD)                    as Total_Exposure
            format=comma20.2

     , sum(Stressed_ECL)           as Total_Stressed_ECL
            format=comma20.2

from stress.portfolio_ecl

group by
       Scenario_Name
     , Product_Type
;

quit;

proc print
     data=stress.product_ecl_summary(obs=50);

title "Product Level Stress Report";

run;


/*---------------------------------------------------------------------*/
/* Step 5 - Risk Segment Summary                                       */
/*---------------------------------------------------------------------*/

proc sql;

create table stress.segment_ecl_summary as

select

       Scenario_Name

     , Risk_Segment

     , count(*)                    as Account_Count

     , sum(EAD)                    as Total_Exposure
            format=comma20.2

     , sum(Stressed_ECL)           as Total_Stressed_ECL
            format=comma20.2

from stress.portfolio_ecl

group by
       Scenario_Name
     , Risk_Segment
;

quit;

proc print
     data=stress.segment_ecl_summary;

title "Risk Segment Stress Report";

run;


/*---------------------------------------------------------------------*/
/* Step 6 - Worst 20 Accounts                                          */
/*---------------------------------------------------------------------*/

proc sort
     data=stress.portfolio_ecl
     out=work.top_accounts;

     by descending Stressed_ECL;

run;

proc print
    data=work.top_accounts(obs=20);

title "Top 20 Accounts By Stressed ECL";

run;


/*---------------------------------------------------------------------*/
/* Step 7 - Portfolio Metadata                                         */
/*---------------------------------------------------------------------*/

proc contents
     data=stress.ecl_summary;

title "Executive Summary Structure";

run;


/*---------------------------------------------------------------------*/
/* Step 8 - Final Completion Message                                   */
/*---------------------------------------------------------------------*/

data _null_;

put "---------------------------------------------------";
put "PHASE VIII COMPLETED SUCCESSFULLY";
put "PORTFOLIO STRESS REPORTING READY";
put "CORE SAS STRESS TESTING FRAMEWORK COMPLETE";
put "---------------------------------------------------";

run;

title;