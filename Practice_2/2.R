library(dplyr)
data(starwars)
# 1. Сколько строк в датафрейме?
starwars |> nrow()
# 2. Сколько столбцов в датафрейме?
starwars |> ncol()
# 3. Как просмотреть примерный вид датафрейма?
starwars |> glimpse()
# 4. Сколько уникальных рас персонажей (species) представлено в данных?
count_unique_species <- length(unique(starwars$species))
count_unique_species
# 5. Найти самого высокого персонажа.
top_height <- starwars |>
              arrange(desc(height)) |>
                      head(1)
top_height
# 6. Найти всех персонажей ниже 170
under_170 <- starwars |>
             filter(height < 170)
under_170
# 7. Подсчитать ИМТ (индекс массы тела) для всех персонажей. ИМТ подсчитать по формуле 
#𝐼 = 𝑚/h^2, где 𝑚 – масса (weight), а ℎ – рост (height).
starwars_with_bmi <- starwars |>
                     mutate(BMI = mass / (height/100)^2)
starwars_with_bmi$BMI
# 8. Найти 10 самых “вытянутых” персонажей. “Вытянутость” оценить по отношению массы (mass) к росту
# (height) персонажей.
top_10_elong <- starwars |> 
                mutate(elong = mass / height) |>
                arrange(desc(elong)) |>
                head(10)
top_10_elong
# 9. Найти средний возраст персонажей каждой расы вселенной Звездных войн
avg_age_by_spec <- starwars |>
                   group_by(species) |>
                   summarise(avg_value = mean(birth_year, na.rm = TRUE))
avg_age_by_spec
# 10. Найти самый распространенный цвет глаз персонажей вселенной Звездных войн
top_eye_color <- starwars |>
                 group_by(eye_color) |>
                 summarise(count_eye_color = n()) |>
                 arrange(desc(count_eye_color)) |>
                 head(1)
top_eye_color
# 11. Подсчитать среднюю длину имени в каждой расе вселенной Звездных войн.
avg_len_name_by_spec <- starwars |>
                        group_by(species) |>
                        summarise(avg_nm_len = mean(nchar(name)))
avg_len_name_by_spec
