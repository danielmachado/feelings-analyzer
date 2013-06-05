# SW-FEELINGS-ANALYZER

A toolset to determine if a tweet has got a happy or sad nature. A set of tasks are presented by Rake.

Co-Developed with: Natalia García Menéndez


includes: 

## CSV Parser

A CSV Parser to retrieve words from the Warriner definition and our generated csv file.

## Stemmizer

Reduces a word to its stem

## Tokenizer

Extract tokens from a text (tweet)

## Tweet extractor

Split the corpus in two keys for the studie: train and test

## Scorer

Ranks the words and calculates the text average

## Vagrant

A Vagrantfile and a bootstrap.sh files were included in order to replicate the developer's environment

# How to Use

The right order to run the Rake tasks is the following:

* extract_tweets_score
* extract_words_tweets
* delete_words
* calculate_scores_words_relatives
* calculate_scores_words_limits
* calculate_scores_words_combinate
* calculate_scores_words_final > ./resources/newLexic.csv
* csv_parser
* csv_parser_new
* calculate_punctuation_tweets