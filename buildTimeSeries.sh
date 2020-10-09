#! /bin/bash

#export DAYNUM=30

buildTS() {
    YEAR=$1
    T03d=$(printf %03d $2)
    VRT=median.$DAYNUM.tif.d/$YEAR/$T03d.vrt
    gdalbuildvrt -q -overwrite $VRT median.$DAYNUM.tif.d/$YEAR/$T03d/*.tif
}
export -f buildTS

parallel buildTS ::: 2019 ::: ${TIMES_2019}
parallel buildTS ::: 2020 ::: ${TIMES_2020}

gdalbuildvrt -q -separate -overwrite median.$DAYNUM.tif.vrt $(find median.$DAYNUM.tif.d -type f -regex ".*\.vrt$" | sort)
gdal_translate -co COMPRESS=Deflate -co BIGTIFF=YES median.$DAYNUM.tif.vrt median.$DAYNUM.tif


buildTSCloud(){
    YEAR=$1
    T03d=$(printf %03d $2)
    VRT=hdf/$YEAR/$T03d.CloudMask.vrt
    gdalbuildvrt -q -overwrite $VRT hdf/$YEAR/$T03d/*.CloudMask.tif
}
export -f buildTSCloud
parallel buildTSCloud ::: 2019 ::: ${PERIOD_2019}
parallel buildTSCloud ::: 2020 ::: ${PERIOD_2020}

find hdf/ -type f -regex ".*CloudMask.vrt" > CloudMask.lst
gdalbuildvrt -q -separate -overwrite -input_file_list CloudMask.lst CloudMask.vrt
gdal_translate -co COMPRESS=Deflate -co BIGTIFF=YES CloudMask.vrt CloudMask.tif
