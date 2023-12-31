## Цель работы
1. Зекрепить практические навыки использования языка программирования R для обработки данных
2. Закрепить знания основных функций обработки данных экосистемы tidyverse языка R
3. Развить пркатические навыки использования функций обработки данных пакета dplyr – функции
select(), filter(), mutate(), arrange(), group_by()

## Исходные данные
1. Библиотека nycflights13
2. Библиотека dplyr
3. RStudio

## План выполнения практической работы
1. Загрузить библиотеку nycflights
2. Выполнить задания из практической работы
3. Оформить отчет

## Описание шагов
### Устанавливаем и загружаем бибилиотеку nycflights и dplyr
   
```r
library(nycflights13)
library(dplyr)
```

### Вполнение заданий.

#### 1. Сколько встроенных в пакет nycflights13 датафреймов?
```r
data(package = "nycflights13")
```
    5
    Data sets in package ‘nycflights13’:
    airlines               Airline names.
    airports               Airport metadata
    flights                Flights data
    planes                 Plane metadata.
    weather                Hourly weather data

#### 2. Сколько строк в каждом датафрейме?
```r
df_s <- list(airlines, airports, flights, planes, weather)
for (df in df_s) {
  print(nrow(df))
}
```
    [1] 16
    [1] 1458
    [1] 336776
    [1] 3322
    [1] 26115

#### 3. Сколько столбцов в каждом датафрейме?
```r
for (col in df_s) {
  print(ncol(col))
}
```
    [1] 2
    [1] 8
    [1] 19
    [1] 9
    [1] 15

