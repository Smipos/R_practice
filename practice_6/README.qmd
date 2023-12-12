# Практика 6

# Исследование вредоносной активности в домене Windows

## Цель работы

1.  Закрепить навыки исследования данных журнала Windows Active
    Directory
2.  Изучить структуру журнала системы Windows Active Directory
3.  Закрепить практические навыки использования языка программирования R
    для обработки данных
4.  Закрепить знания основных функций обработки данных экосистемы
    `tidyverse` языка R

## Исходные данные

1.  RStudio

## Задание

Используя программный пакет `dplyr` языка программирования R, провести
анализ журналов и ответить на вопросы

## Ход работы

### Подгрузка библиотек и импорт данных

``` r
library(dplyr)
library(jsonlite)
library(tidyr)
library(xml2)
library(rvest)

data = stream_in(file('C:/Users/smipo/OneDrive/Рабочий стол/practice_6/caldera_attack_evals_round1_day1_2019-10-20201108.json'))
```

#### Привести датасеты в вид “аккуратных данных”, преобразовать типы столбцов в соответствии с типом данных

``` r
clean_data <- df %>%
  mutate(`@timestamp` = as.POSIXct(`@timestamp`, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")) %>%
  rename(timestamp = `@timestamp`, metadata = `@metadata`)
```


#### Просмотрите общую структуру данных с помощью функции glimpse()

``` r
glimpse(clean_data)
```

    Rows: 101,904
    Columns: 9
    $ timestamp <dttm> 2019-10-20 20:11:06, 2019-10-20 20:11:07, 2019-10-20 20:11:09, 2019-10-20 …
    $ metadata  <df[,4]> <data.frame[31 x 4]>
    $ event     <df[,4]> <data.frame[31 x 4]>
    $ log       <df[,1]> <data.frame[31 x 1]>
    $ message   <chr> "A token right was adjusted.\n\nSubject:\n\tSecurity ID:\t\tS-1-5-18\n\t…
    $ winlog    <df[,16]> <data.frame[31 x 16]>
    $ ecs       <df[,1]> <data.frame[31 x 1]>
    $ host      <df[,1]> <data.frame[31 x 1]>
    $ agent     <df[,5]> <data.frame[31 x 5]>

#### 1. Раскройте датафрейм избавившись от вложенных датафреймов.

``` r
df <- clean_data %>%
  tidyr::unnest(c(metadata, event, log, winlog, ecs, host, agent), names_sep = ".")

df
```

    # # A tibble: 101,904 × 34
      timestamp           metadata.beat metadata.type metadata.version metadata.topic
      <dttm>              <chr>         <chr>         <chr>            <chr>         
    1 2019-10-20 20:11:06 winlogbeat    _doc          7.4.0            winlogbeat    
    2 2019-10-20 20:11:07 winlogbeat    _doc          7.4.0            winlogbeat    
    3 2019-10-20 20:11:09 winlogbeat    _doc          7.4.0            winlogbeat    
    4 2019-10-20 20:11:10 winlogbeat    _doc          7.4.0            winlogbeat    
    5 2019-10-20 20:11:11 winlogbeat    _doc          7.4.0            winlogbeat    
    6 2019-10-20 20:11:15 winlogbeat    _doc          7.4.0            winlogbeat    
    7 2019-10-20 20:11:15 winlogbeat    _doc          7.4.0            winlogbeat    
    8 2019-10-20 20:11:15 winlogbeat    _doc          7.4.0            winlogbeat    
    9 2019-10-20 20:11:15 winlogbeat    _doc          7.4.0            winlogbeat    
    10 2019-10-20 20:11:16 winlogbeat    _doc          7.4.0            winlogbeat    
    # ℹ 101,894 more rows
    # ℹ 29 more variables: event.created <chr>, event.kind <chr>, event.code <int>,
    #   event.action <chr>, log.level <chr>, message <chr>, winlog.event_data <df[,234]>,
    #   winlog.event_id <int>, winlog.provider_name <chr>, winlog.api <chr>,
    #   winlog.record_id <int>, winlog.computer_name <chr>, winlog.process <df[,2]>,
    #   winlog.keywords <list>, winlog.provider_guid <chr>, winlog.channel <chr>,
    #   winlog.task <chr>, winlog.opcode <chr>, winlog.version <int>, winlog.user <df[,4]>, …
    # ℹ Use `print(n = ...)` to see more rows

#### 2. Минимизируйте количество колонок в датафрейме – уберите колоки с единственным значением параметра.

