export TIF_DIR=outGTiff
#CALC_DIR=median
#rm -rf $CALC_DIR $CALC_DIR.vrt.d
#mkdir -p $CALC_DIR $CALC_DIR.vrt.d
 
#export DAYNUM=30

calcMedian(){
    export YEAR=$1
    export T=$2
    export TILE=$3
    export T_DAY1=$(perl -e "print $T * $DAYNUM + 1")
    CALC_OPT=""
    LABELS=""

    for inc in $(seq 0 $(expr $DAYNUM - 1)); do
	DOY03d=$(printf %03d $(expr $T_DAY1 + $inc))
	if [ -e $TIF_DIR/$YEAR/$DOY03d/VNP46A1.A$YEAR$DOY03d.$TILE.001.DNB_At_Sensor_Radiance_500m.CloudMask.tif ]; then
	    export CALC_OPT="$CALC_OPT $TIF_DIR/$YEAR/$DOY03d/VNP46A1.A$YEAR$DOY03d.$TILE.001.DNB_At_Sensor_Radiance_500m.CloudMask.tif"
	fi
    done

    export LABELS=$(echo $LABELS | sed 's/^,//')

    # Calculationg median removing NA
    export T03d=$(printf %03d $T)
    export OUTVRT=stack.$DAYNUM.vrt.d/$YEAR/$T03d
    export OUTTIF=median.$DAYNUM.tif.d/$YEAR/$T03d
    mkdir -p $OUTTIF $OUTVRT

    export VRT=$OUTVRT/VNP46A1.A$YEAR.t$T03d.$TILE.vrt

    make $OUTTIF/VNP46A1.A$YEAR.t$T03d.$TILE.tif
    
}
export -f calcMedian

parallel calcMedian ::: 2020 ::: ${TIMES_2020} ::: $INPUT_TILES
parallel calcMedian ::: 2019 ::: ${TIMES_2019} ::: $INPUT_TILES