#### 4. Как просмотреть примерный вид датафрейма?
```r
sapply(df_s, glimpse)
```
    Rows: 16
    Columns: 2
    $ carrier <chr> "9E", "AA", "AS", "B6", "DL", "EV", "F9", "FL", "HA", "MQ",…
    $ name    <chr> "Endeavor Air Inc.", "American Airlines Inc.", "Alaska Airl…
    Rows: 1,458
    Columns: 8
    $ faa   <chr> "04G", "06A", "06C", "06N", "09J", "0A9", "0G6", "0G7", "0P2"…
    $ name  <chr> "Lansdowne Airport", "Moton Field Municipal Airport", "Schaum…
    $ lat   <dbl> 41.13047, 32.46057, 41.98934, 41.43191, 31.07447, 36.37122, 4…
    $ lon   <dbl> -80.61958, -85.68003, -88.10124, -74.39156, -81.42778, -82.17…
    $ alt   <dbl> 1044, 264, 801, 523, 11, 1593, 730, 492, 1000, 108, 409, 875,…
    $ tz    <dbl> -5, -6, -6, -5, -5, -5, -5, -5, -5, -8, -5, -6, -5, -5, -5, -…
    $ dst   <chr> "A", "A", "A", "A", "A", "A", "A", "A", "U", "A", "A", "U", "…
    $ tzone <chr> "America/New_York", "America/Chicago", "America/Chicago", "Am…
    Rows: 336,776
    Columns: 19
    $ year           <int> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013…
    $ month          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    $ day            <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    $ dep_time       <int> 517, 533, 542, 544, 554, 554, 555, 557, 557, 558, 55…
    $ sched_dep_time <int> 515, 529, 540, 545, 600, 558, 600, 600, 600, 600, 60…
    $ dep_delay      <dbl> 2, 4, 2, -1, -6, -4, -5, -3, -3, -2, -2, -2, -2, -2,…
    $ arr_time       <int> 830, 850, 923, 1004, 812, 740, 913, 709, 838, 753, 8…
    $ sched_arr_time <int> 819, 830, 850, 1022, 837, 728, 854, 723, 846, 745, 8…
    $ arr_delay      <dbl> 11, 20, 33, -18, -25, 12, 19, -14, -8, 8, -2, -3, 7,…
    $ carrier        <chr> "UA", "UA", "AA", "B6", "DL", "UA", "B6", "EV", "B6"…
    $ flight         <int> 1545, 1714, 1141, 725, 461, 1696, 507, 5708, 79, 301…
    $ tailnum        <chr> "N14228", "N24211", "N619AA", "N804JB", "N668DN", "N…
    $ origin         <chr> "EWR", "LGA", "JFK", "JFK", "LGA", "EWR", "EWR", "LG…
    $ dest           <chr> "IAH", "IAH", "MIA", "BQN", "ATL", "ORD", "FLL", "IA…
    $ air_time       <dbl> 227, 227, 160, 183, 116, 150, 158, 53, 140, 138, 149…
    $ distance       <dbl> 1400, 1416, 1089, 1576, 762, 719, 1065, 229, 944, 73…
    $ hour           <dbl> 5, 5, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 6…
    $ minute         <dbl> 15, 29, 40, 45, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 59…
    $ time_hour      <dttm> 2013-01-01 05:00:00, 2013-01-01 05:00:00, 2013-01-0…
    Rows: 3,322
    Columns: 9
    $ tailnum      <chr> "N10156", "N102UW", "N103US", "N104UW", "N10575", "N10…
    $ year         <int> 2004, 1998, 1999, 1999, 2002, 1999, 1999, 1999, 1999, …
    $ type         <chr> "Fixed wing multi engine", "Fixed wing multi engine", …
    $ manufacturer <chr> "EMBRAER", "AIRBUS INDUSTRIE", "AIRBUS INDUSTRIE", "AI…
    $ model        <chr> "EMB-145XR", "A320-214", "A320-214", "A320-214", "EMB-…
    $ engines      <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
    $ seats        <int> 55, 182, 182, 182, 55, 182, 182, 182, 182, 182, 55, 55…
    $ speed        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    $ engine       <chr> "Turbo-fan", "Turbo-fan", "Turbo-fan", "Turbo-fan", "T…
    Rows: 26,115
    Columns: 15
    $ origin     <chr> "EWR", "EWR", "EWR", "EWR", "EWR", "EWR", "EWR", "EWR", …
    $ year       <int> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 20…
    $ month      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    $ day        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    $ hour       <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 1…
    $ temp       <dbl> 39.02, 39.02, 39.02, 39.92, 39.02, 37.94, 39.02, 39.92, …
    $ dewp       <dbl> 26.06, 26.96, 28.04, 28.04, 28.04, 28.04, 28.04, 28.04, …
    $ humid      <dbl> 59.37, 61.63, 64.43, 62.21, 64.43, 67.21, 64.43, 62.21, …
    $ wind_dir   <dbl> 270, 250, 240, 250, 260, 240, 240, 250, 260, 260, 260, 3…
    $ wind_speed <dbl> 10.35702, 8.05546, 11.50780, 12.65858, 12.65858, 11.5078…
    $ wind_gust  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    $ precip     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    $ pressure   <dbl> 1012.0, 1012.3, 1012.5, 1012.2, 1011.9, 1012.4, 1012.2, …
    $ visib      <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, …
    $ time_hour  <dttm> 2013-01-01 01:00:00, 2013-01-01 02:00:00, 2013-01-01 03…
    [[1]]
    # A tibble: 16 × 2
    carrier name                       
    <chr>   <chr>                      
    1 9E      Endeavor Air Inc.          
    2 AA      American Airlines Inc.     
    3 AS      Alaska Airlines Inc.       
    4 B6      JetBlue Airways            
    5 DL      Delta Air Lines Inc.       
    6 EV      ExpressJet Airlines Inc.   
    7 F9      Frontier Airlines Inc.     
    8 FL      AirTran Airways Corporation
    9 HA      Hawaiian Airlines Inc.     
    10 MQ      Envoy Air                  
    11 OO      SkyWest Airlines Inc.      
    12 UA      United Air Lines Inc.      
    13 US      US Airways Inc.            
    14 VX      Virgin America             
    15 WN      Southwest Airlines Co.     
    16 YV      Mesa Airlines Inc.         

    [[2]]
    # A tibble: 1,458 × 8
    faa   name                             lat    lon   alt    tz dst   tzone 
    <chr> <chr>                          <dbl>  <dbl> <dbl> <dbl> <chr> <chr> 
    1 04G   Lansdowne Airport               41.1  -80.6  1044    -5 A     Ameri…
    2 06A   Moton Field Municipal Airport   32.5  -85.7   264    -6 A     Ameri…
    3 06C   Schaumburg Regional             42.0  -88.1   801    -6 A     Ameri…
    4 06N   Randall Airport                 41.4  -74.4   523    -5 A     Ameri…
    5 09J   Jekyll Island Airport           31.1  -81.4    11    -5 A     Ameri…
    6 0A9   Elizabethton Municipal Airport  36.4  -82.2  1593    -5 A     Ameri…
    7 0G6   Williams County Airport         41.5  -84.5   730    -5 A     Ameri…
    8 0G7   Finger Lakes Regional Airport   42.9  -76.8   492    -5 A     Ameri…
    9 0P2   Shoestring Aviation Airfield    39.8  -76.6  1000    -5 U     Ameri…
    10 0S9   Jefferson County Intl           48.1 -123.    108    -8 A     Ameri…
    # ℹ 1,448 more rows
    # ℹ Use `print(n = ...)` to see more rows

    [[3]]
    # A tibble: 336,776 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time
    <int> <int> <int>    <int>          <int>     <dbl>    <int>
    1  2013     1     1      517            515         2      830
    2  2013     1     1      533            529         4      850
    3  2013     1     1      542            540         2      923
    4  2013     1     1      544            545        -1     1004
    5  2013     1     1      554            600        -6      812
    6  2013     1     1      554            558        -4      740
    7  2013     1     1      555            600        -5      913
    8  2013     1     1      557            600        -3      709
    9  2013     1     1      557            600        -3      838
    10  2013     1     1      558            600        -2      753
    # ℹ 336,766 more rows
    # ℹ 12 more variables: sched_arr_time <int>, arr_delay <dbl>, carrier <chr>,
    #   flight <int>, tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>,
    #   distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
    # ℹ Use `print(n = ...)` to see more rows

    [[4]]
    # A tibble: 3,322 × 9
    tailnum  year type           manufacturer model engines seats speed engine
    <chr>   <int> <chr>          <chr>        <chr>   <int> <int> <int> <chr> 
    1 N10156   2004 Fixed wing mu… EMBRAER      EMB-…       2    55    NA Turbo…
    2 N102UW   1998 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    3 N103US   1999 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    4 N104UW   1999 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    5 N10575   2002 Fixed wing mu… EMBRAER      EMB-…       2    55    NA Turbo…
    6 N105UW   1999 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    7 N107US   1999 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    8 N108UW   1999 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    9 N109UW   1999 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    10 N110UW   1999 Fixed wing mu… AIRBUS INDU… A320…       2   182    NA Turbo…
    # ℹ 3,312 more rows
    # ℹ Use `print(n = ...)` to see more rows

    [[5]]
    # A tibble: 26,115 × 15
    origin  year month   day  hour  temp  dewp humid wind_dir wind_speed
    <chr>  <int> <int> <int> <int> <dbl> <dbl> <dbl>    <dbl>      <dbl>
    1 EWR     2013     1     1     1  39.0  26.1  59.4      270      10.4 
    2 EWR     2013     1     1     2  39.0  27.0  61.6      250       8.06
    3 EWR     2013     1     1     3  39.0  28.0  64.4      240      11.5 
    4 EWR     2013     1     1     4  39.9  28.0  62.2      250      12.7 
    5 EWR     2013     1     1     5  39.0  28.0  64.4      260      12.7 
    6 EWR     2013     1     1     6  37.9  28.0  67.2      240      11.5 
    7 EWR     2013     1     1     7  39.0  28.0  64.4      240      15.0 
    8 EWR     2013     1     1     8  39.9  28.0  62.2      250      10.4 
    9 EWR     2013     1     1     9  39.9  28.0  62.2      260      15.0 
    10 EWR     2013     1     1    10  41    28.0  59.6      260      13.8 
    # ℹ 26,105 more rows
    # ℹ 5 more variables: wind_gust <dbl>, precip <dbl>, pressure <dbl>,
    #   visib <dbl>, time_hour <dttm>
    # ℹ Use `print(n = ...)` to see more rows

