#Based on https://cengel.github.io/rspatial/5_Geocoding.nb.html

library(ggmap)
library(ggplot2)

#read data
data <- read.csv(file="C:/Users/Michael-PC/Documents/FX Ultimate/Testcsv.csv", header=TRUE, sep = ",")

#concatenate data to make one fluid address
FFX_adr <- paste0(data$streetAddress," ", data$city, ",", data$state," ", data$zipcode)

#run ggmap's data geocoding function on the addresses
FFX_adr_coords <- geocode(FFX_adr)

#add the coordinates back into original dataset
data <- data.frame(cbind(data, FFX_adr_coords))

#output dataset
write.csv(data, file = "FFXUltimateLatLong.csv")



