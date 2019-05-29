#!/bin/bash
#rm -rf GPRegCCGAge
#rm -rf GPRegPrac5yrAge

mkdir -p GPRegCCGAge
mkdir -p GPRegPrac5yrAge
i=0
cd GPRegCCGAge
while read url; do wget -O GPRegCCGAge_$((++i)).csv "$url"; done < ../GPRegCCGAge.txt
i=0
cd ../GPRegPrac5yrAge
while read url; do wget -O GPRegPrac5yrAge_$((++i)).csv "$url"; done < ../GPRegPrac5yrAge.txt

# Renumbering - this seems to be unnecessary after re-initialising i to 0 but it's fast
cd ../GPRegCCGAge
N=100
for X in GPRegCCGAge_*.csv; do mv $X GPRegCCGAge_$N.csv; N=$(($N+1)); done
N=1
for X in GPRegCCGAge_*.csv; do mv $X GPRegCCGAge_$N.csv; N=$(($N+1)); done

cd ../GPRegPrac5yrAge
N=100
for X in GPRegPrac5yrAge_*.csv; do mv $X GPRegPrac5yrAge_$N.csv; N=$(($N+1)); done
N=1
for X in GPRegPrac5yrAge_*.csv; do mv $X GPRegPrac5yrAge_$N.csv; N=$(($N+1)); done

# check periods
N=1
cd ../GPRegCCGAge
for N in GPRegCCGAge_*.csv; do cut -d "," -f 2 $N | head -2 | tail -1; done
N=1
cd ../GPRegPrac5yrAge
for N in GPRegPrac5yrAge_*.csv; do cut -d "," -f 2 $N | head -2 | tail -1; done

# check the number of columns in each file
N=1
cd ../GPRegCCGAge
for N in GPRegCCGAge_*.csv; do head -1 $N | sed 's/[^,]//g'| wc -c; done
N=1
cd ../GPRegPrac5yrAge
for N in GPRegPrac5yrAge_*.csv; do head -1 $N | sed 's/[^,]//g'| wc -c; done

# cat the files together
cd ../GPRegCCGAge
head -1 GPRegCCGAge_1.csv > GPRegCCGAgeAll.csv # get the header row from the first file
tail -n +2 -q GPRegCCGAge_*.csv >> GPRegCCGAgeAll.csv # tail all the files into the header file

# check the counts
N=1
for N in GPRegCCGAge_*.csv; do tail -n +2 $N | wc -l | cut -d " " -f 1; done > temp.list
paste -sd+ temp.list | bc
tail -n +2 GPRegCCGAgeAll.csv | wc -l

# check periods
cut -d "," -f 2 GPRegCCGAgeAll.csv | uniq

# alter the periods for Apr-Jun 2017 to not have dashes
sed -i 's/01-Jun-17/01JUN2017/;s/01-May-17/01MAY2017/;s/01-Apr-17/01APR2017/g' GPRegCCGAgeAll.csv

# check it again after sed
cut -d "," -f 2 GPRegCCGAgeAll.csv | uniq
rm temp.list

# do the same for GPRegPrac5yrAge
cd ../GPRegPrac5yrAge
# cat the files together
head -1 GPRegPrac5yrAge_1.csv > GPRegPrac5yrAgeAll.csv # get the header row from the first file
tail -n +2 -q GPRegPrac5yrAge_*.csv >> GPRegPrac5yrAgeAll.csv # tail all the files into the header file

# check the counts
N=1
for N in GPRegPrac5yrAge_*.csv; do tail -n +2 $N | wc -l | cut -d " " -f 1; done > temp.list
paste -sd+ temp.list | bc
tail -n +2 GPRegPrac5yrAgeAll.csv | wc -l

# check periods
cut -d "," -f 2 GPRegPrac5yrAgeAll.csv | uniq

# alter the periods for Apr-Jun 2017 to not have dashes
sed -i 's/01-Jun-17/01JUN2017/;s/01-May-17/01MAY2017/;s/01-Apr-17/01APR2017/g' GPRegPrac5yrAgeAll.csv

# check it again after sed
cut -d "," -f 2 GPRegPrac5yrAgeAll.csv | uniq
rm temp.list

cd ..
mkdir -p Final

cp GPRegCCGAge/GPRegCCGAgeAll.csv Final/
cp GPRegPrac5yrAge/GPRegPrac5yrAgeAll.csv Final/

