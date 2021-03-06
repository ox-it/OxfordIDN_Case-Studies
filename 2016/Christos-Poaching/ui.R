library(shiny)
library(plotly)
library(highcharter)
library(googleVis)
library(shinyjs)


shinyUI(navbarPage(
  "KNP Poaching",
  tabPanel(
    "Rainfall / Patrol / Gunshots (weekly)",
    fluidPage(
      checkboxGroupInput("weekheatmap_years_selected", label = "Years to view", 
                         choices = list("Year 1" = "Yr1", "Year 2" = "Yr2", "Year 3" = "Yr3"),
                         selected = "Yr1", inline = TRUE),
      uiOutput("weekheatmap_selected_sensors_UI"),
      selectInput("weekheatmap_time_of_shot", label = "Which shots to include?",
                  choices = c("All Shots","Diurnal Shots", "Noctural Shots"),
                  selected = "All Shots"),
      uiOutput("weekheatmap_hc_display")
    )
  ),
  tabPanel(
    "Date / Time of Day / Gunshots",
    fluidPage(
      useShinyjs(),
      includeCSS("www/animate.min.css"),
      # provides pulsating effect
      includeCSS("www/loading-content.css"),
      sidebarLayout(
        sidebarPanel(
          uiOutput("calendar_heatmap_timeperiod_UI"),
          uiOutput("calendar_heatmap_animals_killed_UI")
        ),
        mainPanel(tabsetPanel(
          tabPanel("Surface",
                   fluidPage(
                     plotlyOutput("calendar_surface_plotly", width = "100%", height = "100%")
                     )),
          tabPanel(
            "Heatmap",
            fluidPage(
              div(id = "loading-calendar_heatmap_hc",
                  fillPage(
                    h2(class = "animated infinite pulse", "Loading data...")
                  )),
              highchartOutput("calendar_heatmap_hc", height = "500px")
            )
          ),
          tabPanel("Weekday comparison",
                   fluidPage(
                     highchartOutput("calendar_weekdays_hc")
                   )),
          tabPanel("Monthly Comparison",
                   fluidPage(wellPanel("Note the controls to the left do not affect this chart"),
                             plotlyOutput("month_by_hour_gunshots_surface", width = "100%", height = "100%")))
        ))
      )
    )
  ),
  tabPanel(
    "Calendar of Activity",
    fluidPage(
      wellPanel("This section of the app allows the dataset to be explored via an interactive calendar. Click on a date for more information"),
      
      fluidRow(
        column(
          wellPanel(selectInput(
            "calendar_shots_or_patrols",
            "Show shots or patrols?",
            choices = c("gunshots", "patrols")
          ),
          uiOutput("calheatmap_select_day_UI")),
          width = 4
        ),
        
        column(
          div(style = 'overflow-x:scroll;overflow-y:hidden;alignment:center', uiOutput("calheatmap_gvis")),
          width = 8,
          style = "min-width:600px"
        )
      )
    )
  ),
  
  collapsible = TRUE
))