# Цель работы
1. Закрепить практические навыки использования языка программирования R для обработки данных.
3. Закрепить пркатические навыки использования функций обработки данных пакета dplyr – функции select(), filter(), mutate(), arrange(), group_by().

# Исходные данные
1. Библиотека nycflights13
2. Библиотека dplyr
3. RStudio

# План выполнения практической работы
1. Загрузить библиотеку nycflights
2. Выполнить задания из практической работы
3. Оформить отчет

# Описание шагов
1. Устанавливаем бибилиотеку nycflights
   
```R
install.packages("nycflights13")
```
2. Загружаем бибилиотеки nycflights, dplyr
   
```R
library(nycflights13)
library(dplyr)
```

3. Задания из практической работы

* Сколько встроенных в пакет nycflights13 датафреймов?
```R
data(package = "nycflights13")
```
![](img/1.jpg)

* Сколько строк в каждом датафрейме?
```R
count_nyc <- list(airlines, airports, flights, planes, weather)
sapply(count_nyc, nrow)
```
![](img/2.jpg)

* Сколько столбцов в каждом датафрейме?
```R
sapply(count_nyc, ncol)
```
![](img/3.jpg)

* Как просмотреть примерный вид датафрейма?
```R
sapply(count_nyc, glimpse)
```
![](img/4_1.jpg)
![](img/4_3.jpg)
![](img/4_4.jpg)
![](img/4_5.jpg)

*  Сколько компаний-перевозчиков (carrier) учитывают эти наборы данных (представлено в наборах данных)?
```R
carriers <- airlines %>%
            select(carrier) %>%
            distinct() %>%
            nrow()
carriers
```
![](img/5.jpg)

* Сколько рейсов принял аэропорт John F Kennedy Intl в мае?
```R
count_flights_jfk <- flights %>%
               filter(month == 5 & dest == "JFK") %>%
               nrow()
count_flights_jfk
```
![](img/6.jpg)

* Какой самый северный аэропорт?
```R
airport_north <- airports %>%
                 arrange(desc(lat)) %>%
                 head(1)
airport_north$name
```
![](img/7.jpg)

* Какой аэропорт самый высокогорный (находится выше всех над уровнем моря)?
```R
highland_airport <- airports %>%
                    arrange(desc(alt)) %>%
                    head(1)
highland_airport$name
```
![](img/8.jpg)

* Какие бортовые номера у самых старых самолетов?
```R
ancient_num <- planes %>%
               arrange(year) %>%
               head(10) %>%
               select(tailnum)
ancient_num
```
![](img/9.jpg)

* Какая средняя температура воздуха была в сентябре в аэропорту John F Kennedy Intl (в градусах Цельсия)?
```R
avg_jfki_temp_in_sep <- weather %>%
                        filter(month == 9 & origin == "JFK") %>%
                        summarise(avg_temp = mean(temp, na.rm = TRUE))
degree <- round((5/9) * (avg_jfki_temp_in_sep$avg_temp - 32), 1)
degree
```
![](img/10.jpg)

* Самолеты какой авиакомпании совершили больше всего вылетов в июне?
```R
top_count_flights_jun <- flights %>% 
                         filter(month == 6) %>% 
                         group_by(carrier) %>% 
                         summarize(num_flights = n()) %>% 
                         arrange(desc(num_flights)) %>% 
                         head(1)
top_count_flights_jun
```
![](img/11.jpg)

* Самолеты какой авиакомпании задерживались чаще других в 2013 году?
```R
delay_comp <- flights %>% 
              filter(year == 2013) %>% 
              group_by(carrier) %>% 
              summarize(num_delays = sum(arr_delay > 0, na.rm = TRUE)) %>% 
              arrange(desc(num_delays)) %>% 
              head(1)
delay_comp
```
![](img/12.jpg)

# Вывод
Закрепил практические навыки работы с языком R и библиотекой dplyr. Выполнил практические задания, связанные с библиотекой nycflights.