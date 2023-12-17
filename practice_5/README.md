## Цель работы

1. Получить знания о методах исследования радиоэлектронной обстановки.
2. Составить представление о механизмах работы Wi-Fi сетей на канальном и сетевом уровне модели OSI.
3. Зекрепить практические навыки использования языка программирования R для обработки данных
4. Закрепить знания основных функций обработки данных экосистемы tidyverse языка R

## Подготовка данных

#### Установка и загрузка библиотек
```r
library(dplyr)
library(lubridate)
```

#### 1. Импортируйте данные.
```r
anons <- read.csv("mir.csv-01.csv",
              nrows = 167)
head(anons)
reqs <- read.csv("mir.csv-01.csv",
                 skip = 170)
head(reqs)
```

#### 2. Привести датасеты в вид “аккуратных данных”, преобразовать типы столбцов в соответствии с типом данных
```r
anons <- anons |> 
  mutate_at(vars(BSSID, Privacy, Cipher, Authentication, LAN.IP, ESSID), trimws) |>
  mutate_at(vars(BSSID, Privacy, Cipher, Authentication, LAN.IP, ESSID), na_if, "") |>
  mutate_at(vars(First.time.seen, Last.time.seen), as.POSIXct, format = "%Y-%m-%d %H:%M:%S")

reqs <- reqs |>
  mutate_at(vars(Station.MAC, BSSID, Probed.ESSIDs), trimws) |>
  mutate_at(vars(Station.MAC, BSSID, Probed.ESSIDs), na_if, "") |>
  mutate_at(vars(First.time.seen, Last.time.seen), as.POSIXct, format = "%Y-%m-%d %H:%M:%S") |>
  mutate_at(vars(Power, X..packets), as.integer) |>
  filter(!is.na(BSSID))
  ```

