# server.R

library(shiny)

# Read the n-gram frequency data
Trigram_data <- read.table("Trigram Frequency Table v3.txt") 
Bigram_data <- read.table("Bigram Frequency Table v3.txt")

# Load required packages
library(stringr)
library(qdap)

shinyServer(function(input, output) {      
       
      user_input <- reactive({input$phrase})
      
      # Convert all words to lower case where applicable
      lower_input <- reactive({tolower(user_input())})
      
      # Remove punctuation
      punc_input <- reactive({gsub("[[:punct:]]", "", lower_input())})
      
      # Remove numbers
      num_input <- reactive({gsub("[0-9]", "", punc_input())})
      
      # Remove extra whitespace
      ws_input <- reactive({Trim(clean(num_input()))})
      
      # Count number of words in cleaned input string
      input_word_count <- reactive({wc(ws_input())})
      
      # Extract the last word(s) from the input
      last_two_words <- reactive({word(ws_input(), -2, -1)})
      last_word <- reactive({word(ws_input(), -1)})
      
      # Highest frequency unigram word = "the"
      next_uni_word <- reactive({c("the")})
      next_word <- reactive({uni_word()})
      
      # Attempt to match last word(s) of the input to the first word(s) of n-grams
      
      # Start with trigrams
      trigram_contains <- reactive({grep(last_two_words(), Trigram_data$word)})
      bigram_contains <- reactive({grep(last_word(), Bigram_data$word)})
      
      trigram_first_two <- reactive({word(Trigram_data$word[trigram_contains()], 1, 2)})
      trigram_match <- reactive({trigram_first_two() == last_two_words()})
      tri_match_sum <- reactive({sum(trigram_match() == TRUE)})
      
      next_tri_word <- reactive ({
      if (!is.na(tri_match_sum()) == TRUE) {
      first_trigram_match <- min(which(trigram_match() == TRUE))
      trigram_match_line <- trigram_contains()[first_trigram_match]
      matching_trigram <- Trigram_data$word[trigram_match_line]
      trigram_last_word <- word(matching_trigram, 3)
      next_tri_word <- trigram_last_word
      }
      })
      
      # Backoff to bigrams if no trigram match
      bigram_first <- reactive({word(Bigram_data$word[bigram_contains()])})
      bigram_match <- reactive({bigram_first() == last_word()})
      bi_match_sum <- reactive({sum(bigram_match() == TRUE)})
            
      next_bi_word <- reactive ({
      if (!is.na(bi_match_sum()) == TRUE) {
      first_bigram_match <- min(which(bigram_match() == TRUE))
      bigram_match_line <- bigram_contains()[first_bigram_match]
      matching_bigram <- Bigram_data$word[bigram_match_line]
      bigram_last_word <- word(matching_bigram, 2)
      next_bi_word <- bigram_last_word
      }
      })
      
      next_word <- reactive({
            
            # Next word = most common unigram ("the") if only one word in the series
            if (input_word_count() < 2) {
                  next_word <- next_uni_word()
            
            # Attempt trigram match 
            } else if (!is.na(tri_match_sum()) == TRUE) {
                  next_word <- next_tri_word()
            
            # If no trigram match, backoff to bigrams and attempt match
            } else if (!is.na(bi_match_sum()) == TRUE) {
                  next_word <- next_bi_word()
            
            # If no bigram match, backoff again to highest probability unigram
            } else
                  next_word <- next_uni_word()
      })
      
      # Output cleaned input phrase and predicted next word
      output$repeat_phrase <- renderText({ws_input()})
      output$prediction <- renderText({next_word()})
      
}
)     
