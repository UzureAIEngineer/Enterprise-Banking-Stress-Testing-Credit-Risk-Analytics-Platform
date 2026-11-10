/*============================================================================*/
/* Program Name : Phase_III_Scenario_Creation.sas                             */
/* Project      : Banking Stress Testing Framework                            */
/* Purpose      : Create and validate macroeconomic stress scenarios          */
/* Author       : Umesh Zure                                                  */
/*============================================================================*/

/*---------------------------------------------------------------------------*/
/* Step 1 : Create Scenario Master Dataset                                   */
/*---------------------------------------------------------------------------*/

data stress.scenario_master;

    length Scenario_Name $20;

    input
        Scenario_ID
        Scenario_Name $
        GDP_Growth
        Unemployment_Rate
        Interest_Rate
        HPI_Change;

    datalines;
1 Baseline      6   5   6    0
2 Mild_Stress   3   7   8  -10
3 Severe_Stress -2 10  11  -25
;
run;

/*---------------------------------------------------------------------------*/
/* Step 2 : Dataset Validation                                               */
/*---------------------------------------------------------------------------*/

title "Scenario Master Dataset";

proc print data=stress.scenario_master noobs;
run;

/*---------------------------------------------------------------------------*/
/* Step 3 : Metadata Validation                                              */
/*---------------------------------------------------------------------------*/

title "Scenario Master Structure";

proc contents data=stress.scenario_master;
run;

/*---------------------------------------------------------------------------*/
/* Step 4 : Scenario Count Validation                                        */
/*---------------------------------------------------------------------------*/

title "Scenario Frequency Validation";

proc freq data=stress.scenario_master;

    tables Scenario_Name / nocum;

run;

/*---------------------------------------------------------------------------*/
/* Step 5 : Summary Statistics Validation                                    */
/*---------------------------------------------------------------------------*/

title "Scenario Variable Summary";

proc means data=stress.scenario_master
           n mean min max
           maxdec=2;

    var
        GDP_Growth
        Unemployment_Rate
        Interest_Rate
        HPI_Change;

run;

/*---------------------------------------------------------------------------*/
/* Step 6 : Final Dataset Verification                                       */
/*---------------------------------------------------------------------------*/

proc sql;

    select count(*) as Scenario_Count
    from stress.scenario_master;

quit;

/*---------------------------------------------------------------------------*/
/* Step 7 : Completion Message                                               */
/*---------------------------------------------------------------------------*/

data _null_;

    put "NOTE: Phase III - Scenario Creation Completed Successfully.";

run;

title;