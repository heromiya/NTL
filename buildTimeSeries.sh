#! /bin/bash

export DAYNUM=30

buildTS() {
    YEAR=$1
    T03d=$(printf %03d $2)
    VRT=median.$DAYNUM.tif.d/$YEAR/$T03d.vrt
    gdalbuildvrt -q -overwrite $VRT median.$DAYNUM.tif.d/$YEAR/$T03d/*.tif
}

buildTS 2019 11
for T in {0..6}; do
    buildTS 2020 $T
done

gdalbuildvrt -q -separate -overwrite median.$DAYNUM.tif.vrt $(find median.$DAYNUM.tif.d -type f -regex ".*\.vrt$" | sort)
gdal_translate -co COMPRESS=Deflate -co BIGTIFF=YES median.$DAYNUM.tif.vrt median.$DAYNUM.tif

