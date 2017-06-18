library(shiny)
library(leaflet)
library(ggplot2)

#set up static data for fields and CSV read for FFX Ultimate player data
#Player data run through ggmap geocoding function to append lat and lon columns to dataset

field <-
  c('Baron Cameron Park',
    'Lake Fairfax',
    'ECL',
    'Centerville HS',
    'Arrowhead Park')
lat <- c(38.9751015, 38.9656623, 38.8596084, 38.8251507, 38.8477109)
lon <-
  c(-77.3374677,
    -77.3151115,
    -77.4361681,
    -77.4132585,
    -77.4085512)

fielddata <- data.frame(field, lat, lon)

FFXPlayerData <-
  read.csv(file = "C:/Users/Michael-PC/Documents/FX Ultimate/FFXUltimateLatLong.csv", header =
             TRUE, sep = ",")

#Shiny UI

ui <- fluidPage(navbarPage(
  "FFX Ultimate - Summer 2016 Rec",
  tabPanel(
    "Map",
    fluidPage(
      leafletOutput('mymap', height = 700),
      actionButton("run", "Run"),
      actionButton("reset_button", "Reset view")
    )
  ),
  tabPanel("Data Analysis",
           tabsetPanel(tabPanel(
             "Raw Data", dataTableOutput('datatable')
           ))),
  tags$head(
    tags$style('
               nav .container:first-child {
               margin-left:10px; width: 100%;
               }')
)
    ))

server <- function(input, output, session) {
  initial_lat = 38.8023893
  initial_lng = -77.3370973
  initial_zoom = 9
  
  ActiveData <- eventReactive(input$run, {
    FFXPlayerData
  })
  
  ActiveFieldData <- eventReactive(input$run, {
    fielddata
  })
  
  output$mymap <- renderLeaflet({
    data <- ActiveData()
    fieldd <- ActiveFieldData()
    leaflet(data) %>%
      setView(lat = initial_lat,
              lng = initial_lng,
              zoom = initial_zoom) %>%
      addTiles() %>%
      addCircleMarkers(
        data$lon,
        data$lat,
        popup = paste(data$firstname, data$lastname, "-" , data$teamName),
        clusterOptions = markerClusterOptions()
      ) %>%
      addMarkers(fieldd$lon, fieldd$lat, popup = paste("Field -", fieldd$field))
  })
  
  output$datatable <- renderDataTable({
    ActiveData()
  })
  
  observe({
    input$reset_button
    leafletProxy("mymap") %>% setView(lat = initial_lat,
                                      lng = initial_lng,
                                      zoom = initial_zoom)
  })
}

shinyApp(ui, server)
