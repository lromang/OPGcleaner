## Librerias
library(gdata)
library(dplyr)
library(plyr)
library(stringr)
library(ggplot2)
library(xlsx)

clean_com <- function(word){
    word <- iconv(word, "latin1", "ASCII", sub="_")
    word  <- tolower(word)
    eng   <- str_detect(word,"/")
    if(eng == TRUE){
        word  <- str_split(word, "/")[[1]][2]
    }else{
        word <- str_replace(word,"_","o")
    }
    word <- str_trim(word)
    word <- str_split(word,"[[:space:]]")[[1]][1]
    word
}

shinyServer(function(input, output) {
###############################################################
  datasetInput <- reactive({
    ## En esta seccin se carga la base de datos desde la liga que se proporciona.
          data <- data.frame(read.xls("http://tecnoregistro.com.mx/AGA2015/reportes/?action=exportarRegUser&email=marianacourtney@gmail.com&clave=4598cfd1cfe70d29e5c9d77b51002f272790ba66"))
          data
  })
###############################################################
    output$table <- renderDataTable({
        ## Despliegue de resultados.
    datasetInput()
    })
###############################################################
    output$plot <- renderPlot({
        ## Despliegue de gráfica
        data <- filter(datasetInput(),
                      !is.na(as.Date(fecha_registro)))
        ## Hacer fecha
        data$fecha_registro <- as.Date(data$fecha_registro)
        ## Procesar variable a desplegar
        data[,15] <- laply(data[,15],
                          function(t)t <- clean_com(t))
        ## Poner nombres que pide carlos
        data <- filter(data, comentarios %in% c("student",
                                               "national",
                                               "private",
                                               "civil",
                                               "other",
                                               "legislative",
                                               "academia",
                                               "foundation",
                                               "subnational",
                                               "media",
                                               "multilateral",
                                               "judiciary"))

        ## Serie de tiempo
        if(input$graph != "Histograma"){
            data_series <- plyr::count(data[,c(13,15)])
             if(input$var == "General"){
               plot <- ggplot(data = data_series,
               aes(x = fecha_registro, y = freq, col = comentarios)
               ) + geom_point() + geom_smooth(se = FALSE) +
            theme(panel.background = element_blank(),
                  axis.text.y = element_text(color="#2962ff", size =15),
                  axis.title = element_blank())    +
                   scale_color_discrete(labels = sort(c("Subnational Government",
                                       "Student",
                                       "Private Sector",
                                       "Other",
                                       "National Government",
                                       "Multilateral Organization",
                                       "Media",
                                       "Legislative Branch",
                                       "Judiciary Branch",
                                       "Foundation or Donor",
                                       "Civil Society Organization",
                                       "Academia")))
             }else{
             plotVar <- str_split(tolower(input$var)," ")[[1]][1]
             ## 
             data_series     <- filter(data_series, comentarios == plotVar)
                            plot <- ggplot(data = data_series,
               aes(x = fecha_registro, y = freq)
               ) + geom_point(color = "#2962ff") + geom_smooth(se = FALSE) +
            theme(panel.background = element_blank(),
                  axis.text.y = element_text(color="#2962ff", size =15),
                  axis.title = element_blank())
             }
        }else{
        ## Verificar la variable que está seleccionada
        if(input$var == "General"){
        plot_data <- plyr::count(data[,15])
        plot      <- ggplot(data = plot_data,
                           aes(x = x, y = freq)) +
            geom_bar(stat = "identity",fill = "#2962ff") +
            geom_text(aes(label = freq, y = freq + 25), col = "#2962ff", size = 5) +
            theme(panel.background = element_blank(),
                  axis.text.y = element_text(color="#2962ff", size =15),
                  axis.title = element_blank()) +
            scale_x_discrete(labels = sort(c("Subnational Government",
                                       "Student",
                                       "Private Sector",
                                       "Other",
                                       "National Government",
                                       "Multilateral Organization",
                                       "Media",
                                       "Legislative Branch",
                                       "Judiciary Branch",
                                       "Foundation or Donor",
                                       "Civil Society Organization",
                                       "Academia")))+
                         coord_flip()
        }else{
             country  <- iconv(data$residencia, "latin1", "ASCII", sub="_")
             country  <- tolower(country)
             country[country != "0" & country != "m_xico"] <- "other"
             country[country == "m_xico"] <- "Mexico"
             data_interest <- data.frame("comment" = data[,15], "residencia" = country)
            ## Variable a graficar
             plotVar <- str_split(tolower(input$var)," ")[[1]][1]
             ## 
             data_plot     <- filter(data_interest, comment == plotVar)
             plot_data     <- plyr::count(data_plot[,2])
             plot      <- ggplot(data = plot_data,
                                aes(x = x, y = freq)) +
                 geom_bar(stat = "identity",fill = "#2962ff") +
                 geom_text(aes(label = freq, y = freq + 25), col = "#2962ff", size = 5) +
                 theme(panel.background = element_blank(),
                  axis.text.y = element_text(color="#2962ff", size =15),
                  axis.title = element_blank()) +
            coord_flip()
        }
        }
        plot
    })
  

  output$downloadData <- downloadHandler(
    ## Nombre del archivo
    filename = function() {
		  paste(input$nombre, input$filetype, sep = ".")
	  },

    ## Esta fun. escribe el archivo.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "xlsx" = "\t")
        ## Write to a file specified by the 'file' argument
      if(sep == ","){
          write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
      }
    }
  )
})
