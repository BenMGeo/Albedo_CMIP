# Monthly albedo comparison of CMIP and ERA datasets
Ben Müller  

## Analysis

### Basic calculations for CMIP and ERA-Interim data

Setting the operating directories for CMIP and ERA-interim data ...


```r
##### Operating directories #####

WD.CMIP = "MPI-M.CMIP5.AMIP\\Amon\\r2i1p1"

WD.ERA = "ERA-Interim"
```

and run *source('Main.R')* will start the preprocessing, including:

* loading monthly CMIP data for upwelling and downwelling short wave data,
* calculating albedo from the ratio of shortwave data,
* if necessary, aggregating daily ERA-Interim albedo data at 12:00 am to monthly data,
* loading monthly ERA-Interim albedo data,
* adjusting the resolution of the finer ERA-Interim data to the coarser CMIP data,
* masking data that is NA in one of the datasets, and
* wraping data to center the maps on the Atlantic ocean.


```
Get CMIP: 
Time difference of 8.98 secs

Get ERA: 
Time difference of 0.09200001 secs

Adjust resolution: 
Time difference of 19.203 secs

Mask data: 
Time difference of 2.399 secs

Wrap data: 
Time difference of 15.136 secs

Do all: 
Time difference of 46.383 secs
```
  
***
  
### Overview on the datasets ...

![](README_files/figure-html/unnamed-chunk-3-1.png) 
  
### ... and their differences

<img src="README_files/figure-html/unnamed-chunk-4-1.png" title="" alt="" style="display: block; margin: auto;" />
  
  
  
  
***

### Spatially aggregated differences analysis in the time series of CMIP and ERA

<img src="README_files/figure-html/unnamed-chunk-5-1.png" title="" alt="" style="display: block; margin: auto;" />
  
The time steps are aggregated in spatial means of differences and boxplot-like calculations lead to the determination of the hinges.
  
***

### Temporally differences between CMIP and ERA as maps of boxplot-like occurence

<img src="README_files/figure-html/unnamed-chunk-6-1.png" title="" alt="" style="display: block; margin: auto;" />
    
Mapped boxplot-like calculations of pixel-wise time series data of differences between CMIP and ERA.
  
***
  
### Spatially aggregated temporal differences between CMIP and ERA ...
  
#### ... by continent

<img src="README_files/figure-html/unnamed-chunk-7-1.png" title="" alt="" style="display: block; margin: auto;" />

#### ... by latitude

<img src="README_files/figure-html/unnamed-chunk-8-1.png" title="" alt="" style="display: block; margin: auto;" />
  
***
  
### Coefficient of variation (COV) for CMIP and ERA

The coefficient of variation is calculated as: $\sigma \over \mu$
  
#### Time series of spatial COV

<img src="README_files/figure-html/unnamed-chunk-9-1.png" title="" alt="" style="display: block; margin: auto;" />
    
#### Maps of temporal COV

<img src="README_files/figure-html/unnamed-chunk-10-1.png" title="" alt="" style="display: block; margin: auto;" />