``` r
df_filtered  <- df %>%
  select(-metadata.beat, -metadata.type, -metadata.version, -metadata.topic,
         -event.kind, -winlog.api, -agent.ephemeral_id, -agent.hostname, 
         -agent.id, -agent.version, -agent.type) %>%
  mutate(`event.created` = as.POSIXct(`event.created`, 
                                      format = "%Y-%m-%dT%H:%M:%OSZ", 
                                      tz = "UTC"))
df_filtered
```

    # A tibble: 101,904 × 23
      timestamp           event.created       event.code event.action            log.level message
      <dttm>              <dttm>                   <int> <chr>                   <chr>     <chr>  
    1 2019-10-20 20:11:06 2019-10-20 20:11:09       4703 Token Right Adjusted E… informat… "A tok…
    2 2019-10-20 20:11:07 2019-10-20 20:11:09       4673 Sensitive Privilege Use informat… "A pri…
    3 2019-10-20 20:11:09 2019-10-20 20:11:11         10 Process accessed (rule… informat… "Proce…
    4 2019-10-20 20:11:10 2019-10-20 20:11:14         10 Process accessed (rule… informat… "Proce…
    5 2019-10-20 20:11:11 2019-10-20 20:11:14         10 Process accessed (rule… informat… "Proce…
    6 2019-10-20 20:11:15 2019-10-20 20:11:18         10 Process accessed (rule… informat… "Proce…
    7 2019-10-20 20:11:15 2019-10-20 20:11:18         11 File created (rule: Fi… informat… "File …
    8 2019-10-20 20:11:15 2019-10-20 20:11:18         10 Process accessed (rule… informat… "Proce…
    9 2019-10-20 20:11:15 2019-10-20 20:11:18         10 Process accessed (rule… informat… "Proce…
    10 2019-10-20 20:11:16 2019-10-20 20:11:18         10 Process accessed (rule… informat… "Proce…
    # ℹ 101,894 more rows
    # ℹ 17 more variables: winlog.event_data <df[,234]>, winlog.event_id <int>,
    #   winlog.provider_name <chr>, winlog.record_id <int>, winlog.computer_name <chr>,
    #   winlog.process <df[,2]>, winlog.keywords <list>, winlog.provider_guid <chr>,
    #   winlog.channel <chr>, winlog.task <chr>, winlog.opcode <chr>, winlog.version <int>,
    #   winlog.user <df[,4]>, winlog.activity_id <chr>, winlog.user_data <df[,30]>,
    #   ecs.version <chr>, host.name <chr>

#### 3. Какое количество хостов представлено в данном датасете?

``` r
df_filtered %>%
  distinct(host.name)
```

    # A tibble: 1 × 1
      host.name
      <chr>    
    1 WECServer

#### 4. Подготовьте датафрейм с расшифровкой Windows Event_ID, приведите типы данных к типу их значений

``` r
url <- "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/appendix-l--events-to-monitor"
web <- xml2::read_html(url)
event <- rvest::html_table(web)[[1]]
event

win_data <- event %>%
  mutate_at(vars(`Current Windows Event ID`, `Legacy Windows Event ID`), as.integer) %>%
  rename(c(Current_Windows_Event_ID = `Current Windows Event ID`, 
           Legacy_Windows_Event_ID = `Legacy Windows Event ID`, 
           Potential_Criticality = `Potential Criticality`, 
           Event_Summary = `Event Summary`))
win_data
```

    # A tibble: 381 × 4
       `Current Windows Event ID` `Legacy Windows Event ID` `Potential Criticality`
       <chr>                      <chr>                     <chr>                  
     1 4618                       N/A                       High                   
     2 4649                       N/A                       High                   
     3 4719                       612                       High                   
     4 4765                       N/A                       High                   
     5 4766                       N/A                       High                   
     6 4794                       N/A                       High                   
     7 4897                       801                       High                   
     8 4964                       N/A                       High                   
     9 5124                       N/A                       High                   
    10 N/A                        550                       Medium to High         
    # ℹ 371 more rows
    # ℹ 1 more variable: `Event Summary` <chr>

    # A tibble: 381 × 4
       Current_Windows_Event_ID Legacy_Windows_Event_ID Potential_Criticality
                          <int>                   <int> <chr>                
     1                     4618                      NA High                 
     2                     4649                      NA High                 
     3                     4719                     612 High                 
     4                     4765                      NA High                 
     5                     4766                      NA High                 
     6                     4794                      NA High                 
     7                     4897                     801 High                 
     8                     4964                      NA High                 
     9                     5124                      NA High                 
    10                       NA                     550 Medium to High       
    # ℹ 371 more rows
    # ℹ 1 more variable: Event_Summary <chr>

#### 5. Есть ли в логе события с высоким и средним уровнем значимости? Сколько их?

``` r
  win_data %>%
  count(Potential_Criticality) %>%
  arrange(desc(n))
```

    # A tibble: 4 × 2
      Potential_Criticality     n
      <chr>                 <int>
    1 Low                     291
    2 Medium                   79
    3 High                      9
    4 Medium to High            2

Есть. 
Средний - 79.
Высокий - 9.

## Оценка результатов

В ходе практической работы были получены навыки исследования данных
журнала Windows Active Directory.

## Вывод

Были закреплены навыки использования языка R для обработки данных.
