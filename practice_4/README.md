# Исследование метаданных DNS трафика

## Цель работы

1.  Зaкрепить практические навыки использования языка программирования R
    для обработки данных
2.  Закрепить знания основных функций обработки данных экосистемы
    tidyverse языка R
3.  Закрепить навыки исследования метаданных DNS трафика

## Задания

### Подготовка данных

1.  Импорт данных DNS

``` R
library(tidyverse)
library(dplyr)

dns = read.csv("C:/Users/smipo/OneDrive/Рабочий стол/practice_4/dns.log", header = FALSE, sep="\t", encoding = "UTF-8")
```

2.  Добавить пропущенные данные в назначении столбцов

``` R
columns = read.csv("C:/Users/smipo/OneDrive/Рабочий стол/practice_4/header.csv", encoding = "UTF-8", skip = 1, header = FALSE, sep = ',')$V1
colnames(dns) = columns
```

3.  Преобразовать формат данных

``` R
dns$ts <- as.POSIXct(dns$ts, origin="1970-01-01")
```

4.  Сколько участников информационного обмена в сети Доброй Организации?

``` R
count_parts <- union(
  unique(dns$id.orig_h),
  unique(dns$id.resp_h)
)

count_parts %>% length()
```

    [1] 1359


5.  Соотношение участников обмена внутри сети и участников обращений к внешним ресурсам?

``` R
ip <- c("192.168.", "10.", "100.([6-9]|1[0-1][0-9]|12[0-7]).", "172.((1[6-9])|(2[0-9])|(3[0-1])).")

intern_ips <- count_parts[grep(paste(ip, collapse = "|"), count_parts)]
intern <- sum(count_parts %in% intern_ips)
external <- length(count_parts) - intern
ratio <- intern / external

ratio
```

    [1] 15.57317

6.  Топ-10 участников в сети, проявляющих наибольшую сетевую активность

``` R
top_activity <- dns %>%
  group_by(ip_act=id.orig_h) %>%
  summarise(activity = n()) %>%
  arrange(desc(activity)) %>%
  head(10)
ip_act <- select(top_activity,ip_act)

ip_act
```

    # A tibble: 10 × 1
       ip_act             
       <chr>          
     1 10.10.117.210  
     2 192.168.202.93 
     3 192.168.202.103
     4 192.168.202.76 
     5 192.168.202.97 
     6 192.168.202.141
     7 10.10.117.209  
     8 192.168.202.110
     9 192.168.203.63 
    10 192.168.202.106

7.  Топ-10 доменов, к которым обращаются пользователи сети и соответствующее количество обращений


``` R
top_domain <- dns %>%
  group_by(domain = tolower(query)) %>%
  summarise(request = n()) %>%
  arrange(desc(request)) %>%
  head(10)
top_domains <- select(top_domain, domain)

top_domains
```

    # A tibble: 10 × 1
       domain                                                                   
       <chr>                                                                    
     1 "teredo.ipv6.microsoft.com"                                              
     2 "tools.google.com"                                                       
     3 "www.apple.com"                                                          
     4 "time.apple.com"                                                         
     5 "safebrowsing.clients.google.com"                                        
     6 "wpad"                                                                   
     7 "*\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00"
     8 "isatap"                                                                 
     9 "44.206.168.192.in-addr.arpa"                                            
    10 "hpe8aa67"                                                               

8.  Опеределите базовые статистические характеристики (функция
    summary()) интервала времени между последовательным обращениями к
    топ-10 доменам.

``` R
top_domains_filter <- dns %>% 
  filter(tolower(query) %in% top_domains$domain) %>%
  arrange(ts)
time <- diff(top_domains_filter$ts)

summary(time)
```

      Length    Class     Mode 
      137205 difftime  numeric 

9.  По периодическим запросам на один и тот же домен можно выявить скрытый DNS канал. Есть ли такие IP адреса в исследуемом датасете?

``` R
ip_domain <- dns %>%
  group_by(ip = tolower(id.orig_h), domain = tolower(query)) %>%
  summarise(request = n(), .groups = 'drop') %>%
  filter(request > 1)

unique_ips <- unique(ip_domain$ip)
num_unique_ips <- length(unique_ips)

head(unique_ips)
```

    [1] "10.10.10.10"     "10.10.117.209"   "10.10.117.210"   "128.244.37.196" 
    [5] "169.254.109.123" "169.254.228.26" 

10.  Определите местоположение (страну, город) и организацию-провайдера
    для топ-10 доменов. Для этого можно использовать сторонние сервисы,
    например . https://ip2geolocation.com

<!-- -->

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
