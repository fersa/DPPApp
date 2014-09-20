library('shiny')
library('ggplot2')
library('randomForest')
dataset <- read.csv("data/dummyData1.csv", row.names=1)

shinyServer(function(input, output) {
    dataout <- reactive({
      trainSize <- as.integer(input$trainRatio*nrow(dataset)/100)
      datatrain <- dataset[c(1:trainSize),]
      datatest <- dataset[(trainSize+1):nrow(dataset),]
      rfModel <- randomForest(x=datatrain[,2:6], y=datatrain[,1],
                              mtry=input$mtry, ntree=input$ntree, keep.forest=T)
      predTest <- predict(rfModel, newdata=datatest[,c(2:6)])
      dataout <- data.frame(dataset, 'Prediction' = c(rfModel$predicted, predTest), 
                            'Error'=c((datatrain[,1]-rfModel$predicted),(datatest[,1]-predTest)))      
    })
  #########################################################
    output$plot1 <- renderPlot({
      p <- ggplot(dataout(), aes(x=X1, y=Y)) + 
      geom_point(alpha=.3, size=5)
      q <- p + geom_line(data=dataout(), aes(x=X1, y = Prediction))+
      theme_bw()+geom_vline(xintercept = dataset[as.integer(input$trainRatio*nrow(dataset)/100),2])
      print(q)
    }, height=400)
  ###########################################################
    output$plot2 <- renderPlot({
      r <- ggplot(dataout(), aes(x=X1, y=Error))+geom_point(stat='identity')+
      theme_bw()+geom_vline(xintercept = dataset[as.integer(input$trainRatio*nrow(dataset)/100),2])
      print(r)
    }, height=200)
  #########################################################
    output$RMSE <- renderPrint({
      trainSize <- as.integer(input$trainRatio*nrow(dataset)/100)  
      c(sqrt(sum((dataout()$Error[1:trainSize])^2)/trainSize),
      sqrt(sum((dataout()$Error[(trainSize+1):nrow(dataout())])^2)/(nrow(dataout())-trainSize)))
    })
  #########################################################
    output$MaxErr <- renderPrint({
      trainSize <- as.integer(input$trainRatio*nrow(dataset)/100)
      c(max(dataout()$Error[1:trainSize]),
      max(dataout()$Error[(trainSize+1):nrow(dataout())]) )
    })
})