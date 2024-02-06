# Compare different

| command                       | mean              | stddev                |
| ----------------------------- | ----------------- | --------------------- |
| `merykittyunsafe`             | 1.38626720956     | 0.01020137999217643   |
| `merykitty`                   | 1.52302498056     | 0.024776606613417875  |
| `dannyvankooten/analyze``     | 1.26986208056     | 0.0027637210575434737 |
| **`1brc_parallel_mmap 64 8`** | **3.22288731556** | 0.047787448027210376  |

Relative performance was as follows:

```txt
  dannyvankooten/analyze ran
    1.09 ± 0.01 times faster than merykittyunsafe
    1.20 ± 0.02 times faster than merykitty
    2.54 ± 0.04 times faster than 1brc_parallel_mmap 64 8
```

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
