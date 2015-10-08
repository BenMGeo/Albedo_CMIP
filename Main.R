# Main script

# libraries
require(raster)
require(rworldmap)
require(rgeos)
require(maptools)
#source('W:/R_Functions/memview.R')
source('Functions.R')


##### read data #####

# CMIP

t0=Sys.time()
CMIP=list()

F.CMIP=list.files(WD.CMIP,recursive = T,full.names = T,pattern="[.]nc")

for (f in F.CMIP){
  
  CMIP[[f]]=stack(f)
}

CMIP=CMIP[[grep("sus",names(CMIP))]]/CMIP[[grep("sds",names(CMIP))]]
cat("Get CMIP: \n")
print(Sys.time()-t0)
cat("\n")
# ERA

t=Sys.time()
# write batch for cdo to aggregate to monthly
file.bsh="cdoAGGNC.bsh"

files=list.files(WD.ERA, recursive = T, full.names = T, pattern="[.]nc")
if(length(files)==1){
  files=gsub("[\\]","/",files)
  
  con.file=file(file.bsh,open="wb")
  writeLines(paste("cd ",getwd(),sep=""),con.file)
  writeLines(paste("cdo monavg ",files," ",files,"_agg",sep=""),con.file)
  close(con.file)
  
  # open cygwin and run aggregation with cdo
  system(paste("S:/cygwincdo/bin/bash.exe -l /cygdrive/",substring(getwd(),1,1),"/",substring(getwd(),4,nchar(getwd())),"/cdoAGGNC.bsh",sep=""),show.output.on.console=F)
  
  # rename 
  WD.loc=getwd()
  setwd(WD.ERA)
  F.ERA=list.files(recursive = T, pattern="_agg")
  file.rename(F.ERA,paste("agg_",strsplit(F.ERA,"[.]")[[1]][1],".nc",sep=""))
  con.file=file("dummy.file",open="wb")
  close(con.file)
  setwd(WD.loc)
}

# read
F.ERA=list.files(WD.ERA, recursive = T, full.names = T, pattern="agg")

ERA=stack(F.ERA)
cat("Get ERA: \n")
print(Sys.time()-t)
cat("\n")

##### run from here if both time series are available! #####
names(ERA)=substr(names(ERA),1,8)
names(CMIP)=substr(names(CMIP),1,8)
Sets=list(CMIP=CMIP,ERA=ERA)
names(Sets[[1]])=names(CMIP)
names(Sets[[2]])=names(ERA)

##### adjust resolution #####
t=Sys.time()
Sets= adjRes(Sets,coarse=T, method="bilinear")
cat("Adjust resolution: \n")
print(Sys.time()-t)
cat("\n")

##### get vector overlay #####
sPDF <- getMap()
cont <-
  sapply(levels(sPDF$REGION),
         FUN = function(i) {
           # Merge polygons within a continent
           poly <- gUnionCascaded(subset(sPDF, REGION==i))
           # Give each polygon a unique ID
           poly <- spChFIDs(poly, i)
           # Make SPDF from SpatialPolygons object
           SpatialPolygonsDataFrame(poly,
                                    data.frame(REGION=i, row.names=i))
         },
         USE.NAMES=TRUE)

# Bind the 6 continent-level SPDFs into a single SPDF
cont <- Reduce(spRbind, cont)

##### finalize data #####
t=Sys.time()
mask=mean(stack(lapply(Sets,mean)))
Sets=lapply(Sets,mask,mask)
cat("Mask data: \n")
print(Sys.time()-t)
cat("\n")


t=Sys.time()
Sets=lapply(Sets,wraper,180)
cat("Wrap data: \n")
print(Sys.time()-t)
cat("\n")

cat("Do all: \n")
print(Sys.time()-t0)
cat("\n")
