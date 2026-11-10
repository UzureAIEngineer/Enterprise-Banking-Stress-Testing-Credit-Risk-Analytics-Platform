/***************************************************************************/
/* Program Name : PD_Stress_Im**ct.sas                           **        */
/* Project      : Bank**g Stress Testing Framework       **                */
/* Author     **: Umesh Zure                                               */
/*                                                                         */
/* Purpose      :                                                          */
/* Apply Probability of Default (PD) stress adjustments to the scenario    */
/* expanded portfolio generated during Phase IV.                           */
/***************************************************************************/

/*-----------------------------------------------------------------------*/
/* Step 1 : Create PD-Stressed Portfolio Dataset                          */
/*-----------------------------------------------------------------------*/

data stress.portfolio_pd;

    set stress.portfolio_scenario;

    length PD_Band $20;

    /********************************************************************/
    /* Assign Base PD using Risk Segment                                */
    /********************************************************************/

      if Risk_Segment = "Low Risk" then Base_PD = 0.02;

      else if Risk_Segment = "Medium Risk" then Base_PD = 0.05;

      else if Risk_Segment = "High Risk" then Base_PD = 0.10;

      else Base_PD = 0.15;
                              
                              
    /********************************************************************/
    /* Apply Scenario Stress Factor                                      */
    /********************************************************************/
       if Scenario_Name = "Baseline" then PD_Factor = 1.00;

       else if Scenario_Name = "Mild_Stress" then  PD_Factor = 1.25;

       else if Scenario_Name = "Severe_Stress" then PD_Factor = 1.75;

       else PD_Factor = 1.00;
                                

    /********************************************************************/
    /* Calculate Stressed PD                                             */
    /********************************************************************/

    Stressed_PD = Base_PD * PD_Factor;

    /********************************************************************/
    /* PD Banding                                                        */
    /********************************************************************/

    if Stressed_PD <= 0.03 then PD_Band = "Low PD";

       else if Stressed_PD <= 0.08 then PD_Band = "Medium PD";

       else PD_Band = "High PD";

    format
        Base_PD     percent8.2
        PD_Factor   8.2
        Stressed_PD percent8.2;

run;

/*-----------------------------------------------------------------------*/
/* Step 2 : Record Count Validation                                      */
/*-----------------------------------------------------------------------*/

proc sql;

    title "PD Stress Dataset Count Validation";

    select count(*) as Total_Records
    from stress.portfolio_pd;

quit;

/*-----------------------------------------------------------------------*/
/* Step 3 : Scenario-wise PD Summary                                     */
/*-----------------------------------------------------------------------*/

proc means data=stress.portfolio_pd n mean min max maxdec=4;

    class Scenario_Name;

    var
        Base_PD
        Stressed_PD;

    title "Scenario-wise PD Summary";

run;

/*-----------------------------------------------------------------------*/
/* Step 4 : PD Band Validation                                           */
/*-----------------------------------------------------------------------*/

proc freq data=stress.portfolio_pd;

    tables
        Scenario_Name*PD_Band
        / norow nocol nopercent;

    title "Scenario vs PD Band Distribution";

run;

/*-----------------------------------------------------------------------*/
/* Step 5 : Sample Validation                                            */
/*-----------------------------------------------------------------------*/

proc print data=stress.portfolio_pd(obs=25);

    title "Sample PD Stress Results";

run;

/*-----------------------------------------------------------------------*/
/* Step 6 : Metadata Validation                                          */
/*-----------------------------------------------------------------------*/

proc contents data=stress.portfolio_pd;

    title "Portfolio PD Dataset Structure";

run;

/*-----------------------------------------------------------------------*/
/* Step 7 : Completion Message                                           */
/*-----------------------------------------------------------------------*/

data _null_;

    put "NOTE: Ph*se V - PD Stress Impact Completed *uccessfully.";

run;

title;