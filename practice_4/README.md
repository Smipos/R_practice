## Цель работы

1. Зекрепить практические навыки использования языка программирования R для
обработки данных
2. Закрепить знания основных функций обработки данных экосистемы tidyverse
языка R
3. Закрепить навыки исследования метаданных DNS трафика

## Общая ситуация

Вы исследуете подозрительную сетевую активность во внутренней сети Доброй
Организации. Вам в руки попали метаданные о DNS трафике в исследуемой сети.
Исследуйте файлы, восстановите данные, подготовьте их к анализу и дайте
обоснованные ответы на поставленные вопросы исследования.

## Задание

Используя программный пакет dplyr, освоить анализ
DNS логов с помощью языка программирования R.

## Ход работы

### Подготовка данных

#### Устанавливаем и загружаем бибилиотеки dplyr и tidyverse
   
```r
library(nycflights13)
library(dplyr)
```

#### 1. Импортируйте данные DNS

```r
df <- read.table("dns.log",
                 header = FALSE,
                 sep = "\t",
                 quote = "",
                 encoding = "UTF-8")
head(df)
```

#### 2. Добавьте пропущенные данные о структуре данных (назначении столбцов)
```r
colnames(df) <- read.csv("header.csv",
                         header = FALSE,
                         sep = ',',
                         skip = 1,
                         encoding = "UTF-8")$V1
head(df)
```

#### 3. Преобразуйте данные в столбцах в нужный формат
```r
df$ts <- as.POSIXct(df$ts,
                    origin = "2000-01-01") 
head(df$ts)
```
    [1] "2012-03-16 16:30:05 MSK" "2012-03-16 16:30:15 MSK" "2012-03-16 16:30:15 MSK" "2012-03-16 16:30:16 MSK" "2012-03-16 16:30:05 MSK" "2012-03-16 16:30:06 MSK"

#### 4. Просмотрите общую структуру данных с помощью функции glimpse()
```r
glimpse(df)
```
    Rows: 427,935
    Columns: 23
    $ ts          <dttm> 2012-03-16 16:30:05, 2012-03-16 16:30:15, 2012-03-16 16:30:15, 2012-03-16 16:30:16, 2012-03-16 16:30:05, 2012-03-16 16:30:06, 2012-03-16 16:30:07…
    $ uid         <chr> "CWGtK431H9XuaTN4fi", "C36a282Jljz7BsbGH", "C36a282Jljz7BsbGH", "C36a282Jljz7BsbGH", "C36a282Jljz7BsbGH", "C36a282Jljz7BsbGH", "C36a282Jljz7BsbGH"…
    $ id.orig_h   <chr> "192.168.202.100", "192.168.202.76", "192.168.202.76", "192.168.202.76", "192.168.202.76", "192.168.202.76", "192.168.202.76", "192.168.202.89", "…
    $ id.orig_p   <int> 45658, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 45658, 45659, 45658, 137, 137, 137, 60821, 60821, 60821, 60821, 61184, 61184, 6…
    $ id.resp_h   <chr> "192.168.27.203", "192.168.202.255", "192.168.202.255", "192.168.202.255", "192.168.202.255", "192.168.202.255", "192.168.202.255", "192.168.202.2…
    $ id.resp_p   <int> 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 5353, 5353, 137, 137, 137, 137, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 5…
    $ proto       <chr> "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp", "udp",…
    $ trans_id    <int> 33008, 57402, 57402, 57402, 57398, 57398, 57398, 62187, 62187, 62187, 62190, 62190, 62190, 0, 0, 33008, 34107, 32821, 32818, 3550, 3550, 35599, 35…
    $ query       <chr> "*\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00", "HPE8AA67", "HPE8AA67", "HPE8AA67", "WPAD", "WPAD", "WPAD", "EWREP1", "…
    $ qclass      <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "…
    $ qclass_name <chr> "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INTERNET", "C_INT…
    $ qtype       <chr> "33", "32", "32", "32", "32", "32", "32", "32", "32", "32", "33", "33", "33", "12", "12", "33", "32", "32", "32", "28", "28", "28", "28", "1", "1"…
    $ qtype_name  <chr> "SRV", "NB", "NB", "NB", "NB", "NB", "NB", "NB", "NB", "NB", "SRV", "SRV", "SRV", "PTR", "PTR", "SRV", "NB", "NB", "NB", "AAAA", "AAAA", "AAAA", "…
    $ rcode       <chr> "0", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "0", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "…
    $ rcode_name  <chr> "NOERROR", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "NOERROR", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-",…
    $ AA          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
    $ TC          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
    $ RD          <lgl> FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, T…
    $ RA          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
    $ Z           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    $ answers     <chr> "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "…
    $ TTLs        <chr> "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "…
    $ rejected    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…

## Анализ данных

#### 1. Сколько участников информационного обмена в сети Доброй Организации?
```r
partic_count <- union(unique(df$id.orig_h),
                unique(df$id.resp_h)) |>
                length()
partic_count

hosts <- c(unique(df$id.orig_h),
               unique(df$id.resp_h))
```
    [1] 1359

