library(sf)
library(leaflet)

treedata<-read.csv('camden_trees.csv')


# get in correct format ready for conversion

BNGCRS<-"+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +units=m +no_defs";
OSGB="+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"
wgs84 = '+proj=longlat +datum=WGS84'
#UKUTM<-"+proj=utm +zone=30 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
names(treedata)

#Generate Lat Long coordinates from BNG
treepoints<-st_as_sf(treedata,coords=c("Easting","Northing"),crs=OSGB)%>%
  st_transform(crs=wgs84)

treepointsDF<-do.call(rbind,st_geometry(treepoints))%>%
  as.data.frame()%>%setNames(c("long","lat"))
treedata.final<-cbind.data.frame(treepoints,treepointsDF)

leaflet()%>%
  addTiles()%>%
  addCircles(data=treepoints)


