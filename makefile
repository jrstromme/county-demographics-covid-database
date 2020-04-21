all: onet ipums stay-at-home beds disease-prevalence combine-all-data

onet:
	/Applications/Stata/StataSE.app/Contents/MacOS/StataSE -e code/onet-import.do
	/Library/Frameworks/R.framework/Resources/bin/R --vanilla < code/onet-process.R

ipums:
	/Library/Frameworks/R.framework/Resources/bin/R --vanilla < code/ipums-process.R

stay-at-home:
	curl -o stay_at_home.csv https://raw.githubusercontent.com/jrstromme/covid-stay-at-home-orders/master/stay_at_home.csv

beds:
	/Library/Frameworks/R.framework/Resources/bin/R --vanilla < code/beds-process.R

disease-prevalence:
	/Library/Frameworks/R.framework/Resources/bin/R --vanilla < code/health-process.R

combine-all-data:
	/Applications/Stata/StataSE.app/Contents/MacOS/StataSE -e code/wrangle_together.do
