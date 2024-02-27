# Install the Packages
install.packages("syuzhet", repos = "http://cran.us.r-project.org", Ncpus=4)
install.packages("RColorBrewer", repos = "http://cran.us.r-project.org", Ncpus=4)
install.packages("wordcloud", repos = "http://cran.us.r-project.org", Ncpus=4)
install.packages("tm", repos = "http://cran.us.r-project.org", Ncpus=4)

# Load the Packages
library(syuzhet)
library(RColorBrewer)
library(wordcloud)
library(tm)

# Scan in single text
# Amend later to use user system variable, and work on corpora
text_string <- get_text_as_string("/scratch/users/bcritt/testCorpus/emancipationProclamation.clean.txt")

# Tokenize by word
# text_words <- get_tokens(text_string)
# or by sentence
sentence_vector <- get_sentences(text_string)

# Generate sentiment scores: for all following examples, replace ("sentence_vector" with "text_words" if you tokenized by word). Language can be changed here in the appropriate option.
sentiment_scores <- get_nrc_sentiment(sentence_vector, lang="english")

# Save bar graph
svg("barplot.svg")
barplot(
  colSums(prop.table(sentiment_scores[, 1:8])),
  space = 0.2,
  horiz = FALSE,
  las = 1,
  cex.names = 0.7,
  col = brewer.pal(n = 8, name = "Set3"),
  main = "'Emancipation Proclamation' by Ralph Waldo Emerson",
  sub = "Analysis by Brad Rittenhouse",
  xlab="emotions", ylab = NULL)
dev.off() 

# Aggregate sentences by sentiment (or words by replacing sentence_vector with text_words)
sad_sentences <- sentence_vector[sentiment_scores$sadness>0]
sad_sentence_order <- sort(table(unlist(sad_sentences)), decreasing = TRUE)
head(sad_sentence_order, n = 12)

# Create line graph of narrative
sentiment_valence <- (sentiment_scores$negative *-1) + sentiment_scores$positive
svg("linegraph.svg")
simple_plot(sentiment_valence)
dev.off() 
