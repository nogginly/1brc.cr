# i7-9750H CPU @ 2.60GHz, 6 cores HT, 16GB RAM with macOS

### Running on battery

I ran a bunch of timed executions, each at least twice, to get a sense of the way the performance related to _N_ and _D_.

Two observations

1. for the varying _N_ threads used we can see local minima based on _D_.
2. higher _N_ for some optimal _D_ yields better absolute performance regardless of how much more _N_ is relative to the number of physical cores.
3. Even if I assume hyper-threading means we can "assume" 12 parallel computes, that we can get the best result using 48 threads is a bit unexpected.

|  Min | _N_    | _D_    | Performance  | system | cpu       | total      |
| ---: | ------ | ------ | ------------ | ------ | --------- | ---------- |
|      | 48     | 48     | 128.74s user | 11.75s | 1033%     | 13.597     |
|      | 48     | 47     | 131.23s user | 11.45s | 1024%     | 13.923     |
|      | 48     | 45     | 125.05s user | 11.97s | 1024%     | 13.375     |
|   => | **48** | **44** | 127.38s user | 11.64s | **1053%** | **13.196** |
|      | 48     | 43     | 131.51s user | 11.86s | 1069%     | 13.410     |
|      | 48     | 40     | 127.93s user | 11.36s | 1015%     | 13.717     |
|      | 48     | 32     | 132.84s user | 13.61s | 1052%     | 13.914     |
|      | 4*     | 24     | 133.44s user | 15.37s | 1041%     | 14.285     |
|  --- | ------ | --     | ------------ | ------ | --------  | ---------- |
|      | 32     | 48     | 97.82s user  | 7.93s  | 654%      | 16.152     |
|      | 32     | 32     | 116.90s user | 9.11s  | 852%      | 14.786     |
|      | 32     | 28     | 117.48s user | 11.07s | 872%      | 14.734     |
|      | 32     | 25     | 123.33s user | 11.35s | 933%      | 14.431     |
|      | 32     | 24     | 122.20s user | 11.62s | 920%      | 14.536     |
|      | 32     | 23     | 124.14s user | 12.04s | 935%      | 14.561     |
|      | 32     | 22     | 125.11s user | 11.76s | 958%      | 14.280     |
|   => | **32** | **21** | 127.89s user | 12.52s | **990%**  | **14.176** |
|      | 32     | 20     | 128.88s user | 11.93s | 951%      | 14.791     |
|      | 32     | 16     | 131.93s user | 13.83s | 957%      | 15.230     |
|      | 32     | 12     | 133.76s user | 18.93s | 903%      | 16.900     |
|  --- | ------ | --     | ------------ | ------ | --------  | ---------- |
|      | 24     | 24     | 96.53s user  | 8.24s  | 664%      | 15.762     |
|      | 24     | 16     | 122.56s user | 11.49s | 852%      | 15.727     |
|      | 24     | 12     | 129.13s user | 13.07s | 924%      | 15.388     |
|   => | **24** | **11** | 129.96s user | 12.28s | **897%**  | **15.840** |
|      | 24     | 10     | 129.31s user | 11.85s | 871%      | 16.202     |
|      | 24     | 8      | 133.11s user | 16.86s | 857%      | 17.487     |
|      | 24     | 6      | 141.90s user | 41.55s | 767%      | 23.916     |
|  --- | ------ | --     | ------------ | ------ | --------  | ---------- |
|      | 16     | 48     | 80.18s user  | 4.89s  | 240%      | 35.385     |
|      | 16     | 32     | 81.90s user  | 6.29s  | 306%      | 28.819     |
|      | 16     | 24     | 86.15s user  | 7.65s  | 390%      | 24.036     |
|      | 16     | 16     | 89.56s user  | 8.80s  | 530%      | 18.544     |
|      | 16     | 12     | 93.20s user  | 9.94s  | 594%      | 17.353     |
|      | 16     | 8      | 112.89s user | 11.31s | 737%      | 16.849     |
|   => | **16** | **7**  | 120.93s user | 11.73s | **827%**  | **16.036** |
|      | 16     | 6      | 127.62s user | 13.25s | 791%      | 17.791     |
|      | 16     | 4      | 132.37s user | 42.18s | 687%      | 25.401     |
|  --- | ------ | --     | ------------ | ------ | --------  | ---------- |
|      | 12     | 48     | 79.09s user  | 4.65s  | 168%      | 49.660     |
|      | 12     | 24     | 83.97s user  | 5.25s  | 259%      | 34.367     |
|      | 12     | 16     | 85.83s user  | 6.41s  | 327%      | 28.189     |
|      | 12     | 12     | 88.30s user  | 7.00s  | 411%      | 23.137     |
|      | 12     | 8      | 93.41s user  | 9.22s  | 539%      | 19.039     |
|      | 12     | 6      | 103.96s user | 10.34s | 626%      | 18.240     |
|   => | **12** | **5**  | 117.81s user | 10.49s | **725%**  | **17.686** |
|      | 12     | 4      | 122.34s user | 26.09s | 692%      | 21.420     |
|  --- | ------ | --     | ------------ | ------ | --------  | ---------- |
|      | 9      | 8      | 84.40s user  | 6.84s  | 349%      | 26.122     |
|      | 9      | 6      | 86.40s user  | 7.51s  | 379%      | 24.755     |
|      | 9      | 5      | 88.93s user  | 8.56s  | 450%      | 21.660     |
|   => | **9**  | **4**  | 97.93s user  | 11.17s | **571%**  | **19.094** |
|      | 9      | 3      | 109.76s user | 22.78s | 568%      | 23.296     |
|      | 9      | 2      | 115.04s user | 42.20s | 502%      | 31.277     |

### Running while plugged in

These trials were used to select the concurrency / buffer division configuration to benchmark.

| Threads | Buf Denom. | Performance |               |               | ******          | Peak memory  |
| ------- | ---------- | ----------- | ------------- | ------------- | --------------- | ------------ |
| 16      | 8          | 66.89s user | 9.11s system  | 593% cpu      | *12.802 total*  | 3.966 GB     |
| 16      | 10         | 67.15s user | 7.94s system  | 672% cpu      | *11.161 total*  | 3.174 GB     |
| 16      | 12         | 62.33s user | 6.75s system  | 553% cpu      | *12.479 total*  | 2.647 GB     |
| 16      | 14         | 58.79s user | 6.14s system  | 503% cpu      | *12.901 total*  | 2.295 GB     |
| 24      | 12         | 79.81s user | 9.40s system  | 802% cpu      | *11.110 total*  | 3.968 GB     |
| 24      | 16         | 72.38s user | 8.41s system  | 768% cpu      | *10.512 total*  | 3.008 GB     |
| 24      | 18         | 67.34s user | 7.76s system  | 714% cpu      | *10.505 total*  | 2.673 GB     |
| 32      | 16         | 79.99s user | 11.17s system | 886% cpu      | *10.285 total*  | 4.008 GB     |
| **32**  | **24**     | 87.65s user | 9.16s system  | **986% cpu**  | **9.812 total** | **2.669 GB** |
| 32      | 32         | 76.66s user | 13.22s system | 822% cpu      | *10.929 total*  | 2.014 GB     |
| **48**  | **32**     | 85.95s user | 9.78s system  | **1001% cpu** | **9.558 total** | **3.015 GB** |
| 48      | 48         | 83.80s user | 8.56s system  | 1017% cpu     | *9.081 total*   | 2.020 GB     |

> It's fascinating that on my 6-core CPU the best results use 32-48 worker threads.
