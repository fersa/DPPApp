library('shiny')
library('ggplot2')
library('randomForest')

shinyUI(pageWithSidebar(
  headerPanel("Build a Random Forest model"),
  sidebarPanel(
    h4('Percentage of data instances to be used for training. 
       The rest is reserved for testing'),
     sliderInput('trainRatio', 'Percentage of training data', min=1, max=100,
                value=50, step=5, round=0),
    h4('Parameters of the Random Forest Model'),
    numericInput('mtry', 'mtry', min=1, max=6, value=2, step=1),
    numericInput('ntree', 'Number of trees in the forest', min=100, max=1000, value=100, step=100),
    p(em("Documentation:",a("DPPApp",href="Documentation.html")))
    ),
  mainPanel(
    h4('Results'),
    h5('RMSE: Train - Test'),
    verbatimTextOutput("RMSE"),
    h5('Max(Abs(Error)): Train - Test'),    
    verbatimTextOutput("MaxErr"),    
    plotOutput('plot1'),
    plotOutput('plot2')
  )
))