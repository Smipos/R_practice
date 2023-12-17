library(dplyr)
library(tidyverse)
## Подготовка данных

#### 1. Импортируйте данные DNS
df <- read.table("dns.log",
                 header = FALSE,
                 sep = "\t",
                 quote = "",
                 encoding = "UTF-8")
head(df)
#### 2. Добавьте пропущенные данные о структуре данных (назначении столбцов)
colnames(df) <- read.csv("header.csv",
                         header = FALSE,
                         sep = ',',
                         skip = 1,
                         encoding = "UTF-8")$V1
head(df)
#### 3. Преобразуйте данные в столбцах в нужный формат
df$ts <- as.POSIXct(df$ts,
                    origin = "2000-01-01") 
head(df$ts)
#### 4. Просмотрите общую структуру данных с помощью функции glimpse()
glimpse(df)

## Анализ данных

#### 1. Сколько участников информационного обмена в сети Доброй Организации?
partic_count <- union(unique(df$id.orig_h),
                unique(df$id.resp_h)) |>
                length()
partic_count

hosts <- c(unique(df$id.orig_h),
               unique(df$id.resp_h))
#### 5. Какое соотношение участников обмена внутри сети и участников обращений к внешним ресурсам?
internal_ip_pattern <- c("192.168.", "10.", "100.([6-9]|1[0-1][0-9]|12[0-7]).", "172.((1[6-9])|(2[0-9])|(3[0-1])).")
internal_ips <- hosts[grep(paste(internal_ip_pattern, collapse = "|"), hosts)]
internal_ips_cnt <- sum(hosts %in% internal_ips)
external_ips_cnt <- length(hosts) - internal_ips_cnt
ratio <- internal_ips_cnt / external_ips_cnt
ratio
#### 6. Найдите топ-10 участников сети, проявляющих наибольшую сетевую активность.
top_10_by_activity <- df |>
  group_by(id.orig_h) |>
  summarise(req_count = n()) |>
  arrange(desc(req_count)) |>
  head(10)
top_10_by_activity  
#### 7. Найдите топ-10 доменов, к которым обращаются пользователи сети и соответственное количество обращений
top_10_domains <- df |>
  group_by(query) |>
  summarise(count_req = n()) |>
  arrange(desc(count_req)) |>
  head(10)
top_10_domains
#### 8. Опеределите базовые статистические характеристики (функция summary() ) интервала времени между последовательным обращениями к топ-10 доменам
filter_by_top_domain <- df |>
  filter(tolower((query)) %in% top_10_domains$query) |>
  arrange(ts)
times_int <- diff(filter_by_top_domain$ts) 
summary(times_int)
#### 9. Часто вредоносное программное обеспечение использует DNS канал в качестве канала управления, периодически отправляя запросы на подконтрольный злоумышленникам DNS сервер. По периодическим запросам на один и тот же домен можно выявить скрытый DNS канал. Есть ли такие IP адреса в исследуемом датасете?
ip_cnt <- df |>
  group_by(ip = id.orig_h, dom = query) |>
  summarise(count_req = n()) |>
  filter(count_req > 1)

ips_period_req <- unique(ip_cnt$ip)
ips_period_req %>% length()
head(ips_period_req)
