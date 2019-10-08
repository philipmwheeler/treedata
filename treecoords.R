#Tree Package - spatial coordinate conversion
#Carlos Abrahams
library(tidyverse)

treedata <- read.csv("camden_trees.csv")
treedata[[1]] <- toupper(treedata[[1]])
column.names <- names(data)
column.names <- toupper(column.names)

coord.names <- c("EASTING", "NORTHING", "EAST", "NORTH",
                 "X", "Y", "LONGITUDE", "LATITUDE", "LONG", "LAT")
matches <-  sapply(coord.names, function(p) grep(p, column.names, value=TRUE, fixed = TRUE))                 
matches2 <- unique(grep(paste(coord.names, collapse="|"), column.names, value=TRUE, ignore.case = TRUE), , fixed = TRUE)


#################
#Need to try and determine what the Coordinate Reference System is, without this being known
#So, check data values fall within reasonable parameters
library(sf)

#checks whether maximum coordinate value is less than 90, hence latlong
Max90long <- max(treedata$Longitude) < 90
Max90lat <- max(treedata$Latitude) < 180
#checks whether maximum coordinate value is less than max possible OSGB values
MaxOSlong  <- max(treedata$Easting) < 700000
MaxOSlat  <- max(treedata$Northing) < 1240000


#Assign CRS type based on data values
if(Max90long == TRUE) {
  CRS <- "wgs84"
}

if(MaxOSlong == TRUE) {
  CRS <- "OSGB"
}

#Create new lat long coordinates if original 'EASTING/NORTHING' data is OSGB
#Create new shorthand variables for CRS systems
BNGCRS <- "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +units=m +no_defs";
OSGB <- "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"
wgs84 <- "+proj=longlat +datum=WGS84"

if(max(treedata$Northing) >90 ){
  treecoords<- cbind.data.frame(treedata$Easting,treedata$Northing)
  treelatlong <- st_as_sf(treecoords,coords=c("treedata$Easting","treedata$Northing"),crs=OSGB)%>%
    st_transform(crs=wgs84)
}
#######################
library(leaflet)

leaflet()%>%
  addTiles()%>%
  addCircles(data=treelatlong)

#######################


# get in correct format ready for conversion

OSGB <- "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"
wgs84 <- "+proj=longlat +datum=WGS84"
#UKUTM<-"+proj=utm +zone=30 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

#Generate Lat Long coordinates from BNG
treepoints <- st_as_sf(treedata,coords=c("Easting","Northing"),crs=OSGB)%>%
  st_transform(crs=wgs84)

treepointsDF<-do.call(rbind,st_geometry(treepoints))%>%
  as.data.frame()%>%setNames(c("long","lat"))
treedata.final<-cbind.data.frame(treepoints,treepointsDF)

#
############################



