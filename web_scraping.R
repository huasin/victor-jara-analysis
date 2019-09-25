
# Seteos iniciales --------------------------------------------------------

rm (list=ls())
graphics.off()
library(tidyverse)
library(rvest)


# Web scraping ------------------------------------------------------------

web <- 'https://www.letras.com'
artist <- 'victor-jara'
page <- paste0(web,'/',artist)

# Obtenemos lo que está en el html
scraping <- read_html(page)

# Obtenemos el nombre del artista
nombre_artista <- scraping %>% 
  html_node('div.cnt-head_title') %>% 
  html_node('h1') %>% 
  html_text()

# Obtenemos el listado de las canciones
musica <- scraping %>% 
  html_node('ul.cnt-list') %>% 
  html_nodes('li') %>% 
  html_node('a')

# Obtenemos los links del listado de canciones
links <- musica %>% 
  html_attr('href') %>% 
  paste0(web,.)

# Obtenemos los nombres de las canciones
canciones <- musica %>% 
  html_text() 

# Entramos a cada link de canción y obtenemos la letra
letras <- links %>% map_chr(
  ~{read_html(.x) %>% 
      html_node('div.cnt-letra') %>% 
      html_nodes('p') %>% 
      paste(collapse = ' ') %>% 
      str_remove_all('<p>') %>% 
      str_remove_all('</p>') %>% 
      str_remove_all('\n') %>% 
      str_replace_all('<br>', ' ')
  }
)


# Data frame con las canciones --------------------------------------------

repertorio <- tibble(artista = nombre_artista,
                     cancion = canciones,
                     link = paste0(web,links),
                     letra = letras)

# Guardamos la data -------------------------------------------------------

saveRDS(repertorio, 'files/repertorio_raw.rds')