#### 2. Какое соотношение участников обмена внутри сети и участников обращений к внешним ресурсам?
```r
internal_ip_pattern <- c("192.168.", "10.", "100.([6-9]|1[0-1][0-9]|12[0-7]).", "172.((1[6-9])|(2[0-9])|(3[0-1])).")
internal_ips <- hosts[grep(paste(internal_ip_pattern, collapse = "|"), hosts)]
internal_ips_cnt <- sum(hosts %in% internal_ips)
external_ips_cnt <- length(hosts) - internal_ips_cnt
ratio <- internal_ips_cnt / external_ips_cnt
ratio   
```
    [1] 16.24419

#### 3. Найдите топ-10 участников сети, проявляющих наибольшую сетевую активность.
```r
top_10_by_activity <- df |>
  group_by(id.orig_h) |>
  summarise(req_count = n()) |>
  arrange(desc(req_count)) |>
  head(10)
top_10_by_activity  
```
    # A tibble: 10 × 2
      id.orig_h       req_count
      <chr>               <int>
    1 10.10.117.210       75943
    2 192.168.202.93      26522
    3 192.168.202.103     18121
    4 192.168.202.76      16978
    5 192.168.202.97      16176
    6 192.168.202.141     14967
    7 10.10.117.209       14222
    8 192.168.202.110     13372
    9 192.168.203.63      12148
    10 192.168.202.106     10784

#### 4. Найдите топ-10 доменов, к которым обращаются пользователи сети и соответственное количество обращений

```r
top_10_domains <- df |>
  group_by(query) |>
  summarise(count_req = n()) |>
  arrange(desc(count_req)) |>
  head(10)
top_10_domains
```
    # A tibble: 10 × 2
      query                                                               count_req
      <chr>                                                                   <int>
    1 "teredo.ipv6.microsoft.com"                                             39273
    2 "tools.google.com"                                                      14057
    3 "www.apple.com"                                                         13390
    4 "time.apple.com"                                                        13109
    5 "safebrowsing.clients.google.com"                                       11658
    6 "*\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x0…     10401
    7 "WPAD"                                                                   9134
    8 "44.206.168.192.in-addr.arpa"                                            7248
    9 "HPE8AA67"                                                               6929
    10 "ISATAP"                                                                 6569

#### 8. Опеределите базовые статистические характеристики (функция summary() ) интервала времени между последовательным обращениями к топ-10 доменам
```r
filter_by_top_domain <- df |>
  filter(tolower((query)) %in% top_10_domains$query) |>
  arrange(ts)
times_int <- diff(filter_by_top_domain$ts) 
summary(times_int)
```
      Length    Class     Mode 
      109135 difftime  numeric 

#### 9. Часто вредоносное программное обеспечение использует DNS канал в качестве канала управления, периодически отправляя запросы на подконтрольный злоумышленникам DNS сервер. По периодическим запросам на один и тот же домен можно выявить скрытый DNS канал. Есть ли такие IP адреса в исследуемом датасете?
```r
ip_cnt <- df |>
  group_by(ip = id.orig_h, dom = query) |>
  summarise(count_req = n()) |>
  filter(count_req > 1)

ips_period_req <- unique(ip_cnt$ip)
ips_period_req_len |> length()
head(ips_period_req)
```
    [1] 240
    [1] "10.10.10.10"     "10.10.117.209"   "10.10.117.210"   "128.244.37.196" 
    [5] "169.254.109.123" "169.254.228.26" 

#### 10.  Определите местоположение (страну, город) и организацию-провайдера
    для топ-10 доменов. Для этого можно использовать сторонние сервисы,
    например . https://ip2geolocation.com


1.  tools.google.com

-   IP-адрес 142.250.186.142
-   Хост fra24s07-in-f14.1e100.net
-   Континент Северная Америка
-   Код страны US − USA − 840
-   Страна США
-   Широта 37°45’03.6”N (37.751°)
-   Долгота 97°49’19.2”W (−97.822°)
-   Часовой пояс America/Chicago (UTC −06:00)
-   Провайдер Google Servers
-   Домен 1e100.net
-   Домен страны .us

2.  www.apple.com

-   IP-адрес 17.253.144.10
-   Хост www.brkgls.com
-   Континент Северная Америка
-   Код страны US − USA − 840
-   Страна США
-   Широта 37°45’03.6”N (37.751°)
-   Долгота 97°49’19.2”W (−97.822°)
-   Часовой пояс America/Chicago (UTC −06:00)
-   Тип подключения Корпоративное
-   Провайдер Apple
-   Домен страны .us

3.  safebrowsing.clients.google.com

-   IP-адрес 142.250.181.238
-   Хост fra16s56-in-f14.1e100.net
-   Континент Северная Америка
-   Код страны US − USA − 840
-   Страна США
-   Код региона GA
-   Регион Джорджия
-   Почтовый индекс 30628
-   Широта 34°02’06.0”N (34.035°)
-   Долгота 83°13’08.8”W (−83.2191°)
-   Часовой пояс America/New York (UTC −05:00)
-   Тип подключения Кабель/DSL
-   Провайдер Google Servers
-   Домен 1e100.net
-   Домен страны .us


## Вывод

Закрепили навыки исследования метаданных DNS трафика.
