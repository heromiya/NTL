#! /bin/bash

export DAYNUM=15

buildTS() {
    YEAR=$1
    T03d=$(printf %03d $2)
    VRT=median.$DAYNUM.tif.d/$YEAR/$T03d.vrt
    gdalbuildvrt -q -overwrite $VRT median.$DAYNUM.tif.d/$YEAR/$T03d/*.tif
}
export -f buildTS

parallel buildTS ::: 2019 ::: 22 23
parallel buildTS ::: 2020 ::: {0..13}

gdalbuildvrt -q -separate -overwrite median.$DAYNUM.tif.vrt $(find median.$DAYNUM.tif.d -type f -regex ".*\.vrt$" | sort)
gdal_translate -co COMPRESS=Deflate -co BIGTIFF=YES median.$DAYNUM.tif.vrt median.$DAYNUM.tif


buildTSCloud(){
    YEAR=$1
    T03d=$(printf %03d $2)
    VRT=hdf/$YEAR/$T03d.CloudMask.vrt
    gdalbuildvrt -q -overwrite $VRT hdf/$YEAR/$T03d/*.CloudMask.tif
}
export -f buildTSCloud
#for T in {329..365}; do
parallel buildTSCloud ::: 2019 ::: {329..365}
#done

#for T in {1..207}; do
parallel buildTSCloud ::: 2020 ::: {1..207}
#done

find hdf/ -type f -regex ".*CloudMask.vrt" > CloudMask.lst
gdalbuildvrt -q -separate -overwrite -input_file_list CloudMask.lst CloudMask.vrt
gdal_translate -co COMPRESS=Deflate -co BIGTIFF=YES CloudMask.vrt CloudMask.tif