#### 3. Просмотрите общую структуру данных с помощью функции glimpse()
```r
glimpse(anons)
glimpse(reqs)
```
    Rows: 167
    Columns: 15
    $ BSSID           <chr> "BE:F1:71:D5:17:8B", "6E:C7:EC:16:DA:1A", "9A:75:A8:B9:04:1E", "4A:EC:1E:DB:BF:95", "D2:6D:52:61:51:5D", "E8:…
    $ First.time.seen <dttm> 2023-07-28 09:13:03, 2023-07-28 09:13:03, 2023-07-28 09:13:03, 2023-07-28 09:13:03, 2023-07-28 09:13:03, 202…
    $ Last.time.seen  <dttm> 2023-07-28 11:50:50, 2023-07-28 11:55:12, 2023-07-28 11:53:31, 2023-07-28 11:04:01, 2023-07-28 10:30:19, 202…
    $ channel         <int> 1, 1, 1, 7, 6, 6, 11, 11, 11, 1, 6, 14, 11, 11, 6, 6, 6, 6, 44, 1, 1, 1, 3, 11, 6, 6, 14, 14, 1, 11, 14, 1, 1…
    $ Speed           <int> 195, 130, 360, 360, 130, 130, 195, 130, 130, 195, 180, 65, 130, 130, 130, 130, 65, -1, -1, 54, 270, 54, 270, …
    $ Privacy         <chr> "WPA2", "WPA2", "WPA2", "WPA2", "WPA2", "OPN", "WPA2", "WPA2", "WPA2", "WPA2", "WPA2", "WPA2", "WPA2", "WPA2"…
    $ Cipher          <chr> "CCMP", "CCMP", "CCMP", "CCMP", "CCMP", NA, "CCMP", "CCMP", "CCMP", "CCMP", "CCMP", "CCMP", "CCMP", "CCMP", N…
    $ Authentication  <chr> "PSK", "PSK", "PSK", "PSK", "PSK", NA, "PSK", "PSK", "PSK", "PSK", "PSK", "PSK", "PSK", "PSK", NA, NA, "PSK",…
    $ Power           <int> -30, -30, -68, -37, -57, -63, -27, -38, -38, -66, -42, -62, -73, -69, -63, -63, -51, -1, -1, -65, -61, -65, -…
    $ X..beacons      <int> 846, 750, 694, 510, 647, 251, 1647, 1251, 704, 617, 1390, 142, 28, 112, 260, 279, 248, 0, 0, 84, 109, 65, 42,…
    $ X..IV           <int> 504, 116, 26, 21, 6, 3430, 80, 11, 0, 0, 86, 0, 0, 0, 907, 0, 806, 3, 5, 33, 0, 0, 41, 304, 0, 2, 0, 0, 71, 4…
    $ LAN.IP          <chr> "0.  0.  0.  0", "0.  0.  0.  0", "0.  0.  0.  0", "0.  0.  0.  0", "0.  0.  0.  0", "172. 17.203.197", "0.  …
    $ ID.length       <int> 12, 4, 2, 14, 25, 13, 12, 13, 24, 12, 10, 0, 24, 24, 12, 0, 8, 0, 0, 4, 0, 3, 0, 13, 0, 13, 0, 0, 13, 4, 0, 4…
    $ ESSID           <chr> "C322U13 3965", "Cnet", "KC", "POCO X5 Pro 5G", NA, "MIREA_HOTSPOT", "C322U21 0566", "AndroidAP177B", "EBFCD5…
    $ Key             <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…

    Rows: 12,084
    Columns: 7
    $ Station.MAC     <chr> "CA:66:3B:8F:56:DD", "96:35:2D:3D:85:E6", "5C:3A:45:9E:1A:7B", "C0:E4:34:D8:E7:E5", "5E:8E:A6:5E:34:81", "10:…
    $ First.time.seen <dttm> 2023-07-28 09:13:03, 2023-07-28 09:13:03, 2023-07-28 09:13:03, 2023-07-28 09:13:03, 2023-07-28 09:13:04, 202…
    $ Last.time.seen  <dttm> 2023-07-28 10:59:44, 2023-07-28 09:13:03, 2023-07-28 11:51:54, 2023-07-28 11:53:16, 2023-07-28 09:13:04, 202…
    $ Power           <int> -33, -65, -39, -61, -53, -43, -31, -71, -74, -65, -45, -65, -49, -1, -67, -37, -69, -55, -57, -57, -75, -43, …
    $ X..packets      <int> 858, 4, 432, 958, 1, 344, 163, 3, 115, 437, 265, 77, 7, 71, 1, 125, 2245, 4096, 849, 179, 2, 332, 667, 122, 6…
    $ BSSID           <chr> "BE:F1:71:D5:17:8B", "(not associated)", "BE:F1:71:D6:10:D7", "BE:F1:71:D5:17:8B", "(not associated)", "(not …
    $ Probed.ESSIDs   <chr> "C322U13 3965", "IT2 Wireless", "C322U21 0566", "C322U13 3965", NA, NA, "C322U06 5179", NA, NA, "GIVC", NA, "…

## Анализ 

### Точки доступа

#### 1. Определить небезопасные точки доступа (без шифрования – OPN)
```r
unsafe_dt <- anons |>
  filter(Privacy == "OPN") |>
  select(BSSID, ESSID) |>
  arrange(BSSID) |>
  distinct()
unsafe_dt
```

#### 2. Определить производителя для каждого обнаруженного устройства

    00:03:7A Taiyo Yuden Co., Ltd.
    00:03:7F Atheros Communications, Inc.
    00:25:00 Apple, Inc.
    00:26:99 Cisco Systems, Inc
    E0:D9:E3 Eltex Enterprise Ltd.
    E8:28:C1 Eltex Enterprise Ltd.

#### 3. Выявить устройства, использующие последнюю версию протокола шифрования WPA3, и названия точек доступа, реализованных на этих устройствах
```r
devices_wpa3 <- anons |>
  filter(Privacy == "WPA3 WPA2") |>
  select(BSSID, ESSID, Privacy)
devices_wpa3 
```
                  BSSID              ESSID   Privacy
    1 26:20:53:0C:98:E8               <NA> WPA3 WPA2
    2 A2:FE:FF:B8:9B:C9         Christie’s WPA3 WPA2
    3 96:FF:FC:91:EF:64               <NA> WPA3 WPA2
    4 CE:48:E7:86:4E:33 iPhone (Анастасия) WPA3 WPA2
    5 8E:1F:94:96:DA:FD iPhone (Анастасия) WPA3 WPA2
    6 BE:FD:EF:18:92:44            Димасик WPA3 WPA2
    7 3A:DA:00:F9:0C:02  iPhone XS Max 🦊🐱🦊 WPA3 WPA2
    8 76:C5:A0:70:08:96               <NA> WPA3 WPA2

