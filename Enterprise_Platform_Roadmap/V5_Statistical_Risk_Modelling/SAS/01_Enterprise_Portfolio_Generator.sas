/*********************************************************************/
/* PROGRAM      : 01_Enterprise_Portfolio_Generator.sas              */
/* PROJECT      : Enterprise Banking Stress Testing Platform         */
/* VERSION      : V5 Statistical Risk Modelling                     */
/* PURPOSE      : Generate 200K Enterprise Portfolio Dataset        */
/*********************************************************************/

options mprint mlogic symbolgen fullstimer;

/*********************************************************************/
/* EXECUTION START                                                   */
/*********************************************************************/

%let START_DTM=%sysfunc(datetime());

data _null_;

    START_TIME=&START_DTM.;

    put "====================================================";
    put "V5 - ENTERPRISE PORTFOLIO GENERATOR";
    put "====================================================";
    put "Execution Start Time = " START_TIME datetime20.;
    put "Target Portfolio Size = 200,000 Records";
    put "Retail Portfolio      = 100,000 Records";
    put "Wholesale Portfolio   = 100,000 Records";
    put "====================================================";

run;

/*********************************************************************/
/* GENERATE PORTFOLIO DATASET                                        */
/*********************************************************************/

data work.enterprise_portfolio_200k;

    call streaminit(12345);

    length
        CUSTOMER_ID $20
        LOAN_ID $20
        PORTFOLIO_TYPE $15
        PRODUCT_TYPE $30
        REGION $20
        DELINQUENCY_BUCKET $20;

    do RECORD_ID=1 to 200000;

        CUSTOMER_ID =
            cats('CUST', put(RECORD_ID,z8.));

        LOAN_ID =
            cats('LOAN', put(RECORD_ID,z8.));

        /*************************************************************/
        /* PORTFOLIO CLASSIFICATION                                  */
        /*************************************************************/

        if RECORD_ID <= 100000 then do;

            PORTFOLIO_TYPE='RETAIL';

            PRODUCT_RANDOM=
                ceil(rand('uniform')*4);

            if PRODUCT_RANDOM=1 then PRODUCT_TYPE='Mortgage';
            else if PRODUCT_RANDOM=2 then PRODUCT_TYPE='Personal Loan';
            else if PRODUCT_RANDOM=3 then PRODUCT_TYPE='Auto Loan';
            else PRODUCT_TYPE='Credit Card';

        end;

        else do;

            PORTFOLIO_TYPE='WHOLESALE';

            PRODUCT_RANDOM=
                ceil(rand('uniform')*4);

            if PRODUCT_RANDOM=1 then PRODUCT_TYPE='Corporate Loan';
            else if PRODUCT_RANDOM=2 then PRODUCT_TYPE='SME Loan';
            else if PRODUCT_RANDOM=3 then PRODUCT_TYPE='Trade Finance';
            else PRODUCT_TYPE='Project Finance';

        end;

        /*************************************************************/
        /* REGION                                                    */
        /*************************************************************/

        REGION_RANDOM=
            ceil(rand('uniform')*5);

        if REGION_RANDOM=1 then REGION='North';
        else if REGION_RANDOM=2 then REGION='South';
        else if REGION_RANDOM=3 then REGION='East';
        else if REGION_RANDOM=4 then REGION='West';
        else REGION='Central';

        /*************************************************************/
        /* CREDIT ATTRIBUTES                                          */
        /*************************************************************/

        CREDIT_SCORE=
            floor(300 + rand('uniform')*550);

        ANNUAL_INCOME=
            round(
                300000 +
                rand('uniform')*5000000,
                100
            );

        LOAN_AMOUNT=
            round(
                50000 +
                rand('uniform')*10000000,
                100
            );

        OUTSTANDING_BALANCE=
            round(
                LOAN_AMOUNT *
                (0.20 + rand('uniform')*0.80),
                100
            );

        /*************************************************************/
        /* RISK ATTRIBUTES                                            */
        /*************************************************************/

        LTV=
            round(
                40 +
                rand('uniform')*60,
                0.01
            );

        DTI=
            round(
                5 +
                rand('uniform')*55,
                0.01
            );

        YEARS_ON_BOOK=
            floor(rand('uniform')*20)+1;

        /*************************************************************/
        /* DELINQUENCY STATUS                                         */
        /*************************************************************/

        RANDOM_DPD=
            ceil(rand('uniform')*4);

        if RANDOM_DPD=1 then
            DELINQUENCY_BUCKET='CURRENT';
        else if RANDOM_DPD=2 then
            DELINQUENCY_BUCKET='30_DPD';
        else if RANDOM_DPD=3 then
            DELINQUENCY_BUCKET='60_DPD';
        else
            DELINQUENCY_BUCKET='90_PLUS_DPD';

        /*************************************************************/
        /* MACROECONOMIC VARIABLES                                   */
        /*************************************************************/

        GDP_GROWTH_RATE=
            round(
                -2 + rand('uniform')*8,
                0.01
            );

        UNEMPLOYMENT_RATE=
            round(
                2 + rand('uniform')*8,
                0.01
            );

        INTEREST_RATE=
            round(
                4 + rand('uniform')*8,
                0.01
            );

        /*************************************************************/
        /* RISK METRICS                                               */
        /*************************************************************/

        PD=
            round(
                rand('uniform')*0.20,
                0.0001
            );

        LGD=
            round(
                rand('uniform')*0.70,
                0.0001
            );

        EAD=
            OUTSTANDING_BALANCE;

        OBSERVED_DEFAULT=
            (rand('uniform') < PD);

        output;

    end;

