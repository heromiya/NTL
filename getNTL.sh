#rm -rf tif-cm #CloudMask
mkdir -p hdf

#for YEAR in 2019 2020; do
#h30v05
#h30v06
#Japan h3{1..2}v0{4..5}
#NYC h10v04
#Wuhan h29v05

getNTL() {
    export YEAR=$1
    export DOY=$2
    export TILE=$3
    export DOY03d=$(printf %03d $DOY)
    mkdir -p hdf/$YEAR/$DOY03d

    if [ -e hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.*.h5 ]; then
	gdalinfo hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.*.h5 > /dev/null
	if [ $? -ne 0 ]; then
	    rm hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.*.h5
	fi
    fi
    
    if [ ! -e hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.*.h5 ]; then
	wget --no-check-certificate -q -e robots=off -m -np -R .html,.tmp -nH --cut-dirs=3 "https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/5000/VNP46A1/${YEAR}/$DOY03d/" --header "Authorization: Bearer 9F1C6012-0A53-11EB-9E3A-A1B02ADBF251" -P hdf/$YEAR/$DOY03d --accept-regex=.*$TILE.* -nd
    fi
    
    export IN_HDF=$(find hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.*.h5)
    
    export Radiance=hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.DNB_At_Sensor_Radiance_500m.vrt
    export QF_Cloud_Mask=hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.QF_Cloud_Mask.vrt
    
    export CloudMask=hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.CloudMask.tif
    export MoonFraction=hdf/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.MoonFraction.vrt
    export OUT_GTIF=outGTiff/$YEAR/$DOY03d/VNP46A1.A${YEAR}$DOY03d.$TILE.001.DNB_At_Sensor_Radiance_500m.CloudMask.tif

    eval `gdalinfo $IN_HDF | grep Coord= | sed 's/HDFEOS_GRIDS_VNP_Grid_DNB_//g'`
    export COORDS="$WestBoundingCoord $NorthBoundingCoord $EastBoundingCoord $SouthBoundingCoord"
    make $OUT_GTIF
}
export -f getNTL

parallel getNTL ::: 2019 ::: ${PERIOD_2019} ::: $INPUT_TILES
parallel getNTL ::: 2020 ::: ${PERIOD_2020} ::: $INPUT_TILES

#for TILE in $INPUT_TILES; do for DAY in $PERIOD_2019; do getNTL 2019 $DAY $TILE; done; done
#for TILE in $INPUT_TILES; do for DAY in $PERIOD_2020; do getNTL 2020 $DAY $TILE; done; done