#### 4. Отсортировать точки доступа по интервалу времени, в течение которого они находились на связи, по убыванию.
```r
anons_intervals <- anons |>
  mutate(Interval = seconds_to_period(Last.time.seen - First.time.seen)) |>
  select(ESSID, First.time.seen, Last.time.seen, Interval, X..beacons) |>
  arrange(desc(Interval)) |>
  head()  
anons_intervals
```
              ESSID     First.time.seen      Last.time.seen   Interval
    1          <NA> 2023-07-28 09:13:06 2023-07-28 11:56:21 2H 43M 15S
    2 MIREA_HOTSPOT 2023-07-28 09:13:09 2023-07-28 11:56:05 2H 42M 56S
    3 MIREA_HOTSPOT 2023-07-28 09:13:03 2023-07-28 11:55:38 2H 42M 35S
    4          <NA> 2023-07-28 09:13:27 2023-07-28 11:55:53 2H 42M 26S
    5          Cnet 2023-07-28 09:13:03 2023-07-28 11:55:12  2H 42M 9S
    6  MIREA_GUESTS 2023-07-28 09:13:06 2023-07-28 11:55:12  2H 42M 6S

#### 5. Обнаружить топ-10 самых быстрых точек доступа
```r
top_10_spots <- anons |>
  arrange(desc(Speed)) |>
  select(BSSID, ESSID, Speed, Privacy) |>
  head(10)
top_10_spots
```
                   BSSID              ESSID Speed   Privacy
    1  26:20:53:0C:98:E8               <NA>   866 WPA3 WPA2
    2  96:FF:FC:91:EF:64               <NA>   866 WPA3 WPA2
    3  CE:48:E7:86:4E:33 iPhone (Анастасия)   866 WPA3 WPA2
    4  8E:1F:94:96:DA:FD iPhone (Анастасия)   866 WPA3 WPA2
    5  9A:75:A8:B9:04:1E                 KC   360      WPA2
    6  4A:EC:1E:DB:BF:95     POCO X5 Pro 5G   360      WPA2
    7  56:C5:2B:9F:84:90         OnePlus 6T   360      WPA2
    8  E8:28:C1:DC:B2:41       MIREA_GUESTS   360       OPN
    9  E8:28:C1:DC:B2:40      MIREA_HOTSPOT   360       OPN
    10 E8:28:C1:DC:B2:42               <NA>   360       OPN

#### 6. Отсортировать точки доступа по частоте отправки запросов (beacons) в единицу времени по их убыванию.
```r
anons_beacons <- anons_intervals |> 
  select(ESSID, First.time.seen, Last.time.seen, X..beacons) |>
  arrange(desc(X..beacons)) |>
  head()
anons_beacons
```
                    ESSID      First.time.seen       Last.time.seen  Duration
    1                      2023-07-28 09:52:54  2023-07-28 10:25:02 1928 secs
    2                      2023-07-28 09:15:45  2023-07-28 09:33:10 1045 secs
    3  iPhone (Анастасия)  2023-07-28 10:08:32  2023-07-28 10:15:27  415 secs
    4  iPhone (Анастасия)  2023-07-28 09:59:20  2023-07-28 10:04:15  295 secs
    5   iPhone XS Max 🦊🐱🦊  2023-07-28 10:27:01  2023-07-28 10:27:10    9 secs
    6            Димасик   2023-07-28 10:15:24  2023-07-28 10:15:28    4 secs
    7                      2023-07-28 11:16:36  2023-07-28 11:16:38    2 secs
    8          Christie’s  2023-07-28 09:41:52  2023-07-28 09:41:52    0 secs

## Данные клиентов

