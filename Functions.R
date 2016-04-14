# Functions

# adjust resolution

adjRes=function(TS.list, coarse=T, method='bilinear'){
  
  # Input:
  # TS.list:    list of the two raster time series to be adjusted to same coarse resolution
  # coarse:     if resolution should be adjusted to be coarse
  # method:     method for resampling of the time series 
  
  # Output:
  # TS.list:    list of the two raster time series after resolution adjustment and with europe in center
  
  Ress=lapply(TS.list,res)                                                                                                                      # get resolutions
  
  take=which(unlist(lapply(Ress,function(x,y){(all(x==y))},do.call(ifelse(coarse,pmax,pmin),lapply(TS.list,res)))))                             # which resolution shoud be taken
  
  extent=c(-180,180,-90,90)
  res=take
  dummy=raster()
  
  # if(sum(unlist(take))==3){warning("Resolutions are already equal!");return(TS.list)}                                                           # abort if both resolutions are equal
  
  TS.list[[which(names(Ress)!=names(take))]]=resample(TS.list[[which(names(TS.list)!=names(take))]],TS.list[[names(take)]], method=method)      # conversion of the time series
  
  return(TS.list)
  
}

# wrap around

wraper=function(r,cut=180){
  
  # Input:
  # r:    raster to wrap
  # cut:  meridian for new cut
  
  # Output:
  # res:  wraped raster
  
  part1=raster()                            # dummy raster
  projection(part1)=projection(r)           # keep projection
  extent(part1)=extent(r)                   # keep extent
  part2=part1                               # copy for second dummy
  xmax(part1)=cut                           # right end for wrap around
  res(part1)=res(r)                         # adjust resolution
  xmin(part2)=xmax(part1)                   # left end for wrap around (adjustetd to resolution issues)
  res(part2)=res(r)                         # adjust resolution
  S1=resample(r,part1)                      # mask for part1
  S2=resample(r,part2)                      # mask for part2
  xmin(S2)=xmin(S2)-360                     # shift part2
  xmax(S2)=xmax(S2)-360                     # shift part2
  res=merge(S1,S2)                          # merge wrapped data
  names(res)=names(r)                       # adjust layer names
    
  return(res)
}
