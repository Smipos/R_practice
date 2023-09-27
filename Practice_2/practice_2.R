library(dplyr)
data(starwars)


number_of_rows <- starwars %>% nrow()
number_of_rows

number_of_columns<- starwars %>% ncol()
number_of_columns


df <- starwars %>% glimpse()
df

uniq_number_of_race <- starwars %>%
  select(species) %>%
  distinct() %>%
  nrow()
uniq_number_of_race


height_character <- starwars %>%
  filter(height == max(height, na.rm = TRUE))
height_character



under_num <- starwars %>%
  filter(height < 170)
under_num







bmi <- starwars %>%
  mutate(BMI = mass / ((height/100)^2))
bmi




top_10_elongated <- starwars %>%
  mutate(elongation = mass / height) %>%
  arrange(desc(elongation)) %>%
  head(10)
top_10_elongated







avg_age <- starwars %>%
  group_by(species) %>%
  summarise(average_age = mean(birth_year, na.rm = TRUE))
avg_age








widespread_eye_color <- starwars %>%
  count(eye_color) %>%
  filter(n == max(n))
widespread_eye_color





avg_name_len_by_race <- starwars %>%
  group_by(species) %>%
  summarise(average_name_len = mean(nchar(name)))
avg_name_len_by_race
