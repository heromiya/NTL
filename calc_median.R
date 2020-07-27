## install.packages("rgdal")
## install.packages("raster")
library("rgdal")
library("raster")

args = commandArgs(trailingOnly=TRUE)
m <- calc(brick(args[1]),median,na.rm=TRUE)

writeRaster(m,filename=args[2]
            ,options="COMPRESS=Deflate"
            ,overwrite=TRUE)
