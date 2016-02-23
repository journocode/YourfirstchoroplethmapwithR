#setwd("/Users/MarieLou/Desktop/journocode")
                                                                                                                                                                                                                                                                                                                                                       
if (!require(rgdal)) {
  install.packages("rgdal", repos = "http://cran.us.r-project.org")
  require(rgdal)
}

dortmund <- readOGR("Statistische Bezirke.kml", "Statistische_Bezirke", encoding = "utf-8")           
          
#plot(dortmund)
          
student1 <- read.csv("student1.csv", encoding = "latin1", sep = ",", dec = ".")
student2 <- read.csv("student2.csv", encoding = "latin1", sep = ",", dec = ".")
          
if (!require(leaflet)) {
   install.packages("leaflet", repos = "http://cran.us.r-project.org")
   require(leaflet)
}
          
palette <-
colorBin(c('#fee0d2',  
           '#fcbba1',
           '#fc9272',
           '#fb6a4a',
           '#ef3b2c',
           '#cb181d',
           '#a50f15',
           '#67000d'), 
           bins = c(0, 5, 8, 10, 12, 14, 18, 24, 26))

popup1 <- paste0("<span style='color: #7f0000'><strong>18-25 year olds 2000</strong></span>",
                 "<br><span style='color: salmon;'><strong>District: </strong></span>", 
                 student1$Bezirk, 
                 "<br><span style='color: salmon;'><strong>relative amount: </strong></span>", 
                 student1$Anteil
                 ,"<br><span style='color: salmon;'><strong>absolute amount: </strong></span>", 
                 student1$X2000   
)

popup2 <- paste0("18-25 year olds 2014",
                 "<br>District: ",             
                 student2$Bezirk,         
                 "<br>relative amount: ", 
                 student2$Anteil          
                 ,"<br>absolute amount: ", 
                 student2$X2014           
)
mymap <- leaflet() %>% 
  
  addProviderTiles("Esri.WorldGrayCanvas",
                   options = tileOptions(minZoom=10, maxZoom=16)) %>% 
  
  addPolygons(data = dortmund, 
              fillColor = ~palette(student1$Anteil),  
              fillOpacity = 0.6,         
              color = "darkgrey",       
              weight = 1.5,            
              popup = popup1,         
              group="<span style='color: #7f0000; font-size: 11pt'><strong>2000</strong></span>")%>%  
  
  addPolygons(data = dortmund, 
              fillColor = ~palette(student2$Anteil), 
              fillOpacity = 0.2, 
              color = "white", 
              weight = 2.0, 
              popup = popup2, 
              group="2014")%>%
  
  addLayersControl(
    baseGroups = c("<span style='color: #7f0000; font-size: 11pt'><strong>2000</strong></span>",
                   "2014" 
    ),
    options = layersControlOptions(collapsed = FALSE))%>% 
  
  addLegend(position = 'topleft', 
            colors = c('#fee0d2',
                       '#fcbba1',
                       '#fc9272',
                       '#fb6a4a',
                       '#ef3b2c',
                       '#cb181d',
                       '#a50f15',
                       '#67000d'), 
            labels = c('0%',"","","","","","",'26%'),  
            opacity = 0.6,      
            title = "relative<br>amount")  

print(mymap)

#library(htmlwidgets)
#saveWidget(mymap, file = "mymap.html", selfcontained = F)
