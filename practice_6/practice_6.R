# Библиотеки
library(dplyr)
library(jsonlite)
library(tidyr)
library(xml2)
library(rvest)

#Загрузка данных
data = stream_in(file('C:/Users/smipo/OneDrive/Рабочий стол/practice_6/caldera_attack_evals_round1_day1_2019-10-20201108.json'))


neat_data <- data %>%
  mutate(`@timestamp` = as.POSIXct(`@timestamp`, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")) %>%
  rename(timestamp = `@timestamp`, metadata = `@metadata`)

glimpse(neat_data)

# 1. Раскройте датафрейм избавившись от вложенных датафреймов.
data <- neat_data %>%
  tidyr::unnest(c(metadata, event, log, winlog, ecs, host, agent), names_sep = ".")
data

# 2. Минимизируйте количество колонок в датафрейме – уберите колоки с единственным значением параметра.
data_minimized  <- data %>%
  select(-metadata.beat, -metadata.type, -metadata.version, -metadata.topic,
         -event.kind, -winlog.api, -agent.ephemeral_id, -agent.hostname, 
         -agent.id, -agent.version, -agent.type) %>%
  mutate(`event.created` = as.POSIXct(`event.created`, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC"))
data_minimized

# 3. Какое количество хостов представлено в данном датасете?
data_minimized %>%
  distinct(host.name)

# 4. Подготовьте датафрейм с расшифровкой Windows Event_ID, приведите типы данных к типу их значений
web_url <- "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/appendix-l--events-to-monitor"
web <- xml2::read_html(web_url)
event <- rvest::html_table(web)[[1]]
event

event_data <- event %>%
  mutate_at(vars(`Current Windows Event ID`, `Legacy Windows Event ID`), as.integer) %>%
  rename(c(Current_Windows_Event_ID = `Current Windows Event ID`, 
           Legacy_Windows_Event_ID = `Legacy Windows Event ID`, 
           Potential_Criticality = `Potential Criticality`, 
           Event_Summary = `Event Summary`))
event_data

# 5. Есть ли в логе события с высоким и средним уровнем значимости? Сколько их?
  event_data %>%
  count(Potential_Criticality) %>%
  arrange(desc(n))

  