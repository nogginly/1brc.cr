# Compare different


## Results

See [this CSV](/perfdata/compare1brc.csv) for details.

```txt
  ~/Dev/C/FOSS/1brc/bin/analyze measurements.txt ran
    1.09 ± 0.01 times faster than ./calculate_average_merykittyunsafe.sh
    1.20 ± 0.02 times faster than ./calculate_average_merykitty.sh
    2.54 ± 0.04 times faster than ~/Dev/Crystal/1brc.cr/run.sh 1brc_parallel_mmap 64 8
    2.60 ± 0.01 times faster than ~/Dev/Crystal/1brc.cr/run.sh 1brc_parallel_mmap 32 4
    2.88 ± 0.03 times faster than ~/Dev/Crystal/1brc.cr/run.sh 1brc_parallel_mmap 16 2
```
