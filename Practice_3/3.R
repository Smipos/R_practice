library(dplyr)
library(nycflights13)

# 1. Сколько встроенных в пакет nycflights13 датафреймов?
data(package = "nycflights13")

# 2. Сколько строк в каждом датафрейме?
df_s <- list(airlines, airports, flights, planes, weather)
for (df in df_s) {
  print(nrow(df))
}
# 3. Сколько столбцов в каждом датафрейме?
for (col in df_s) {
  print(ncol(col))
}
# 4. Как просмотреть примерный вид датафрейма?
sapply(df_s, glimpse)
# 5. Сколько компаний-перевозчиков (carrier) учитывают эти наборы данных (представлено в наборах даннных)?
count_carrier <- airlines |>
  distinct(carrier) |>
  nrow()
print(count_carrier)
# 6. Сколько рейсов принял аэропорт John F Kennedy Intl в мае?
count_flights <- flights |>
  filter(dest == "JFK" & month == 5) |>
  nrow()
count_flights
# 7. Какой самый северный аэропорт?
north_ap <- airports |> 
  filter(lat == max(lat))
north_ap$name  
# 8. Какой аэропорт самый высокогорный (находится выше всех над уровнем моря)?
alt_ap <- airports |>
  filter(alt == max(alt))
alt_ap$name
# 9. Какие бортовые номера у самых старых самолетов?
old_planes <- planes |>
  arrange(year) |>
  head(5) |>
  select(tailnum)
old_planes
# 10. Какая средняя температура воздуха была в сентябре в аэропорту John F Kennedy Intl (в градусах Цельсия).
avg_temp_jfk <- weather |>
  filter(origin == "JFK" & month == 9) |>
  summarise(avg_temp = round( (5/9) * (mean(temp, na.rm = TRUE) - 32) , 1))
avg_temp_jfk
# 11. Самолеты какой авиакомпании совершили больше всего вылетов в июне?
top_carrier <- flights |>
  group_by(carrier) |>
  filter(month == 6) |>
  summarise(n_fl = n()) |>
  arrange(desc(n_fl)) |>
  head(1)
top_carrier$carrier
# 12. Самолеты какой авиакомпании задерживались чаще других в 2013 году?
delay_carrier <- flights |>
  group_by(carrier) |>
  filter(year == 2013) |>
  summarise(n_delays = sum(arr_delay > 0, na.rm = TRUE)) |>
  arrange(desc(n_delays)) |>
  head(1)
delay_carrier$carrier
