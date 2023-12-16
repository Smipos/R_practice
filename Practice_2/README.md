## Цель работы
* Проанализировать встроенный в пакет dplyr набор данных starwars с помощью языка R и ответить на вопросы

## Исходные данные
* RStudio

## План работы
1. Развить практические навыки использования языка программирования R для обработки данных
2. Закрепить знания базовых типов данных языка R
3. Развить пркатические навыки использования функций обработки данных пакета dplyr – функции
select(), filter(), mutate(), arrange(), group_by()

## Описание шагов

### Устанавливаем и загружаем библиотеку dplyr.
```r
library(dplyr)
```

### Выполнение заданий.
#### 1. Сколько строк в датафрейме?
```r
starwars |> nrow()
```
        [1] 87

#### # 2. Сколько столбцов в датафрейме?
```r
starwars |> ncol()
```
        [1] 14

#### 3. Как просмотреть примерный вид датафрейма?
```r
starwars |> glimpse()
```
        Rows: 87
        Columns: 14
        $ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa", "Owen La…
        $ height     <int> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188, 180, 228, 180, 173, 1…
        $ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 84.0, 77.0, 84.0, NA, 11…
        $ hair_color <chr> "blond", NA, NA, "none", "brown", "brown, grey", "brown", NA, "black", "au…
        $ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "light", "light", "white,…
        $ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue", "blue", "red", "brown"…
        $ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0, 57.0, 41.9, 64.0, 200…
        $ sex        <chr> "male", "none", "none", "male", "female", "male", "female", "none", "male"…
        $ gender     <chr> "masculine", "masculine", "masculine", "masculine", "feminine", "masculine…
        $ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alderaan", "Tatooine", "Tato…
        $ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human", "Human", "Droid", "H…
        $ films      <list> <"A New Hope", "The Empire Strikes Back", "Return of the Jedi", "Revenge …
        $ vehicles   <list> <"Snowspeeder", "Imperial Speeder Bike">, <>, <>, <>, "Imperial Speeder B…
        $ starships  <list> <"X-wing", "Imperial shuttle">, <>, <>, "TIE Advanced x1", <>, <>, <>, <>…

#### 4. Сколько уникальных рас персонажей (species) представлено в данных?
```r
count_unique_species <- length(unique(starwars$species))
count_unique_species
```
        [1] 38

#### 5. Найти самого высокого персонажа.
```r
top_height <- starwars |>
              arrange(desc(height)) |>
                      head(1)
top_height
```
        # A tibble: 1 × 14
        name   height  mass hair_color skin_color eye_color birth_year sex   gender homeworld species
        <chr>   <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr>  <chr>     <chr>  
        1 Yarae…    264    NA none       white      yellow            NA male  mascu… Quermia   Quermi…
        # ℹ 3 more variables: films <list>, vehicles <list>, starships <list>

#### 6. Найти всех персонажей ниже 170
```r
under_170 <- starwars |>
             filter(height < 170)
under_170
```
        # A tibble: 22 × 14
        name  height  mass hair_color skin_color eye_color birth_year sex   gender homeworld species
        <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr>  <chr>     <chr>  
        1 C-3PO    167    75 NA         gold       yellow           112 none  mascu… Tatooine  Droid  
        2 R2-D2     96    32 NA         white, bl… red               33 none  mascu… Naboo     Droid  
        3 Leia…    150    49 brown      light      brown             19 fema… femin… Alderaan  Human  
        4 Beru…    165    75 brown      light      blue              47 fema… femin… Tatooine  Human  
        5 R5-D4     97    32 NA         white, red red               NA none  mascu… Tatooine  Droid  
        6 Yoda      66    17 white      green      brown            896 male  mascu… NA        Yoda's…
        7 Mon …    150    NA auburn     fair       blue              48 fema… femin… Chandrila Human  
        8 Wick…     88    20 brown      brown      brown              8 male  mascu… Endor     Ewok   
        9 Nien…    160    68 none       grey       black             NA male  mascu… Sullust   Sullus…
        10 Watto    137    NA black      blue, grey yellow            NA male  mascu… Toydaria  Toydar…
        # ℹ 12 more rows
        # ℹ 3 more variables: films <list>, vehicles <list>, starships <list>

