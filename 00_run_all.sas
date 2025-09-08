
/*IMPORTING RAW DATA*/

proc import datafile="D:\Learners\PROJECT 2\raw\adverse_ae.csv"
	out = adverse_ae dbms=csv replace;
	getnames=yes;
run;

/*CLEANING RAW DATA*/
/*PATIENTS_ID*/
data patient_ad_ae;
	set adverse_ae;
		clean_id = strip(upcase(patient_id));
		clean_id = compress(clean_id, , 'kad');
	if substr(clean_id,1,1) ne "P" then
		clean_id = cats("P", put(input(clean_id, 8.), z3.));
	else do;
		num = input(substr(clean_id, 2), 8.);
		clean_id = cats("P", put(num, z3.));
	end;
	drop num;

run;

proc print data = patient_ad_ae;
	var patient_id clean_id;
run;

/*TERMS*/

data term_clean;
	set patient_ad_ae;
	clean_ae_term = propcase(strip(ae_term));
	if clean_ae_term = "Vomting" then clean_ae_term = "Vomiting";
run;
proc print data =term_clean;
	var ae_term clean_ae_term;
run;

/*DATES*/

data start_date;
    set term_clean;
    length clean_start 8;
    if upcase(strip(ae_start)) in ("NA", "N/A", "") then clean_start = .;
    else do;
        clean_start = input(ae_start, anydtdte.);
		if clean_start = . then clean_start = input(ae_start, ?? ddmmyy10.);
        if clean_start = . then clean_start = input(ae_start, ?? mmddyy10.);
        if clean_start = . then clean_start = input(ae_start, ?? yymmdd10.);
    end;

    format clean_start date9.;
run;

proc print data = start_date ;
	var ae_start clean_start;
run;

data end_date;
	set start_date;
	length clean_end 8;
	if upcase(strip(ae_end)) in ("NA", "N/A", "") then clean_end = .;
	else do;
		clean_end = input(ae_end, anydtdte.);
		if clean_end = . then clean_end = input(ae_end, ?? mmddyy10.);
		if clean_end = . then clean_end = input(ae_end, ?? ddmmyy10.);
		if clean_end = . then clean_end = input(ae_end, ?? yymmdd10.);
	end;
	format clean_end date9. ;
	
run;

proc print data = end_date ;
	var ae_end clean_end;
run;

/*SERIOUSNESS*/

data ser_clean;
	set end_date;
	clean_serious = upcase(strip(seriousness));
	if clean_serious in ("Y","YES") then clean_serious = "YES";
	ELSE IF  clean_serious in ("NO", "N", "N0") then clean_serious = "NO";
	ELSE CLEAN_SERIOUS = "UNK";
run;

proc print data = ser_clean ;
	var seriousness clean_serious;
run;

/*OUTCOME*/

data out_clean;
	set ser_clean;
		outcome_clean = upcase(strip(outcome));
	select (outcome_clean);
		when ("RECOVERED", "RECOVERD", "RECOVERED", "RECOVERED") outcome_clean = "RECOVERED";
		when ("RECOVERING", "ONGOING", "ONGOING") outcome_clean = "ONGOING";
		when ("NOT RECOVERED", "NOT RECOVERED") outcome_clean = "NOT RECOVERED";
		when ("FATAL") outcome_clean = "FATAL";
	end;
run;

proc print data = out_clean;
	var outcome outcome_clean;
run;

/*ACTION TAKEN*/

data act_clean;
	set out_clean;
	length action_clean $20;
		action_clean = upcase(strip(action_taken));
	if action_clean in ("NONE") then action_clean = "NONE";
	ELSE if action_clean in ("DOSE REDUCED") then action_clean = "DOSE REDUCED";
	ELSE if action_clean in ("DRUG STOPPED") then action_clean = "DRUG WITHDRAWN";
	ELSE action_clean = "UNKNOWN";

run;

proc print data = act_clean;
	VAR action_clean action_taken;
run;

data rel_clean;
	set act_clean;
	length relation_clean $20;
		relation_clean = upcase(strip(relation));
	if relation_clean in ("RELATED") then relation_clean = "RELATED";
	else if relation_clean in ("NOT RELATED") then relation_clean = "NOT RELATED";
	else if relation_clean in ("POSSIBLE") then relation_clean = "POSSIBLE";
	else if relation_clean in ("UNLIKELY") then relation_clean = "UNLIKELY";
	ELSE relation_clean = "UNKNOWN";
RUN;

proc print data = rel_clean;
	var relation relation_clean;
run;

/*RENAMING VARIABLES*/
 
data ae_final;
	set rel_clean;
	keep clean_id clean_ae_term clean_start clean_end clean_serious outcome_clean action_clean relation_clean;
	rename 
		clean_id       = USUBJID
		clean_ae_term  = AEDECOD
		clean_start    = AESDTC
		clean_end      = AEENDTC
		clean_serious  = AESER
		outcome_clean  = AEOUT
		action_clean   = AEACN
		relation_clean = AEREL
		;
run;

proc contents data = ae_final;
run;
proc print data = ae_final;
run;

/*DERIVED VARIABLES*/

data ae_final_deriv;
	set ae_final;
	if nmiss(AESDTC, AEENDTC) = 0 then Duration = AEENDTC - AESDTC + 1;
	else Duration = .;
	AESERFL = (AESER="YES");
	AEONGOFL = (missing(AEENDTC));
run;
proc print data = ae_final_deriv;
	var AESDTC AEENDTC Duration AEONGOFL;
run;

/*EXPORTING*/

PROC EXPORT OUTFILE = "D:\Learners\PROJECT 2\out\ae_final.csv"
	dbms=csv replace;
run;

PROC EXPORT OUTFILE = "D:\Learners\PROJECT 2\out\ae_final_deriv.csv"
	dbms=csv replace;
run;























