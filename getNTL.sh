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
	wget -q -e robots=off -m -np -R .html,.tmp -nH --cut-dirs=3 "https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/5000/VNP46A1/${YEAR}/$DOY03d/" --header "Authorization: Bearer 092F4048-9676-11EA-BFF9-AD357E92A282" -P hdf/$YEAR/$DOY03d --accept-regex=.*$TILE.* -nd
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

#for TILE in h2{7..8}v07 h10v04 h29v05 h19v04 h13v11 h17v04 h10v05 h08v04; do
#    export TILE
#    for DOY in {1..195}; do

#INPUT_TILES="`h2{7..8}v07` h10v04 h29v05 h19v04 h13v11 h17v04 h10v05 h08v04"
INPUT_TILES=h31v05

parallel getNTL ::: 2020 ::: {1..207} ::: $INPUT_TILES
parallel getNTL ::: 2019 ::: {329..365} ::: $INPUT_TILES
# --bar
#done
