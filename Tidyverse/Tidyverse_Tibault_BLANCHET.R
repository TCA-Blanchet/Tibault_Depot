# install.packages("tidyverse")

library(tidyverse)
#read_table() # pour du txt trouve tout seul le séparateur
#read_csv2("data_tidy/musique.csv") -> musique
#view(musique)

#musique %>% pivot_longer(Genr:Honnet) -> musique_long
#view(musique_long)
#musique_long %>% pivot_wider(names_from = name, values_from = value) -> musique_wide


# read.csv2("data_tidy/candy.csv") -> candy #  skip = 1 pour enlever la première ligne
# view(candy)

read_delim("data_tidy/candy.csv", delim=";") -> candy
view(candy)

candy %>% 
  pivot_longer(chocolate:nougat, names_to = "names") -> candy_long
view(candy_long)
candy_long %>% pivot_wider(names_from = names, values_from = value) -> candy_wide
view(candy_wide)

candy %>% 
  mutate(sucre_euro= as.numeric(sugar)/as.numeric(price)) %>% 
  # filter(sucre_euro <= 7) %>%
  select(name, chocolate, price, sugar, win, sucre_euro) -> result_concentration
# view(result_concentration)

library(ggplot2)
result_concentration %>%
  drop_na() %>%
  ggplot() +
  aes(x=sucre_euro, y=win, color=price) +
  geom_point(size=4) +
  geom_text(aes(label=ifelse(win > 75, name,"")), hjust=-0.1, vjust=0, size=3, fontface="bold") + 
  geom_smooth(method = lm, size=1) +
  scale_color_continuous(palette="Spectral") +
  scale_x_log10() + 
  # facet_grid(row=vars(chocolate)) +
  xlab("Taux de sucre par Euro") + 
  ylab("Pourcentage de victoire") + # options
  ggtitle("Graphique") +
  coord_cartesian()
# La plupart des bonnos ont un ratio sucre/euro égale à 1
#on notera que produit les plus chère ne sont pas les mieux noté cependant l'inverse semble plus vrai avec un taux de sucre/euro supérieur

candy %>% 
  mutate(sucre_euro= as.numeric(sugar)/as.numeric(price)) %>% 
  filter(str_detect(name, "Reese's")) %>%
  select(name, chocolate, price, sugar, win, sucre_euro) -> result_Reese

result_Reese %>%
  drop_na() %>%
  ggplot() +
  aes(x=sucre_euro, y=win, color=price) +
  geom_point(size=4) +
  geom_text(aes(label=name), hjust=-0.1, vjust=0, size=3, fontface="bold") + 
  # geom_smooth(method = lm, size=1) +
  scale_color_continuous(palette="Spectral") +
  # scale_x_log10() + 
  # facet_grid(row=vars(chocolate)) +
  xlab("Taux de sucre par Euro") + 
  ylab("Pourcentage de victoire") + # options
  ggtitle("Graphique") +
  coord_cartesian()
# on peut voir que la marque Reese's possède une très bonne réputation de ses produits avec plus de 72% avec l'un des produits les moins chères dans les meilleurs

candy %>% 
  pivot_longer(chocolate:nougat, names_to = "names") -> candy_long
view(candy_long)

candy %>% 
  filter(chocolate == 1) %>%
  select(name, chocolate, price, sugar, win, ) -> result_chocolat

result_chocolat %>%
  drop_na() %>%
  ggplot() +
  aes(x=price, y=sugar, color=win) +
  geom_point(size=4) +
  geom_text(aes(label=name), hjust=-0.1, vjust=0, size=3, fontface="bold") + 
  geom_smooth(method = lm, size=1) +
  scale_color_continuous(palette="Spectral") +
  # scale_x_log10() + 
  # facet_grid(row=vars(chocolate)) +
  xlab("Prix") + 
  ylab("Taux de sucre") + # options
  ggtitle("Graphique") +
  coord_cartesian()
# encore une fois on voit le produit Reese's Miniatures avec peu de sucre et un prix plus faible que la moyenne et une très bonne notation