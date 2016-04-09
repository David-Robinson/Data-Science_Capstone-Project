## ui.R

library(shiny)

shinyUI(
      pageWithSidebar(
            # Application title
            headerPanel("Next Word Predictor"),
                 
            sidebarPanel(
                  
                  h4("Instructions"),
                  p("Enter an incomplete phrase (a series of multiple words) in the text box below 
                  and then select the 'Submit' button.  The phrase you input and the predicted next 
                  word will appear in the text boxes on the right.  The prediction model automatically 
                  converts words to lower case and removes numbers, punctuation, and extra spaces.
                  Thank you for your interest, and I hope you enjoy the application!"),
                                          
                  textInput('phrase', "Input a phrase (series of multiple words)",
                  placeholder = "type a series of words here"),
                  submitButton("Submit")
            ),     
      mainPanel(
            h3("Background"),
            p("This application is a basic concept demonstration that uses Natural Language Processing 
            (NLP) to predict the 'next word' based on a series of words input by the user.  Some 
            compromises in accuracy have been accepted in order to create a small and fast enough model
            to load into Shiny, run on shinyapps.io, and provide a reasonable user experience for the 
            purpose of this demonstration project.  The model uses dataframes containing 'tri-gram' 
            (three-word) and 'bi-gram' (two-word) combinations sampled from blog, news, and Twitter files."),
            
            h3("You input the phrase:"),
            verbatimTextOutput('repeat_phrase'),
            
            h3("Predicted next word:"),
            verbatimTextOutput('prediction'),
                  
            tags$style(type="text/css",
                       ".shiny-output-error { visibility: hidden; }",
                       ".shiny-output-error:before { visibility: hidden; }")
            
            )
      )
)

