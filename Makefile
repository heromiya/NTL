

# Nighttime light intensity       
$(Radiance): $(IN_HDF)
	mkdir -p `dirname $@`
	cd `dirname $@` && \
	gdal_translate -q -of VRT -co COMPRESS=Deflate -a_srs EPSG:4326 -a_ullr $(COORDS) HDF5:"`basename $<`"://HDFEOS/GRIDS/VNP_Grid_DNB/Data_Fields/DNB_At_Sensor_Radiance_500m `basename $@`

# Cloud mask flags
$(QF_Cloud_Mask): $(IN_HDF)
	mkdir -p `dirname $@`
	cd `dirname $@` && \
	gdal_translate -q -of VRT -co COMPRESS=Deflate -a_srs EPSG:4326 -a_ullr $(COORDS) HDF5:"`basename $<`"://HDFEOS/GRIDS/VNP_Grid_DNB/Data_Fields/QF_Cloud_Mask `basename $@`

# Extracting the cloud mask (Probably Cloudy and Confident Cloudy)
$(CloudMask): $(QF_Cloud_Mask)
	mkdir -p `dirname $@`
	python ./extractFlag.py $< $@

# Moon illumination fraction
$(MoonFraction): $(IN_HDF)
	mkdir -p `dirname $@`
	cd `dirname $@` && \
	gdal_translate -q -of VRT -co COMPRESS=Deflate -a_srs EPSG:4326 -a_ullr $(COORDS) HDF5:"`basename $<`"://HDFEOS/GRIDS/VNP_Grid_DNB/Data_Fields/Moon_Illumination_Fraction `basename $@`

# Combine the NTL, cloud mask, and moon illumination
$(OUT_GTIF): $(Radiance) $(CloudMask) $(MoonFraction)
	mkdir -p `dirname $@`
	gdal_calc.py --quiet -A $(Radiance) -B $(CloudMask) -C $(MoonFraction) --co=COMPRESS=Deflate --calc="where(isnan(B),nan,A*(1-C.astype(float)/10000))" --outfile=$@

$(VRT): $(CALC_OPT)
	mkdir -p `dirname $@`
	gdalbuildvrt -q -separate -overwrite $@ $^

$(OUTTIF)/VNP46A1.A$(YEAR).t$(T03d).$(TILE).tif: $(VRT)
	mkdir -p `dirname $@`
	Rscript calc_median.R $< $@
