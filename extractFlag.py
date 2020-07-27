#! /usr/bin/python
import sys

fileNameIn = sys.argv[1]
fileNameOut = sys.argv[2]
dst_options = ['COMPRESS=DEFLATE']
noDataValue = 255

from osgeo import gdal
import numpy

src_ds = gdal.Open(fileNameIn)
format = "GTiff"
driver = gdal.GetDriverByName(format)
dst_ds = driver.CreateCopy(fileNameOut, src_ds, False ,dst_options)

# Set location
dst_ds.SetGeoTransform(src_ds.GetGeoTransform())
# Set projection
dst_ds.SetProjection(src_ds.GetProjection())
srcband = src_ds.GetRasterBand(1)

# extract bits for cloud masks
dataraster = numpy.where( (numpy.vectorize(numpy.binary_repr)(srcband.ReadAsArray()).astype(numpy.int) / 1000000) % 100 >= 10, numpy.nan, 1)

#Rplace the nan value with the predefiend noDataValue
dataraster[numpy.isnan(dataraster)]=noDataValue

dst_ds.GetRasterBand(1).WriteArray(dataraster)
dst_ds.GetRasterBand(1).SetNoDataValue(noDataValue)

dst_ds = None
