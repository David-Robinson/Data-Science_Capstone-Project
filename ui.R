## ui.R

library(shiny)

shinyUI(
      pageWithSidebar(
            # Application title
            headerPanel("Next Word Predictor"),
                 
            sidebarPanel(
                  
                  h4("Instructions"),
                  p("Enter an incomplete phrase (series of multiple words) in the text box below 
                  and then select the 'Submit' button.  The phrase you input and the predicted next 
                  word will appear in the text boxes on the right.  Since the model's database is 
                  intentionally limited to minimize size and run time in order to provide a reasonable 
                  user experience, if the 'predicted next word' doesn't appear or 'NA' appears, simply 
                  type the next word in your phrase and press 'Enter'."),
                                          
                  textInput('phrase', "Input a phrase (series of multiple words)",
                  placeholder = "type a series of words here"),
                  submitButton("Submit")
            ),     
      mainPanel(
            h3("Background"),
            p("This application is a basic concept demonstration that uses Natural Language Processing 
            (NLP) to predict the 'next word' based on a series of words input by the user.  Some 
            compromises in accuracy have been accepted in order to create a small and fast enough model
            to load into Shiny and run on shinyapps.io for the purposes of this demonstration project.  
            The model uses dataframes containing 'tri-gram' (three-word) and 'bi-gram' (two-word) 
            combinations sampled from blog, news, and Twitter files.  The prediction model automatically 
            converts words to lower case and removes numbers, punctuation, and extra spaces."),
            
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

