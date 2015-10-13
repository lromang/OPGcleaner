shinyServer(function(input, output) {
    
  datasetInput <- reactive({
    ## En esta seccin se carga la base de datos desde la liga que se proporciona.
      if(input$link != "url"){
          read.csv(input$link,encoding="UTF-8")
      }
  })
  
    output$table <- renderDataTable({
        ## Despliegue de resultados.
    datasetInput()
  })
  

  output$downloadData <- downloadHandler(
    # Nombre del archivo
    filename = function() {
		  paste(input$nombre, input$filetype, sep = ".")
	  },

    # Esta fun. escribe el archivo.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")

      # Write to a file specified by the 'file' argument
      write.table(datasetInput(), file, sep = sep,
        row.names = FALSE)
    }
  )
})
