shinyUI(fluidPage(
    titlePanel('OGP Cleaner'),
    theme="theme.css",
  sidebarLayout(
      sidebarPanel(
          textInput("link", h4("Ingresa la URL de tus datos:"), value = "url"),
           textInput("nombre", h4("Nombre archivo de descarga:"), value = "archivo"),
      radioButtons("filetype", "File type:",
                   choices = c("csv", "tsv")),
      downloadButton('downloadData', 'Download')
    ),
    mainPanel(
        tabsetPanel(
            tabPanel(h2("Datos"),
                dataTableOutput('table')
            ),
            tabPanel(h2("Analytics")
                
            )
          )
    )
  )
))