#### 1. Определить производителя для каждого обнаруженного устройства
```r
proizv <- reqs |> 
  filter(grepl("(..:..:..:)(..:..:..)", BSSID)) |>
  distinct(BSSID)
proizv
```
    BSSID
    1  BE:F1:71:D5:17:8B
    2  BE:F1:71:D6:10:D7
    3  1E:93:E3:1B:3C:F4
    4  E8:28:C1:DC:FF:F2
    5  00:25:00:FF:94:73
    6  00:26:99:F2:7A:E2
    7  0C:80:63:A9:6E:EE
    8  E8:28:C1:DD:04:52
    9  0A:C5:E1:DB:17:7B
    10 9A:75:A8:B9:04:1E
    11 8A:A3:03:73:52:08
    12 4A:EC:1E:DB:BF:95
    13 BE:F1:71:D5:0E:53
    14 08:3A:2F:56:35:FE
    15 6E:C7:EC:16:DA:1A
    16 2A:E8:A2:02:01:73
    17 E8:28:C1:DC:B2:52
    18 E8:28:C1:DC:C6:B2
    19 E8:28:C1:DC:C8:32
    20 56:C5:2B:9F:84:90
    21 9A:9F:06:44:24:5B
    22 12:48:F9:CF:58:8E
    23 E8:28:C1:DD:04:50
    24 AA:F4:3F:EE:49:0B
    25 3A:70:96:C6:30:2C
    26 E8:28:C1:DC:3C:92
    27 8E:55:4A:85:5B:01
    28 5E:C7:C0:E4:D7:D4
    29 E2:37:BF:8F:6A:7B
    30 96:FF:FC:91:EF:64
    31 CE:B3:FF:84:45:FC
    32 00:26:99:BA:75:80
    33 76:70:AF:A4:D2:AF
    34 E8:28:C1:DC:B2:50
    35 00:AB:0A:00:10:10
    36 E8:28:C1:DC:C8:30
    37 8E:1F:94:96:DA:FD
    38 E8:28:C1:DB:F5:F2
    39 E8:28:C1:DD:04:40
    40 EA:7B:9B:D8:56:34
    41 BE:FD:EF:18:92:44
    42 7E:3A:10:A7:59:4E
    43 00:26:99:F2:7A:E1
    44 00:23:EB:E3:49:31
    45 E8:28:C1:DC:B2:40
    46 E0:D9:E3:49:04:40
    47 3A:DA:00:F9:0C:02
    48 E8:28:C1:DC:B2:41
    49 E8:28:C1:DE:74:32
    50 E8:28:C1:DC:33:12
    51 92:F5:7B:43:0B:69
    52 DC:09:4C:32:34:9B
    53 E8:28:C1:DC:F0:90
    54 E0:D9:E3:49:04:52
    55 22:C9:7F:A9:BA:9C
    56 E8:28:C1:DD:04:41
    57 92:12:38:E5:7E:1E
    58 B2:1B:0C:67:0A:BD
    59 E8:28:C1:DC:33:10
    60 E0:D9:E3:49:04:41
    61 1E:C2:8E:D8:30:91
    62 A2:64:E8:97:58:EE
    63 A6:02:B9:73:2F:76
    64 A6:02:B9:73:81:47
    65 AE:3E:7F:C8:BC:8E
    66 B6:C4:55:B5:53:24
    67 86:DF:BF:E4:2F:23
    68 02:67:F1:B0:6C:98
    69 36:46:53:81:12:A0
    70 E8:28:C1:DC:0B:B0
    71 82:CD:7D:04:17:3B
    72 E8:28:C1:DC:54:B2
    73 00:03:7F:10:17:56
    74 00:0D:97:6B:93:DF

