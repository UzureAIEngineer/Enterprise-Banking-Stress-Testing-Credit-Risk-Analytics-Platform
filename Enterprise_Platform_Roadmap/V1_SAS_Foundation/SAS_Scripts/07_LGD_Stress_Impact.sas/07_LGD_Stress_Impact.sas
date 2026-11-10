/************************************************************************/
/* Program Name : LGD_Stress_Impact.sas                                 */
/* Project      : Banking Stress Testing Framework                      */
/* Phase        : VI - LGD Stress Impact                                */
/************************************************************************/

/*---------------------------------------------------------------------*/
/* Step 1 - Create LGD Dataset                                          */
/*---------------------------------------------------------------------*/

data stress.portfolio_lgd;

    set stress.portfolio_pd;

    length LGD_Band $20;

    /* Base LGD by Product */

    if Product_Type = "Mortgage" then Base_LGD = 0.20;

      else if Product_Type = "Auto Loan" then Base_LGD = 0.35;

      else if Product_Type = "SME Loan" then Base_LGD = 0.40;

      else if Product_Type = "Corporate Loan" then Base_LGD = 0.45;

      else if Product_Type = "Personal Loan" then Base_LGD = 0.60;

      else if Product_Type = "Credit Card" then Base_LGD = 0.85;

      else Base_LGD = 0.50;


    /* Scenario LGD Factor */

    if Scenario_Name = "Baseline" then LGD_Factor = 1.00;

       else if Scenario_Name = "Mild_Stress" then LGD_Factor = 1.10;

       else if Scenario_Name = "Severe_Stress" then LGD_Factor = 1.25;

       else LGD_Factor = 1.00;


    /* Stressed LGD */

    Stressed_LGD = Base_LGD * LGD_Factor;

    /* Cap LGD at 100% */

    if Stressed_LGD > 1 then Stressed_LGD = 1;


    /* LGD Band */

    if Stressed_LGD < 0.30 then LGD_Band = "Low LGD";

       else if Stressed_LGD <=0.60 then LGD_Band = "Medium LGD";

                               else      LGD_Band = "High LGD";


    format
        Base_LGD     percent8.2
        Stressed_LGD percent8.2;

run;

/*---------------------------------------------------------------------*/
/* Step 2 - Count Validation                                            */
/*---------------------------------------------------------------------*/

proc sql;

select count(*) as Total_Records
from stress.portfolio_lgd;

quit;

/*---------------------------------------------------------------------*/
/* Step 3 - LGD Summary                                                 */
/*---------------------------------------------------------------------*/

proc means data=stress.portfolio_lgd
           n mean min max
           maxdec=4;

    class Scenario_Name;

    var
        Base_LGD
        Stressed_LGD;

    title "Scenario-wise LGD Summary";

run;

/*---------------------------------------------------------------------*/
/* Step 4 - LGD Band Validation                                         */
/*---------------------------------------------------------------------*/

proc freq data=stress.portfolio_lgd;

    tables
    Scenario_Name * LGD_Band
    / norow nocol nopercent;

    title "Scenario vs LGD Band Distribution";

run;

/*---------------------------------------------------------------------*/
/* Step 5 - Sample Output                                               */
/*---------------------------------------------------------------------*/

proc print data=stress.portfolio_lgd(obs=25);

    title "Sample LGD Stress Results";

run;

/*---------------------------------------------------------------------*/
/* Step 6 - Metadata Validation                                         */
/*---------------------------------------------------------------------*/

proc contents data=stress.portfolio_lgd;

    title "Portfolio LGD Dataset Structure";

run;

/*---------------------------------------------------------------------*/
/* Step 7 - Completion Message                                          */
/*---------------------------------------------------------------------*/

data _null_;

    put NOTE: "Phase VI - LGD Stress Impact Completed Successfully";

run;

title;

/************************************************************************/
/* Program Name : LGD_Stress_Impact.sas                                 */
/* Project      : Banking Stress Testing Framework                      */
/* Phase        : VI - LGD Stress Impact                                */
/************************************************************************/

/*---------------------------------------------------------------------*/
/* Step 1 - Create LGD Dataset                                          */
/*---------------------------------------------------------------------*/

data stress.portfolio_lgd;

    set stress.portfolio_pd;

    length LGD_Band $20;

    /* Base LGD by Product */

    if Product_Type = "Mortgage" then Base_LGD = 0.20;

    else if Product_Type = "Auto Loan" then Base_LGD = 0.35;

    else if Product_Type = "SME Loan" then Base_LGD = 0.40;

    else if Product_Type = "Corporate Loan" then Base_LGD = 0.45;

    else if Product_Type = "Personal Loan" then Base_LGD = 0.60;

    else if Product_Type = "Credit Card" then Base_LGD = 0.85;

    else Base_LGD = 0.50;


    /* Scenario LGD Factor */

    if Scenario_Name = "Baseline" then LGD_Factor = 1.00;

    else if Scenario_Name = "Mild_Stress" then LGD_Factor = 1.10;

    else if Scenario_Name = "Severe_Stress" then LGD_Factor = 1.25;

    else LGD_Factor = 1.00;


    /* Stressed LGD */

    Stressed_LGD = Base_LGD * LGD_Factor;

    /* Cap LGD at 100% */

    if Stressed_LGD > 1 then Stressed_LGD = 1;


    /* LGD Band */

    if Stressed_LGD < 0.30 then LGD_Band = "Low LGD";

    else if Stressed_LGD <= 0.60 then LGD_Band = "Medium LGD";

    else LGD_Band = "High LGD";


    format
        Base_LGD     percent8.2
        Stressed_LGD percent8.2;

run;

/*---------------------------------------------------------------------*/
/* Step 2 - Count Validation                                            */
/*---------------------------------------------------------------------*/

proc sql;

select count(*) as Total_Records
from stress.portfolio_lgd;

quit;

/*---------------------------------------------------------------------*/
/* Step 3 - LGD Summary                                                 */
/*---------------------------------------------------------------------*/

proc means data=stress.portfolio_lgd
           n mean min max
           maxdec=4;

    class Scenario_Name;

    var
        Base_LGD
        Stressed_LGD;

    title "Scenario-wise LGD Summary";

run;

/*---------------------------------------------------------------------*/
/* Step 4 - LGD Band Validation                                         */
/*---------------------------------------------------------------------*/

proc freq data=stress.portfolio_lgd;

    tables
    Scenario_Name * LGD_Band
    / norow nocol nopercent;

    title "Scenario vs LGD Band Distribution";

run;

/*---------------------------------------------------------------------*/
/* Step 5 - Sample Output                                               */
/*---------------------------------------------------------------------*/

proc print data=stress.portfolio_lgd(obs=25);

    title "Sample LGD Stress Results";

run;

/*---------------------------------------------------------------------*/
/* Step 6 - Metadata Validation                                         */
/*---------------------------------------------------------------------*/

proc contents data=stress.portfolio_lgd;

    title "Portfolio LGD Dataset Structure";

run;

/*---------------------------------------------------------------------*/
/* Step 7 - Completion Message                                          */
/*---------------------------------------------------------------------*/

data _null_;

    put "NOTE: Phase VI - LGD Stress Impact*Completed Successfully";

run;

title;