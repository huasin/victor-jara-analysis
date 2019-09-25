
# Seteos iniciales --------------------------------------------------------

rm (list=ls())
graphics.off()
library(tidyverse)
library(tidytext)
library(quanteda) # stop es
library(tm)       # stop es
library(wordcloud)

# Read de data ------------------------------------------------------------

repertorio <- readRDS('files/repertorio_raw.rds')


# me creo stop words en español
stop_words <- stop_words %>% 
  bind_rows(tibble(word = tm::stopwords('es'),
                   lexicon = 'CUSTOM')) %>% 
  bind_rows(tibble(word = quanteda::stopwords('es'),
                   lexicon = 'CUSTOM')) %>% 
  bind_rows(tibble(word = c('si','pa','aquel','así','aquí'),
                   lexicon = 'CUSTOM'))

# Word count --------------------------------------------------------------

repertorio_tidy <- repertorio %>% 
  unnest_tokens(word, letra)

# Ejemplo amanda
word_count <- repertorio_tidy %>% 
  #filter(cancion == 'Te Recuerdo Amanda') %>% 
  count(word) %>% 
  arrange(desc(n)) %>% 
  anti_join(stop_words) %>% 
  mutate(word2 = fct_reorder(word,n))

# Graphics ----------------------------------------------------------------

# Top 20 canciones
word_count %>% 
  top_n(20, n) %>% 
  ggplot(aes(word2, n)) +
    geom_col() +
    coord_flip()

# Wordcloud
set.seed(1234)
wordcloud(words = word_count$word,
          freq = word_count$n,
          min.freq = 1,
          max.words = 70,
          colors = 'purple',
          random.order = F)