run;

/*********************************************************************/
/* VALIDATION 1 - RECORD COUNT                                       */
/*********************************************************************/

title "VALIDATION - TOTAL RECORD COUNT";

proc sql;

select count(*) as TOTAL_RECORDS
from work.enterprise_portfolio_200k;

quit;

/*********************************************************************/
/* VALIDATION 2 - PORTFOLIO SPLIT                                    */
/*********************************************************************/

title "VALIDATION - RETAIL VS WHOLESALE";

proc freq
    data=work.enterprise_portfolio_200k;

tables
    PORTFOLIO_TYPE;

run;

/*********************************************************************/
/* VALIDATION 3 - PRODUCT DISTRIBUTION                               */
/*********************************************************************/

title "VALIDATION - PRODUCT DISTRIBUTION";

proc freq
    data=work.enterprise_portfolio_200k;

tables
    PRODUCT_TYPE;

run;

/*********************************************************************/
/* VALIDATION 4 - SUMMARY STATISTICS                                 */
/*********************************************************************/

title "PORTFOLIO SUMMARY STATISTICS";

proc means
    data=work.enterprise_portfolio_200k
    n mean min max maxdec=2;

var

    CREDIT_SCORE
    ANNUAL_INCOME
    LOAN_AMOUNT
    OUTSTANDING_BALANCE
    LTV
    DTI
    PD
    LGD
    EAD;

run;

/*********************************************************************/
/* VALIDATION 5 - SAMPLE OBSERVATIONS                                */
/*********************************************************************/

title "SAMPLE PORTFOLIO RECORDS";

proc print
    data=work.enterprise_portfolio_200k(obs=20);

run;

/*********************************************************************/
/* EXECUTION COMPLETION                                               */
/*********************************************************************/

%let END_DTM=%sysfunc(datetime());

data _null_;

    START_TIME=&START_DTM.;
    END_TIME=&END_DTM.;

    DURATION=
        round(
            END_TIME-START_TIME,
            0.01
        );

    put "====================================================";
    put "V5 ENTERPRISE PORTFOLIO GENERATION COMPLETED";
    put "====================================================";
    put "Execution Start = " START_TIME datetime20.;
    put "Execution End   = " END_TIME datetime20.;
    put "Duration (Sec)  = " DURATION;
    put "Records Created = 200000";
    put "Retail Records  = 100000";
    put "Wholesale Recs  = 100000";
    put "====================================================";

run;

proc export
    data=work.enterprise_portfolio_200k
    outfile="/home/&sysuserid/enterprise_portfolio_200k.csv"
    dbms=csv
    replace;
run;