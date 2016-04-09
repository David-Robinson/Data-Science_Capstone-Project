## Read the data (lines of text)
blogs <- readLines("en_US.blogs.txt")
news <- readLines("en_US.news.txt")
twitter <- readLines("en_US.twitter.txt")

## Perform sampling (5,000 lines from each file for a total of 15,000 lines
## in order to reduce memory requirements and increase processing speed), 
## and combine into an integrated text corpus
set.seed(101)
blogs_sample <- sample(blogs, 5000, replace = FALSE)
news_sample <- sample(news, 5000, replace = FALSE)
twitter_sample <- sample(twitter, 5000, replace = FALSE)
combined_sample <- paste(blogs_sample, news_sample, twitter_sample, collapse = ' ')

## Clean the combined sample (corpus)
library(NLP)
library(tm)
sample_corpus <- Corpus(VectorSource(combined_sample))

# Convert all words to lower case where applicable
sample_corpus <- tm_map(sample_corpus, tolower)

# Remove punctuation
sample_corpus <- tm_map(sample_corpus, removePunctuation)

# Remove numbers
sample_corpus <- tm_map(sample_corpus, removeNumbers)

# Remove extra whitespace
sample_corpus <- tm_map(sample_corpus, stripWhitespace)

# Ensure document is all plain text for tokenization
sample_corpus <- tm_map(sample_corpus, PlainTextDocument)

## Develop lists of words, word pairs, word triplets, and word quads 
## ("n-gram tokenization") arranged in descending order according to 
## frequency of occurrence
library("RWeka")
library(RWekajars)

# Single words (Uni-gram)
unigram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
unigram_DTM <- DocumentTermMatrix(sample_corpus, 
                                  control = list(tokenize = unigram_tokenizer))
unigram_freq <- sort(colSums(as.matrix(unigram_DTM)), decreasing = TRUE)
unigram_word_freq <- data.frame(freq = unigram_freq, word = names(unigram_freq))

# Word pairs (Bi-gram)
bigram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
bigram_DTM <- DocumentTermMatrix(sample_corpus, 
                                 control = list(tokenize = bigram_tokenizer))
bigram_freq <- sort(colSums(as.matrix(bigram_DTM)), decreasing = TRUE)
bigram_word_freq <- data.frame(freq = bigram_freq, word = names(bigram_freq))

# Word triplets (Tri-gram)
trigram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
trigram_DTM <- DocumentTermMatrix(sample_corpus, 
                                  control = list(tokenize = trigram_tokenizer))
trigram_freq <- sort(colSums(as.matrix(trigram_DTM)), decreasing = TRUE)
trigram_word_freq <- data.frame(freq = trigram_freq, word = names(trigram_freq))

# Word quads (Quad-gram)
quadgram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
quadgram_DTM <- DocumentTermMatrix(sample_corpus, 
                                   control = list(tokenize = quadgram_tokenizer))
quadgram_freq <- sort(colSums(as.matrix(quadgram_DTM)), decreasing = TRUE)
quadgram_word_freq <- data.frame(freq = quadgram_freq, word = names(quadgram_freq))

# Change "word" column in bigram data frame from factor to character class
i <- sapply(bigram_word_freq, is.factor)
bigram_word_freq[i] <- lapply(bigram_word_freq[i], as.character)

# Change "word" column in trigram data frame from factor to character class
i <- sapply(trigram_word_freq, is.factor)
trigram_word_freq[i] <- lapply(trigram_word_freq[i], as.character)

# Change "word" column in quadgram data frame from factor to character class
i <- sapply(quadgram_word_freq, is.factor)
quadgram_word_freq[i] <- lapply(quadgram_word_freq[i], as.character)

write.table(unigram_word_freq, "C:/Unigram Frequency Table v3.txt", sep = "\t")

write.table(bigram_word_freq, "C:/Bigram Frequency Table v3.txt", sep = "\t")

write.table(trigram_word_freq, "C:/Trigram Frequency Table v3.txt", sep = "\t")

write.table(quadgram_word_freq, "C:/Quadgram Frequency Table v3.txt", sep = "\t")

