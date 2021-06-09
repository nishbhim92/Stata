import excel "Performance measure data.xls", sheet("1") cellrange(A1:S195) firstrow case(lower)

tabulate year , summarize (lnbonus )

tabstat lnbonus, statistics( count mean min p25 p50 p75 max ) by(year)

sum lnbonus stock_return subjectivedummy firm_age firm_size board_indep board_size ceo_power financial_crisis herf_index leverage markettobook roe

ssc install winsor


winsor stock_return , gen(w_stock_return) p(0.01)

sum w_stock_return ,d

gen wstockreturn_subjective = w_stock_return * subjectivedummy


tabstat industry_code , statistics(count) by (industry_code )

tabstat lnbonus , statistics (count mean min p25 p50 p75 max) by(year)

pwcorr lnbonus w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power, sig star (0.1)
tabulate industry_code, generate (dum)

ssc install outreg2
xi:rreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy 
outreg2 using adv.doc, replace
xi:rreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power
outreg2 using adv.doc, append
xi:rreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power dum1 dum2 dum3 dum4 dum5 dum6 dum7
outreg2 using adv.doc, append
xi:rreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power dum2 dum3 dum4 dum5 dum6 dum7 dum8
outreg2 using adv.doc, append
xi:rreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power i.year
outreg2 using adv.doc, append
xi:rreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power i.industry_code
outreg2 using adv.doc, append
xtset firm_id year, yearly


xi:xtreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power i.industry_code , fe
estimate store fixed

xi:xtreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power i.industry_code , re
estimate store random

hausman fixed random

xi:xtreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power i.industry_code, re

xttest0
xi:xtreg lnbonus wstockreturn_subjective w_stock_return subjectivedummy roe firm_age firm_size leverage financial_crisis board_size board_indep markettobook herf_index ceo_power i.industry_code, re
outreg2 using adv.doc, replace
