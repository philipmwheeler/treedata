# treedata
_Package development for tree data cleaning_

The purpose of this package is to facilitate the cleaning of existing tree data records and mapping to the new urban tree data standard.

Three components:
-Species matching
-Category cleaning and mapping
-Coordinate translation

Workflow:
-Import data
-Mapping to data standard data fields
  -Document metadata to describe which fields map to which, which levels match to which within each field
  -Metadata for location information
  -Metadata for date/time
-Flagging errors and anomalies at the data field level
-Process location data to lat long/WGS84
-Process species data to reference species list
-Export 'clean' standardised data
-Export files describing cleaning and mapping process

Packages to refer to: dataspice, EML, Metadar? (https://github.com/annakrystalli/metadatar) 
