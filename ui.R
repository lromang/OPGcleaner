shinyUI(fluidPage(
    titlePanel('OGP Cleaner'),
    theme="theme.css",
    tags$head(tags$style(type="text/css", ".dataTables_filter {display: none;    }")),
  sidebarLayout(
      sidebarPanel(h3("Dashboard",style="color:#2962ff"),
                   hr(),
                   br(),
###
                   tabsetPanel(
                       tabPanel("Análisis",
                                br(),
         radioButtons("graph", h4("Tipo de Gráfica:"),
                                                   choices = c("Histograma","Serie de tiempo"),
                                                   selected = "Histograma"),
                                hr(),
                                      radioButtons("var", h4("Variables:"),
                                                   choices = c("General",
                                                               "Academia",
                                                               "Student",
                                                               "Foundation or Donor",
                                                               "National Government",
                                                               "Subnational Government",
                                                               "Private Sector",
                                                               "Media",
                                                               "Civil Society Organization",
                                                               "Multilateral Organization",
                                                               "Other",
                                                               "Judiciary Branch",
                                                               "Legislative Branch"),
                                                   selected = "General")
                                ),
                   tabPanel("Descarga",
                            br(),
           textInput("nombre", h4("Nombre archivo de descarga:"), value = "archivo"),
      radioButtons("filetype", "File type:",
                   choices = c("csv")),
      downloadButton('downloadData', 'Download')
      ),
      tabPanel("Diccionario",
               h5("Academia",style="color:#2962ff"),
               p("Académico / Academia"),
               hr(),
               h5("Confirmación enviada",style="color:#2962ff"),
               p("CONFIRMACIÓN ENVIADA"),
               hr(),
               h5("Student",style="color:#2962ff"),
               p("Estudiante / Student"),
               hr(),
               h5("Foundation or Donor",style="color:#2962ff"),
               p("Fundación o Donante / Foundation or Donor"),
               hr(),
               h5("National Government",style="color:#2962ff"),
               p("Gobierno Nacional / National Government"),
               hr(),
               h5("Subnational Government",style="color:#2962ff"),
               p("Gobierno Subnacional / Subnational Government"),
                              hr(),
               h5("Private Sector",style="color:#2962ff"),
               p("Iniciativa Privada / Private Sector"),
                              hr(),
               h5("Media",style="color:#2962ff"),
               p("Medios / Media"),
                              hr(),
               h5("Civil Society Organization",style="color:#2962ff"),
               p("Organización de la Sociedad Civil / Civil Society Organization"),
                                             hr(),
               h5("Multilateral Organization",style="color:#2962ff"),
               p("Organización Multilateral / Multilateral Organization"),
                                             hr(),
               h5("Other",style="color:#2962ff"),
               p("Otro / Other"),
                                             hr(),
               h5("Judiciary Branch",style="color:#2962ff"),
               p("Poder Judicial / Judiciary Branch"),
                                                            hr(),
               h5("Legislative Branch",style="color:#2962ff"),
               p("Poder Legislativo / Legislative Branch")
               )
      )
###
    ),
    mainPanel(
        tabsetPanel(
            tabPanel(h2("Datos"),
                dataTableOutput('table')
            ),
            tabPanel(h2("Analytics"),
                plotOutput("plot")
            )
          )
    )
  )
))
