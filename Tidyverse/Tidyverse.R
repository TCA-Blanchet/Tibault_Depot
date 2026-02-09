install.packages("tidyverse")
library(tidyverse)

a <- rnorm(30)
d <- sqrt(exp(a))
hist(d)

##Le pipe
rnorm(30) %>% 
  exp     %>% 
  sqrt    %>% 
  hist(col = "Blue")

## Les Tibbles
b <- sample(c("a","b"),30,replace=T) #création de 30 nombres 
dat <- data.frame(fac=b,variable=round(a,2)) # puis les places dans les tableaux, dat restitue les colonnes en ligne en forme vectorielle
tib <- tibble(factor=b,variable=round(a,2)) # donne le nombre de variable, leur type (charactère), tib conserve la forme de colonne

library(readxl)
read_excel("peng.xlsx", na = "NA") -> peng
view(peng) #pour voir l'ensemble des données de peng

## Les pivots (dans le package tidyr)
peng %>% pivot_longer(bill_len:body_mass) -> peng_long #On a pris les variables mathématiques de peng que nous avons fait pivoter pour 
peng_long %>% pivot_wider(names_from = name, values_from = value) -> peng_wide #pour revenir aux formats initiales après un long

## Manipulation de donnée avec dplyr
peng %>% 
  mutate(imc= body_mass/flipper_len) %>% # création d'une nouvelle variable dans le tableau
  filter(year == 2007) %>% #Création d'un filtre de sélection de ligne
  select(sex, imc, species) %>% # on affiche que les colonnes choisies
  group_by(species) %>% #Groupé par especes dans le tableau
  summarise(across(where(is.numeric), mean)) -> result_imc
# option select(c(id:island, starts_with("bill")),sex)  

## Jointure

peng %>% 
  select(id:island,sex,year) %>%
  slice_sample(n = 100) %>% # selection de 100 données au hasard
  rename(idf=id) -> pengFac

peng %>% 
  select(c(where(is.numeric)),-year) %>% 
  slice_sample(n = 50) -> pengVar

full_join(pengFac,pengVar, by=join_by(idf==id)) -> pengFG # on donne les 2 tableaux et les champs de jointure identique, la jointure possède moins de ligne car elles sont en commun
inner_join(pengFac,pengVar, by=join_by(idf==id)) -> pengIG # idf est dans le tableau de gauche et id dans celui de droite

pengFac %>% left_join(pengVar,by=join_by(idf==id)) -> pengLJ # pour être d'envoie l'objet dans le bon ordre
pengFac %>% right_join(pengVar,by=join_by(idf==id)) -> pengRJ # Le pipe envoie l'élément en premier objet de la fonction
pengFac %>% full_join(pengVar,by=join_by(idf==id)) -> pengFJ 
pengFac %>% inner_join(pengVar,by=join_by(idf==id)) -> pengIJ
# right_join(pengVar,., by=join_by(id==idf)) permet de dire où doit attérir l'objet envoyé par le pipe qui peut être utilisé en paramètre

library(ggplot2)
peng %>% # Les données
  drop_na() %>%
  ggplot() + #Mapping dans ggplot pas de %>% mais des +
  aes(x=bill_len, y=bill_dep,color=sex) +# Décrit qui est la variable réponse et variable explicative possibilité de factor()
  # fill = species pour les intervalles de confiance
  # color = species pour les couleurs pontuelles (les points)
  
  geom_point(size=1) + # Layers (couches)
  geom_smooth(method = lm, size=1) +
  geom_density2d(size=0.1) +
  
  # scale_color_discrete(palette="Dark2") pour les points et les lignes https://larmarange.github.io/analyse-R/couleurs.html
  # scale_fill_discret(palette="Dark2") pour les surfaces
  # scale pour modifier un axe  scale_x_log10
  # scale_x_continuous(limits=c(30:60)) pour déplacer les limites du graphiques
  
  facet_grid(row=vars(species)) + #met les NA en 3ème sexe par défaut à géré en amont avec drop_na() %>%
  # facet_grid(vars()) je choisi le nombre de l et colonne et je place mes graphiqes dedans avec nrow et nclo
  # facet_wrap(vars()) l'ordinateur choisi tout seul la position des graphiques des différentes variables 
  
  xlab("Bill Lenght in (mm)") + 
  ylab("a") + # options
  ggtitle("SUUU")  +
  
  #coord_equal()  pour conserver la meme unité en x et y si on redimentionne l'image
  coord_cartesian()  # coordonnée prend le max de place en x et y 

  #theme(aspect.ratio = 1/1) mes graphiques seront toujours des carrés
  #theme_bw() visuellement moins chargée