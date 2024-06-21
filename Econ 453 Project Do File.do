import delimited "C:\Users\noahd\OneDrive\Documents\Econ 453 Project Basic Team Batting Stats.xls.csv", clear

ssc install outreg2

rename finals name
rename v29 post
rename aa restrict
rename b doubles
rename v11 triples

gen postxrestrict = post*restrict
gen sacrificespg =  sh / g
gen hrpg = hr / g
egen nameid = group(name)

sum babip ba obp slg ops rg sacrificespg hrpg batage


// List the numeric identifier along with the corresponding team name
list name nameid

reg babip postxrestrict post restrict
reg ba postxrestrict post restrict
reg obp postxrestrict post restrict
reg slg postxrestrict post restrict
reg ops postxrestrict post restrict
reg rg postxrestrict post restrict
reg sacrificespg postxrestrict post restrict
reg hrpg postxrestrict post restrict


* Estimate regression models and store results ChatGPT for eststo
eststo clear
eststo: regress babip postxrestrict post restrict
eststo: regress ba postxrestrict post restrict
eststo: regress obp postxrestrict post restrict
eststo: regress slg postxrestrict post restrict
eststo: regress ops postxrestrict post restrict
eststo: regress rg postxrestrict post restrict
eststo: regress sacrificespg postxrestrict post restrict
eststo: regress hrpg postxrestrict post restrict


* Display results in a single table ChatGPT for esttab
esttab, main(b) cells(b(star fmt(3)) se(fmt(3))) ///
    coeflabels("Treatment Effect" "BABIP" "Batting Average" "On Base %" "Slugging %" "On Base Plus Slugging %" "Runs Per Game" "Sacrifices Per Game" "Home Runs Per Game") ///
    drop(_cons) label nostar
	
outreg2 [*] using MyTable,   dec(3) keep(postxrestrict) nocons replace
	
replace post = 1 if year >= 2019
replace post = 0 if year < 2019
replace restrict = 1 if league == "aa"
replace restrict = 0 if league != "aa"
replace postxrestrict = post*restrict

reg babip postxrestrict i.year restrict i.nameid
reg ba postxrestrict i.year restrict i.nameid
reg obp postxrestrict i.year restrict i.nameid
reg slg postxrestrict i.year restrict i.nameid
reg ops postxrestrict i.year restrict i.nameid
reg rg postxrestrict i.year restrict i.nameid
reg sacrificespg postxrestrict i.year restrict i.nameid
reg hrpg postxrestrict i.year restrict i.nameid

* Estimate regression models and store results ChatGPT for eststo
eststo clear
eststo: regress babip postxrestrict i.year restrict i.nameid
eststo: regress ba postxrestrict i.year restrict i.nameid
eststo: regress obp postxrestrict i.year restrict i.nameid
eststo: regress slg postxrestrict i.year restrict i.nameid
eststo: regress ops postxrestrict i.year restrict i.nameid
eststo: regress rg postxrestrict i.year restrict i.nameid
eststo: regress sacrificespg postxrestrict i.year restrict i.nameid
eststo: regress hrpg postxrestrict i.year restrict i.nameid

esttab, main(b) cells(b(star fmt(3)) se(fmt(3))) ///
    coeflabels("Treatment Effect" "BABIP" "Batting Average" "On Base %" "Slugging %" "On Base Plus Slugging %" "Runs Per Game" "Sacrifices Per Game" "Home Runs Per Game") ///
    drop(_cons *.nameid) label nostar

outreg2 [*] using MyTable,   dec(3) keep(postxrestrict) nocons replace

	
collapse (mean) babip ba obp slg ops rg sacrificespg hrpg, by(league year)

twoway connect babip year if league == "aa" || ///
       connect babip year if league == "mlb", ///
       legend(label(1 "AA") label(2 "MLB")) ///
       xline(2019) ///
       ytitle("BABIP") xtitle("Year")

twoway connect ba year if league == "aa"  || ///
       connect ba year if league == "mlb", ///
	   legend(label(1 "AA") label(2 "MLB")) ///
	   xline(2019) ///
       ytitle("Batting Average") xtitle("Year")
	   
twoway connect obp year if league == "aa"  || ///
       connect obp year if league == "mlb", ///
	   legend(label(1 "AA") label(2 "MLB")) ///
	   xline(2019) ///
       ytitle("On Base %") xtitle("Year")
	   
twoway connect slg year if league == "aa"  || ///
       connect slg year if league == "mlb", ///
	   legend(label(1 "AA") label(2 "MLB")) ///
	   xline(2019) ///
       ytitle("Slugging %") xtitle("Year")
	   
twoway connect ops year if league == "aa"  || ///
       connect ops year if league == "mlb", ///
	   legend(label(1 "AA") label(2 "MLB")) ///
	   xline(2019) ///
       ytitle("On Base Plus Slugging %") xtitle("Year")
	   
twoway connect rg year if league == "aa"  || ///
       connect rg year if league == "mlb", ///
	   legend(label(1 "AA") label(2 "MLB")) ///
	   xline(2019) ///
       ytitle("Runs Per Game") xtitle("Year")
	   
twoway connect sacrificespg year if league == "aa"  || ///
       connect sacrificespg year if league == "mlb", ///
	   legend(label(1 "AA") label(2 "MLB")) ///
	   xline(2019) ///
       ytitle("Sacrifices Per Game") xtitle("Year")
	   
twoway connect hrpg year if league == "aa"  || ///
       connect hrpg year if league == "mlb", ///
	   legend(label(1 "AA") label(2 "MLB")) ///
	   xline(2019) ///
       ytitle("Home Runs Per Game") xtitle("Year")