#### 5. Сколько компаний-перевозчиков (carrier) учитывают эти наборы данных (представлено в наборах даннных)?
```r
count_carrier <- airlines |>
  distinct(carrier) |>
  nrow()
print(count_carrier)
```
    [1] 16

#### 6. Сколько рейсов принял аэропорт John F Kennedy Intl в мае?
```r
count_flights <- flights |>
  filter(dest == "JFK" & month == 5) |>
  nrow()
count_flights
```
    [1] 0

#### 7. Какой самый северный аэропорт?
```r
north_ap <- airports |> 
  filter(lat == max(lat))
north_ap$name 
```
    [1] "Dillant Hopkins Airport"

#### 8. Какой аэропорт самый высокогорный (находится выше всех над уровнем моря)?
```r
alt_ap <- airports |>
  filter(alt == max(alt))
alt_ap$name
```
    [1] "Telluride"

#### 9. Какие бортовые номера у самых старых самолетов?
```r
old_planes <- planes |>
  arrange(year) |>
  head(5) |>
  select(tailnum)
old_planes
```
    # A tibble: 5 × 1
    tailnum
    <chr>  
    1 N381AA 
    2 N201AA 
    3 N567AA 
    4 N378AA 
    5 N575AA 

#### 10. Какая средняя температура воздуха была в сентябре в аэропорту John F Kennedy Intl (в градусах Цельсия).
```r
avg_temp_jfk <- weather |>
  filter(origin == "JFK" & month == 9) |>
  summarise(avg_temp = round( (5/9) * (mean(temp, na.rm = TRUE) - 32) , 1))
avg_temp_jfk
```
    # A tibble: 1 × 1
    avg_temp
        <dbl>
        19.4

#### 11. Самолеты какой авиакомпании совершили больше всего вылетов в июне?
```r
top_carrier <- flights |>
  group_by(carrier) |>
  filter(month == 6) |>
  summarise(n_fl = n()) |>
  arrange(desc(n_fl)) |>
  head(1)
top_carrier$carrier
```
    [1] "UA"

#### 12. Самолеты какой авиакомпании задерживались чаще других в 2013 году?
```r
delay_carrier <- flights |>
  group_by(carrier) |>
  filter(year == 2013) |>
  summarise(n_delays = sum(arr_delay > 0, na.rm = TRUE)) |>
  arrange(desc(n_delays)) |>
  head(1)
delay_carrier$carrier
```
    [1] "EV"

## Вывод
Закрепил практические навыки работы с языком R и библиотекой dplyr. Выполнил практические задания, связанные с библиотекой nycflights.