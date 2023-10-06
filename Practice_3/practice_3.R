install.packages("nycflights13")

library(nycflights13)
library(dplyr)

data(package = "nycflights13")


count_nyc <- list(airlines, airports, flights, planes, weather)
sapply(count_nyc, nrow)


sapply(count_nyc, ncol)


sapply(count_nyc, glimpse)


carriers <- airlines %>%
            select(carrier) %>%
            distinct() %>%
            nrow()
carriers

count_flights_jfk <- flights %>%
               filter(month == 5 & dest == "JFK") %>%
               nrow()
count_flights_jfk


airport_north <- airports %>%
                 arrange(desc(lat)) %>%
                 head(1)
airport_north$name


highland_airport <- airports %>%
                    arrange(desc(alt)) %>%
                    head(1)
highland_airport$name


ancient_num <- planes %>%
               arrange(year) %>%
               head(10) %>%
               select(tailnum)
ancient_num


avg_jfki_temp_in_sep <- weather %>%
                        filter(month == 9 & origin == "JFK") %>%
                        summarise(avg_temp = mean(temp, na.rm = TRUE))
degree <- round((5/9) * (avg_jfki_temp_in_sep$avg_temp - 32), 1)
degree


top_count_flights_jun <- flights %>% 
                         filter(month == 6) %>% 
                         group_by(carrier) %>% 
                         summarize(num_flights = n()) %>% 
                         arrange(desc(num_flights)) %>% 
                         head(1)
top_count_flights_jun


delay_comp <- flights %>% 
              filter(year == 2013) %>% 
              group_by(carrier) %>% 
              summarize(num_delays = sum(arr_delay > 0, na.rm = TRUE)) %>% 
              arrange(desc(num_delays)) %>% 
              head(1)
delay_comp
