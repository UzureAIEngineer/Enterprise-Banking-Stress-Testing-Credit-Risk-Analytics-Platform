/************************************************************************/
/* Program Name : ECL_Calculation.sas                                   */
/* Project      : Banking Stress Testing Framework                      */
/* Phase        : VII - Expected Credit Loss Calculation                */
/************************************************************************/


/*---------------------------------------------------------------------*/
/* Step 1 - Create ECL Dataset                                          */
/*---------------------------------------------------------------------*/

data stress.portfolio_ecl;

    set stress.portfolio_lgd;

    /*-------------------------------------------------------------*/
    /* Exposure At Default (EAD)                                   */
    /*-------------------------------------------------------------*/

    EAD = Outstanding_Balance;

    /*-------------------------------------------------------------*/
    /* Base ECL                                                    */
    /*-------------------------------------------------------------*/

    Base_ECL =
        EAD
        *
        Base_PD
        *
        Base_LGD;

    /*-------------------------------------------------------------*/
    /* Stressed ECL                                                */
    /*-------------------------------------------------------------*/

    Stressed_ECL =
        EAD
        *
        Stressed_PD
        *
        Stressed_LGD;

    /*-------------------------------------------------------------*/
    /* Incremental Stress Loss                                     */
    /*-------------------------------------------------------------*/

    Incremental_Stress_Loss =
        Stressed_ECL
        -
        Base_ECL;

    format
        EAD                     comma18.2
        Base_ECL               comma18.2
        Stressed_ECL           comma18.2
        Incremental_Stress_Loss comma18.2;

run;


/*---------------------------------------------------------------------*/
/* Step 2 - Record Count Validation                                    */
/*---------------------------------------------------------------------*/

proc sql;

    title "Portfolio ECL Record Count Validation";

    select count(*) as Total_Records
    from stress.portfolio_ecl;

quit;


/*---------------------------------------------------------------------*/
/* Step 3 - Scenario-wise ECL Summary                                  */
/*---------------------------------------------------------------------*/

proc means data=stress.portfolio_ecl
           n sum mean min max
           maxdec=2;

    class Scenario_Name;

    var
        Base_ECL
        Stressed_ECL
        Incremental_Stress_Loss;

    title "Scenario-wise ECL Summary";

run;


/*---------------------------------------------------------------------*/
/* Step 4 - Risk Segment Impact                                        */
/*---------------------------------------------------------------------*/

proc means data=stress.portfolio_ecl
           n sum
           maxdec=2;

    class
        Scenario_Name
        Risk_Segment;

    var
        Stressed_ECL;

    title "Scenario and Risk Segment ECL";

run;


/*---------------------------------------------------------------------*/
/* Step 5 - Product Level Impact                                       */
/*---------------------------------------------------------------------*/

proc means data=stress.portfolio_ecl
           n sum
           maxdec=2;

    class
        Scenario_Name
        Product_Type;

    var
        Stressed_ECL;

    title "Scenario and Product Level ECL";

run;


/*---------------------------------------------------------------------*/
/* Step 6 - Top Stressed Accounts                                      */
/*---------------------------------------------------------------------*/

proc sort
    data=stress.portfolio_ecl
    out=work.top_ecl;

    by descending Stressed_ECL;

run;

proc print
    data=work.top_ecl(obs=25);

    title "Top 25 Accounts by Stressed ECL";

run;


/*---------------------------------------------------------------------*/
/* Step 7 - Metadata Validation                                        */
/*---------------------------------------------------------------------*/

proc contents data=stress.portfolio_ecl;

    title "Portfolio ECL Dataset Structure";

run;


/*---------------------------------------------------------------------*/
/* Step 8 - Completion Message                                         */
/*---------------------------------------------------------------------*/

data _null_;

    put "NOTE: Phase VII - ECL Calculation Completed Successfully.";

run;

title;