#### 7. Подсчитать ИМТ (индекс массы тела) для всех персонажей. ИМТ подсчитать по формуле 𝐼 = 𝑚/h^2, где 𝑚 – масса (weight), а ℎ – рост (height).
```r
starwars_with_bmi <- starwars |>
                     mutate(BMI = mass / (height/100)^2)
starwars_with_bmi$BMI
```
        [1]  26.02758  26.89232  34.72222  33.33007  21.77778  37.87401  27.54821  34.00999  25.08286
        [10]  23.24598  23.76641        NA  21.54509  24.69136  24.72518 443.42857  26.64360  33.95062
        [19]  39.02663  25.95156  23.35095  35.00000  31.30194  25.21625  25.79592  25.61728        NA
        [28]        NA  25.82645  26.56250  23.89326  24.67038        NA  13.14828  17.18034  16.34247
        [37]        NA        NA        NA  31.88776        NA        NA  26.12245        NA  17.35892
        [46]  24.03461  50.92802        NA  24.46460  23.76641  20.91623  22.64681        NA  14.76843
        [55]        NA        NA  22.63468        NA  24.83565        NA        NA  23.88844  19.44637
        [64]  18.14487        NA  21.47709        NA  23.58984  19.48696  26.01775  16.78076        NA
        [73]        NA        NA  12.88625        NA  17.99015  34.07922  24.83746  22.35174  15.14960
        [82]  18.85192        NA        NA        NA        NA        NA

#### 8. Найти 10 самых “вытянутых” персонажей. “Вытянутость” оценить по отношению массы (mass) к росту (height) персонажей.
```r
top_10_elong <- starwars |> 
                mutate(elong = mass / height) |>
                arrange(desc(elong)) |>
                head(10)
top_10_elong
```
        # A tibble: 10 × 15
        name  height  mass hair_color skin_color eye_color birth_year sex   gender homeworld species
        <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr>  <chr>     <chr>  
        1 Jabb…    175  1358 NA         green-tan… orange         600   herm… mascu… Nal Hutta Hutt   
        2 Grie…    216   159 none       brown, wh… green, y…       NA   male  mascu… Kalee     Kaleesh
        3 IG-88    200   140 none       metal      red             15   none  mascu… NA        Droid  
        4 Owen…    178   120 brown, gr… light      blue            52   male  mascu… Tatooine  Human  
        5 Dart…    202   136 none       white      yellow          41.9 male  mascu… Tatooine  Human  
        6 Jek …    180   110 brown      fair       blue            NA   NA    NA     Bestine … NA     
        7 Bossk    190   113 none       green      red             53   male  mascu… Trandosha Trando…
        8 Tarf…    234   136 brown      brown      blue            NA   male  mascu… Kashyyyk  Wookiee
        9 Dext…    198   102 none       brown      yellow          NA   male  mascu… Ojom      Besali…
        10 Chew…    228   112 brown      unknown    blue           200   male  mascu… Kashyyyk  Wookiee
        # ℹ 4 more variables: films <list>, vehicles <list>, starships <list>, elong <dbl>

#### 9. Найти средний возраст персонажей каждой расы вселенной Звездных войн
```r
avg_age_by_spec <- starwars |>
                   group_by(species) |>
                   summarise(avg_value = mean(birth_year, na.rm = TRUE))
avg_age_by_spec
```
        # A tibble: 38 × 2
        species   avg_value
        <chr>         <dbl>
        1 Aleena        NaN  
        2 Besalisk      NaN  
        3 Cerean         92  
        4 Chagrian      NaN  
        5 Clawdite      NaN  
        6 Droid          53.3
        7 Dug           NaN  
        8 Ewok            8  
        9 Geonosian     NaN  
        10 Gungan         52  
        # ℹ 28 more rows
        # ℹ Use `print(n = ...)` to see more rows

#### 10. Найти самый распространенный цвет глаз персонажей вселенной Звездных войн
```r
top_eye_color <- starwars |>
                 group_by(eye_color) |>
                 summarise(count_eye_color = n()) |>
                 arrange(desc(count_eye_color)) |>
                 head(1)
top_eye_color
```
        # A tibble: 1 × 2
        eye_color count_eye_color
        <chr>               <int>
        1 brown                  21

#### 11. Подсчитать среднюю длину имени в каждой расе вселенной Звездных войн.
```r
avg_len_name_by_spec <- starwars |>
                        group_by(species) |>
                        summarise(avg_nm_len = mean(nchar(name)))
avg_len_name_by_spec
```
        # A tibble: 38 × 2
        species   avg_nm_len
        <chr>          <dbl>
        1 Aleena         12   
        2 Besalisk       15   
        3 Cerean         12   
        4 Chagrian       10   
        5 Clawdite       10   
        6 Droid           4.83
        7 Dug             7   
        8 Ewok           21   
        9 Geonosian      17   
        10 Gungan         11.7 
        # ℹ 28 more rows
        # ℹ Use `print(n = ...)` to see more rows
        
## Вывод
Изучил основы языка R.
