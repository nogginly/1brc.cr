# Compare different

## Updated 2024 Feb 11

> AMD 7735HS 16 cores 32GB running on Linux

See [this CSV](/perfdata/compare1brc240211.csv) for the detailed results.

| command                      | Lang        | mean                 | stddev               |
| ---------------------------- | ----------- | -------------------- | -------------------- |
| merykittyunsafe.sh           | Java        | 1.34270993842        | 0.036888174169103186 |
| merykitty.sh                 | Java        | 1.51770504842        | 0.021277280568716347 |
| dannyvankooten/analyze       | C           | 1.24137285062        | 0.003261490844545827 |
| **1brc_parallel_ptr4 16 48** | **Crystal** | **2.03081785402**    | 0.06009663760371807  |
| 1brc_parallel_mmap2b 16 32   | Crystal     | 2.06915509142        | 0.01875921473395469  |
| *serkan-ozal*                | *Java*      | *1.1661091954200002* | 0.10359078275160513  |

Relative performance summary is below:

```txt
  serkan-ozal ran
    1.06 ± 0.09 times faster than dannyvankooten/analyze
    1.15 ± 0.11 times faster than merykittyunsafe
    1.30 ± 0.12 times faster than merykitty
    1.74 ± 0.16 times faster than 1brc_parallel_ptr4 16 48
    1.77 ± 0.16 times faster than 1brc_parallel_mmap2b 16 32
```

## Previous update

> AMD 7735HS 16 cores 32GB running on Linux

| command                       | mean               | stddev               |
| ----------------------------- | ------------------ | -------------------- |
| merykittyunsafe               | 1.3731531913399997 | 0.04445930820906459  |
| merykitty                     | 1.5263957833400001 | 0.034382946135534866 |
| dannyvankooten/analyze        | 1.28599224174      | 0.01613285976790795  |
| **1brc_parallel_mmap2b 64 8** | ** 2.28868977854** | 0.024446179192799067 |
| 1brc_parallel_mmap2b 32 4     | 2.3561572355399996 | 0.027036956269126788 |
| 1brc_parallel_mmap2b 16 2     | 2.5898512893400003 | 0.012356261466824503 |
| serkan-ozal                   | 1.06250354374      | 0.0816364288869122   |

## Results

See [this CSV](/perfdata/compare1brc.csv) for details.

```txt
  serkan-ozal ran
    1.21 ± 0.09 times faster than dannyvankooten/analyze
    1.29 ± 0.11 times faster than merykittyunsafe
    1.44 ± 0.12 times faster than merykitty
    2.15 ± 0.17 times faster than 1brc_parallel_mmap2b 64 8
    2.22 ± 0.17 times faster than 1brc_parallel_mmap2b 32 4
    2.44 ± 0.19 times faster than 1brc_parallel_mmap2b 16 2
```