#### 2. Обнаружить устройства, которые НЕ рандомизируют свой MAC адрес
```r
devices_n_r <- reqs |>
  filter(grepl("(..:..:..:)(..:..:..)", BSSID) & !is.na(Probed.ESSIDs)) |>
  group_by(BSSID, Probed.ESSIDs) |>
  filter(n() > 1) |>
  arrange(BSSID) |>
  unique()
devices_n_r
```
    # A tibble: 52 × 7
    # Groups:   BSSID, Probed.ESSIDs [16]
    Station.MAC       First.time.seen     Last.time.seen      Power X..packets BSSID             Probed.ESSIDs
    <chr>             <dttm>              <dttm>              <int>      <int> <chr>             <chr>        
    1 50:3E:AA:5F:AB:23 2023-07-28 09:39:02 2023-07-28 11:46:39   -61         90 00:26:99:BA:75:80 GIVC         
    2 C6:D1:E8:6A:1C:C3 2023-07-28 10:28:36 2023-07-28 10:31:22   -67         60 00:26:99:BA:75:80 GIVC         
    3 9A:F7:00:BC:C9:69 2023-07-28 10:28:36 2023-07-28 11:55:54   -61        358 00:26:99:BA:75:80 GIVC         
    4 B0:BE:83:81:8E:68 2023-07-28 10:35:26 2023-07-28 11:55:36   -63        430 00:26:99:BA:75:80 GIVC         
    5 9A:7D:CE:C9:0A:DF 2023-07-28 10:53:07 2023-07-28 11:50:15   -59         29 00:26:99:BA:75:80 GIVC         
    6 76:D3:55:13:DB:CC 2023-07-28 11:39:40 2023-07-28 11:39:40   -51          2 00:26:99:BA:75:80 GIVC         
    7 CA:54:C4:8B:B5:3A 2023-07-28 09:13:06 2023-07-28 11:55:04   -65        437 00:26:99:F2:7A:E2 GIVC         
    8 0E:AD:54:09:04:37 2023-07-28 09:13:51 2023-07-28 09:43:22   -71         16 00:26:99:F2:7A:E2 GIVC         
    9 F6:4D:98:98:18:C3 2023-07-28 09:14:37 2023-07-28 11:55:29   -61       1062 00:26:99:F2:7A:E2 GIVC         
    10 42:C7:F5:C1:59:B0 2023-07-28 09:23:50 2023-07-28 11:53:13   -67        114 00:26:99:F2:7A:E2 GIVC
    #### 3. Кластеризовать запросы от устройств к точкам доступа по их именам. Определить время появления устройства в зоне радиовидимости и время выхода его из нее.
    cluster_req <- reqs |>
    filter(!is.na(Probed.ESSIDs)) |>
    group_by(Station.MAC, Probed.ESSIDs) |>
    arrange(First.time.seen) |>
    summarise(Cluster_Start_Time = min(First.time.seen),
                Cluster_End_Time = max(Last.time.seen),
                Total_Power = sum(Power))
    cluster_req

#### 3. Кластеризовать запросы от устройств к точкам доступа по их именам. Определить время появления устройства в зоне радиовидимости и время выхода его из нее.
```r
cluster_req <- reqs |>
  filter(!is.na(Probed.ESSIDs)) |>
  group_by(Station.MAC, Probed.ESSIDs) |>
  arrange(First.time.seen) |>
  summarise(Cluster_Start_Time = min(First.time.seen),
            Cluster_End_Time = max(Last.time.seen),
            Total_Power = sum(Power))
cluster_req
```
    # A tibble: 1,477 × 5
    # Groups:   Station.MAC [1,477]
    Station.MAC       Probed.ESSIDs                    Cluster_Start_Time  Cluster_End_Time    Total_Power
    <chr>             <chr>                            <dttm>              <dttm>                    <int>
    1 00:90:4C:E6:54:54 Redmi                            2023-07-28 09:16:59 2023-07-28 10:21:15         -65
    2 00:95:69:E7:7C:ED nvripcsuite                      2023-07-28 09:13:11 2023-07-28 11:56:13         -55
    3 00:95:69:E7:7D:21 nvripcsuite                      2023-07-28 09:13:15 2023-07-28 11:56:17         -33
    4 00:95:69:E7:7F:35 nvripcsuite                      2023-07-28 09:13:11 2023-07-28 11:56:07         -69
    5 00:F4:8D:F7:C5:19 Redmi 12                         2023-07-28 10:45:04 2023-07-28 11:43:26         -73
    6 02:00:00:00:00:00 xt3 w64dtgv5cfrxhttps://vk.com/v 2023-07-28 09:54:40 2023-07-28 11:55:36         -67
    7 02:06:2B:A5:0C:31 Avenue611                        2023-07-28 09:55:12 2023-07-28 09:55:12         -65
    8 02:1D:0F:A4:94:74 iPhone (Дима )                   2023-07-28 09:57:08 2023-07-28 09:57:08         -61
    9 02:32:DC:56:5C:82 Timo Resort                      2023-07-28 10:58:23 2023-07-28 10:58:24         -84
    10 02:35:E9:C2:44:5F iPhone (Максим)                  2023-07-28 10:00:55 2023-07-28 10:00:55         -88
    # ℹ 1,467 more rows

## Вывод

Получили знания о методах исследования радиоэлектронной обстановки,
представление о механизмах работы Wi-Fi сетей на канальном и сетевом
уровне модели OSI, закрепили практические навыки использования языка
программирования R для обработки данных и знания о функциях обработки
данных экосистемы tidyverse в R
