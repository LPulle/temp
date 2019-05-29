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

# cat the files together
cd ../GPRegCCGAge
head -1 GPRegCCGAge_1.csv > GPRegCCGAgeAll.csv # get the header row from the first file
tail -n +2 -q GPRegCCGAge_*.csv >> GPRegCCGAgeAll.csv # tail all the files into the header file

# alter the periods for Apr-Jun 2017 to not have dashes
sed -i 's/01-Jun-17/01JUN2017/;s/01-May-17/01MAY2017/;s/01-Apr-17/01APR2017/g' GPRegCCGAgeAll.csv

# do the same for GPRegPrac5yrAge
cd ../GPRegPrac5yrAge
# cat the files together
head -1 GPRegPrac5yrAge_1.csv > GPRegPrac5yrAgeAll.csv # get the header row from the first file
tail -n +2 -q GPRegPrac5yrAge_*.csv >> GPRegPrac5yrAgeAll.csv # tail all the files into the header file

# alter the periods for Apr-Jun 2017 to not have dashes
sed -i 's/01-Jun-17/01JUN2017/;s/01-May-17/01MAY2017/;s/01-Apr-17/01APR2017/g' GPRegPrac5yrAgeAll.csv

cd ..
mkdir -p Final

cp GPRegCCGAge/GPRegCCGAgeAll.csv Final/
cp GPRegPrac5yrAge/GPRegPrac5yrAgeAll.csv Final/
